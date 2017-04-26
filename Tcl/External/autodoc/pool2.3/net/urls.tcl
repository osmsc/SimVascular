# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: urls.tcl,v 1.6 1998/11/12 21:48:11 aku Exp $
#
# @c URL related utilities (extraction from documents, split, join, ...)
# @s URL related utilities
# @i URL related utilities, regular expressions (for urls)
# -----------------------------

package require Tcl 8.0
package require Pool_Base


namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval urls {
	variable version @net:mFullVersion@

	# Currently known URL schemes:
	#
	# (RFC 1738)
	# ------------------------------------------------
	# scheme	basic syntax of scheme specific part
	# ------------------------------------------------
	# ftp		//<user>:<password>@<host>:<port>/<cwd1>/.../<cwdN>/<name>;type=<typecode>
	#
	# http		//<host>:<port>/<path>?<searchpart>
	#
	# gopher	//<host>:<port>/<gophertype><selector>
	#				<gophertype><selector>%09<search>
	#		<gophertype><selector>%09<search>%09<gopher+_string>
	#
	# mailto	<rfc822-addr-spec>
	# news		<newsgroup-name>
	#		<message-id>
	# nntp		//<host>:<port>/<newsgroup-name>/<article-number>
	# telnet	//<user>:<password>@<host>:<port>/
	# wais		//<host>:<port>/<database>
	#		//<host>:<port>/<database>?<search>
	#		//<host>:<port>/<database>/<wtype>/<wpath>
	# file		//<host>/<path>
	# prospero	//<host>:<port>/<hsoname>;<field>=<value>
	# ------------------------------------------------
	#
	# (RFC 2111)
	# ------------------------------------------------
	# scheme	basic syntax of scheme specific part
	# ------------------------------------------------
	# mid	message-id
	#		message-id/content-id
	# cid	content-id
	# ------------------------------------------------

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# basic regular expressions used in URL syntax.

	namespace eval basic {
	    variable	loAlpha		{[a-z]}
	    variable	hiAlpha		{[A-Z]}
	    variable	digit		{[0-9]}
	    variable	alpha		{[a-zA-Z]}
	    variable	safe		{[$_.+-]}
	    variable	extra		{[!*'(,)]}
	    # danger in next pattern, order important for []
	    variable	national	{[][|\}\{\^~`]}
	    variable	punctuation	{[<>#%"]}	;#" fake emacs hilit
	    variable	reserved	{[;/?:@&=]}
	    variable	hex		{[0-9A-Fa-f]}
	    variable	alphaDigit	{[A-Za-z0-9]}
	    variable	alphaDigitMinus	{[A-Za-z0-9-]}
	
	    # next is <national | punctuation>
	    variable	unsafe		{[][<>"#%\{\}|\\^~`]} ;#" emacs hilit
	    variable	escape		"%${hex}${hex}"

	    #	unreserved	= alpha | digit | safe | extra
	    #	xchar		= unreserved | reserved | escape

	    variable	unreserved	{[a-zA-Z0-9$_.+!*'(,)-]}
	    variable	uChar		"(${unreserved}|${escape})"
	    variable	xCharN		{[a-zA-Z0-9$_.+!*'(,);/?:@&=-]}
	    variable	xChar		"(${xCharN}|${escape})"
	    variable	digits		"${digit}+"

	    variable	toplabel	\
		    "(${alpha}${alphaDigitMinus}*${alphaDigit}|${alpha})"
	    variable	domainlabel	\
	    "(${alphaDigit}${alphaDigitMinus}*${alphaDigit}|${alphaDigit})"

	    variable	hostname	\
		    "((${domainlabel}\\.)*${toplabel})"
	    variable	hostnumber	\
		    "(${digits}\\.${digits}\\.${digits}\\.${digits})"

	    variable	host		"(${hostname}|${hostnumber})"

	    variable	port		$digits
	    variable	hostOrPort	"${host}(:${port})?"

	    variable	usrCharN	{[a-zA-Z0-9$_.+!*'(,);?&=-]}
	    variable	usrChar		"(${usrCharN}|${escape})"
	    variable	user		"${usrChar}*"
	    variable	password	$user
	    variable	login		"(${user}(:${password})?@)?${hostOrPort}"
	} ;# basic {}

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# regular expressions covering the various url schemes

	# extend this variable in the coming namespaces
	variable schemes {}

	# FTP
	namespace eval ftp {
	    set escape $::pool::urls::basic::escape
	    set login  $::pool::urls::basic::login

	    variable	charN	{[a-zA-Z0-9$_.+!*'(,)?:@&=-]}
	    variable	char	"(${charN}|${escape})"
	    variable	segment	"${char}*"
	    variable	path	"${segment}(/${segment})*"

	    variable	type		{[AaDdIi]}
	    variable	typepart	";type=${type}"
	    variable	schemepart	\
		    "//${login}(/${path}(${typepart})?)?"

	    variable	url		"ftp:${schemepart}"

	    lappend ::pool::urls::schemes ftp
	}

	# FILE
	namespace eval file {
	    set host $::pool::urls::basic::host
	    set path $::pool::urls::ftp::path

	    variable	schemepart	"//(${host}|localhost)?/${path}"
	    variable	url		"file:${schemepart}"

	    lappend ::pool::urls::schemes file
	}

	# HTTP
	namespace eval http {
	    set escape		$::pool::urls::basic::escape
	    set hostOrPort	$::pool::urls::basic::hostOrPort

	    variable	charN		{[a-zA-Z0-9$_.+!*'(,);:@&=-]}
	    variable	char		"($charN|${escape})"
	    variable	segment		"${char}*"

	    variable	path		"${segment}(/${segment})*"
	    variable	search		$segment
	    variable	schemepart	\
		    "//${hostOrPort}(/${path}(\\?${search})?)?"

	    variable	url		"http:${schemepart}"

	    lappend ::pool::urls::schemes http
	}

	# GOPHER
	namespace eval gopher {
	    set xChar		$::pool::urls::basic::xChar
	    set hostOrPort	$::pool::urls::basic::hostOrPort
	    set search		$::pool::urls::http::search

	    variable	type		$xChar
	    variable	selector	"$xChar*"
	    variable	string		$selector
	    variable	schemepart	\
		    "//${hostOrPort}(/(${type}(${selector}(%09${search}(%09${string})?)?)?)?)?"
	    variable	url		"gopher:${schemepart}"

	    lappend ::pool::urls::schemes gopher
	}
	
	# MAILTO
	namespace eval mailto {
	    set xChar	$::pool::urls::basic::xChar
	    set host	$::pool::urls::basic::host

	    variable	schemepart	"$xChar+(@${host})?"
	    variable	url		"mailto:${schemepart}"

	    lappend ::pool::urls::schemes mailto
	}

	# NEWS
	namespace eval news {
	    set escape		$::pool::urls::basic::escape
	    set alpha		$::pool::urls::basic::alpha
	    set host		$::pool::urls::basic::host

	    variable	aCharN		{[a-zA-Z0-9$_.+!*'(,);/?:&=-]}
	    variable	aChar		"($aCharN|${escape})"
	    variable	gChar		{[a-zA-Z0-9$_.+-]}
	    variable	group		"${alpha}${gChar}*"
	    variable	article		"${aChar}+@${host}"
	    variable	schemepart	"\\*|${group}|${article}"
	    variable	url		"news:${schemepart}"

	    lappend ::pool::urls::schemes news
	}

	# WAIS
	namespace eval wais {

	    set uChar		$::pool::urls::basic::xChar
	    set hostOrPort	$::pool::urls::basic::hostOrPort
	    set search		$::pool::urls::http::search

	    variable	db		"${uChar}*"
	    variable	type		"${uChar}*"
	    variable	path		"${uChar}*"

	    variable	database	"//${hostOrPort}/${db}"
	    variable	index		"//${hostOrPort}/${db}\\?${search}"
	    variable	doc		"//${hostOrPort}/${db}/${type}/${path}"


	    #variable	schemepart	"${doc}|${index}|${database}"

	    variable schemepart \
		    "//${hostOrPort}/${db}((\\?${search})|(/${type}/${path}))?"

	    variable	url		"wais:${schemepart}"

	    lappend ::pool::urls::schemes wais
	}

	# PROSPERO
	namespace eval prospero {
	    set escape		$::pool::urls::basic::escape
	    set hostOrPort	$::pool::urls::basic::hostOrPort
	    set path		$::pool::urls::ftp::path

	    variable	charN		{[a-zA-Z0-9$_.+!*'(,)?:@&-]}
	    variable	char		"(${charN}|$escape)"

	    variable	fieldname	"${char}*"
	    variable	fieldvalue	"${char}*"
	    variable	fieldspec	";${fieldname}=${fieldvalue}"

	    variable	schemepart	"//${hostOrPort}/${path}(${fieldspec})*"
	    variable	url		"prospero:$schemepart"

	    lappend ::pool::urls::schemes prospero
	}

	# ------------------------------------------------------
	# combine all together, self adjusting code, no need for maintenance
	# after adding more schemes

	variable schemePattern	"([join $schemes |]):"
	variable url		""
	variable url2part

	foreach scheme $schemes {
	    append url "(${scheme}:[set ${scheme}::schemepart])|"
	    set url2part($scheme) "${scheme}:[set ${scheme}::schemepart]"
	}
	set   url [string trimright $url |]
	unset scheme

	# ------------------------------------------------------
    }
}


# -----------------------------

proc ::pool::urls::extract {text} {
    # @c Scans through the HTML <a text> and extracts all URLs referenced in it
    # @c (links and image references)
    # @a text: The HTML string to search in.
    # @r List of urls found in the <a text>.
    # @i url extraction, extraction of urls from text

    # HTML commands containing urls:
    # * <A HREF=...></A>
    # * <IMG SRC=...>

    # steps:
    #   i) convert to all lowercase, to simplify search.
    #  ii) remove all text between '>' and '<'.
    # iii) remove all closing tags, and all tags not
    #      starting with '<a ' or '<img '.
    #  iv) now start looking for parameters HREF and SRC.
    #
    # (i)...(iii) are used to cut down on the size of the
    # string to search in

    set text   [string tolower $text]
    regsub -all {>[^<]*<}      $text {><} text	;# (i)
    regsub -all {</[^>]*>}     $text {}   text	;# (ii)
    regsub -all {<[^ai][^>]*>} $text {}   text	;# (iii)

    set ulist ""
    foreach pattern {
	{href="([^"]*)"}
	 {href=([^"][^ >]*)}
	 {src="([^"]*)"}
	  {src=([^"][^ >]*)}
    } {
	set working $text
	while {[regexp -indices $pattern $working dummy url]} {
	    lappend ulist [string range $working [lindex $url 0] [lindex $url 1]]
	    set working [string range $working [lindex $dummy 1] end]
	}
    }

    return $ulist
}



proc ::pool::urls::findUrls {text} {
    # @c Scans through the given <a text> and extracts all embedded URL's.
    # @a text: The string to search in.
    # @r List of urls found in the <a text>.
    # @i url extraction, extraction of urls from text


    variable schemes
    variable url2part

    set sList $schemes

    # remove the patterns which are too complicated.
    #::pool::list::delete sList wais

    # search for each scheme separately, the overall regular expression is much
    # to complicated

    foreach s $sList {
	if {![regexp "${s}:" $text]} {
	    continue
	}

	set pattern $url2part($s)

	#puts "$s = $pattern"

	while {[regexp -- $pattern $text match]} {
	    lappend result $match
	    regsub -- $match $text "" text
	}
    }

    return $result
}



proc ::pool::urls::split {url} {
    # @c Splits the given <a url> into its constituents.
    # @a url: The url to split, scheme part required.
    # @r List containing the constituents, suitable for 'array set'.

    # @n This procedure absolutely requires existence of the
    # @n 'scheme'-constituent in the given <a url>, it is
    # @n unable to parse a lone scheme-specific string.

    # @i url splitting, splitting an url into its constituents

    set url [string trim $url]

    # RFC 1738:	scheme = 1*[ lowalpha | digit | "+" | "-" | "." ]
    regexp {^([a-z0-9+-.][a-z0-9+-.]*):} $url dummy scheme

    if {$scheme == {}} {
	error "no scheme specified in '$url'"
    }

    # ease maintenance: dynamic dispatch, able to handle all schemes
    # added in future!

    if {[::info procs Split[::pool::string::cap $scheme]] == {}} {
	error "unknown scheme '$scheme' in '$url'"
    }

    regsub "^${scheme}:" $url {} url

    set       parts(scheme) $scheme
    array set parts [Split[::pool::string::cap $scheme] url]

    # should decode all encoded characters!

    return [array get parts]
}



proc ::pool::urls::SplitFtp {url} {
    # @c Splits the given ftp-<a url> into its constituents.
    # @a url: The url to split, without! scheme specification.
    # @r List containing the constituents, suitable for 'array set'.

    # general syntax:
    # //<user>:<password>@<host>:<port>/<cwd1>/.../<cwdN>/<name>;type=<typecode>
    #
    # additional rules:
    #
    # <user>:<password> are optional, detectable by presence of @.
    # <password> is optional too.
    #
    # "//" [ <user> [":" <password> ] "@"] <host> [":" <port>] "/"
    #	<cwd1> "/" ..."/" <cwdN> "/" <name> [";type=" <typecode>]

    upvar #0 ::pool::urls::ftp::typepart ftptype

    ::pool::array::def parts

    # slash off possible type specification

    if {[regexp -indices "${ftptype}$" $url dummy ftype]} {
	set from	[lindex $ftype 0]
	set to		[lindex $ftype 1]

	set parts(type)	[string range   $url $from $to]

	set from	[lindex $dummy 0]
	set url		[::pool::string::replace $url $from end]
    }

    # Handle user, password, host and port

    if {[string match "//*" $url]} {
	set url [string range $url 2 end]

	array set parts [GetUPHP url]
    }

    set parts(path) [string trimleft $url /]

    return [array get parts]
}



proc ::pool::urls::SplitHttp {url} {
    # @c Splits the given http-<a url> into its constituents.
    # @a url: The url to split, without! scheme specification.
    # @r List containing the constituents, suitable for 'array set'.

    # general syntax:
    # //<host>:<port>/<path>?<searchpart>
    #
    #   where <host> and <port> are as described in Section 3.1. If :<port>
    #   is omitted, the port defaults to 80.  No user name or password is
    #   allowed.  <path> is an HTTP selector, and <searchpart> is a query
    #   string. The <path> is optional, as is the <searchpart> and its
    #   preceding "?". If neither <path> nor <searchpart> is present, the "/"
    #   may also be omitted.
    #
    #   Within the <path> and <searchpart> components, "/", ";", "?" are
    #   reserved.  The "/" character may be used within HTTP to designate a
    #   hierarchical structure.
    #
    # path == <cwd1> "/" ..."/" <cwdN> "/" <name> ["#" <fragment>]

    upvar #0 ::pool::urls::http::search  search
    upvar #0 ::pool::urls::http::segment segment

    ::pool::array::def parts

    set searchPattern   "\\?(${search})\$"
    set fragmentPattern "#(${segment})\$"

    # slash off possible query

    if {[regexp -indices $searchPattern $url match query]} {
	set from [lindex $query 0]
	set to   [lindex $query 1]

	set parts(query) [string range $url $from $to]

	set url [::pool::string::replace $url [lindex $match 0] end]
    }

    # slash off possible fragment

    if {[regexp -indices $fragmentPattern $url match fragment]} {
	set from [lindex $fragment 0]
	set to   [lindex $fragment 1]

	set parts(fragment) [string range $url $from $to]

	set url [::pool::string::replace $url [lindex $match 0] end]
    }

    if {[string match "//*" $url]} {
	set url [string range $url 2 end]

	array set parts [GetHostPort url]
    }

    set parts(path) [string trimleft $url /]

    return [array get parts]
}



proc ::pool::urls::SplitFile {url} {
    # @c Splits the given file-<a url> into its constituents.
    # @a url: The url to split, without! scheme specification.
    # @r List containing the constituents, suitable for 'array set'.

    upvar #0 ::pool::urls::basic::hostname	hostname
    upvar #0 ::pool::urls::basic::hostnumber	hostnumber

    if {[string match "//*" $url]} {
	set url [string range $url 2 end]

	set hostPattern "^($hostname|$hostnumber)"

	if {[regexp -indices $hostPattern $u match host]} {
	    set fh	[lindex $host 0]
	    set th	[lindex $host 1]

	    set parts(host)	[string range $url $fh $th]

	    set  matchEnd   [lindex $match 1]
	    incr matchEnd

	    set url	[string range $url $matchEnd end]
	}
    }

    set parts(path) $url

    return [array get parts]
}



proc ::pool::urls::SplitMailto {url} {
    # @c Splits the given mailto-<a url> into its constituents.
    # @a url: The url to split, without! scheme specification.
    # @r List containing the constituents, suitable for 'array set'.

    if {[regexp @ $url]} {
	set url [split $url @]
	return [list user [lindex $url 0] host [lindex $url 1]]
    } else {
	return [list user $url]
    }
}



proc ::pool::urls::GetUPHP {urlvar} {
    # @c Parse user, password host and port out of the url stored in
    # @c variable <a urlvar>.
    # @d Side effect: The extracted information is removed from the given url.
    # @r List containing the extracted information in a format suitable for
    # @r 'array set'.
    # @a urlvar: Name of the variable containing the url to parse.

    upvar #0 ::pool::urls::basic::user		user
    upvar #0 ::pool::urls::basic::password	password
    upvar #0 ::pool::urls::basic::hostname	hostname
    upvar #0 ::pool::urls::basic::hostnumber	hostnumber
    upvar #0 ::pool::urls::basic::port		port

    upvar $urlvar url

    ::pool::array::def parts

    # syntax
    # "//" [ <user> [":" <password> ] "@"] <host> [":" <port>] "/"
    # "//" already cut off by caller

    set upPattern "^(${user})(:(${password}))?@"

    if {[regexp -indices $upPattern $u dummy theUser c d thePassword]} {
	set fu	[lindex $theUser 0]
	set tu	[lindex $theUser 1]
	    
	set fp	[lindex $thePassword 0]
	set tp	[lindex $thePassword 1]

	set parts(user)	[string range $u $fu $tu]
	set parts(pwd)	[string range $u $fp $tp]

	set  matchEnd   [lindex $user 1]
	incr matchEnd

	set url	[string range $u $matchEnd end]
    }

    set hpPattern "^($hostname|$hostnumber)(:($port))?"

    if {[regexp -indices $hpPattern $u match theHost c d e f g h thePort]} {
	set fh	[lindex $theHost 0]
	set th	[lindex $theHost 1]

	set fp	[lindex $thePort 0]
	set tp	[lindex $thePort 1]

	set parts(host)	[string range $u $fh $th]
	set parts(port)	[string range $u $fp $tp]

	set  matchEnd   [lindex $match 1]
	incr matchEnd

	set url	[string range $u $matchEnd end]
    }

    return [array get parts]
}



proc ::pool::urls::GetHostPort {urlvar} {
    # @c Parse host and port out of the url stored in variable <a urlvar>.
    # @d Side effect: The extracted information is removed from the given url.
    # @r List containing the extracted information in a format suitable for
    # @r 'array set'.
    # @a urlvar: Name of the variable containing the url to parse.

    upvar #0 ::pool::urls::basic::hostname	hostname
    upvar #0 ::pool::urls::basic::hostnumber	hostnumber
    upvar #0 ::pool::urls::basic::port		port

    upvar $urlvar url

    ::pool::array::def parts

    set pattern "^(${hostname}|${hostnumber})(:(${port}))?"

    if {[regexp -indices $pattern $url match host c d e f g h thePort]} {
	set fromHost	[lindex $host 0]
	set toHost	[lindex $host 1]

	set fromPort	[lindex $thePort 0]
	set toPort	[lindex $thePort 1]

	set parts(host)	[string range $u $fromHost $toHost]
	set parts(port)	[string range $u $fromPort $toPort]

	set  matchEnd   [lindex $match 1]
	incr matchEnd

	set url [string range $url $matchEnd end]
    }

    return [array get parts]
}



proc ::pool::urls::hyperize {text} {
    # @c Detects and transforms all urls found in <a text> into
    # @c equivalent hyperlinks. All special HTML characters found in the
    # @c non-url text are protected against their special interpretation
    # @c afterward.
    # @a text: string to search urls in.
    # @r A string with all urls transformed into hyperlinks

    # regexp of matching all known urls
    variable schemes
    variable url2part

    package require cgi

    set                n  1
    ::pool::array::def urls

    foreach scheme $schemes {
	# done this way as the complete url-regexp contains to much
	# parentheses to get compiled by tcl!

	if {![regexp "${scheme}:" $text]} {
	    continue
	}

	while {[regexp -indices $url2part($scheme) $text match]} {
	    set matchStart [lindex $match 0]
	    set matchEnd   [lindex $match 1]
	    set match      [string range $text $matchStart $matchEnd]

	    set replacement ##URL$n##

	    set text [::pool::string::replace \
		    $text $matchStart [incr matchEnd] $replacement]

	    set urls($replacement) [cgi_link _ $match $match]
	    incr n
	}
    }

    # protect HTML special characters in non-urls text
    set text [cgi_quote_html $text]

    foreach key [lsort [array names urls]] {
	regsub -- $key $text $urls($key) text
    }

    return $text
}



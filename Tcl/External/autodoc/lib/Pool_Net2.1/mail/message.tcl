# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: message.tcl,v 1.4 1998/06/02 20:05:31 aku Exp $
#
# @c Mail manipulation functionality, from the simple to the arcane (not yet?)
# @s Mail manipulation,
# @s defined in separate namespace, tcl 8.x only.
# @i Mail manipulation, Header manipulation, RFC 821, RFC 822
# -----------------------------

package require Tcl 8.0
package require Pool_Base


namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval mail {
	variable version @net:mFullVersion@
    }
}


proc ::pool::mail::body {message} {
    # @c Extract the body of <a message>.
    # @a message: String containing the message to be analysed.
    # @r Return body of <a message>.

    # split the message at the first empty line (may contain whitespace)
    set match [regexp -- "\n\[ \t]*\n(.*)$" $message dummy message]
    if {!$match} {
	return ""
    } else {
	return $message
    }
}



proc ::pool::mail::header {message} {
    # @c Extract the headers from the  <a message>.
    # @a message: String containing the message to be analysed.
    # @r Return headers of <a message>.

    # split the message at the first empty line (may contain whitespace)
    regsub -- "\n\[ \t]*\n(.*)$" $message {} message
    return $message
}



proc ::pool::mail::headerAnalyse {header} {
    # @c Transform the message <a header> into a form suitable
    # @c to 'array set'. Multiple instances of the same header
    # @c are merged into one (Received:). Continuation lines
    # @c are merged into a single line.
    # @a header: String containing the headers to be analysed
    # @r List suitable for 'array set', mapping header keywords
    # @r to their contents. Keywords are all lowercase.

    ::pool::array::def hdr
    set header [split $header \n]

    set last ""

    foreach line $header {
	if {[regexp "^\[\t \]" $line]} {
	    # continuation line, add to last header.
	    append hdr($last) " $line"
	} else {
	    regexp "(\[^:\]*:)(.*)" $line dummy key line
	    set key [string tolower $key]
	    append hdr($key) "\n$line"
	    set last $key
	}
    }

    # remove data of continuation lines before first real header!
    catch {unset hdr()}

    # remove superfluous characters introduced by parser
    foreach k [array names hdr] {
	set hdr($k) [string trim [::pool::string::removeSpaces $hdr($k)]]
    }

    return [array get hdr]
}



proc ::pool::mail::analyse {message} {
    # @c Transforms the whole <a message> into a form suitable for
    # @c 'array set'. The body is stored as pseudo header 'x-body:'.
    # @a message: String containing the message to be analysed.
    # @r Returns a list of header keywords and associated contents.

    array set hdr          [headerAnalyse [header $message]]
    set       hdr(x-body:) [body $message]
    return [array get hdr]
}



proc ::pool::mail::address {text} {
    # @c Extracts a valid rfc821 address from <a text>.
    # @c Copied from 'Exmh/lib/msgShow.tcl' (copyright: <xref Welch>)
    # @r Hopefully a valid mail address.
    # @a text: The string to search for a mail address

    # remove superfluous whitespace and surounding parentheses
    set text [string trim $text]

    if {[regsub {\(.*\)} $text {} newtext]} {
	set text $newtext
    }

    # look out for token grouped around @,
    # neither whitespace nor '"' allowed /"

    if {[regexp {[^ 	"]*@[^ 	"]*} $text token]} {
	# remove angle bracket, if present
	set token [string trim $token <>]
    } else {
	# no remote address found (one containing @),
	# so search for something in angle brackets.
	# if nothing like this is present just take
	# the first word!

	if [regexp {<.*>} $text token] {
	    set token [string trim $token <>]
	} else {
	    set token [lindex $text 0]
	}
    }

    return $token
}


proc ::pool::mail::addressB {text {default {}}} {
    # @c see RFC 821 on mail messages
    # @c originally copied from 'Exmh/lib/msgShow.tcl'.
    # @c Added comments and default argument.
    # @c A variant of <p ::pool::mail::address>, returns the
    # @c <a default> if no address could be recognized. 

    # @a text: Text check for an embedded email address.
    # @a default: value to use if no address was extractable.
    # @r The email address embedded in <a text> or the <a default>.


    # remove superfluous whitespace and surounding parentheses
    set text [string trim $text]

    if {[regsub {\(.*\)} $text {} newtext]} {
	set text $newtext
    }

    # look out for token grouped around @,
    # neither whitespace nor apostroph allowed

    if {[regexp {[^ 	"]*@[^ 	"]*} $text token]} {
	# remove angle bracket, if present
	return [string trim $token <>]
    } else {
	# no remote address found (one containing @),
	# so search for something in angle brackets.
	# if nothing like this is present just take
	# the first word!

	if [regexp {<.*>} $text token] {
	    return [string trim $token <>]
	} else {
	    #set token [lindex $text 0]
	}
    }

    # use provided default
    return $default
}


proc ::pool::mail::addresses {text} {
    # @c Extracts a list of address from <a text>.
    # @c They must be separated by ,
    # @r Hopefully a list of valid mail addresses.
    # @a text: The string to search for a mail addresses

    # comma is separator
    set text [split $text ,]
    set res ""

    foreach t $text {
	set t [address $t]
	if {$t == {}} {
	    continue
	}
	lappend res $t
    }

    return $res
}



proc ::pool::mail::build {msgvar} {
    # @c Takes an array containing headers and body of a
    # @c message (same format as generated by <p ::pool::mail::analyse>)
    # @c and builds a message string.
    # @a msgvar: Name of the array variable containing the
    # @a msgvar: message in split form
    # @r A message suitable for transmission

    upvar $msgvar m

    set body $m(x-body:)
    unset     m(x-body:)

    set str ""
    foreach h [array names m] {
	if {[regexp \n $m($h)]} {
	    # multiline contents, transform into series of headers.
	    foreach l [split $m($h) \n] {
		append str "$h $l\n"
	    }
	} else {
	    append str "$h $m($h)\n"
	}
    }

    # end of header marker, body afterward
    append str "\n"
    append str $body

    # regenerate removed entry, array must not be changed
    set m(x-body:) $body

    return $str
}



proc ::pool::mail::sender {msgvar} {
    # @c Retrieves the sender of the message from the given array.
    # @a msgvar: Name of the array variable containing the
    # @a msgvar: message in split form
    # @r Mail address of sender.

    upvar $msgvar m
    return [address $m(from:)]
}



proc ::pool::mail::recipients {msgvar} {
    # @c Retrieves the recipients of the message from the given array.
    # @a msgvar: Name of the array variable containing the
    # @a msgvar: message in split form
    # @r Mail addresses of the recipients.

    upvar $msgvar m
    set res [addresses $m(to:)]
    if {[info exists m(cc:)]} {
	eval lappend res [addresses $m(cc:)]
    }

    return $res
}



proc ::pool::mail::invisibleRecipients {msgvar} {
    # @c Retrieves the recipients of the message which are
    # @c invisible to all others from the given array.
    # @a msgvar: Name of the array variable containing the
    # @a msgvar: message in split form
    # @r List of addresses

    upvar $msgvar m
    if {[info exists m(bcc:)]} {
	return [addresses $m(bcc:)]
    } else {
	return {}
    }
}


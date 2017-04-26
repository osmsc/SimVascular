# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/open.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3OpenSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3OpenSeq {
    variable  _superclasses    pop3Sequencer
    variable  _scChainForward  pop3OpenSeq
    variable  _scChainBackward pop3OpenSeq
    variable  _classVariables  {}
    variable  _methods         {GotGreeting OpenTry constructor}

    variable  _variables
    array set _variables  {tries {pop3OpenSeq {isArray 0 initialValue 0}}}

    variable  _options
    array set _options  {retrydelay {pop3OpenSeq {-default 10000 -type ::pool::getopt::notype -action {} -class Retrydelay}} maxtries {pop3OpenSeq {-default 1 -type ::pool::getopt::notype -action {} -class Maxtries}} host {pop3OpenSeq {-default localhost -type ::pool::getopt::notype -action {} -class Host}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {OpenTry . constructor . GotGreeting .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3OpenSeq::GotGreeting {line} {
    ::pool::oo::support::SetupVars pop3OpenSeq
    # @c Called after the the demon sent a greeting message
	# @c identifying itself. The sent information is stored
	# @c in the pop3 descriptor as it may contain information
	# @c required by APOP.
	#
	# @a line: Text of response

	Log                     $line
	$opt(-conn) SetGreeting $line

	event done
	return
}



proc ::pool::oo::class::pop3OpenSeq::OpenTry {} {
    ::pool::oo::support::SetupVars pop3OpenSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Tries to get a socket refering to a connection to the
	# @c server. In case of failure at most <o maxtries> retries are made
	# @c before giving up.

	incr tries

	#parray opt
	#::puts "tries=$tries"

	::pool::syslog::syslog debug  "Connecting to $opt(-host) on port [::pool::pop3::port] ($tries)"

	set fail [catch {
	    set sock [socket $opt(-host) [::pool::pop3::port]]
	} errmsg] ;# {}

	::pool::syslog::syslog debug "Connecting: $fail $errmsg"

	if {$fail} {
	    if {$tries == $opt(-maxtries)} {
		event error $errmsg
	    }

	    after $opt(-retrydelay) $this event next
	    return
	}

	# We have a connection now, configure it, then wait for
	# initial greeting send by demon we are talking to.

	fconfigure $sock -blocking 0 -buffering line -translation crlf

	$opt(-conn) SetSock $sock
	set opt(-sock)      $sock

	wait $sock GotGreeting
	return
}



proc ::pool::oo::class::pop3OpenSeq::constructor {} {
    ::pool::oo::support::SetupVars pop3OpenSeq
    # @c Constructor.

	next OpenTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3OpenSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3OpenSeq

# Create object instantiation procedure
interp alias {} pop3OpenSeq {} ::pool::oo::support::New pop3OpenSeq

# -------------------------------


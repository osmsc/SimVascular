# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/smtp/open.cls'.
# Date: Thu Sep 14 23:03:30 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> smtpOpenSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::smtpOpenSeq {
    variable  _superclasses    smtpSequencer
    variable  _scChainForward  smtpOpenSeq
    variable  _scChainBackward smtpOpenSeq
    variable  _classVariables  {}
    variable  _methods         {GotGreeting GotHeloResponse OpenTry constructor}

    variable  _variables
    array set _variables  {tries {smtpOpenSeq {isArray 0 initialValue 0}}}

    variable  _options
    array set _options  {helo {smtpOpenSeq {-default {} -type ::pool::getopt::notype -action {} -class Helo}} retrydelay {smtpOpenSeq {-default 10000 -type ::pool::getopt::notype -action {} -class Retrydelay}} maxtries {smtpOpenSeq {-default 1 -type ::pool::getopt::notype -action {} -class Maxtries}} host {smtpOpenSeq {-default localhost -type ::pool::getopt::notype -action {} -class Host}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {OpenTry . GotHeloResponse . constructor . GotGreeting .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::smtpOpenSeq::GotGreeting {line} {
    ::pool::oo::support::SetupVars smtpOpenSeq
    # @c Called after the the demon sent a greeting message
	# @c identifying itself. Now we identify ourselves by
	# @c sending HELO with an appropriate argument.
	#
	# @a line: Text of response

	Log   $line
	wait  $opt(-sock) GotHeloResponse
	Write "HELO $opt(-helo)"
	return
}



proc ::pool::oo::class::smtpOpenSeq::GotHeloResponse {line} {
    ::pool::oo::support::SetupVars smtpOpenSeq
    # @c Called after the demon reacted on HELO. Depending
	# @c on the type of response the transaction completes
	# @c with either success or failure.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	   event done
	}
}



proc ::pool::oo::class::smtpOpenSeq::OpenTry {} {
    ::pool::oo::support::SetupVars smtpOpenSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Tries to get a socket refering to a connection to the
	# @c server. In case of failure at most <o maxtries> retries are made
	# @c before giving up.

	incr tries

	set fail [catch {
	    set sock [socket $opt(-host) [::pool::smtp::port]]
	} errmsg] ;# {}

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



proc ::pool::oo::class::smtpOpenSeq::constructor {} {
    ::pool::oo::support::SetupVars smtpOpenSeq
    # @c Constructor.

	next OpenTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::smtpOpenSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::smtpSequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences smtpOpenSeq

# Create object instantiation procedure
interp alias {} smtpOpenSeq {} ::pool::oo::support::New smtpOpenSeq

# -------------------------------


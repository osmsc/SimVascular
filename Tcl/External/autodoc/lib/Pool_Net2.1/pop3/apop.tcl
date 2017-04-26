# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/apop.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3ApopSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
# This sequencer relies on my Trf extension to generate and encode the
	# required hashes.

	package require Trf

# Namespace describing the class
namespace eval ::pool::oo::class::pop3ApopSeq {
    variable  _superclasses    pop3Sequencer
    variable  _scChainForward  pop3ApopSeq
    variable  _scChainBackward pop3ApopSeq
    variable  _classVariables  {}
    variable  _methods         {ApopTry GotApopResponse GotStatResponse constructor}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {greeting {pop3ApopSeq {-default {} -type ::pool::getopt::nonempty -action {} -class Greeting}} secret {pop3ApopSeq {-default {} -type ::pool::getopt::nonempty -action {} -class Secret}} user {pop3ApopSeq {-default {} -type ::pool::getopt::nonempty -action {} -class User}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {GotApopResponse . GotStatResponse . constructor . ApopTry .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3ApopSeq::ApopTry {} {
    ::pool::oo::support::SetupVars pop3ApopSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Extracts the timestamp from the greeting, uses
	# @c this and the password to generate the response to our challenge,
	# @c then writes out the login command to the pop3 server, at last
	# @c waits for its response.

	# extract server timestamp from greeting
	regexp {<(.*)@(.*)>} $opt(-greeting) timestamp

	if {$timestamp == {}}       {
	    error "no timestamp, server unable to handle APOP"
	}

	# generate the hash

	set digIn  "${timestamp}$opt(-secret)"
	set digOut [hex -mode encode $digIn]

	::pool::syslog::syslog debug $this digest input <${digIn}>
	::pool::syslog::syslog debug $this digest outpt <${digOut}>

	# create the sequencer ...

	wait $opt(-sock) GotApopResponse
	Write "APOP $opt(-user) $digOut"
	return
}



proc ::pool::oo::class::pop3ApopSeq::GotApopResponse {line} {
    ::pool::oo::support::SetupVars pop3ApopSeq
    # @c Called after pop3 demon responded to the APOP command. Depending
	# @c on the result of the login the sequencer stops its operation now
	# @c (error), or writes out the command to retrieve the number of
	# @c messages storeed in the mailbox (successful login).
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    wait   $opt(-sock) GotStatResponse
	    Write "STAT"
	}
}



proc ::pool::oo::class::pop3ApopSeq::GotStatResponse {line} {
    ::pool::oo::support::SetupVars pop3ApopSeq
    # @c Called after pop3 demon responded to the STAT command.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    $opt(-conn) SetN [lindex $line 1]
	    event done
	}
}



proc ::pool::oo::class::pop3ApopSeq::constructor {} {
    ::pool::oo::support::SetupVars pop3ApopSeq
    # @c Constructor.

	next ApopTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3ApopSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3ApopSeq

# Create object instantiation procedure
interp alias {} pop3ApopSeq {} ::pool::oo::support::New pop3ApopSeq

# -------------------------------


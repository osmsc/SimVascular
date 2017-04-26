# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/user.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3UserSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3UserSeq {
    variable  _superclasses    pop3Sequencer
    variable  _scChainForward  pop3UserSeq
    variable  _scChainBackward pop3UserSeq
    variable  _classVariables  {}
    variable  _methods         {GotPassResponse GotStatResponse GotUserResponse UserTry constructor}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {secret {pop3UserSeq {-default {} -type ::pool::getopt::nonempty -action {} -class Secret}} user {pop3UserSeq {-default {} -type ::pool::getopt::nonempty -action {} -class User}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {GotUserResponse . GotPassResponse . GotStatResponse . constructor . UserTry .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3UserSeq::GotPassResponse {line} {
    ::pool::oo::support::SetupVars pop3UserSeq
    # @c Called after pop3 demon responded to the PASS command. Depending
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



proc ::pool::oo::class::pop3UserSeq::GotStatResponse {line} {
    ::pool::oo::support::SetupVars pop3UserSeq
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



proc ::pool::oo::class::pop3UserSeq::GotUserResponse {line} {
    ::pool::oo::support::SetupVars pop3UserSeq
    # @c Called after pop3 demon responded to the USER command. Send the
	# @c password to the server (in clear!), but only if the user was
	# @c accepted by the server.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    wait   $opt(-sock) GotPassResponse
	    Write "PASS $opt(-secret)"
	    # not so secret here in open transmission!
	}
}



proc ::pool::oo::class::pop3UserSeq::UserTry {} {
    ::pool::oo::support::SetupVars pop3UserSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the login command to the pop3 server, then
	# @c waits for its response.

	# create the sequencer ...

	wait $opt(-sock) GotUserResponse
	Write "USER $opt(-user)"
	return
}



proc ::pool::oo::class::pop3UserSeq::constructor {} {
    ::pool::oo::support::SetupVars pop3UserSeq
    # @c Constructor.

	next UserTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3UserSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3UserSeq

# Create object instantiation procedure
interp alias {} pop3UserSeq {} ::pool::oo::support::New pop3UserSeq

# -------------------------------


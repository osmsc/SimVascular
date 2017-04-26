# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/dele.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3DeleteSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3DeleteSeq {
    variable  _superclasses    pop3Sequencer
    variable  _scChainForward  pop3DeleteSeq
    variable  _scChainBackward pop3DeleteSeq
    variable  _classVariables  {}
    variable  _methods         {DeleteTry GotDeleResponse constructor}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {msg {pop3DeleteSeq {-default {} -type ::pool::getopt::nonempty -action {} -class Msg}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {DeleteTry . constructor . GotDeleResponse .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3DeleteSeq::DeleteTry {} {
    ::pool::oo::support::SetupVars pop3DeleteSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the deletion command to the pop3 server,
	# @c then waits for its response.

	wait $opt(-sock) GotDeleResponse
	Write "DELE $opt(-msg)"
	return
}



proc ::pool::oo::class::pop3DeleteSeq::GotDeleResponse {line} {
    ::pool::oo::support::SetupVars pop3DeleteSeq
    # @c Called after pop3 demon responded to the DELE command.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    event done
	}
}



proc ::pool::oo::class::pop3DeleteSeq::constructor {} {
    ::pool::oo::support::SetupVars pop3DeleteSeq
    # @c Constructor.

	next DeleteTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3DeleteSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3DeleteSeq

# Create object instantiation procedure
interp alias {} pop3DeleteSeq {} ::pool::oo::support::New pop3DeleteSeq

# -------------------------------


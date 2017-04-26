# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/close.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3CloseSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3CloseSeq {
    variable  _superclasses    pop3Sequencer
    variable  _scChainForward  pop3CloseSeq
    variable  _scChainBackward pop3CloseSeq
    variable  _classVariables  {}
    variable  _methods         {CloseTry GotQuitResponse constructor}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {GotQuitResponse . CloseTry . constructor .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3CloseSeq::CloseTry {} {
    ::pool::oo::support::SetupVars pop3CloseSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the command to the demon, then waits for
	# @c its response.

	wait $opt(-sock) GotQuitResponse
	Write QUIT
	return
}



proc ::pool::oo::class::pop3CloseSeq::GotQuitResponse {line} {
    ::pool::oo::support::SetupVars pop3CloseSeq
    # @c Called after pop3 demon responded to the QUIT command.
	# @c Whatever state we are in, the channel will be closed.
	#
	# @a line: Text of response

	Log $line

	$opt(-conn) ClearSocket

	if {[IsError $line]} {
	    event error $line
	} else {
	    event done
	}
}



proc ::pool::oo::class::pop3CloseSeq::constructor {} {
    ::pool::oo::support::SetupVars pop3CloseSeq
    # @c Constructor.

	next CloseTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3CloseSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3CloseSeq

# Create object instantiation procedure
interp alias {} pop3CloseSeq {} ::pool::oo::support::New pop3CloseSeq

# -------------------------------


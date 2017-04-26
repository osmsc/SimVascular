# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/smtp/close.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> smtpCloseSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::smtpCloseSeq {
    variable  _superclasses    smtpSequencer
    variable  _scChainForward  smtpCloseSeq
    variable  _scChainBackward smtpCloseSeq
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


proc ::pool::oo::class::smtpCloseSeq::CloseTry {} {
    ::pool::oo::support::SetupVars smtpCloseSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the command to the demon, then waits for
	# @c its response.

	wait $opt(-sock) GotQuitResponse
	Write QUIT
	return
}



proc ::pool::oo::class::smtpCloseSeq::GotQuitResponse {line} {
    ::pool::oo::support::SetupVars smtpCloseSeq
    # @c Called after smtp demon responded to the QUIT command.
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



proc ::pool::oo::class::smtpCloseSeq::constructor {} {
    ::pool::oo::support::SetupVars smtpCloseSeq
    # @c Constructor.

	next CloseTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::smtpCloseSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::smtpSequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences smtpCloseSeq

# Create object instantiation procedure
interp alias {} smtpCloseSeq {} ::pool::oo::support::New smtpCloseSeq

# -------------------------------


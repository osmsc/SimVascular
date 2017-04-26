# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/acceptEverything.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> acceptEverything <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::acceptEverything {
    variable  _superclasses    popClientMsgClassificatorBase
    variable  _scChainForward  acceptEverything
    variable  _scChainBackward acceptEverything
    variable  _classVariables  {}
    variable  _methods         classify

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
    array set _methodTable  {classify .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::acceptEverything::classify {client msgId messageHeader} {
    ::pool::oo::support::SetupVars acceptEverything
    # @c Just tell the calling pop client to get the mail. See
	# @c <c pop3Client> for a class using it.
	#
	# @a client:        Handle of the pop client object requesting our
	# @a client:        assistance.
	# @a msgId:         Number of the message to classify
	# @a messageHeader: Ignored here.

	$client msgRetrieve $msgId
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::acceptEverything::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::popClientMsgClassificatorBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences acceptEverything

# Create object instantiation procedure
interp alias {} acceptEverything {} ::pool::oo::support::New acceptEverything

# -------------------------------


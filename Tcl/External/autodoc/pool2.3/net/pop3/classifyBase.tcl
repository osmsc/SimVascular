# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/classifyBase.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> popClientMsgClassificatorBase <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::popClientMsgClassificatorBase {
    variable  _superclasses    {}
    variable  _scChainForward  popClientMsgClassificatorBase
    variable  _scChainBackward popClientMsgClassificatorBase
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


proc ::pool::oo::class::popClientMsgClassificatorBase::classify {client msgId messageHeader} {
    ::pool::oo::support::SetupVars popClientMsgClassificatorBase
    # @c Abstract method, used by <c pop3Client> to request the
	# @c classification of incoming mail. Use one of the methods
	# @c <pop3Client:msgRetrieve>, <pop3Client:msgIgnore> and
	# @c <pop3Client:msgDelete> to send the client the decision.
	#
	# @a client:        Handle of the pop client object requesting our
	# @a client:        assistance.
	# @a msgId:         Number of the message to classify
	# @a messageHeader: Ignored here.

	error "[oinfo class]: abstract method 'classify' not overidden"
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::popClientMsgClassificatorBase::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods popClientMsgClassificatorBase
::pool::oo::support::FixOptions popClientMsgClassificatorBase

# Create object instantiation procedure
interp alias {} popClientMsgClassificatorBase {} ::pool::oo::support::New popClientMsgClassificatorBase

# -------------------------------


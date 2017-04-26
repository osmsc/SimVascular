# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/udbBase.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> userdbBase <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::userdbBase {
    variable  _superclasses    {}
    variable  _scChainForward  userdbBase
    variable  _scChainBackward userdbBase
    variable  _classVariables  {}
    variable  _methods         lookup

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
    array set _methodTable  {lookup .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::userdbBase::lookup {name} {
    ::pool::oo::support::SetupVars userdbBase
    # @c Abstract method.
	# @c Query database for information about user <a name>.
	# @a name: Name of the user to query for.
	# @r a 2-element list containing password and storage 
	# @r location of user <a name>, in this order.

	error "[oinfo class]: abstract method 'lookup' not overidden"
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::userdbBase::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods userdbBase
::pool::oo::support::FixOptions userdbBase

# Create object instantiation procedure
interp alias {} userdbBase {} ::pool::oo::support::New userdbBase

# -------------------------------


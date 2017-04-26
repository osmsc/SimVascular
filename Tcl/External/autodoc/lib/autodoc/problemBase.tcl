# -*- tcl -*-
# Automatically generated from file 'problemBase.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> problemBase <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::problemBase {
    variable  _superclasses    formatterInterface
    variable  _scChainForward  problemBase
    variable  _scChainBackward problemBase
    variable  _classVariables  {}
    variable  _methods         {clear pPage}

    variable  _variables
    array set _variables  {problemPage {problemBase {isArray 0 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {pPage . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::problemBase::clear {} {
    ::pool::oo::support::SetupVars problemBase
    # @c Resets the state information of a scan to allow future
	# @c reconfiguration and scanning.

	set problemPage {}
	return
}



proc ::pool::oo::class::problemBase::pPage {} {
    ::pool::oo::support::SetupVars problemBase
    # @r Retrieval interface to the location information. Generates a
	# @c unique page upon the first call and then returns always this
	# @c information.

	if {[string length $problemPage] == 0} {
	    set problemPage prob[::pool::serial::new]
	}

	return [$fmt pageFile $problemPage]
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::problemBase::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::formatterInterface::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences problemBase

# Create object instantiation procedure
interp alias {} problemBase {} ::pool::oo::support::New problemBase

# -------------------------------


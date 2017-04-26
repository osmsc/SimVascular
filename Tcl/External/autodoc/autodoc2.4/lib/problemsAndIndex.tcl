# -*- tcl -*-
# Automatically generated from file 'problemsAndIndex.cls'.
# Date: Thu Sep 07 18:20:50 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> problemsAndIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::problemsAndIndex {
    variable  _superclasses    {problems problemIndex}
    variable  _scChainForward  problemsAndIndex
    variable  _scChainBackward problemsAndIndex
    variable  _classVariables  {}
    variable  _methods         {addProblemObject clear}

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
    array set _methodTable  {addProblemObject . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::problemsAndIndex::addProblemObject {o} {
    ::pool::oo::support::SetupVars problemsAndIndex
    # @c Overrides base class functionality
	# @c (<m problemIndex:addProblemObject>) to add signal propagation
	# @c capabilities to it.
	#
	# @a o: The handle of the problematic object.

	problemIndex_addProblemObject $o

	# No further ado is required, the receiver will filter multiple
	# registrations.

	$opt(-index) addProblemObject $this
	return
}



proc ::pool::oo::class::problemsAndIndex::clear {} {
    ::pool::oo::support::SetupVars problemsAndIndex
    # @c Resets state information

	problems_clear
	problemIndex_clear
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::problemsAndIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::problems::loadClass
::pool::oo::class::problemIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences problemsAndIndex

# Create object instantiation procedure
interp alias {} problemsAndIndex {} ::pool::oo::support::New problemsAndIndex

# -------------------------------


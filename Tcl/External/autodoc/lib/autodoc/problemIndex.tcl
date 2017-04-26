# -*- tcl -*-
# Automatically generated from file 'problemIndex.cls'.
# Date: Thu Sep 07 18:20:50 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> problemIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::problemIndex {
    variable  _superclasses    {problemBase formatterInterface}
    variable  _scChainForward  problemIndex
    variable  _scChainBackward problemIndex
    variable  _classVariables  {}
    variable  _methods         {addProblemObject clear numProblemObjects writeProblemIndex}

    variable  _variables
    array set _variables  {problemObjects {problemIndex {isArray 0 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {writeProblemIndex . addProblemObject . clear . numProblemObjects .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::problemIndex::addProblemObject {object} {
    ::pool::oo::support::SetupVars problemIndex
    # @c Adds the <a object> to the list of problematic entities. The
	# @c class automatically filters duplicate entries.
	#
	# @a object: The handle of the added object.

	lappend problemObjects $object
	set     problemObjects [::pool::list::uniq $problemObjects]

	return
}



proc ::pool::oo::class::problemIndex::clear {} {
    ::pool::oo::support::SetupVars problemIndex
    # @c Resets state information.

	#puts "$this clear / class = [$this oinfo class]"

	problemBase_clear
	set problemObjects {}
	return
}



proc ::pool::oo::class::problemIndex::numProblemObjects {} {
    ::pool::oo::support::SetupVars problemIndex
    # @r The number of registered problematic objects.

	return [llength $problemObjects]
}



proc ::pool::oo::class::problemIndex::writeProblemIndex {} {
    ::pool::oo::support::SetupVars problemIndex
    # @c Generates a list of references to the detailed problem
	# @c descriptions of all registered objects.

	#puts "$this writeProblemIndex [$this oinfo class]"

	$fmt pushAppendClass -problems
	$fmt itemize {
	    foreach o [$fmt sortByName $problemObjects] {
		$fmt item [$fmt link [$o name] [$o pPage]]
	    }
	}
	$fmt popClass

	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::problemIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::problemBase::loadClass
::pool::oo::class::formatterInterface::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences problemIndex

# Create object instantiation procedure
interp alias {} problemIndex {} ::pool::oo::support::New problemIndex

# -------------------------------


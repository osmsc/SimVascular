# -*- tcl -*-
# Automatically generated from file 'packageIndex.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> packageIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::packageIndex {
    variable  _superclasses    {indexBase problemIndex}
    variable  _scChainForward  packageIndex
    variable  _scChainBackward packageIndex
    variable  _classVariables  {}
    variable  _methods         {completeDatabase constructor writeProblemPage}

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
    array set _methodTable  {writeProblemPage . completeDatabase . constructor .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::packageIndex::completeDatabase {author} {
    ::pool::oo::support::SetupVars packageIndex
    # @c Propagates author-information to the indexed packages and their
	# @c contents (files, classes, procedures)
	#
	# @a author: Author of the distribution.
	# @r a list containing the names of all packages defined by the scanned
	# @r distribution.

	set internal {}

	foreach item $items {
	    $item completeDatabase $author
	    lappend internal [$item name]
	}

	return $internal
}



proc ::pool::oo::class::packageIndex::constructor {} {
    ::pool::oo::support::SetupVars packageIndex
    # @c Constructor, parameterizes the baseclass.

	set indexPage        packages
	set indexName        packages
	set indexShortTitle  Packages
	set indexTitle       "Index of packages"
	set entity           package
	return
}



proc ::pool::oo::class::packageIndex::writeProblemPage {} {
    ::pool::oo::support::SetupVars packageIndex
    # @c Writes a page containing references to the detailed problem
	# @c descriptions of packages having such.

	if {[numProblemObjects] > 0} {
	    $fmt newPage [pPage] "Problematic packages"
	    writeProblemIndex
	    $fmt closePage

	    foreach o $problemObjects {
		$o writeProblemPage
	    }
	}
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::packageIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::indexBase::loadClass
::pool::oo::class::problemIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences packageIndex

# Create object instantiation procedure
interp alias {} packageIndex {} ::pool::oo::support::New packageIndex

# -------------------------------


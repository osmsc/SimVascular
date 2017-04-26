# -*- tcl -*-
# Automatically generated from file 'procIndex.cls'.
# Date: Thu Sep 07 18:20:50 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> procIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::procIndex {
    variable  _superclasses    azIndex
    variable  _scChainForward  procIndex
    variable  _scChainBackward procIndex
    variable  _classVariables  {}
    variable  _methods         {clear constructor writeProblemPage}

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
    array set _methodTable  {writeProblemPage . constructor . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::procIndex::clear {} {
    ::pool::oo::support::SetupVars procIndex
    # @c Resets state information

	azIndex_clear
	return
}



proc ::pool::oo::class::procIndex::constructor {} {
    ::pool::oo::support::SetupVars procIndex
    # @c Constructor, parameterizes the baseclass.

	set indexPage       procs
	set indexName       procs
	set indexShortTitle Procedures
	set indexTitle      "Index of procedures"
	set entity          procedure
	return
}



proc ::pool::oo::class::procIndex::writeProblemPage {} {
    ::pool::oo::support::SetupVars procIndex
    # @c Writes a page containing references to the detailed problem
	# @c descriptions of procedures having such.

	if {[numProblemObjects] > 0} {
	    $fmt  newPage [pPage] "Problematic procedures"
	    $dist writeJumpbar

	    writeProblemIndex
	    $fmt closePage
	}
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::procIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences procIndex

# Create object instantiation procedure
interp alias {} procIndex {} ::pool::oo::support::New procIndex

# -------------------------------


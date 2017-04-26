# -*- tcl -*-
# Automatically generated from file 'fileIndex.cls'.
# Date: Thu Sep 07 18:20:48 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> fileIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::fileIndex {
    variable  _superclasses    azIndex
    variable  _scChainForward  fileIndex
    variable  _scChainBackward fileIndex
    variable  _classVariables  {}
    variable  _methods         {clear constructor getRef writeProblemPage}

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
    array set _methodTable  {getRef . writeProblemPage . constructor . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::fileIndex::clear {} {
    ::pool::oo::support::SetupVars fileIndex
    # @c Resets state information

	azIndex_clear
	return
}



proc ::pool::oo::class::fileIndex::constructor {} {
    ::pool::oo::support::SetupVars fileIndex
    # @c Constructor, parameterizes the baseclass.

	set indexPage       files
	set indexName       files
	set indexShortTitle "Files"
	set indexTitle      "Index of files"
	set entity          file
	return
}



proc ::pool::oo::class::fileIndex::getRef {name} {
    ::pool::oo::support::SetupVars fileIndex
    # @c Override of baseclass functionality (<m indexBase:getRef>). A file
	# @c not in the index is searched relative to the basedir of the
	# @c distribution and not marked as error (if it exists.)
	#
	# @a name: The name of the file searched by the caller.

	foreach i $items {
	    if {[string compare $name [$i name]] == 0} {
		return [list 1 [$i link]]
	    }
	}

	set fullName [file join [$dist cget -srcdir] $name]

	if {[file exists $fullName]} {
	    # -W- switchable warning in future.
	    #::puts "file not indexed, exists: $name => $fullName"

	    return [list 1 [$fmt strong $name]]
	}

	return [list 0 [refError $name]]
}



proc ::pool::oo::class::fileIndex::writeProblemPage {} {
    ::pool::oo::support::SetupVars fileIndex
    # @c Writes a page containing references to the detailed problem
	# @c descriptions of files having such.

	if {[numProblemObjects] > 0} {
	    $fmt  newPage [pPage] "Problematic files"
	    $dist writeJumpbar

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
proc ::pool::oo::class::fileIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences fileIndex

# Create object instantiation procedure
interp alias {} fileIndex {} ::pool::oo::support::New fileIndex

# -------------------------------


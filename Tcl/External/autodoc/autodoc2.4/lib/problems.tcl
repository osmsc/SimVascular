# -*- tcl -*-
# Automatically generated from file 'problems.cls'.
# Date: Thu Sep 07 18:20:50 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> problems <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::problems {
    variable  _superclasses    {problemBase indexBaseEntry}
    variable  _scChainForward  problems
    variable  _scChainBackward problems
    variable  _classVariables  {}
    variable  _methods         {addProblem clear numProblems writeProblems}

    variable  _variables
    array set _variables  {problems {problems {isArray 1 initialValue {
	crossref {}
	desc     {}
    }}} numProblems {problems {isArray 0 initialValue 0}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {numProblems . addProblem . writeProblems . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::problems::addProblem {category errortext url} {
    ::pool::oo::support::SetupVars problems
    # @c Adds a problem specified by <a category>, <a errortext> and a
	# @c place to link to to the list of problems
	#
	# @a category:  Either [strong crossref] or [strong desc].
	# @a errortext: A description of the problem.
	# @a url:       Reference to the place of the problem.

	if {($numProblems == 0) && ([string length $opt(-index)] != 0)} {
	    $opt(-index) addProblemObject $this
	}

	incr numProblems
	lappend problems($category) [list $errortext $url]
	return
}



proc ::pool::oo::class::problems::clear {} {
    ::pool::oo::support::SetupVars problems
    # @c Resets state information.

	problemBase_clear

	set numProblems 0
	array set problems {
	    crossref {}
	    desc     {}
	}
	return
}



proc ::pool::oo::class::problems::numProblems {} {
    ::pool::oo::support::SetupVars problems
    # @r The number of reported problems.

	return $numProblems
}



proc ::pool::oo::class::problems::writeProblems {} {
    ::pool::oo::support::SetupVars problems
    # @c Generates the formatting for all reported problems.

	$fmt setAnchor $this
	$fmt definitionList {
	    $fmt defterm  [$fmt link [$this name] [$this page]]  [$fmt getString {

		foreach d $problems(desc) {
		    set text [lindex $d 0]
		    set url  [lindex $d 1]

		    if {[string length $url] == 0} {
			$fmt par $text
		    } else {
			$fmt par [$fmt link $text $url]
		    }
		}

		foreach cr $problems(crossref) {
		    set text [lindex $cr 0]
		    set url  [lindex $cr 1]

		    if {[string length $url] == 0} {
			$fmt par $text
		    } else {
			$fmt par [$fmt link $text $url]
		    }
		}


	    }] ;#{}
	}
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::problems::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::problemBase::loadClass
::pool::oo::class::indexBaseEntry::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences problems

# Create object instantiation procedure
interp alias {} problems {} ::pool::oo::support::New problems

# -------------------------------


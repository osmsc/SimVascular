# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: problems.cls,v 1.1 1998/05/26 20:34:38 aku Exp $
#
# @c Management of problems for an entity
# @s Problem management
# @i problem management, management of problems
# ----------------------------------------------------------------------


class problems : problemBase indexBaseEntry {
    # @c Common behaviour and variables of all classes which are able to record
    # @c problems of their respectivee entity.

    # @v numProblems: Number of problems reported so far.

    var numProblems 0

    # @v problems: Map from error categories to the actual problem
    # @v problems: descriptions. The system currently recognizes
    # @v problems: [strong crossref]erencing and [strong desc]ription related
    # @v problems: problems. A problem description is a 2-element list
    # @v problems: containing the error text and a page reference to link to,
    # @v problems: in this order. The latter is allowed to be empty.

    var -array problems {
	crossref {}
	desc     {}
    }



    method addProblem {category errortext url} {
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



    method numProblems {} {
	# @r The number of reported problems.

	return $numProblems
    }



    method writeProblems {} {
	# @c Generates the formatting for all reported problems.

	$fmt setAnchor $this
	$fmt definitionList {
	    $fmt defterm \
		    [$fmt link [$this name] [$this page]] \
		    [$fmt getString {

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



    method clear {} {
	# @c Resets state information.

	problemBase_clear

	set numProblems 0
	array set problems {
	    crossref {}
	    desc     {}
	}
	return
    }
}


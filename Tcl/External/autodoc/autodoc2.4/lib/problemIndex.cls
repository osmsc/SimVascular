# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: problemIndex.cls,v 1.3 2000/09/05 20:10:43 aku Exp $
#
# @c Management of problem indices.
# @s Problem indices.
# @i problem management, management of problems, problem index, indices
# ----------------------------------------------------------------------

class problemIndex : problemBase formatterInterface {
    # @c This class contains the common variables and behaviour of all indices
    # @c whose entities are able to record problems. It records all objects
    # @c signaling to have problems (via <m addProblemObject>) and provides
    # @c functionality to generate a block of references to their detailed
    # @c problem descriptions.

    # @see <c problems>.

    # @v problemObjects: The ist of objects having problems (at least they
    # @v problemObjects: said so).

    var problemObjects {}


    method addProblemObject {object} {
	# @c Adds the <a object> to the list of problematic entities. The
	# @c class automatically filters duplicate entries.
	#
	# @a object: The handle of the added object.

	lappend problemObjects $object
	set     problemObjects [::pool::list::uniq $problemObjects]

	return
    }




    method numProblemObjects {} {
	# @r The number of registered problematic objects.

	return [llength $problemObjects]
    }




    method writeProblemIndex {} {
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



    method clear {} {
	# @c Resets state information.

	#puts "$this clear / class = [$this oinfo class]"

	problemBase_clear
	set problemObjects {}
	return
    }
}


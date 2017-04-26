# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: problemsAndIndex.cls,v 1.2 2000/09/05 20:10:43 aku Exp $
#
# @c Helper for classes having problems and having subordinate objects having
# @c problems.
# @s Helper class for problem management
# @i problem management, management of problems
# ----------------------------------------------------------------------


class problemsAndIndex : problems problemIndex {

    # @c Entities managing a set of problems of their own [strong and] an index
    # @c of problematic objects contained in them should derive from this
    # @c class. Its special feature is an automatic inclusion of both required
    # @c base classes plus the propagation of problem signals to their own
    # @c superior. That is, if a contained object marks itself as problematic
    # @c this object will be problematic for its superiors too.


    method addProblemObject {o} {
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


    method clear {} {
	# @c Resets state information

	problems_clear
	problemIndex_clear
	return
    }
}


# -*- tcl -*-
# (C) 1998 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: problemBase.cls,v 1.1 1998/05/26 20:34:37 aku Exp $
#
# @c Base class for problem reporting facility
# @s Base class for problem reporting facility
# @i problem reporting, reporting of problems
# ----------------------------------------------------------------------

class problemBase : formatterInterface {

    # @c Baseclass with common functionality required by all classes doing some
    # @c problem reporting. Essentially manages the location information for a
    # @c possible problem page.


    # @v problemPage: Name of the file containing the problem page. Defaults to
    # @v problemPage: {}, which is an indicator that the information was never
    # @v problemPage: requested before too.

    var problemPage {}


    method pPage {} {
	# @r Retrieval interface to the location information. Generates a
	# @c unique page upon the first call and then returns always this
	# @c information.

	if {[string length $problemPage] == 0} {
	    set problemPage prob[::pool::serial::new]
	}

	return [$fmt pageFile $problemPage]
    }



    method clear {} {
	# @c Resets the state information of a scan to allow future
	# @c reconfiguration and scanning.

	set problemPage {}
	return
    }
}


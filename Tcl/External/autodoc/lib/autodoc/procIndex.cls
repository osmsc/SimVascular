# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: procIndex.cls,v 1.1 1998/05/26 20:34:38 aku Exp $
#
# @c Management of procedure indices.
# @s Procedure indices.
# @i procedures, procedure index, indices
# ----------------------------------------------------------------------

class procIndex : azIndex {
    # @c Manages a single procedure index. Entries are the procedures
    # @c encountered during the scan of the directory hierarchy.


    method procIndex {} {
	# @c Constructor, parameterizes the baseclass.

	set indexPage       procs
	set indexName       procs
	set indexShortTitle Procedures
	set indexTitle      "Index of procedures"
	set entity          procedure
	return
    }



    method writeProblemPage {} {
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



    method clear {} {
	# @c Resets state information

	azIndex_clear
	return
    }
}


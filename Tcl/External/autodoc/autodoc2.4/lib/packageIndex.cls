# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: packageIndex.cls,v 1.1 1998/05/26 20:34:32 aku Exp $
#
# @c Management of package indices.
# @s Package indices.
# @i packages, package index, indices
# ----------------------------------------------------------------------


class packageIndex : indexBase problemIndex {
    # @c Manages a single package index. Entries are the packages
    # @c encountered during the scan of the directory hierarchy.


    method packageIndex {} {
	# @c Constructor, parameterizes the baseclass.

	set indexPage        packages
	set indexName        packages
	set indexShortTitle  Packages
	set indexTitle       "Index of packages"
	set entity           package
	return
    }



    method completeDatabase {author} {
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



    method writeProblemPage {} {
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
}


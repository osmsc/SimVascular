# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: fileIndex.cls,v 1.2 2000/09/05 20:10:43 aku Exp $
#
# @c Management of file indices.
# @s File indices.
# @i files, file index, indices
# ----------------------------------------------------------------------


class fileIndex : azIndex {
    # @c Manages a single files index. Entries are the tcl files encountered
    # @c during the scan of the directory hierarchy.


    method fileIndex {} {
	# @c Constructor, parameterizes the baseclass.

	set indexPage       files
	set indexName       files
	set indexShortTitle "Files"
	set indexTitle      "Index of files"
	set entity          file
	return
    }



    method getRef {name} {
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



    method writeProblemPage {} {
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



    method clear {} {
	# @c Resets state information

	azIndex_clear
	return
    }
}


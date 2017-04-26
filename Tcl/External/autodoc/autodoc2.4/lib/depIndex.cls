# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: depIndex.cls,v 1.3 2000/09/05 20:10:42 aku Exp $
#
# @c Management of dependency indices.
# @s Dependency indices.
# @i dependencies, dependency index, indices
# ----------------------------------------------------------------------


class depIndex : indexBase {
    # @c Management of a dependency index. Entries are external packages used
    # @c by the documented code. The associated descriptions refer to the
    # @c entities requiring the different packages.

    # @v pkgUsers: The index maintained by this class. Most member variables of
    # @v pkgUsers: the baseclass are of no relevance here. Maps from package
    # @v pkgUsers: names to the objects requiring them.

    var -array pkgUsers


    method depIndex {} {
	# @c Constructor, parameterizes the base class

	set indexPage       deps
	set indexName       deps
	set indexShortTitle "External packages"
	set indexTitle      "External packages and their users"
	set entity          dependency
	return
    }



    method addItem {pkg object} {
	# @c Adds the external package <a pkg> to the index. The additionally
	# @c specified <a object> depends on this package.
	#
	# @a pkg:    Thee name of the package added to the index.
	# @a object: The handle of the object which is dependent on the
	# @a object: package.

	# We cannot use indexBase_addItem as this tries to index objects,
	# which we don't have. Copied code from there and then modified
	# to deal directly with a package name.
	#
	#indexBase_addItem $pkg

	lappend items $pkg

	if {! [::info exists pkgUsers($pkg)]} {
	    set pkgUsers($pkg) $object
	} else {
	    lappend pkgUsers($pkg) $object
	}

	return
    }



    method writeIndexBody {} {
	# @c Overrides base class definition (<m indexBase:writeIndexBody>) to
	# @c deal with our special index information. Generates the required
	# @c formatting for this index.

	$fmt definitionList {
	    foreach p [lsort [::pool::list::uniq $items]] {
		$fmt defterm \
			[$dist depRef $p] \
			[$fmt linkCommaList [$fmt sortByName $pkgUsers($p)]]
	    }
	}

	return
    }



    method clear {} {
	# @c Resets state information.

	set items {}
	::pool::array::clear pkgUsers
	return
    }
}


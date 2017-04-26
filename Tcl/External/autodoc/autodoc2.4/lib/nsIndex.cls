# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: nsIndex.cls,v 1.1 2000/09/05 20:10:43 aku Exp $
#
# @c Management of namespace indices.
# @s Namespace indices.
# @i namespaces, namespace index, indices
# ----------------------------------------------------------------------


class namespaceIndex : azIndex {
    # @c Manages a single namespace index. Entries are all namespaces
    # @c found while scanning the directory hierarchy.

    method namespaceIndex {} {
	# @c Constructor, parameterizes the base class.

	set indexPage       namespaces
	set indexName       namespaces
	set indexTitle      "Index of namespaces"
	set indexShortTitle Namespaces
	set entity          namespace
	return
    }


    method write {} {
	# @c Write the index, then the pages of its contents.

	indexBase_write

	foreach ns [items] {
	    $ns write
	}
    }


    method clear {} {
	# @c Resets state information

	azIndex_clear
	return
    }
}


# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: indexBase.cls,v 1.4 2000/09/05 20:10:43 aku Exp $
#
# @c General interface of an index.
# @s General interface of an index.
# @i indices, general interface to index.
# ----------------------------------------------------------------------


class indexBase : distInterface formatterInterface problemIndex {
    # @c Baseclass of all indices. Contains their common behaviour and member
    # @c variables.

    # -- Formatting information --

    # @v indexPage:       The name of the page to use for the index during
    # @v indexPage:       output.
    # @v indexName:       The internal logical name of the index, used to
    # @v indexName:       control the generation of its jumpbar.
    # @v indexTitle:      The name of the index, used as the title of its page.
    # @v indexShortTitle: The short name of the index, as used in the jumpbars.
    # @v entity:          Description of the entities referenced by a concrete
    # @v entity:          index.  

    var indexPage       ""
    var indexName       ""
    var indexTitle      ""
    var indexShortTitle ""
    var entity          entity

    # @v items: List of objects known to the index.

    var  items

    # @v name2Item: Mapping from the object names to their handles.

    var -array name2Item

    # @v refs: Cache holding the results of all calls to <m ref>.

    var -array refs


    method ~indexBase {} {
	# @c Destructor, clears out all state information.

	$this clear
	return
    }



    method addItem {item} {
	# @c Adds an <a item> to the index. The item has to support the
	# @c interface provided by <c indexBaseEntry>.
	#
	# @a item: Handle of the object added to the index.

	lappend items $item
	set name2Item([$item name]) $item

	$item configure -index $this
	return
    }



    method number {} {
	# @r The number of registered items

	return [llength $items]
    }



    method items {} {
	# @r A list containing the items registered in the index.
	return $items
    }



    method itemByName {name} {
	# @r The object having the specified <a name>.
	#
	# @a name: The name of the object searched by the caller.

	return $name2Item($name)
    }



    method page {} {
	# @r The filename of the page containing the index.
	# @n The codes assumes that only one index exists.

	return [$fmt pageFile $indexPage]
    }



    method title {} {
	# @r The title of the index.

	return $indexTitle
    }



    method code {} {
	# @r The internal logicval name of the index.

	return $indexName
    }



    method name {} {
	# @r The name of the index, as used by the jumpbars.

	return $indexShortTitle
    }



    method ref {name} {
	# @c Determines wether <a name> is a registered item or not and returns
	# @c appropriately formatted text (a hyperlink, or the name, marked as
	# @c error). Indirectly used by <m distribution:crResolve> to resolve
	# @c embedded crossreferences. Uses an internal cache to speed
	# @c processing.
	#
	# @a name: The name of the item to look for.
	#
	# @r Formatted text for hyperlink to definition of <a name> or a
	# @r error markup for unknown entities.

	if {![::info exists refs($name)]} {
	    set refs($name) [$this getRef $name]
	}

	set ok [lindex $refs($name) 0]

	if {! $ok} {
	    refError $name
	}

	return [lindex $refs($name) 1]
    }



    method getRef {name} {
	# @c Determines wether <a name> is a registered item or not and returns
	# @c appropriately formatted text (a hyperlink, or the name, marked as
	# @c error). Indirectly used by <m distribution:crResolve> to resolve
	# @c embedded crossreferences. The workhorse method, called by <m ref>,
	# @c but only if the cache does not have the answer.
	#
	# @a name: The name of the item to look for.
	#
	# @r Formatted text for hyperlink to definition of <a name> or a
	# @r error markup for unknown entities.

	foreach i $items {
	    if {[string compare $name [$i name]] == 0} {
		return [list 1 [$i link]]
	    }
	}

	return [list 0 [$fmt markWithClass error [$fmt markError $name]]]
    }



    method refError {name} {
	# @r A string formatted as error for cross references to unknown
	# @r entities. Additionally adds the error to the list of problems
	# @r associated to the entity containing the bogus cross reference.
	#
	# @a name: The name of the unknown entity.

	return [$fmt crError $name "Reference to unknown $entity '$name'"]
    }



    method clear {} {
	# @c Resets state information and destroys the indexed objects.

	problemIndex_clear

	#puts "$this clear: items = $items"

	foreach p $items {
	    $p delete
	}

	::pool::array::clear refs
	::pool::array::clear name2Item
	set items ""
	return
    }



    method write {} {
	# @c Generates and writes the index.

	$fmt  pushClass index-$entity
	$fmt  newPage [page] $indexTitle
	$dist writeJumpbar   $indexName

	# delegate action to derived class, may use
	# the default implementation here.

	$this writeIndexBody

	$fmt closePage
	$fmt popClass
	return
    }



    method writeIndexBody {} {
	# @c Generates the body of the index. Indices having specialities
	# @c should override this method, not <m write> to get the frame for
	# @c free.

	$fmt sortedObjectList $items
	return
    }



    method link {} {
	# @r A string containing a hyperlink to the page of this index.

	$fmt pushClass index-$entity
	set link  [$fmt link [name] [page]]
	$fmt popClass

	return $link
    }
}


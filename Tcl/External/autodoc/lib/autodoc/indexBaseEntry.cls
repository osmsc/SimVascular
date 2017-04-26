# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: indexBaseEntry.cls,v 1.2 2000/09/05 20:10:43 aku Exp $
#
# @c General interface of an index entry.
# @s General interface of an index entry.
# @i index entries, general interface to index entry.
# ----------------------------------------------------------------------


class indexBaseEntry : distInterface formatterInterface {
    # @c Interface common to all objects used by indices. Manages the object
    # @c name, a reference to the index it is part of and location information.


    # @o name: The name of the indexed object. Empty by default.

    option name  -d ""


    # @o index: Handle of the index containing this object. Automatically set
    # @o index: during addition of this object to its index.

    option index -d ""


    # @v page: Name of the file containing the page describing this object.
    # @v page: Defaults to {}, which is an indicator that the information was
    # @v page: never requested before too.

    var page ""


    # @v shortDescription: A short description of the object. This text is used
    # @v shortDescription: by the index to embellish the reference to the page
    # @v shortDescription: of the object and give a user hints about the
    # @v shortDescription: purpose of the object

    var shortDescription ""

    # @v entity: The type of the entity described by the
    # @v entity: object. Derived classes have to overide the default
    # @v entity: value (in their constructor).

    var entity entity


    method name {} {
	# @r the name of this object.

	return $opt(-name)
    }



    method page {} {
	# @c Retrieval interface to the location information. Generates a
	# @c unique page upon the first call and then returns always this
	# @c information.

	if {[string length $page] == 0} {
	    set page [$this getPage]
	}

	return $page
    }



    method short {} {
	# @r the short description of the object.

	return $shortDescription
    }



    method link {} {
	# @r a string containing a hyperlink to the page of this object. The
	# @r name of the object is used for the textual part of the link. Uses
	# @r the current formatter object to obtain the data.

	$fmt pushClass $entity
	set link [$fmt link [$this name] [$this page]]
	$fmt popClass
	return $link
    }
}


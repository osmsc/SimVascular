# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: azIndexEntry.cls,v 1.2 2000/09/05 20:10:42 aku Exp $
#
# @c Interface to index entries for alphabetically structured indices.
# @s Index entries for an alphabetically structured index.
# @i index entries, alphabetically structured index
# ----------------------------------------------------------------------


class azIndexEntry : indexBaseEntry {
    # @c Interface to index entries whose first letter is important and used by
    # @c their index (of class <c azIndex>) to structure the page.


    method firstLetter {} {
	# @r the first letter of the name of this index entry.

	#set letter {}
	#regexp -- {^[^a-zA-Z]*([a-zA-Z])} $opt(-name) dummy letter
	#return $letter

	# Skip over ':' (namespaces) but not for '::' alone.

	set n [string trim $opt(-name) :]
	if {$n == {}} {
	    return [string index $opt(-name) 0]
	} else {
	    return [string index $n 0]
	}
    }
}





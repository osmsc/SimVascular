# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: azIndex.cls,v 1.2 2000/09/05 20:10:42 aku Exp $
#
# @c Management of indices with a letter bar (a-z) above them.
# @s Management of indices with a letter bar (a-z) above them.
# @i alphabetically structured index
# ----------------------------------------------------------------------


class azIndex : indexBase {
    # @c A derivation of the standard index structuring its output into
    # @c alphabetically. The first letter of the name of an indexed object is
    # @c used to categorize it.

    # @v initial: This variable is used to maintain a mapping from the first
    # @v initial: letter in the name of an object to its handle. These lists
    # @v initial: are used later to generate the index page.

    var -array initial



    method addItem {object} {
	# @c Adds the specified <a object> to the index. Overrides the
	# @c definition in the baseclass to additionally maintain the mapping
	# @c from letters to objects.
	#
	# @a object: The handle of the object added to the index.

	indexBase_addItem $object

	lappend initial([string tolower [$object firstLetter]]) $object
	return
    }



    method GenerateLetterBar {} {
	# @c Internal method. Generates a jump bar containing the letter of the
	# @c alphabet. Letters having objects associated to them are build as
	# @c hyperlinks to the appropriate section of the page.

	set result ""
	foreach letter [lsort [array names initial]] {
	    lappend result [$fmt link $letter #$letter]
	}

	return [join $result " | "]

	if {0} {
	    foreach letter {a b c d e f g h i j k l m n o p q r s t u v w x y z} {
		if {![::info exists initial($letter)]} {
		    # Nothing define, add the letter in its plain variant

		    append result " $letter |"
		} else {
		    # The generated links point to anchors in this page.

		    append result " [$fmt link $letter #$letter] |"
		}
	    }

	    return $result
	}
    }



    method writeIndexBody {} {
	# @c Called by the base class to write out the main section of the
	# @c index. Overrides the base class definition to generate the
	# @c additional alphabetical sectioning.

	# jump bar for all letters

	$fmt pushClass letterbar
	if {[$fmt cget -css]} {
	    $fmt par [GenerateLetterBar]
	} else {
	    $fmt par align=center [GenerateLetterBar]
	}
	$fmt popClass
	$fmt hrule

	# now the items for all used letters.
	foreach letter [lsort [array names initial]] {
	    $fmt setAnchor        $letter
	    $fmt pushClass index-letter
	    $fmt section          $letter
	    $fmt popClass
	    $fmt sortedObjectList $initial($letter)
	}

	return
    }



    method clear {} {
	# @c Resets state information.

	indexBase_clear
	::pool::array::clear initial
	return
    }
}


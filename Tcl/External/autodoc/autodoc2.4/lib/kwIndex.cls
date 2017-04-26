# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: kwIndex.cls,v 1.3 2000/09/05 20:10:43 aku Exp $
#
# @c Management of keyword indices.
# @s Keyword indices.
# @i keywords, keyword index, indices
# ----------------------------------------------------------------------


class kwIndex : azIndex {
    # @c Manages a single class index. Entries are the keywords encountered
    # @c during the scan of the various packages, files, procedures and classes.

    # @v kw2obj: The relevant index information. Maps keywords (key phrases
    # @v kw2obj: actually) to a list containing the handles of all objects
    # @v kw2Obj: mentioning it.

    var -array kw2obj


    method kwIndex {} {
	# @c Constructor, parameterizes the base class.

	set indexPage       keywords
	set indexName       keywords
	set indexShortTitle "Keywords"
	set indexTitle      "Keywords"
	set entity          keyword
	return
    }



    method addItem {phrase object} {
	# @c Adds the <a object> to the index and associates it with the
	# @c specified key <a phrase>.
	#
	# @a object: The handle of the added object.
	# @a phrase: Keyword the <a object> is indexed under.

	set phrase [string trim $phrase]

	# We cannot use azIndex_addItem as this tries to index objects,
	# which we don't have. Copied code from there and then modified
	# to deal directly with a phrase.

	#azIndex_addItem $phrase
	#indexBase_addItem $item

	lappend items $phrase
	regexp -- {^[^a-zA-Z]*([a-zA-Z])} $phrase dummy firstletter
	lappend initial([string tolower $firstletter]) $phrase

	lappend kw2obj($phrase) $object
	return
    }




    method writeIndexBody {} {
	# @c Overrides base class definition (<m indexBase:writeIndexBody>) to
	# @c deal with our special index information. Generates the required
	# @c formatting for this index.

	# jump bar for all letters

	$fmt pushClass letterbar
	if {[$fmt cget -css]} {
	    $fmt par [GenerateLetterBar]
	} else {
	    $fmt par align=center [GenerateLetterBar]
	}
	$fmt popClass
	$fmt hrule

	# now the objects for all used letters

	foreach letter [lsort [array names initial]] {
	    $this WriteLetter $letter
	}

	return
    }



    method WriteLetter {letter} {
	# @c Internal method to generate the formatting for all
	# @c keywords beginning with <a letter>.
	#
	# @a letter: The letter whose section is written.

	set phraseList [::pool::list::uniq [lsort $initial($letter)]]

	$fmt setAnchor $letter
	$fmt pushClass index-letter
	$fmt section   $letter
	$fmt popClass

	$fmt definitionList {
	    foreach phrase $phraseList {
		$fmt defterm $phrase [$fmt getString {
		    WriteKeyword $phrase
		}] ;#{}
	    }
	}
	return
    }



    method WriteKeyword {keyword} {
	# @c Internal method to generate the formatting for <a keyword>.
	#
	# @a keyword: The index phrase whose section is written.

	$fmt write [$fmt linkCommaList [$fmt sortByName $kw2obj($keyword)]]
	return
    }



    method clear {} {
	# @c Resets state information

	#azIndex_clear

	set items {}
	::pool::array::clear initial
	::pool::array::clear kw2obj
	return
    }
}



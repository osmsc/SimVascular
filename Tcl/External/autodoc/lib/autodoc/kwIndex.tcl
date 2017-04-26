# -*- tcl -*-
# Automatically generated from file 'kwIndex.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> kwIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::kwIndex {
    variable  _superclasses    azIndex
    variable  _scChainForward  kwIndex
    variable  _scChainBackward kwIndex
    variable  _classVariables  {}
    variable  _methods         {WriteKeyword WriteLetter addItem clear constructor writeIndexBody}

    variable  _variables
    array set _variables  {kw2obj {kwIndex {isArray 1 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {WriteKeyword . addItem . writeIndexBody . constructor . clear . WriteLetter .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::kwIndex::WriteKeyword {keyword} {
    ::pool::oo::support::SetupVars kwIndex
    # @c Internal method to generate the formatting for <a keyword>.
	#
	# @a keyword: The index phrase whose section is written.

	$fmt write [$fmt linkCommaList [$fmt sortByName $kw2obj($keyword)]]
	return
}



proc ::pool::oo::class::kwIndex::WriteLetter {letter} {
    ::pool::oo::support::SetupVars kwIndex
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



proc ::pool::oo::class::kwIndex::addItem {phrase object} {
    ::pool::oo::support::SetupVars kwIndex
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



proc ::pool::oo::class::kwIndex::clear {} {
    ::pool::oo::support::SetupVars kwIndex
    # @c Resets state information

	#azIndex_clear

	set items {}
	::pool::array::clear initial
	::pool::array::clear kw2obj
	return
}



proc ::pool::oo::class::kwIndex::constructor {} {
    ::pool::oo::support::SetupVars kwIndex
    # @c Constructor, parameterizes the base class.

	set indexPage       keywords
	set indexName       keywords
	set indexShortTitle "Keywords"
	set indexTitle      "Keywords"
	set entity          keyword
	return
}



proc ::pool::oo::class::kwIndex::writeIndexBody {} {
    ::pool::oo::support::SetupVars kwIndex
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::kwIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences kwIndex

# Create object instantiation procedure
interp alias {} kwIndex {} ::pool::oo::support::New kwIndex

# -------------------------------


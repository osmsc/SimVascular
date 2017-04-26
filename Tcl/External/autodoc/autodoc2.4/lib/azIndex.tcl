# -*- tcl -*-
# Automatically generated from file 'azIndex.cls'.
# Date: Thu Sep 07 18:20:47 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> azIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::azIndex {
    variable  _superclasses    indexBase
    variable  _scChainForward  azIndex
    variable  _scChainBackward azIndex
    variable  _classVariables  {}
    variable  _methods         {GenerateLetterBar addItem clear writeIndexBody}

    variable  _variables
    array set _variables  {initial {azIndex {isArray 1 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {addItem . GenerateLetterBar . writeIndexBody . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::azIndex::GenerateLetterBar {} {
    ::pool::oo::support::SetupVars azIndex
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



proc ::pool::oo::class::azIndex::addItem {object} {
    ::pool::oo::support::SetupVars azIndex
    # @c Adds the specified <a object> to the index. Overrides the
	# @c definition in the baseclass to additionally maintain the mapping
	# @c from letters to objects.
	#
	# @a object: The handle of the object added to the index.

	indexBase_addItem $object

	lappend initial([string tolower [$object firstLetter]]) $object
	return
}



proc ::pool::oo::class::azIndex::clear {} {
    ::pool::oo::support::SetupVars azIndex
    # @c Resets state information.

	indexBase_clear
	::pool::array::clear initial
	return
}



proc ::pool::oo::class::azIndex::writeIndexBody {} {
    ::pool::oo::support::SetupVars azIndex
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::azIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::indexBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences azIndex

# Create object instantiation procedure
interp alias {} azIndex {} ::pool::oo::support::New azIndex

# -------------------------------


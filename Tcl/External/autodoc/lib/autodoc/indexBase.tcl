# -*- tcl -*-
# Automatically generated from file 'indexBase.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> indexBase <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::indexBase {
    variable  _superclasses    {distInterface formatterInterface problemIndex}
    variable  _scChainForward  indexBase
    variable  _scChainBackward indexBase
    variable  _classVariables  {}
    variable  _methods         {addItem clear code destructor getRef itemByName items link name number page ref refError title write writeIndexBody}

    variable  _variables
    array set _variables  {refs {indexBase {isArray 1 initialValue {}}} name2Item {indexBase {isArray 1 initialValue {}}} entity {indexBase {isArray 0 initialValue entity}} indexPage {indexBase {isArray 0 initialValue {}}} indexName {indexBase {isArray 0 initialValue {}}} items {indexBase {isArray 0 initialValue {}}} indexShortTitle {indexBase {isArray 0 initialValue {}}} indexTitle {indexBase {isArray 0 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {writeIndexBody . itemByName . code . ref . page . destructor . addItem . number . name . title . items . write . getRef . link . refError . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::indexBase::addItem {item} {
    ::pool::oo::support::SetupVars indexBase
    # @c Adds an <a item> to the index. The item has to support the
	# @c interface provided by <c indexBaseEntry>.
	#
	# @a item: Handle of the object added to the index.

	lappend items $item
	set name2Item([$item name]) $item

	$item configure -index $this
	return
}



proc ::pool::oo::class::indexBase::clear {} {
    ::pool::oo::support::SetupVars indexBase
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



proc ::pool::oo::class::indexBase::code {} {
    ::pool::oo::support::SetupVars indexBase
    # @r The internal logicval name of the index.

	return $indexName
}



proc ::pool::oo::class::indexBase::destructor {} {
    ::pool::oo::support::SetupVars indexBase
    # @c Destructor, clears out all state information.

	$this clear
	return
}



proc ::pool::oo::class::indexBase::getRef {name} {
    ::pool::oo::support::SetupVars indexBase
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



proc ::pool::oo::class::indexBase::itemByName {name} {
    ::pool::oo::support::SetupVars indexBase
    # @r The object having the specified <a name>.
	#
	# @a name: The name of the object searched by the caller.

	return $name2Item($name)
}



proc ::pool::oo::class::indexBase::items {} {
    ::pool::oo::support::SetupVars indexBase
    # @r A list containing the items registered in the index.
	return $items
}



proc ::pool::oo::class::indexBase::link {} {
    ::pool::oo::support::SetupVars indexBase
    # @r A string containing a hyperlink to the page of this index.

	$fmt pushClass index-$entity
	set link  [$fmt link [name] [page]]
	$fmt popClass

	return $link
}



proc ::pool::oo::class::indexBase::name {} {
    ::pool::oo::support::SetupVars indexBase
    # @r The name of the index, as used by the jumpbars.

	return $indexShortTitle
}



proc ::pool::oo::class::indexBase::number {} {
    ::pool::oo::support::SetupVars indexBase
    # @r The number of registered items

	return [llength $items]
}



proc ::pool::oo::class::indexBase::page {} {
    ::pool::oo::support::SetupVars indexBase
    # @r The filename of the page containing the index.
	# @n The codes assumes that only one index exists.

	return [$fmt pageFile $indexPage]
}



proc ::pool::oo::class::indexBase::ref {name} {
    ::pool::oo::support::SetupVars indexBase
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



proc ::pool::oo::class::indexBase::refError {name} {
    ::pool::oo::support::SetupVars indexBase
    # @r A string formatted as error for cross references to unknown
	# @r entities. Additionally adds the error to the list of problems
	# @r associated to the entity containing the bogus cross reference.
	#
	# @a name: The name of the unknown entity.

	return [$fmt crError $name "Reference to unknown $entity '$name'"]
}



proc ::pool::oo::class::indexBase::title {} {
    ::pool::oo::support::SetupVars indexBase
    # @r The title of the index.

	return $indexTitle
}



proc ::pool::oo::class::indexBase::write {} {
    ::pool::oo::support::SetupVars indexBase
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



proc ::pool::oo::class::indexBase::writeIndexBody {} {
    ::pool::oo::support::SetupVars indexBase
    # @c Generates the body of the index. Indices having specialities
	# @c should override this method, not <m write> to get the frame for
	# @c free.

	$fmt sortedObjectList $items
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::indexBase::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::distInterface::loadClass
::pool::oo::class::formatterInterface::loadClass
::pool::oo::class::problemIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences indexBase

# Create object instantiation procedure
interp alias {} indexBase {} ::pool::oo::support::New indexBase

# -------------------------------


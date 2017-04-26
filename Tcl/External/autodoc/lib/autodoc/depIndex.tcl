# -*- tcl -*-
# Automatically generated from file 'depIndex.cls'.
# Date: Thu Sep 07 18:20:48 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> depIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::depIndex {
    variable  _superclasses    indexBase
    variable  _scChainForward  depIndex
    variable  _scChainBackward depIndex
    variable  _classVariables  {}
    variable  _methods         {addItem clear constructor writeIndexBody}

    variable  _variables
    array set _variables  {pkgUsers {depIndex {isArray 1 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {addItem . writeIndexBody . constructor . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::depIndex::addItem {pkg object} {
    ::pool::oo::support::SetupVars depIndex
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



proc ::pool::oo::class::depIndex::clear {} {
    ::pool::oo::support::SetupVars depIndex
    # @c Resets state information.

	set items {}
	::pool::array::clear pkgUsers
	return
}



proc ::pool::oo::class::depIndex::constructor {} {
    ::pool::oo::support::SetupVars depIndex
    # @c Constructor, parameterizes the base class

	set indexPage       deps
	set indexName       deps
	set indexShortTitle "External packages"
	set indexTitle      "External packages and their users"
	set entity          dependency
	return
}



proc ::pool::oo::class::depIndex::writeIndexBody {} {
    ::pool::oo::support::SetupVars depIndex
    # @c Overrides base class definition (<m indexBase:writeIndexBody>) to
	# @c deal with our special index information. Generates the required
	# @c formatting for this index.

	$fmt definitionList {
	    foreach p [lsort [::pool::list::uniq $items]] {
		$fmt defterm  [$dist depRef $p]  [$fmt linkCommaList [$fmt sortByName $pkgUsers($p)]]
	    }
	}

	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::depIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::indexBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences depIndex

# Create object instantiation procedure
interp alias {} depIndex {} ::pool::oo::support::New depIndex

# -------------------------------


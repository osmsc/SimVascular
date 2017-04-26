# -*- tcl -*-
# Automatically generated from file 'nsIndex.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> namespaceIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::namespaceIndex {
    variable  _superclasses    azIndex
    variable  _scChainForward  namespaceIndex
    variable  _scChainBackward namespaceIndex
    variable  _classVariables  {}
    variable  _methods         {clear constructor write}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {constructor . write . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::namespaceIndex::clear {} {
    ::pool::oo::support::SetupVars namespaceIndex
    # @c Resets state information

	azIndex_clear
	return
}



proc ::pool::oo::class::namespaceIndex::constructor {} {
    ::pool::oo::support::SetupVars namespaceIndex
    # @c Constructor, parameterizes the base class.

	set indexPage       namespaces
	set indexName       namespaces
	set indexTitle      "Index of namespaces"
	set indexShortTitle Namespaces
	set entity          namespace
	return
}



proc ::pool::oo::class::namespaceIndex::write {} {
    ::pool::oo::support::SetupVars namespaceIndex
    # @c Write the index, then the pages of its contents.

	indexBase_write

	foreach ns [items] {
	    $ns write
	}
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::namespaceIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences namespaceIndex

# Create object instantiation procedure
interp alias {} namespaceIndex {} ::pool::oo::support::New namespaceIndex

# -------------------------------


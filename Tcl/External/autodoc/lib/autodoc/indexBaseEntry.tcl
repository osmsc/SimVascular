# -*- tcl -*-
# Automatically generated from file 'indexBaseEntry.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> indexBaseEntry <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::indexBaseEntry {
    variable  _superclasses    {distInterface formatterInterface}
    variable  _scChainForward  indexBaseEntry
    variable  _scChainBackward indexBaseEntry
    variable  _classVariables  {}
    variable  _methods         {link name page short}

    variable  _variables
    array set _variables  {shortDescription {indexBaseEntry {isArray 0 initialValue {}}} entity {indexBaseEntry {isArray 0 initialValue entity}} page {indexBaseEntry {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {index {indexBaseEntry {-default {} -type ::pool::getopt::notype -action {} -class Index}} name {indexBaseEntry {-default {} -type ::pool::getopt::notype -action {} -class Name}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {short . name . page . link .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::indexBaseEntry::link {} {
    ::pool::oo::support::SetupVars indexBaseEntry
    # @r a string containing a hyperlink to the page of this object. The
	# @r name of the object is used for the textual part of the link. Uses
	# @r the current formatter object to obtain the data.

	$fmt pushClass $entity
	set link [$fmt link [$this name] [$this page]]
	$fmt popClass
	return $link
}



proc ::pool::oo::class::indexBaseEntry::name {} {
    ::pool::oo::support::SetupVars indexBaseEntry
    # @r the name of this object.

	return $opt(-name)
}



proc ::pool::oo::class::indexBaseEntry::page {} {
    ::pool::oo::support::SetupVars indexBaseEntry
    # @c Retrieval interface to the location information. Generates a
	# @c unique page upon the first call and then returns always this
	# @c information.

	if {[string length $page] == 0} {
	    set page [$this getPage]
	}

	return $page
}



proc ::pool::oo::class::indexBaseEntry::short {} {
    ::pool::oo::support::SetupVars indexBaseEntry
    # @r the short description of the object.

	return $shortDescription
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::indexBaseEntry::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::distInterface::loadClass
::pool::oo::class::formatterInterface::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences indexBaseEntry

# Create object instantiation procedure
interp alias {} indexBaseEntry {} ::pool::oo::support::New indexBaseEntry

# -------------------------------


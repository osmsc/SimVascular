# -*- tcl -*-
# Automatically generated from file 'azIndexEntry.cls'.
# Date: Thu Sep 07 18:20:47 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> azIndexEntry <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::azIndexEntry {
    variable  _superclasses    indexBaseEntry
    variable  _scChainForward  azIndexEntry
    variable  _scChainBackward azIndexEntry
    variable  _classVariables  {}
    variable  _methods         firstLetter

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
    array set _methodTable  {firstLetter .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::azIndexEntry::firstLetter {} {
    ::pool::oo::support::SetupVars azIndexEntry
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::azIndexEntry::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::indexBaseEntry::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences azIndexEntry

# Create object instantiation procedure
interp alias {} azIndexEntry {} ::pool::oo::support::New azIndexEntry

# -------------------------------


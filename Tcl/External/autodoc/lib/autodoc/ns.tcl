# -*- tcl -*-
# Automatically generated from file 'ns.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> namespaceDescription <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::namespaceDescription {
    variable  _superclasses    azIndexEntry
    variable  _scChainForward  namespaceDescription
    variable  _scChainBackward namespaceDescription
    variable  _classVariables  {}
    variable  _methods         {WriteList addClass addNamespace addProcedure clear constructor firstLetter getPage write}

    variable  _variables
    array set _variables  {namespaces {namespaceDescription {isArray 0 initialValue {}}} listtype {namespaceDescription {isArray 0 initialValue {}}} parent {namespaceDescription {isArray 0 initialValue {}}} classes {namespaceDescription {isArray 0 initialValue {}}} procs {namespaceDescription {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {log {namespaceDescription {-default {} -type ::pool::getopt::notype -action {} -class Log}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {firstLetter . getPage . addNamespace . addProcedure . constructor . write . addClass . clear . WriteList .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::namespaceDescription::WriteList {title mList} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @c Internal method used by the page generator routine (<m write>) to
	# @c produce the output for all procedures contained in the namespace.
	#
	# @a title: The term under which the list is written.
	# @a mList: The list of objects to call.

	if {[llength $mList] == 0} {
	    return
	}

	$fmt section $title
	$fmt itemize {
	    foreach p $mList {
		$fmt item [$p link]
	    }
	}

	if {0} {
	    set text [list]
	    foreach p $mList {
		lappend text [$p link]
	    }
	    set text [join $text [$fmt getString {$fmt parbreak}]]

	    $fmt defterm $title $text
	}
	return
}



proc ::pool::oo::class::namespaceDescription::addClass {o} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @c Add a class defined in this namespace to it.
	# @a o: The <c classDescription> object added to the namespace.
	lappend classes $o
	return
}



proc ::pool::oo::class::namespaceDescription::addNamespace {o} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @c Add a namespace defined in this namespace to it.
	# @a o: The <c namespaceDescription> object added to the namespace.
	lappend namespaces $o
	return
}



proc ::pool::oo::class::namespaceDescription::addProcedure {o} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @c Add a procedure defined in this namespace to it.
	# @a o: The <c procDescription> object added to the namespace.
	lappend procs $o
	return
}



proc ::pool::oo::class::namespaceDescription::clear {} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @c Resets state information.

	azIndexEntry_clear
	return
}



proc ::pool::oo::class::namespaceDescription::constructor {} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @c Constructor. Takes the name of the namespace, extracts
	# @c the name of the containing namespace and retrieves the
	# @c associated object. If that does not exist it is
	# @c constructed and added to the global index.

	set entity namespace

	if {0 != [string compare "::" $opt(-name)]} {
	    set parent [$opt(-dist) nsContaining $opt(-name)]
	    $parent addNamespace $this
	} else {
	    # :: is root namespace, without a parent
	    set parent {}
	}
	return
}



proc ::pool::oo::class::namespaceDescription::firstLetter {} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @r the first letter of the name of this index entry.

	# Skip over ':' (namespaces) but not for '::' alone.

	set n   $opt(-name)
	set pfx [$dist cget -namespace-prefix]
	if {$pfx != {}} {
	    regsub "^$pfx" $n {} n
	}
	set n [string trim $n :]
	if {$n == {}} {
	    return [string index $opt(-name) 0]
	} else {
	    return [string index $n 0]
	}
}



proc ::pool::oo::class::namespaceDescription::getPage {} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @r The url of the page containing the namespace description.

	set nsname $opt(-name)

	if {[catch {set nsname [string map {:: _} $nsname]}]} {
	    regsub -all {::} $nsname {_} nsname
	}
	return [$fmt pageFile ns_$nsname]
}



proc ::pool::oo::class::namespaceDescription::write {} {
    ::pool::oo::support::SetupVars namespaceDescription
    # @c Generates the formatted text describing the namespace.

	$opt(-log) log debug writing namespace [name] ([page])
	set listtype [$dist cget -clisttype]

	$dist pushContext $this
	$fmt  pushClass   namespace

	$fmt  newPage [page] "Namespace '[name]'"
	$dist writeJumpbar

	if {$parent != {}} {
	    $fmt definitionList {
		$fmt defterm {Contained in} [$parent link]
	    }
	}

	$fmt pushClass namespace-listing
	WriteList Namespaces [$fmt sortByName $namespaces]
	$fmt popClass

	$fmt pushClass proc-listing
	WriteList Procedures [$fmt sortByName $procs]
	$fmt popClass

	$fmt pushClass class-listing
	WriteList Classes    [$fmt sortByName $classes]
	$fmt popClass

	$fmt  closePage
	$dist popContext
	$fmt  popClass
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::namespaceDescription::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndexEntry::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences namespaceDescription

# Create object instantiation procedure
interp alias {} namespaceDescription {} ::pool::oo::support::New namespaceDescription

# -------------------------------


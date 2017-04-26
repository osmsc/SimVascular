# -*- tcl -*-
# Automatically generated from file 'file.cls'.
# Date: Thu Sep 07 18:20:48 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> fileDescription <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::fileDescription {
    variable  _superclasses    {azIndexEntry problemsAndIndex}
    variable  _scChainForward  fileDescription
    variable  _scChainBackward fileDescription
    variable  _classVariables  {}
    variable  _methods         {DependencyList PostProcessInformation WriteClassLinks WriteHeading WriteProcLinks WriteProcedures author authorSet clear completeKwIndex constructor dependencies firstLetter getPage keywords problem scan write writeProblemPage}

    variable  _variables
    array set _variables  {keywords {fileDescription {isArray 0 initialValue {}}} comment {fileDescription {isArray 0 initialValue {}}} seeAlso {fileDescription {isArray 0 initialValue {}}} bug {fileDescription {isArray 0 initialValue {}}} note {fileDescription {isArray 0 initialValue {}}} inline {fileDescription {isArray 0 initialValue 0}} authorAddress {fileDescription {isArray 0 initialValue {}}} danger {fileDescription {isArray 0 initialValue {}}} authorName {fileDescription {isArray 0 initialValue {}}} procedures {fileDescription {isArray 0 initialValue {}}} version {fileDescription {isArray 0 initialValue {}}} date {fileDescription {isArray 0 initialValue {}}} classes {fileDescription {isArray 0 initialValue {}}} dependencies {fileDescription {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {ptable {fileDescription {-default {} -type ::pool::getopt::notype -action {} -class Ptable}} psort {fileDescription {-default 1 -type ::pool::getopt::notype -action {} -class Psort}} package {fileDescription {-default {} -type ::pool::getopt::notype -action {} -class Package}} log {fileDescription {-default {} -type ::pool::getopt::notype -action {} -class Log}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {WriteProcLinks . keywords . firstLetter . writeProblemPage . author . DependencyList . PostProcessInformation . scan . constructor . WriteProcedures . problem . WriteClassLinks . completeKwIndex . write . WriteHeading . getPage . authorSet . clear . dependencies .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::fileDescription::DependencyList {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Internal method, generates a string containing references to the
	# @c packages required by the file.
	#
	# @r A string containing a comma separated list of package names, each
	# @r a hyperlink to a location describing the it.

	set text ""

	foreach d $dependencies {
	    append text "[$dist depRef $d], "
	}
	
	return [string trimright $text ", "]
}



proc ::pool::oo::class::fileDescription::PostProcessInformation {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Called to streamline the extracted embedded documentation.

	foreach i {date version} {
	    regsub -all "\n" [set $i] {\&p} $i
	}

	foreach i {
	    comment danger note seeAlso shortDescription bug
	} {
	    set text [set $i]
	    set text [::pool::string::removeWhitespace $text]
	    set text [string trim [::pool::string::oneLine $text]]

	    set $i $text
	}

	set keywords [::pool::string::removeWhitespace $keywords]
	set keywords [split [string trim $keywords ", \t"] ,]
	while {[::pool::list::delete keywords {}]} {}

	return
}



proc ::pool::oo::class::fileDescription::WriteClassLinks {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Generate an itemized list of hyperlinks to the descriptions of
	# @c all classes contained in this file. Used only if classes are
	# @c outlined.

	if {[llength $classes] != 0} {
	    $fmt hrule
	    $fmt pushClass class-listing
	    $fmt itemize {
		foreach c [$fmt sortByName $classes] {
		    $fmt item "Class [$c link]"
		}
	    }
	    $fmt popClass
	}
	return
}



proc ::pool::oo::class::fileDescription::WriteHeading {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Generates the header part of a file description.

	$fmt pushAppendClass -header
	$fmt blockClass {
	    $fmt definitionList {
		$fmt termclasses header-title header-description-value
		$fmt formattedTermVar "Description (short)" shortDescription

		if {[string length $authorName] != 0} {
		    $fmt termclasses header-title header-author-value
		    $fmt mailToDefterm "Written by" authorName authorAddress
		}

		$fmt termclasses header-title header-value
		$fmt formattedTermVar "Version"   version
		$fmt formattedTermVar "Dates"     date

		$fmt termclasses header-title header-description-title
		$fmt formattedTermVar Description comment

		$fmt termclasses header-title header-value
		$fmt formattedTermVar "Bugs"      bug

		if {[llength $dependencies] != 0} {
		    if {$inline} {
			# Retrieve the dependencies of the inlined
			# class and compare. If they are the same
			# supress the file information.

			set cdeps [[lindex $classes 0] dependencies {}]
			#puts stderr "// cdeps [lsort $cdeps]"
			#puts stderr "// deps  [lsort $dependencies]"
			if {
			    0 != [string compare  [lsort $dependencies]  [lsort $cdeps]]
			} {
			    $fmt defterm "Depends on" [DependencyList]
			}
		    } else {
			$fmt defterm "Depends on" [DependencyList]
		    }
		}

		$fmt formattedTermVar Danger      danger
		$fmt formattedTermVar Notes       note
		$fmt formattedTermVar "See also"  seeAlso

		if {[llength $keywords] != 0} {
		    $fmt defterm Keywords [$fmt commaList $keywords]
		}
		$fmt unset_termclasses
	    }
	}
	$fmt popClass
	return
}



proc ::pool::oo::class::fileDescription::WriteProcLinks {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Generate an itemized list of hyperlinks to the descriptions of
	# @c all procedures contained in this file.

	if {[llength $procedures] != 0} {
	    $fmt hrule

	    if {$opt(-psort)} {
		set plist [$fmt sortByName $procedures]
	    } else {
		set plist $procedures
	    }

	    $fmt pushClass proc-listing
	    $fmt itemize {
		foreach p $plist {
		    $fmt item [$p title 1]
		}
	    }
	    $fmt popClass
	}
	return
}



proc ::pool::oo::class::fileDescription::WriteProcedures {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Generates the descriptions for all procedures defined in this
	# @c file. Uses different separator rules dependent on the style of
	# @c procedure descriptions (table vs. definition list).

	if {[llength $procedures] != 0} {
	    if {$opt(-psort)} {
		set plist [$fmt sortByName $procedures]
	    } else {
		set plist $procedures
	    }

	    if {$opt(-ptable)} {
		$fmt hrule
		foreach p $plist {
		    # no visual separator required for table formatting
		    $p write
		}
	    } else {
		foreach p $plist {
		    $fmt hrule
		    $p write
		}
	    }
	}
	return
}



proc ::pool::oo::class::fileDescription::author {} {
    ::pool::oo::support::SetupVars fileDescription
    # @r The author of the file.
	return $authorName
}



proc ::pool::oo::class::fileDescription::authorSet {author} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Called by the containing package to propagate its author
	# @c information.
	# @a author: Author of containing package.

	if {[string length $authorName] == 0} {
	    set authorName $author
	}

	set currentAdr    [::pool::misc::currentAddress]
	set authorAddress [::pool::mail::addressB $authorName $currentAdr]

	foreach p $procedures {
	    $p authorSet $authorName
	}

	foreach c $classes    {
	    $c authorSet $authorName
	}
	return
}



proc ::pool::oo::class::fileDescription::clear {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Resets state information.

	azIndexEntry_clear
	problemsAndIndex_clear
	return
}



proc ::pool::oo::class::fileDescription::completeKwIndex {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c complete indexing of lower levels

	# Index the file using just its own keywords. Keywords coming
	# from the lower levels are ignored.

	set kwi [$dist getIndex keywords]

	foreach phrase $keywords {
	    $kwi addItem $phrase $this
	}

	# propagate global index phrases down to individual classes and
	# procedures (if they don't have information of their own!)

	foreach p $procedures {
	    $p completeKwIndex $keywords
	}
	foreach c $classes {
	    $c completeKwIndex $keywords
	}

	# index procedures
	foreach p $procedures {
	    eval lappend keywords [$p keywords]

	    foreach phrase [$p keywords] {
		$kwi addItem $phrase $p
	    }
	}

	# index classes
	foreach c $classes {
	    eval lappend keywords [$c keywords]
	}

	set keywords [::pool::list::uniq $keywords]

	# don't index the file!
	# its page will contain a mini index of all keywords
	# used by subordinate entities
	return
}



proc ::pool::oo::class::fileDescription::constructor {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Constructor. Initializes the parser functionality in
	# @c <f lib/fileParse.tcl>.

	file_util_init
	set entity file
	return
}



proc ::pool::oo::class::fileDescription::dependencies {internal} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Determines all dependencies of this file.
	# @a internal: list of packages distributed here,
	# @a internal: to be removed from all dependency lists.
	# @r List containing all dependencies of this file.

	#puts stderr "// --> fdeps $internal | $dependencies"
	# i.  delete internal from current dependency list.
	# ii. compute and merge class information.
	# there is no need to merge procedure information,
	# this was done already, by <p fd_extract_definitions>.

	foreach d $internal {
	    while {[::pool::list::delete dependencies $d]} {}
	}

	set deps ""
	foreach c $classes {
	    eval lappend deps [$c dependencies $internal]
	}

	eval lappend dependencies $deps
	set          dependencies [::pool::list::uniq $dependencies]

	#::puts "[name] comp depencencies = <$dependencies>"

	# register this file at the dependency index too,
	# for all found packages

	set depIndex [$dist getIndex deps]

	foreach d $dependencies {
	    $depIndex addItem $d $this
	}

	#puts stderr "// --> fdeps = $dependencies"
	return $dependencies
}



proc ::pool::oo::class::fileDescription::firstLetter {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Overrides base class functionality (<m azIndexEntry:firstLetter>)
	# @c to use the first letter of the actual filename as indexing
	# @c criterium, [strong not] the first letter of the
	# @c path. Except if <o distribution/fsort-fullpath> is
	# @c set. Then the first letter of the full path is used.

	if {[$dist cget -fsort-fullpath]} {
	    set fname $opt(-name)
	    set pfx [$dist cget -file-prefix]
	    if {$pfx != {}} {
		regsub "^$pfx" $fname {} fname
	    }
	    return [string index $fname 0]
	    #return [string index [lindex [file split $opt(-name)] 0] 0]
	} else {
	    return [string index [file tail $opt(-name)] 0]
	}
}



proc ::pool::oo::class::fileDescription::getPage {} {
    ::pool::oo::support::SetupVars fileDescription
    # @r The url of the page containing the file description.

	# Change: Use name of file to derive the name of the output file.
	# map /, \, : ==> _  (/unix \windows :mac)

	if {$inline} {
	    return [[lindex $classes 0] getPage]
	}

	regsub -all {[/\\:]} $opt(-name) {_} oname
	return [$fmt pageFile f_$oname]
	#return [$fmt pageFile f[::pool::serial::new]]
}



proc ::pool::oo::class::fileDescription::keywords {} {
    ::pool::oo::support::SetupVars fileDescription
    # @r The list of keywords this file is indexed under.
	return $keywords
}



proc ::pool::oo::class::fileDescription::problem {proc} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Called by procedures to register them as incompletely
	# @c documented. This is done, additionally the containing
	# @c file (this one) is registered as a problem too.
	# @a proc: Handle of the object registering itself.

	[$dist getIndex procedures] addProblem $proc
	[$dist getIndex files]      addProblem $this
	return
}



proc ::pool::oo::class::fileDescription::scan {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Scans the file for embedded documentation
	# @c and definitions (procedures, classes).

	# I. read description at top
	# - this stops at the first line not a comment
	# - only comments containing a command starting with @ are processed
	# - unknown commands are silently ignored

	set fh [open $opt(-name) r]
	while {! [eof $fh]} {
	    if {[gets $fh line] < 0} {continue}
	    set line [string trim $line]
	    if {![regexp ^# $line]} {break}
	    set line [string trimleft $line "#\t "]
	    if {![regexp ^@ $line]} {continue}
	    set line [string trimleft $line "@"]

	    regexp -indices "^(\[^ \t\]*)" $line dummy word
	    set start [lindex $word 0]
	    set end   [lindex $word 1]

	    set cmd  [string range $line $start $end]
	    set line [string range $line [incr end] end]

	    if {[llength [::info command fd_$cmd]] == 0} {continue}

	    fd_$cmd [string trim $line]
	}

	close $fh
	PostProcessInformation

	# II. now extract and register the definitions inside

	set def          [fd_extract_definitions $opt(-log) $opt(-name)]
	set procs        [lindex $def 0]
	set classSpecs   [lindex $def 1]
	set dependencies [::pool::list::uniq [lindex $def 2]]
	set itclProcs    [lindex $def 3]

	#::puts "[name] file depencencies = <$dependencies>"

	set classIndex [$dist getIndex classes]
	set procIndex  [$dist getIndex procs]

	foreach {cname cspec} $classSpecs {
	    set classId ${this}::Class[::pool::serial::new]

	    classDescription $classId     -name   $cname        -file   $this         -spec   $cspec        -dist   $opt(-dist)   -formatter $fmt  -log    $opt(-log)    -psort  $opt(-psort)  -ptable $opt(-ptable)

	    $classIndex addItem $classId
	    lappend classes $classId
	}

	foreach {pname pspec} $procs {
	    set procId ${this}::Proc[::pool::serial::new]

	    procDescription $procId            -name   $pname             -parent $this              -args   [lindex $pspec 0]  -body   [lindex $pspec 1]  -dist   $opt(-dist)        -log    $opt(-log)    -formatter $fmt  -table  $opt(-ptable)

	    $procIndex addItem $procId
	    lappend procedures $procId
	}


	if {([llength $classes] == 1) && ([llength $procedures] == 0)} {
	    # file contains a single class, and nothing more
	    # mark file and class for inlining of description
	    [lindex $classes 0] configure -inline 1
	    set inline 1
	}

	foreach p $procedures {
	    $p scan
	}
	foreach c $classes    {
	    $c scan
	}

	foreach {name pspec} $itclProcs {
	    foreach {type name} [split $name ,] {break} ;# lassign
	    switch -exact -- $type {
		m {
		    # Detached method. Split name into class and method part.
		    # Lookup class, method in class and add the found body to it.
		    # Scan that body! Dependencies are our responsibility.

		    set pname [lindex [split $name :] end]
		    regsub "$pname\$" $name {} cname
		    set cname [string trimright $cname :]

		    if {$cname == {}} {
			$opt(-log) log error "Detached method '$name': No class reference"
			continue
		    }

		    if {[catch {set classObj [$classIndex itemByName $cname]}]} {
			$opt(-log) log error "Detached method '$name': Class '$cname' not known"
			continue
		    }

		    set mObj [$classObj procByName $pname]
		    if {$mObj == {}} {
			$opt(-log) log error  "Detached method '$name': Method '$pname' not known in class '$cname'"
			continue
		    }

		    foreach {arguments body} $pspec {break}

		    $mObj configure -args $arguments -body $body
		    $mObj scan
		}
		v {
		    # Variable with a config body. The body is of no
		    # interest for now. But mark the variable to have
		    # such a body.

		    set vname [lindex [split $name :] end]
		    regsub "$vname\$" $name {} cname
		    set cname [string trimright $cname :]

		    if {$cname == {}} {
			$opt(-log) log error "Detached config method '$name': No class reference"
			continue
		    }

		    if {[catch {set classObj [$classIndex itemByName $cname]}]} {
			$opt(-log) log error "Detached config method '$name': Class '$cname' not known"
			continue
		    }

		    if {![$classObj hasVariable $vname]} {
			$opt(-log) log error  "Detached config method '$name': Variable '$vname' not known in class '$cname'"
			continue
		    }

		    $classObj variableHasConfig $vname
		}
		default {
		    error "Unknown iTcl type code $type coming from fd_extract_definitions"
		}
	    }
	}
	return
}



proc ::pool::oo::class::fileDescription::write {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Generates the formatted text describing the file.

	$opt(-log) log debug writing file [name] ([page])

	#puts "$this writing html"

	set pkg $opt(-package)

	$dist pushContext $this

	if {[string length $pkg] == 0} {
	    $fmt newPage [page] "File '[name]'"
	} else {
	    $fmt newPage [page]  "File '[name]' (part of '[$pkg name]')"  "File '[name]' (part of '[$pkg link]')"
	}

	$fmt  pushClass file
	$dist writeJumpbar
	WriteHeading

	if {$inline} {
	    # Write the single class of this file, inline its description into
	    # this page

	    [lindex $classes 0] write
	} else {
	    # add data of definitions found in file

	    WriteClassLinks
	    WriteProcLinks
	    WriteProcedures
	}

	$dist writeJumpbar
	$fmt closePage

	if {! $inline} {
	    # and generate the pages of the described entities as well
	    foreach c $classes {
		$c write
	    }
	}

	$dist popContext
	$fmt  popClass
	return
}



proc ::pool::oo::class::fileDescription::writeProblemPage {} {
    ::pool::oo::support::SetupVars fileDescription
    # @c Writes a page containing the detailed problem description of
	# @c this file.

	$fmt  newPage [pPage] "Problems of file '[name]'"
	$dist writeJumpbar

	if {[numProblems] > 0} {
	    writeProblems
	}

	if {[numProblemObjects] > 0} {
	    $fmt section Procedures

	    foreach p [$fmt sortByName $problemObjects] {
		$p writeProblems
	    }
	}

	$fmt closePage
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::fileDescription::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndexEntry::loadClass
::pool::oo::class::problemsAndIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences fileDescription

# Create object instantiation procedure
interp alias {} fileDescription {} ::pool::oo::support::New fileDescription

# -------------------------------


# -*- tcl -*-
# Automatically generated from file 'package.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> packageDescription <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::packageDescription {
    variable  _superclasses    {indexBaseEntry problems}
    variable  _scChainForward  packageDescription
    variable  _scChainBackward packageDescription
    variable  _classVariables  {}
    variable  _methods         {DependencyList ReportNumber TrackDirectory authorSet clear completeDatabase completeKwIndex constructor dependencies getDescription getPage scan write writeProblemPage}

    variable  _variables
    array set _variables  {files {packageDescription {isArray 0 initialValue {}}} phrases {packageDescription {isArray 0 initialValue {}}} desc {packageDescription {isArray 0 initialValue {}}} authorAddress {packageDescription {isArray 0 initialValue {}}} authorName {packageDescription {isArray 0 initialValue {}}} dependencies {packageDescription {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {dir {packageDescription {-default {} -type ::pool::getopt::notype -action TrackDirectory -class Dir}} log {packageDescription {-default {} -type ::pool::getopt::notype -action {} -class Log}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {writeProblemPage . DependencyList . ReportNumber . scan . constructor . completeDatabase . TrackDirectory . completeKwIndex . write . getDescription . getPage . authorSet . clear . dependencies .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::packageDescription::DependencyList {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Internal method, generates a string containing references to the
	# @c packages required by the package.
	#
	# @r A string containing a comma separated list of package names, each
	# @r a hyperlink to a location describing it.

	set text ""

	foreach d $dependencies {
	    append text "[$dist depRef $d], "
	}
	
	return [string trimright $text ", "]
}



proc ::pool::oo::class::packageDescription::ReportNumber {n singular plural} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Report the number of found entities to the log.
	# @a n: The number of found items.
	# @a singular: The singular form of the found entities.
	# @a plural:   The plural form of the found entities.

	if {$n == 1} {
	    $opt(-log) log info 1 $singular found
	} else {
	    $opt(-log) log info $n $plural found
	}
	return
}



proc ::pool::oo::class::packageDescription::TrackDirectory {o oldValue} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o dir>. Causes a rereading of the package
	# @c description in the newly specified directory.
	#
	# @a o: The name of the changed option, here always [strong -dir].
	# @a oldValue: The value of the option before the change. Ignored here.

	# we are in directory $opt(-dir)
	getDescription
}



proc ::pool::oo::class::packageDescription::authorSet {author} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Called by <c distribution> to propagate
	# @c author information to packages and below.
	# @a author: The author of the distribution.

	if {[string length $authorName] == 0} {
	    set authorName $author
	}

	set currentAdr    [::pool::misc::currentAddress]
	set authorAddress [::pool::mail::addressB $authorName $currentAdr]

	foreach f $files {
	    $f authorSet $authorName
	}

	return
}



proc ::pool::oo::class::packageDescription::clear {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Resets state information.

	indexBaseEntry_clear
	problems_clear
	return
}



proc ::pool::oo::class::packageDescription::completeDatabase {author} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Complete the information about the package.
	# @a author: The author of the distribution.

	authorSet $author
	completeKwIndex
	return
}



proc ::pool::oo::class::packageDescription::completeKwIndex {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Complete the indexing of lower levels
	set phrases ""

	foreach f $files {
	    $f completeKwIndex
	    eval lappend phrases [$f keywords]
	}

	set phrases [::pool::list::uniq [lsort $phrases]]
	return
}



proc ::pool::oo::class::packageDescription::constructor {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Constructor. Just used to initialize the <v entity> information.
	set entity package
}



proc ::pool::oo::class::packageDescription::dependencies {internal} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Determines all dependencies of this package
	# @a internal: list of packages distributed here,
	# @a internal: to be removed from all dependency lists.
	# @r List containing all dependencies of this package.

	set deps ""
	foreach f $files {
	    eval lappend deps [$f dependencies $internal]
	}

	set     dependencies [::pool::list::uniq [lsort $deps]]
	return $dependencies
}



proc ::pool::oo::class::packageDescription::getDescription {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Parses package description file 'pkg.doc'.

	# -W- Oops, the description of the internal procedure is attributed to
	# -W- 'getDescription' itself. Do something here to correct this.

	proc package_describe {pkgName spec} {
	    # -@c Reads and analyses the description of a package.
	    # -@a pkgName: The name of the package described by <a spec>.
	    # -@a spec:    The description of the package.

	    upvar                             desc             desc     shortDescription short    authorName       author   version          version  opt(-name)       name

	    array set def {author {} desc {} short {} version {}}
	    array set def $spec


	    foreach e {author desc short version} {
		set $e $def($e)
	    }

	    set name $pkgName

	    set desc  [::pool::string::oneLine      $desc]
	    set desc  [::pool::string::removeSpaces $desc]

	    set short [::pool::string::oneLine      $short]
	    set short [::pool::string::removeSpaces $short]
	    return
	}

	# Read and interpret definition, then remove the temporary procedure
	# used to do this.

	set fail [catch {source pkg.doc} msg]

	rename package_describe {}

	$opt(-log) log info package $opt(-name), at [pwd]

	if {$fail} {
	    $opt(-log) log warning $msg
	}

	return
}



proc ::pool::oo::class::packageDescription::getPage {} {
    ::pool::oo::support::SetupVars packageDescription
    # @r The url of the page containing the package description.

	#puts stdout "Pkg ==== $this getPage $opt(-name)"

	regsub -all {[/\\:]} $opt(-name) {_} oname
	return [$fmt pageFile pkg_$oname]

	#return [$fmt pageFile pkg[::pool::serial::new]]
}



proc ::pool::oo::class::packageDescription::scan {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Scan package for files containing tcl-code
	# @c (.tcl, .cls extensions are recognized)

	$opt(-log) log info scanning $opt(-name)...

	set here [pwd]
	set fail [catch {
	    cd $opt(-dir)

	    # record the files residing in (and under) the package directory
	    set fileIndex [$dist getIndex files]

	    ::pool::file::descendDirs d . {

		set flist [glob -nocomplain *.tcl *.cls]

		foreach f $flist {
		    # check for .tcl having corresponding .cls, skip such

		    set stem [file rootname $f]
		    if {
			([string compare [file extension $f] .tcl] == 0) &&
			[file exists $stem.cls]
		    } {
			continue
		    }

		    # skip over package index files

		    if {[string compare [file tail $f] pkgIndex.tcl] == 0} {
			continue
		    }

		    set fileId   ${this}::File[::pool::serial::new]
		    set fileName [file join $opt(-dir) $d $f]
		    regsub -all {\./} $fileName {} fileName

		    if {[$opt(-dist) Excluded $fileName]} {
			continue
		    }

		    fileDescription $fileId       -name    $fileName    -package $this        -dist    $opt(-dist)  -formatter $fmt  -log     $opt(-log)   -psort   [$dist cget -psort]  -ptable  [$dist cget -ptable]

		    $fileIndex addItem $fileId
		    lappend files      $fileId
		}
	    }
	} msg];	#{}

	if {$fail} {
	    $opt(-log) log warning $msg
	}

	cd $here

	ReportNumber [llength $files] file files

	foreach f $files {
	    $opt(-log) log debug scanning file [$f name]...
	    $f scan
	}

	return
}



proc ::pool::oo::class::packageDescription::write {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Generates the formatted text describing the package.

	#puts "$this writing html"

	$dist pushContext $this
	$fmt  pushClass package
	$fmt  newPage [page] "Package '$opt(-name)'"
	$dist writeJumpbar

	$fmt definitionList {
	    $fmt mailToDefterm "Written by" authorName authorAddress
	
	    if {[string length $desc] != 0} {
		$fmt formattedTerm  Description $desc

		if {[string length $phrases] != 0} {
		    $fmt defterm Keywords [$fmt commaList $phrases]
		}
	    }
	}

	$fmt hrule

	if {([string length $dependencies] != 0)} {
	    $fmt definitionList {
		$fmt defterm "Depends on" [DependencyList]
	    }
	}

	$fmt sortedObjectList $files
	$fmt closePage

	foreach f $files {
	    $f write
	}

	$dist popContext
	$fmt  popClass
	return
}



proc ::pool::oo::class::packageDescription::writeProblemPage {} {
    ::pool::oo::support::SetupVars packageDescription
    # @c Writes a page containing the detailed problem description of
	# @c this package.

	if {[numProblems] > 0} {
	    $fmt newPage [pPage]  "Problems of package '[link]'"  "Problems of package '[name]'"
	    writeProblems
	    $fmt closePage
	}

	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::packageDescription::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::indexBaseEntry::loadClass
::pool::oo::class::problems::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences packageDescription

# Create object instantiation procedure
interp alias {} packageDescription {} ::pool::oo::support::New packageDescription

# -------------------------------


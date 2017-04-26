# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: distribution.cls,v 1.33 2000/09/05 20:10:43 aku Exp $
#
# @c Toplevel class of documentation extractor. Defines external
# @c interface to extractor engine, as used by autodoc application.
# @c Manages everything for a single distribution of files, hence the name.
# @s External interface, toplevel class.
# @i interface, toplevel, distribution
# ----------------------------------------------------------------------

class distribution : formatterInterface problems {

    init {
	package require Pool_Base	
	package require Pool_Net
    }

    # @o itk-opt-alias: The name of a custom command found in the
    # @o itk-opt-alias: code to scan and equivalent to itk_options.

    option itk-opt-alias -d {}

    # @o css: Boolean option to control support for cascading style
    # @o css: sheets (CSS). Support is enabled by default.

    option css -d 1

    # @o clisttype: Either one of [strong comma] or [strong par].
    # @o clisttype: Defines the appearance of the lists used in classes to
    # @o clisttype: reference superclasses, options, methods and member
    # @o clisttype: variables.

    option clisttype -d par
    # Note: should check that!

    # @o fsort-fullpath: Boolean option. If set the listing of files
    # @o fsort-fullpath: in their index is sorted by their full
    # @o fsort-fullpath: path. Else the first letter of the real
    # @o fsort-fullpath: filename (directories stripped).

    option fsort-fullpath -d 1

    # @o file-prefix: In effect only if <o fsort-fullpath> is set.
    # @o file-prefix: Defines a prefix to remove from the path before
    # @o file-prefix: taking the first letter.

    option file-prefix   -d {}

    # @o class-prefix: Defines a prefix to remove from the namespace
    # @o class-prefix: of a class before taking the first letter.

    option class-prefix   -d {}

    # @o proc-prefix: Defines a prefix to remove from the namespace
    # @o proc-prefix: of a procedure before taking the first letter.

    option proc-prefix   -d {}

    # @o namespace-prefix: Defines a prefix to remove from the namespace
    # @o namespace-prefix: of a namespace before taking the first letter.

    option namespace-prefix   -d {}

    # @o no-problems: Boolean option. If set the system will not write
    # @o no-problems: the accumulated problem reports / pages. It will
    # @o no-problems: still write that there are problems and how
    # @o no-problems: many, if any. Default is 0 == no supression.

    option no-problems -d 0


    # @o srcdir:     Path to directory containing the tcl sources to document.
    # @o tables:     Boolean flag. If set the root page is written with tables.

    option srcdir

    # @o outputdir:    Path to directory to store the generated files into.

    option outputdir -a TrackOut

    # @o replyaddr:  Address of person to reply to in case of problems with
    # @o replyaddr:  the documented distribution.

    option replyaddr -a TrackReply

    # @o psort:      Boolean flag. If set procedure documentation is sorted
    # @o psort       alphabetically.
    # @o ptable:     Boolean flag. If set procedure documentation is written as
    # @o ptable:     table.

    option tables -d 0 -t ::pool::getopt::boolean
    option psort  -d 1 -t ::pool::getopt::boolean
    option ptable -d 0 -t ::pool::getopt::boolean

    # @o adlocation: Location of the documentation of AutoDOC.
    # @o adlocation: Required for generation of backreferences for any
    # @o adlocation: generated page.

    option adlocation \
	    -d {http://www.oche.de/~akupries/soft/autodoc/index.htm} \
	    -a TrackAd

    # @o up-link:  The url to use as target in the uplink to the site
    # @o up-link:  containing the generated documentation. Ignored if
    # @o up-link:  neither <o up-title> nor <o up-image> is set.

    # @o up-title: The string to use in the uplink to the site containing the
    # @o up-title: generated documentation.

    # @o up-image: The symbolic name of the image to use in the uplink to the
    # @o up-image: site containing the generated documentation, as defined with
    # @o up-image: a call <m imgDef>.

    # @o up-imglink: A boolean flag. Determines wether the image is made a part
    # @o up-imglink: of the generated uplink or not. Ignored if no text was
    # @o up-imglink: given, the image has to be the link in such a case.

    option up-title   -d {}
    option up-link    -d {}
    option up-image   -d {}
    option up-imglink -d 0 -t ::pool::getopt::boolean

    # @o exclude: A list of glob patterns. All files with names matching at least
    # @o exclude: one of the patterns will be excluded from the scan and
    # @o exclude: documentation processing. This option takes effect while the
    # @o exclude: system is searching for files to document and while searching for
    # @o exclude: additional .doc and .predoc files.

    option exclude -d {}


    # @v hasPackages: Boolean flag. Set if some packages were found
    # @v hasFiles:    Boolean flag. Set if some files were found.
    # @v docFileList: List of files with extension '.doc'.
    # @v inDocFile:   Boolean flag. Set during evaluation of '.doc'-files.
    # @v moreFiles:   List of files marked as required by '.doc'-files.
    # @v morePages:   List of additional files generated by the
    # @v morePages:   '.doc'-files.
    # @v log:         Handle of the <x syslogConnection> object used for
    # @v log:         logging.

    var hasPackages   0
    var hasFiles      0
    var docFileList
    var inDocFile 0
    var moreFiles
    var morePages
    var log

    # @v attributeValue: Maps from the attribute names used in
    # @v attributeValue: [strong DESCRIPTION] files to their respective values.

    var -array attributeValue

    # @v attributeName: Maps from the attribute names used in
    # @v attributeName: [strong DESCRIPTION] files to the texts used in the
    # @v attributeName: generated documentation.

    var -array attributeName {
	version			Version
	copying-policy		{Copying policy}
	date			Date
	name			Name
	comments		Comments
	description		Description
	development-platform	{Development platform}
	platforms		Platforms 
	dependencies		Dependencies
	primary-urls		{Primary urls}
	secondary-urls		{Secondary urls}
	tertiary-urls		{Tertiary urls}
    }

    # @v attrs: List of attributes defined by the distribution description
    # @v attrs: file.

    var attrs

    # @v index: Maps from a logical index name to the object managing it.

    var -array index

    # @v sidebarText: Used by <m add2Sidebar> to record the texts for the
    # @v sidebarText: hyperlinks pointing to the additional pages.

    var -array sidebarText

    # @v jumpbar: A cache holding the formatted jumpbar texts for the various
    # @v jumpbar: callers of <m writeJumpbar>.

    var -array jumpbar


    # @v imgC: Table of scripts for the conversion of an image file into the
    # @v imgC: format required by the browser. The following special strings
    # @v imgC: are recognized by the system: [strong %in%], [strong %tmp%] and
    # @v imgC: [strong %out%]. See <x ...> for their meaning.

    var -array imgC

    # @v imgS: State of images (requested or not)

    var -array imgS


    method distribution {} {
	# @c Constructor. Creates and initializes all subordinate indices.
	# @c These objects are nested into the namespace of this one,
	# @c reducing the possibility of conflicts with command outside.

	set logName ${this}::Log
	set log [syslogConnection $logName -prefix autodoc]

	$log log notice startup...

	foreach {idxClass} {
	    packageIndex fileIndex procIndex classIndex kwIndex depIndex
	    namespaceIndex
	} {
	    set iObjName ${this}::Idx[::pool::serial::new]
	    set indexObj [$idxClass $iObjName -dist $this -formatter $fmt]

	    set index([${indexObj} code]) $indexObj
	}

	foreach key [array names attributeName] {
	    set attributeValue($key) ""
	}

	# self reference, required by 'jumpbar' routine.
	# set opt(-dist) $this

	InitPatterns
	return
    }



    method ~distribution {} {
	# @c Removes all traces of the distribution from memory
	# @n There is no need to delete the subordinate objects
	# @n explicitly. They are nested into this namespace and
	# @n therefore automatically removed. It would still be
	# @n necessary if they were using outside resources, like
	# @n channels, but they don't.

	if {0} {
	    #clear

	    foreach i [array names index] {
		$index($i) delete
	    }

	    $log delete
	}
	return
    }


    method TrackFormatter {o oldValue} {
	# @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o formatter>. Propagates the new value to
	# @c the internal shadow and causes the configuration of the specified
	# @c object.
	#
	# @a o:        The name of the changed option, here always
	# @a o:        [strong -formatter].
	# @a oldValue: The value of the option before the change. Ignored here.

	formatterInterface_TrackFormatter $o $oldValue

	if {[string length $fmt] == 0} {
	    return
	}

	# set backlink from formatter to distribution to give it access to our
	# indices.

	$fmt configure \
		-dist       $this             \
		-outputdir  $opt(-outputdir)  \
		-replyaddr  $opt(-replyaddr)  \
		-adlocation $opt(-adlocation) \
		-css        $opt(-css)

	foreach i [array names index] {
	    $index($i) configure -formatter $fmt
	}
	return
    }

    method TrackOut {o oldValue} {
	# @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o outputdir>. Propagates the new value to
	# @c the internal shadow and causes the configuration of the specified
	# @c object.
	#
	# @a o:        The name of the changed option, here always
	# @a o:        [strong -outputdir].
	# @a oldValue: The value of the option before the change. Ignored here.

	if {$fmt == {}} {return}
	$fmt configure -outputdir $opt(-outputdir)
    }

    method TrackReply {o oldValue} {
	# @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o replyaddr>. Propagates the new value to
	# @c the internal shadow and causes the configuration of the specified
	# @c object.
	#
	# @a o:        The name of the changed option, here always
	# @a o:        [strong -replyaddr].
	# @a oldValue: The value of the option before the change. Ignored here.

	if {$fmt == {}} {return}
	$fmt configure -replyaddr  $opt(-replyaddr)
    }

    method TrackAd {o oldValue} {
	# @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o adlocation>. Propagates the new value to
	# @c the internal shadow and causes the configuration of the specified
	# @c object.
	#
	# @a o:        The name of the changed option, here always
	# @a o:        [strong -adlocation].
	# @a oldValue: The value of the option before the change. Ignored here.

	if {$fmt == {}} {return}
	$fmt configure -adlocation $opt(-adlocation)
    }

    method scan {} {
	# @c Reads DESCRIPTION residing in source directory, scans
	# @c subdirectories for packages/files, evaluates these then
	# @c too.

	set start [clock seconds]

	clear
	$log log notice scanning...

	if {[string length $opt(-srcdir)] == 0}  {
	    error "no source directory given"
	}

	cd $opt(-srcdir)

	$fmt prepareForOutput

	# Interpreter for cross referencing
	set ipName    ${this}_cr ; # embed into this namespace
	interp create $ipName
	PrepareCRefIp $ipName


	ReadDescription
	HandlePredocFiles
	SearchPackages
	SearchDocFiles

	if {[$index(packages) number] > 0} {
	    # We have at least one package, now process them.

	    set hasPackages 1

	    ReportNumber [$index(packages) number] package packages
	    HandlePackages
	} else {
	    # No explicit package here, treat the whole directory
	    # hierarchy as a single implicit package.

	    set hasPackages 0
	    $log log notice no packages found, falling back to full file scan

	    SearchForFiles
	    HandleFiles

	    if {[$index(files) number] > 0} {
		set hasFiles 1
	    }
	}

	CompleteDatabase
	Write

	set runtime [expr {[clock seconds]-$start}]
	$log log notice ...done ($runtime seconds)
	return
    }



    method ReadDescription {} {
	# @c Reads the description file for the entire distribution.
	# @n Assumes to be in the module directory

	if {
	    [file exists   DESCRIPTION] &&
	    [file readable DESCRIPTION]
	} {
	    proc extension {name spec} {
		# get object member, assume a call from member procedure
		upvar attributeValue attributeValue
		upvar attrs          attrs

		# store name and read description
		set   attributeValue(name)      $name

		foreach {k d} $spec {
		    lappend attrs              $k
		    set     attributeValue($k) $d
		}

		return
	    }


	    set fail [catch {source DESCRIPTION} msg]
	    rename extension {}

	    $log log notice distribution '$attributeValue(name)'

	    if {$fail} {
		$log log warning $msg
	    }
	} else {
	    $log log warning distribution at $opt(-srcdir) has no description

	    set attributeValue(name) UNKNOWN
	}
	return
    }



    method SearchPackages {} {
	# @c Searches for packages in the distribution.
	# @c Detects them by the presence of 'pkg.doc' in a directory.
	# @n Assumes to be in the module directory.

	# phase I.: search for packages
	# (detectable by the presence of 'pkg.doc' in a directory)

	::pool::file::descendDirs d . {

	    if {
		[file exists   pkg.doc] &&
		[file readable pkg.doc]
	    } {
		set pkgId ${this}::Package[::pool::serial::new]

		packageDescription $pkgId -log $log -dist $this -formatter $fmt

		# Do this after the creation, no order of option assignments
		# was guaranteed. This reads the package description file
		# ('pkg.doc') and uses the other definitions.

		$pkgId configure -dir $d

		$index(packages) addItem $pkgId
	    }
	}

	return
    }



    method SearchForFiles {} {
	# @c Searches for files containing tcl-code.
	# @n Is done only if no packages were found.

	set files {}

	::pool::file::descendDirs d . {
	    set flist [glob -nocomplain *.tcl *.cls]

	    foreach f $flist {
		# check for .tcl with a corresponding .cls, skip them

		set stem [file rootname $f]
		if {
		    ([string compare [file extension $f] .tcl] == 0) &&
		    ([file exists $stem.cls])
		} {
		    continue
		}

		# skip over package index files

		if {[string compare [file tail $f] pkgIndex.tcl] == 0} {
		    continue
		}

		set fileId   ${this}::File[::pool::serial::new]
		set fileName [file join $d $f]

		regsub -all {\./} $fileName {} fileName

		if {[Excluded $fileName]} {
		    continue
		}

		fileDescription $fileId      \
			-name   $fileName    \
			-dist   $this        \
			-formatter $fmt \
			-log    $log         \
			-psort  $opt(-psort) \
			-ptable $opt(-ptable)

		lappend files         $fileId
		$index(files) addItem $fileId
	    }
	}

	ReportNumber [llength $files] file files
	return
    }



    method HandlePackages {} {
	# @c Tell the found packages to scan themselves.

	foreach p [$index(packages) items] {
	    $p scan
	}

	return
    }



    method HandleFiles {} {
	# @c Tell the found files to scan themselves.
	# @n Is done only if no packages were found.

	foreach f [$index(files) items] {
	    $log log debug scanning file [$f name]...
	    $f scan
	}

	return
    }



    method HandlePredocFiles {} {
	# @c Searches for files ending in '.predoc'
	# @c and executes them in a safe(?) environment.

	set predocFiles ""

	::pool::file::descendDirs d . {
	    set flist [glob -nocomplain *.predoc]
	    foreach f $flist {
		set full [file join $d $f]
		if {[Excluded $full]} {
		    continue
		}
		lappend predocFiles $full
	    }
	}

	if {[llength $predocFiles] == 0} {
	    return
	}

	# ii. execute the found files, use a subinterpreter
	#     to avoid smashing our own state.

	set ipName    ${this}_predoc

	interp create $ipName

	interp alias $ipName xrefDef       {} $this xrefDef
	interp alias $ipName imgDef        {} $this imgDef
	interp alias $ipName imgConverter  {} $this imgConverter
	interp alias $ipName depDef        {} $this depDef
	interp alias $ipName docfile       {} $this docfile

	foreach f $predocFiles {
	    $log log debug processing $f

	    set fail [catch {
		$ipName eval source $f
	    } msg] ;#{}
		
	    if {$fail} {
		$log log warning $f: $msg
	    }
	}

	interp delete $ipName
	return
    }



    method SearchDocFiles {} {
	# @c Searches for files ending in '.doc' and remembers
	# @c them for later usage. 'pkg.doc's are excluded, as
	# @c they have a special meaning as package description
	# @c files.

	::pool::file::descendDirs d . {
	    set flist [glob -nocomplain *.doc]

	    foreach f $flist {
		if {[string compare $f pkg.doc] == 0} {
		    continue
		} elseif {[Excluded $f]} {
		    continue
		}

		lappend docFileList [file join $d $f]
	    }
	}

	return
    }


    method Excluded {filename} {
	# @c Checks the specified <a filename> for exclusion by matching
	# @c it against the patterns stored in <o exclude>.
	# @a filename: The name of the file to check for exclusion.
	# @r a boolean value. True signals that the file has to be excluded.

	foreach gp $opt(-exclude) {
	    if {[string match $gp $filename]} {
		return 1
	    }
	}

	return 0
    }

    method HandleDocFiles {} {
	# @c Executes the remebered '.doc'-files in a safe(?)
	# @c environment.

	global errorInfo

	if {[llength $docFileList] == 0} {
	    # nothing to handle
	    return
	}

	ReportNumber [llength $docFileList] docfile docfiles

	# ii. execute the found .doc - files, use a subinterpreter
	#     to avoid smashing our own state.

	set ipName    ${this}_docIp

	interp create $ipName
	PrepareDocIp  $ipName

	set inDocFile 1
	set morePages ""

	$fmt configure -ip $ipName

	foreach f $docFileList {
	    $log log debug processing $f

	    set fail [catch {
		$ipName eval source $f
	    } msg] ;#{}
		
	    if {$fail} {
		#global errorInfo
		$log log warning $f: $msg
		#puts $errorInfo
	    }
	}

	$fmt configure -ip {}
	set inDocFile 0

	interp delete $ipName

	# morePages now contains the additional pages
	# link_text,* their texts
	# moreFiles has the path of additionally required
	# files (like pictures).
	return
    }



    method PrepareDocIp {ipName} {
	# @c Prepare the specified interpreter for evaluation
	# @c of the .doc files found in the distribution.
	# @a ipName: The name of the interpreter to prepare.

	# i. Link formatter methods as command procedures into it.
	#    Remove the standard methods (constructor, destructor, ...)
	# Remove some methods redirected through the distribution.

	foreach m [$fmt oinfo methods] {
	    interp alias $ipName $m  {} $fmt $m
	}

	if {0} {
	    foreach stdm {
		delete cget config configure
		chainToSuper chainToDerived oinfo
	    } {
		interp alias $ipName $stdm  {} {}	    
	    } 
	}

	catch {interp alias $ipName  [$fmt oinfo class]  {} {}}
	catch {interp alias $ipName ~[$fmt oinfo class]  {} {}}

	interp alias $ipName newPage {} {}


	# ii. Link the cross reference methods of the distribution
	#     into the interpreter.

	foreach m {
	    xrefDef xRef procRef classRef fileRef pkgRef depRef
	    optionRef methodRef varRef add2Sidebar docfile
	    imgDef imgConverter imgRef
	} {
	    interp alias $ipName $m {} $this $m
	}

	interp alias $ipName newPage {} $this NewPage

	return
    }


    method PrepareCRefIp {ipName} {
	# @c Prepare the specified interpreter for evaluation of texts
	# @c containing cross references. A separate interpreter is used to
	# @c allow usage of various formatting commands without polluting the
	# @c global namespace, or this class.
	# @a ipName: The name of the interpreter to prepare.

	# i. Link some formatter methods as command procedures into it.

	foreach m {strong ampersand sample emph} {
	    interp alias $ipName $m  {} $fmt $m
	}

	# ii. Link the cross reference methods of the distribution
	#     into the interpreter. These are not used directly, but in the
	#     course of crossreference resolution via <m crResolve>.

	foreach m {
	    Xpar
	    Xri Xra Xrc Xrcs XrOld
	    xRef depRef imgRef
	} {
	    interp alias $ipName $m {} $this $m
	}

	return
    }



    method CopyMoreFiles {} {
	# @c Files marked as required (by '.doc'-files) are copied
	# @c into the html target directory.

	if {[llength $moreFiles] == 0} {return}

	foreach f $moreFiles {
	    file copy -force $f [file join $opt(-outputdir) [file tail $f]]
	}

	return
    }



    method CompleteDatabase {} {
	# @c Completes database (author information,
	# @c keyword index, dependencies).

	$log log info completing database...

	set a [Author]
	set m [Maintainer]

	set attributeValue(author)     $a
	set attributeValue(maintainer) $m

	# new data

	set currentAdr    [::pool::misc::currentAddress]
	set authorAdr     [::pool::mail::addressB $a $currentAdr]
	set maintainerAdr [::pool::mail::addressB $m $currentAdr]

	set attributeValue(author_address)     $authorAdr
	set attributeValue(maintainer_address) $maintainerAdr

	# remove the attributes handled specially
	::pool::list::delete attrs author
	::pool::list::delete attrs maintainer
	::pool::list::delete attrs maintenance
	::pool::list::delete attrs primary-urls
	::pool::list::delete attrs secondary-urls
	::pool::list::delete attrs tertiary-urls
	::pool::list::delete attrs @


	# propagate author information downward.
	# lift index information upward

	# propagate information about distributed packages downward,
	# so that they are removed from dependency lists. Simultaneously
	# collect all known real dependencies for inclusion into the homepage.

	# Beware of the case with no package to complete, just
	# files. Complete them individually.

	set internalPkgs [list]
	if {$hasPackages} {
	    set internalPkgs [$index(packages) completeDatabase $a]
	} else {
	    foreach f [$index(files) items] {
		$f completeKwIndex
	    }
	}

	# reference to this object, required by 'writeJumpbar'
	set index(home) $this

	CompleteDependencies $internalPkgs
	return
    }



    method CompleteDependencies {internalPkgs} {
	# @c Takes the list of packages required by the scanned distribution
	# @c and removes all packages defined by it. This is required to
	# @c avoid false dependencies.
	#
	# @a internalPkgs: List containing the names of all packages defined by
	# @a internalPkgs: the scanned distribution.

	set deps [split $attributeValue(dependencies) ,]

	set attributeValue(dependencies) ""

	foreach d $deps {
	    lappend attributeValue(dependencies) [string trim $d]
	}

	foreach p [$index(packages) items] {
	    eval lappend attributeValue(dependencies) \
		    [$p dependencies $internalPkgs]
	}

	set attributeValue(dependencies) \
		[::pool::list::uniq [lsort $attributeValue(dependencies)]]

	# check dependencies for missing locations

	#::puts "deps = <$attributeValue(dependencies)>"

	foreach d $attributeValue(dependencies) {
	    if {[string compare $d [depRef $d]] == 0} {
		$log log warning \
			External reference '$d': no web location defined
	    }
	}

	return
    }



    method Write {} {
	# @c Writes out the documentation of the entire distribution.

	$log log info writing the documentation...

	# I.: generate (non-empty) indices

	foreach i [array names index] {
	    if {[string compare $i home] == 0} {
		# skip home, is no index
		continue
	    }
	    if {[$index($i) number] == 0} {
		#puts "skip $i /empty"
		continue
	    }

	    $index($i) write
	}

	#puts "hp/hf = $hasPackages / $hasFiles"

	if {$hasPackages} {
	    # II.: generate package pages
	    foreach p [$index(packages) items] {
		$p write
	    }
	} elseif {$hasFiles} {
	    # II.: or file pages, if no packages available
	    foreach f [$index(files) items] {
		$f write
	    }
	}

	HandleDocFiles
	CopyMoreFiles
	WriteStatistics
	WriteHomepage
	CleanImages
	return
    }



    method WriteHomepage {} {
	# @c Internal method. Generates the main page of the distribution, the
	# @c entry point for all documentation users.

	# III.: now generate homepage of distribution.
	 $fmt newPage [page] "Homepage of $attributeValue(name)"
	 writeJumpbar home

	if {[numProblems] > 0} {
	    if {$opt(-css)} {
		set att class=error
	    } else {
		set att align=center
	    }

	    if {$opt(-no-problems)} {
		$fmt par $att [$fmt markWithClass error [$fmt markError {
		    Please look at the statistics page, this distribution has
		    errors in its documentation. The detailed listing of all
		    problems is suppressed though.
		}]] ; # {}
	    } else {
		$fmt par $att [$fmt markWithClass error [$fmt markError {
		    Please look at the statistics page, this distribution has
		    errors in its documentation
		}]] ; # {}
	    }
	}

	# additional files present ?
	# if yes, use a table based layout to generate a sidebar
	# containing them else do a simple one, containing the
	# description only

	$fmt pushClass report-summary

	if {[llength $morePages] != 0} {
	    if {! $opt(-tables)} {
		$fmt pushClass report-summary-text
		WriteDescription
		$fmt popClass

		$fmt pushClass report-summary-navbar
		WriteSidebar 0
		$fmt popClass
	    } else {
		if {$opt(-css)} {
		    $fmt table {
			$fmt table_row {
			    $fmt pushClass report-summary-navbar
			    $fmt table_data valign=top {
				WriteSidebar 1
			    }
			    $fmt popClass
			    $fmt pushClass report-summary-text
			    $fmt table_data valign=top {
				WriteDescription
			    }
			    $fmt popClass
			}
		    }
		} else {
		    $fmt table border {
			$fmt table_row {
			    $fmt table_data valign=top {
				WriteSidebar 1
			    }
			    $fmt table_data valign=top {
				WriteDescription
			    }
			}
		    }
		}
	    }
	} else {
	    $fmt pushClass report-summary-text
	    WriteDescription
	    $fmt popClass
	}

	$fmt popClass
	$fmt closePage
	return
    }



    method SidebarLink {p} {
	# @r a hyperlink pointing to the specified additional documentation
	# @r page <a p>.
	# @a p: The code of the page whose link shall be retrieved.

	return [$fmt link $sidebarText($p) $p]
    }



    method WriteSidebar {inTable} {
	# @c Writes the text containing the references to
	# @c additional files, as registered via '.doc'-files.
	# @a inTable: flag, 1 if code shall be placed in a table, 0 else.

	if {$inTable} {
	    foreach p $morePages {
		$fmt write [SidebarLink $p]
		$fmt parbreak
	    }
	} else {
	    $fmt hrule
	    $fmt section "More..."
	    foreach p $morePages {
		$fmt par [SidebarLink $p]
	    }
	}

	return
    }



    method WriteDescription {} {
	# @c Writes out the distribution description.

	# list description attributes
	if {[llength $attrs] != 0} {
	    $fmt definitionList {
		$fmt mailToDefterm "Written by" \
			attributeValue(author) \
			attributeValue(author_address)

		$fmt mailToDefterm "Maintained by" \
			attributeValue(maintainer) \
			attributeValue(maintainer_address)

		foreach a [lsort $attrs] {
		    # use known attributes only!
		    if {[::info exists attributeName($a)]} {

			if {[string compare $a dependencies] == 0} {
			    set text ""
			    foreach d $attributeValue($a) {
				append text "[depRef $d], "
			    }
			    set attributeValue($a) [string trim $text ", "]
			}
			
			$fmt defterm $attributeName($a) $attributeValue($a)
		    }
		}
	    }
	}

	# list urls

	set pbreak [$fmt getString {$fmt parbreak}]

	foreach loc {primary-urls secondary-urls tertiary-urls} {
	    if {[llength $attributeValue($loc)] != 0} {
		$fmt definitionList {
		    # now reformat all detected urls into hyperlinks.
		    # then convert all line-endings into the equivalent
		    # explicit formatting.

		    set text $attributeValue($loc)
		    set text [string trim [::pool::urls::hyperize $text]]

		    regsub -all "\n\n*"     $text "\n"        text
		    regsub -all "\n\[ \t]*" $text "$pbreak\n" text
		    regsub -all "\n\n*"     $text "\n"        text

		    $fmt defterm $attributeName($loc) $text
		}
	    }
	}

	return
    }



    method writeJumpbar {{caller {}}} {
	# @c Writes the formatted text of a jumpbar for placement at the top of
	# @c every page, or whereever the caller likes.
	#
	# @a caller: contains the name of a calling special page (home,
	# @a caller: indices) or else an empty list. Used to deactivate the
	# @a caller: corresponding entry in the jumpbar.

	# check for a cached version to speed execution

	if {[::info exists jumpbar($caller)]} {
	    $fmt write $jumpbar($caller)
	    return
	}

	# nothing in the cache, generate it, place it in the cache,
	# write it out too :-)

	$fmt pushClass navbar

	set jumpbar($caller) [$fmt getString {
	    if {[string compare home $caller] == 0} {
		# Add a link to the site containing the documentation tree,
		# if defined.

		set text ""

		set hasLink  [expr {[string length $opt(-up-link)] > 0}]
		set hasTitle [expr {[string length $opt(-up-title)] > 0}]
		set hasImage [expr {[string length $opt(-up-image)] > 0}]

		if {$hasLink && ($hasTitle || $hasImage)} {

		    set linkText "$opt(-up-title)"

		    if {! $hasTitle} {
			# image has to be part of link, is the only part

			set linkText [imgRef $opt(-up-image)]
			set linkText [$fmt link $linkText $opt(-up-link)]
		    } else {
			# evaluate 'up-imglink' to determine placement of image

			if {$opt(-up-imglink)} {
			    # make image a part of the link

			    set linkText "[imgRef $opt(-up-image)]$linkText"
			    set linkText [$fmt link $linkText $opt(-up-link)]

			} else {
			    # place image before the actual link

			    set linkText [$fmt link $linkText $opt(-up-link)]
			    set linkText "[imgRef $opt(-up-image)]$linkText"
			}
		    }

		    append text "$linkText |"
		}

		append text " Home |"
	    } else {
		set text  "[$fmt link Home [page]] |"
	    }

	    #puts "hp/hf = $hasPackages / $hasFiles"

	    if {!$hasFiles} {
		if {$hasPackages} {
		    if {[string compare packages $caller] == 0} {
			append text " Packages |"
		    } else {
			append text " [$index(packages) link] |"
		    }
		}
	    }

	    if {$hasFiles || $hasPackages} {
		foreach i {files procs classes namespaces keywords deps} {
		    # skip empty indices

		    if {[$index($i) number] == 0} {
			#puts "skip $i /empty"
			continue
		    }

		    if {[string compare $i $caller] == 0} {
			append text " [$index($i) name] |"
		    } else {
			append text " [$index($i) link] |"
		    }
		}
	    }

	    $fmt hrule

	    if {$opt(-css)} {
		$fmt par [string trimleft [string trimright $text |]]
	    } else {
		$fmt par align=center [string trimleft [string trimright $text |]]
	    }
	    $fmt hrule
	}] ;# {}

	$fmt popClass

	$fmt write $jumpbar($caller)
	return
    }



    method GatherStatistics {} {
	# @c Checks the main indices for problems and causes the generation of
	# @c their problem reports if they do have such. Records the number of
	# @c problems for inclusion into the main statistics. The generation
	# @c of their problem reports can be suppressed by setting the option
	# @c <o no-problems>.

	::pool::array::def stats

	# check for problems, write appropriate pages
	foreach i {files procs classes packages} {

	    set stats($i,n) [$index($i) numProblemObjects]

	    if {$stats($i,n) > 0} {

		if {!$opt(-no-problems)} {
		    $index($i) writeProblemPage
		}

		set stats($i,page) [$index($i) pPage]

		incr numProblems
	    }
	}

	#set stats(packages,n) 0
	#set stats(packages,page) ""

	return [array get stats]
    }



    method StatText {statvar idx} {
	# @c Internal helper used by the method generating the main statistics.
	# @c Merges the problem information recorded by <m GatherStatistics>
	# @c into the string containing the number of scanned entities. If
	# @c option <o no-problem> is not set the merged information will contain
	# @c a link to the appropriate high level problem report for the index
	# @c refered to (<a idx>). Else it will just be the number of problems.
	#
	# @a statvar: The name of the variable containing the statistics.
	# @a idx: The name of the index whose information is requested.
	# @r a string containing the number of entities found, and the number
	# @r of problematic ones.

	upvar $statvar stats
	set text    [$index($idx) number]
	set problem ""

	switch -- $stats($idx,n) {
	    0 {
		return $text
	    }
	    1 {
		set problem "1 problem"
	    }
	    default {
		set problem "$stats($idx,n) problems"
	    }
	}

	if {!$opt(-no-problems)} {
	    set problem "([$fmt link $problem $stats($idx,page)])"
	} else {
	    set problem "($problem)"
	}

	return "$text $problem"
    }



    method WriteStatistics {} {
	# @c Generates a summary page containing statistics about the scanned
	# @c distribution. Additionally refers to pages with listings of
	# @c problematic files, classes and procedures, if any. If option
	# @c <o no-problems> is set this procedure will not write the list of
	# @c general problems after the statistics.

	array set stats [GatherStatistics]

	$fmt newPage stat.htm "Summary"
	add2Sidebar stat.htm "Statistics"
	writeJumpbar

	if {$opt(-css)} {
	    $fmt pushClass statistics
	    $fmt table {
		# query indices for number of entities registered.

		foreach i {packages files procs classes} {

		    # skip empty indices
		    if {[$index($i) number] == 0} {
			continue
		    }

		    $fmt table_row {
			$fmt pushAppendClass -location
			$fmt table_data {
			    $fmt write [$index($i) name]
			}
			$fmt popClass

			$fmt pushAppendClass -description
			$fmt table_data {
			    $fmt write [StatText stats $i]
			}
			$fmt popClass
		    }
		}
	    }
	    $fmt popClass
	} else {
	    $fmt table border {
		# query indices for number of entities registered.

		foreach i {packages files procs classes} {

		    # skip empty indices
		    if {[$index($i) number] == 0} {
			continue
		    }

		    $fmt table_row {
			$fmt table_data {
			    $fmt write [$index($i) name]
			}
			$fmt table_data {
			    $fmt write [StatText stats $i]
			}
		    }
		}
	    }
	}

	if {([numProblems] > 0) && !$opt(-no-problems)} {
	    $fmt hrule
	    $fmt section {General problems}
	    writeProblems
	}

	$fmt closePage
	return
    }



    method getIndex {idxName} {
	# @r the object managing the specified index.
	# @a idxName: The internal name of the requested index.

	return $index($idxName)
    }


    method CleanImages {} {
	# @c Removes all defined, yet unreferenced pictures from the output
	# @c directory.

	foreach iCode [array names imgS] {
	    if {[::info exists $imgS($iCode)]} {
		file delete $imgS($iCode)
	    }
	}

	return
    }


    method GenerateImage {converter in out} {
	# @c Transfers the image file <a in> to <a out> and converts it along
	# @c the way, using the <a converter>.
	#
	# @a converter: Handle of the converter to use.
	# @a in:        The name of the source image file
	# @a out:       Name of the target file.
	# @r <a out>, extended by the path of the output directory.

	set out       [file join $opt(-outputdir) $out]
	set in        [file join $opt(-srcdir)    $in]
	set tmp       ""

	if {
	    [catch {set cvtScript $imgC($converter)}] ||
	    ([llength $cvtScript] == 0)
	} {
	    # missing/empty converter

	    $fmt MakeError desc \
		    "<Image: $in>" "image converter $converter missing"
	    return ""
	}

	# handle special strings

	regsub -all {%in%}  $cvtScript $in  cvtScript
	regsub -all {%out%} $cvtScript $out cvtScript

	if {[regexp %tmp% $cvtScript]} {
	    set tmp [file join [pwd] tmppic[::pool::serial::new]]
	    regsub -all {%tmp%} $cvtScript $tmp cvtScript
	}

	#puts  stderr "cvt $converter: $in -> $out"
	#puts  stderr "cvt << $cvtScript >>"
	#flush stderr

	# convert and transfer result

	set fail [catch {eval $cvtScript} msg]
	if {$fail} {
	    if {![file exists $out]} {
		# Report only problems causing non-generation of the target
		# file

		$fmt MakeError desc \
			"<Image: $in>" "$converter problem: $msg"
		return ""
	    } else {
		# Partial problem, log a notice
		regsub -all "\n" $msg { } msg
		log notice "<Image: $in> $converter problem: $msg"
	    }
	}

	# clean up transient data, if any

	if {[string length $tmp] > 0} {
	    # skip over problems here, might be a consequence of earlier
	    # problems

	    catch {
		eval file delete [glob -nocomplain ${tmp}*]
	    }
	}

	return $out
    }


    method Author {} {
	# @c Determines author of distribution.

	if {[::info exists attributeValue(author)]} {
	    if {[string length $attributeValue(author)] != 0} {
		return $attributeValue(author)
	    }
	}

	return [::pool::misc::currentUser]
    }



    method Maintainer {} {
	# @c Determines maintainer of distribution.
	if {[::info exists attributeValue(maintainer)]} {
	    if {[string length $attributeValue(maintainer)] != 0} {
		return $attributeValue(maintainer)
	    }
	}

	if {[::info exists attributeValue(maintenance)]} {
	    if {[string length $attributeValue(maintenance)] != 0} {
		return $attributeValue(maintenance)
	    }
	}

	return [Author]
    }



    method page {} {
	# @r The filename of the distribution page.
	# @n The codes assumes that no more than one such page exists.
	return index.htm
    }





    method procRef {name} {
	# @c See <m procIndex:ref>
	# @a name: See <m procIndex:ref>

	return [$index(procs) ref $name]
    }



    method nsRef {name} {
	# @c See <m namespaceIndex:ref>
	# @a name: See <m namespaceIndex:ref>

	return [$index(namespaces) ref $name]
    }



    method classRef {name} {
	# @c See <m classIndex:ref>
	# @a name: See <m classIndex:ref>

	return [$index(classes) ref $name]
    }



    method fileRef {name} {
	# @c See <m fileIndex:ref>
	# @a name: See <m fileIndex:ref>

	return [$index(files) ref $name]
    }



    method pkgRef {name} {
	# @c See <m packageIndex:ref>
	# @a name: See <m packageIndex:ref>

	return [$index(packages) ref $name]
    }



    method optionRef {class name} {
	# @c See <m classIndex:oref>
	# @a class: See <m classIndex:oref>
	# @a name: See <m classIndex:oref>

	return [$index(classes) oref $class $name]
    }



    method methodRef {class name} {
	# @c See <m classIndex:mref>
	# @a class: See <m classIndex:mref>
	# @a name: See <m classIndex:mref>

	return [$index(classes) mref $class $name]
    }



    method varRef {class name} {
	# @c See <m classIndex:vref>
	# @a class: See <m classIndex:vref>
	# @a name: See <m classIndex:vref>

	return [$index(classes) vref $class $name]
    }



    method xRef {code} {
	# @c Return hyperlink to external page <a code>.
	# @a code: Internal symbolic name of external reference.
	if {! [catch {set text [$fmt linkRef xr_$code]}]} {
	    return $text
	}

	return [$fmt MakeError desc \
		"no link for $code" \
		[$fmt quote "no link for <${code}>"]]
    }



    method depRef {name} {
	# @c Converts the <a name> of an external package into a hyperlink.
	# @c The argument is returned unchanged, if that is not possible.
	# @a name: Name of package to link to.
	# @r a string containing a hyperlink to <a name>, if possible.

	set        text $name
	catch {set text [$fmt linkRef dep_$name]}
	return    $text
    }



    method xrefDef {code text url} {
	# @c Defines an external reference.
	# @a code: The internal symbolic name to reach this hyperlink
	# @a text: Text to use in the link.
	# @a url:  Page refered by the link.

	$fmt pushClass xref-xref
	$fmt linkDef xr_$code $text $url
	$fmt popClass
	return
    }



    method depDef {name url} {
	# @c Defines additional information for a 'required' package,
	# @c to allow conversion of usage in descriptions into hyperlinks.
	# @a name: The name of the package
	# @a url:  Page to refer to for information about the package.

	$fmt pushClass xref-dep
	$fmt linkDef dep_$name $name $url
	$fmt popClass
	return
    }


    method imgConverter {code script} {
	# @c Register a <a script> to transfer an image source into the html
	# @c tree, doing format conversion if necessary. The script may
	# @c contain the special strings [strong %in%], [strong %out%] and
	# @c [strong %tmp%]. They refer to the input file, output file and a
	# @c temporary file. The latter is generated only if the string is
	# @c present in the <a script>.
	#
	# @a code:   The internal code used to refer to the new converter.
	# @a script: The script to evaluate for transfer and conversion.

	set imgC($code) $script
	return
    }


    method imgDef {code text converter ext basefile} {
	# @c Defines a new image. The given source is transfered into the
	# @c output directory, and converted along the way. If the picture is
	# @c never referenced it will be removed later.
	#
	# @a code:      Internal symbolic name of the new picture.
	# @a text:      Alternative text describing the contents of the
	# @a text:      picture.
	# @a converter: Handle of the converter to use.
	# @a ext:       Extension to give to the target file.
	# @a basefile:  Source of the picture.

	#set imgfile    pic[::pool::serial::new].$ext

	regsub -all {[/\\:]} [file rootname $basefile] {_} picfile
	set imgfile    pic_$picfile.$ext
	set absImgfile [GenerateImage $converter $basefile $imgfile]

	# use both source and generated image to obtain geometry information.

	set geometry [exec get_imgsize $basefile]

	if {[llength $geometry] == 0} {
	    set geometry [exec get_imgsize $absImgfile]
	}

	# reference is relative to -outputdir !!
	$fmt imgDef pic_$code $text $geometry $imgfile

	set imgS($code) $imgfile
	return
    }


    method imgRef {code} {
	# @c Return hyperlink to image <a code>.
	# @a code: Internal symbolic name of the requested image

	if {! [catch {set text [$fmt imgRef pic_$code]}]} {
	    unset imgS($code)
	    return [$fmt markWithClass xref-image $text]
	}

	return [$fmt MakeError desc \
		"Missing image $code" \
		[$fmt quote "missing image <${code}>"]]
    }


    method docfile {path} {
	# @c Marks file <a path> as required by the documentation.
	# @c It will be copied into the output directory later.
	# @a path: The path of the required file, relative to the
	# @a path: source directory of the distribution.

	if {! $inDocFile} {error "not in a '.doc'-file"}
	lappend moreFiles $path
	return
    }



    method add2Sidebar {aPage {text {}}} {
	# @c Adds the <a aPage> to the sidebar referencing
	# @c additional documentation pages.
	# @a aPage: Name of the page to add, generated earlier
	# @a aPage: by <m genericFormatter:newPage>
	# @a text: Text to use in the hyperlink. Defaults to the
	# @a text: basename of <a aPage>, without extension.

	lappend morePages $aPage

	if {[string length $text] == 0} {
	    set text [::pool::string::cap [file rootname [file tail $aPage]]]
	}

	set sidebarText($aPage) $text
	return
    }



    method clear {} {
	# @c Resets state information of scan to initial values,
	# @c to allow future reconfiguration and scanning.

	$log log debug cleaning up

	# Remove ourselves from index map, to avoid infinity
	catch {unset index(home)}

	foreach i [array names index] {
	    #    puts "clear index $i ($index($i))..."

	    $index($i) clear
	}

	set hasPackages      0
	set hasFiles         0
	set docFileList      ""
	set moreFiles        ""
	set morePages        ""

	set attrs            {}

	foreach key [array names attributeName] {
	    set attributeValue($key) ""
	}

	$fmt clear

	problems_clear
	catch {interp delete ${this}_cr}
	return
    }



    method ReportNumber {n singular plural} {
	# @c Report the number of found entities to the log.
	# @a n: The number of found items.
	# @a singular: The singular form of the found entities.
	# @a plural:   The plural form of the found entities.

	if {$n == 1} {
	    $log log info 1 $singular found
	} else {
	    $log log info $n $plural found
	}
	return
    }



    # --------------------------------------------------------------
    # Crossreference resolution, combined with context management.
    # The latter is required to allow short references to parts of
    # the class currently in output.

    # @v context: The stack of objects currently writing their documentation.

    var context {}

    # @v classContext: The class currently writing its documentation.

    var classContext ""

    # @v xrefPat: Contains all patterns used to detect crossreferences and the
    # @v xrefPat: code to replace any found instance of the pattern.

    var -array xrefPat



    method pushContext {object} {
	# @c Adds the specified <a object> to the top of the stack of objects
	# @c writing their documentation.
	#
	# @a object: The handle of the object now writing its documentation.

	::pool::list::unshift context $object
	return
    }


    method popContext {} {
	# @c Removes the topmost object from the stack of object writing their
	# @c documentation.

	::pool::list::shift context
    }


    method theContext {} {
	# @r the handle of the object currently writing its output. If there is
	# @r no such this one is given to the caller.

	if {[llength $context] == 0} {
	    return $this
	} else {
	    return [lindex $context 0]
	}
    }



    method CurrentClass {} {
	# @r the handle of the class currently writing its documentation.
	# @r Different from <m theContext> as the current object can be one of
	# @r its methods.

	set o  $classContext
	set  classContext {}
	return $o
    }




    method InitPatterns {} {
	# @c Initialize the regular expression pattern used to detect and
	# @c resolve embedded crossreferences.

	# @d Order is important here! Longer matching patterns must be applied
	# @d before shorter ones as they may consume the same input, but
	# @d with an improperly split into constituents. To achieve this the
	# @d internal pattern identifiers are sorted before processing them
	# @d (<m crResolve>), so we have just to ensure that longer patterns
	# @d get identifiers alphabetically sorted before the shorter patterns.

	set ws         "\[ \t\]\[ \t\]*"	;# whitespace
	set procletter "\[a-zA-Z0-9_:\]"
	set fileletter "\[a-zA-Z0-9_/.\]"
	set ident      "${procletter}${procletter}*"
	set filename   "${fileletter}${fileletter}*"
	set wsid       "${ws}(${ident})"
	set wsfile     "${ws}(${filename})"

	# -W- reorganize the internal method names to make usage easier, allow
	# -W- streamlined implementation

	# -- cross references to the big entities:
	# --   files, classes, procedures, procedure arguments, namespaces

	set xrefPat(pkg)	[list "<pkg${wsid}>" "\[Xri packages {\\1}\]"]

	set xrefPat(fil_l)	[list "<file${wsfile}>" "\[Xri files {\\1}\]"]
	set xrefPat(fil_s)	[list    "<f${wsfile}>" "\[Xri files {\\1}\]"]

	set xrefPat(cls_l)	[list "<class${wsid}>" "\[Xri classes {\\1}\]"]
	set xrefPat(cls_s)	[list     "<c${wsid}>" "\[Xri classes {\\1}\]"]

	set xrefPat(prc_l)	[list "<proc${wsid}>" "\[Xri procs {\\1}\]"]
	set xrefPat(prc_s)	[list    "<p${wsid}>" "\[Xri procs {\\1}\]"]

	set xrefPat(ns_l)	[list "<namespace${wsid}>" "\[Xri namespaces {\\1}\]"]
	set xrefPat(ns_s)	[list    "<n${wsid}>"      "\[Xri namespaces {\\1}\]"]

	set xrefPat(arg_l)	[list "<arg${wsid}>" "\[Xra {\\1}\]"]
	set xrefPat(arg_s)	[list   "<a${wsid}>" "\[Xra {\\1}\]"]

	# -- cross references to the parts of a class, the complete and long
	# -- forms (class, then part, separated by a colon (:)).
	# --   options, methods, variables.

	set xrefPat(opt_l)	[list "<option${wsid}:(${ident})>" "\[Xrc oref {\\1} {\\2}\]"]
	set xrefPat(opt_s)	[list      "<o${wsid}:(${ident})>" "\[Xrc oref {\\1} {\\2}\]"]
	set xrefPat(mth_l)	[list "<method${wsid}:(${ident})>" "\[Xrc mref {\\1} {\\2}\]"]
	set xrefPat(mth_s)	[list      "<m${wsid}:(${ident})>" "\[Xrc mref {\\1} {\\2}\]"]
	set xrefPat(var_l)	[list    "<var${wsid}:(${ident})>" "\[Xrc vref {\\1} {\\2}\]"]
	set xrefPat(var_s)	[list      "<v${wsid}:(${ident})>" "\[Xrc vref {\\1} {\\2}\]"]

	# -- cross references to the parts of a class, the short form, to
	# --  reference parts of the class the reference is in.
	# --   options, methods, variables.

	set xrefPat(opt_sl)	[list "<option${wsid}>" "\[Xrcs oref {\\1}\]"]
	set xrefPat(opt_ss)	[list      "<o${wsid}>" "\[Xrcs oref {\\1}\]"]
	set xrefPat(mth_sl)	[list "<method${wsid}>" "\[Xrcs mref {\\1}\]"]
	set xrefPat(mth_ss)	[list      "<m${wsid}>" "\[Xrcs mref {\\1}\]"]
	set xrefPat(var_sl)	[list    "<var${wsid}>" "\[Xrcs vref {\\1}\]"]
	set xrefPat(var_ss)	[list      "<v${wsid}>" "\[Xrcs vref {\\1}\]"]

	# ---------------
	# patterns to detect old syntax for crosss references

	set xrefPat(opt_l_old)	[list "<option${wsid}/(${ident})>" "\[XrOld option {\\1} {\\2}\]"]
	set xrefPat(opt_s_old)	[list      "<o${wsid}/(${ident})>" "\[XrOld option {\\1} {\\2}\]"]

	set xrefPat(mth_l_old)	[list "<method${wsid}/(${ident})>" "\[XrOld method {\\1} {\\2}\]"]
	set xrefPat(mth_s_old)	[list      "<m${wsid}/(${ident})>" "\[XrOld method {\\1} {\\2}\]"]

	# ---------------
	#  general cross references

	set xrefPat(xref_l)	[list "<xref${wsid}>" "\[xRef   {\\1}\]"]
	set xrefPat(xref_s)	[list    "<x${wsid}>" "\[xRef   {\\1}\]"]

	set xrefPat(dep_l)	[list "<dep${wsid}>" "\[depRef {\\1}\]"]
	set xrefPat(dep_s)	[list   "<d${wsid}>" "\[depRef {\\1}\]"]

	set xrefPat(img_l)	[list "<img${wsid}>" "\[imgRef {\\1}\]"]
	set xrefPat(img_s)	[list "<i${wsid}>"   "\[imgRef {\\1}\]"]

	# ---------------
	# -W- reorganize this (packages, external urls, required packages)


	set xrefPat(ext_l)	[list "<ext${wsid}>" "\[XrOld dependency {\\1}\]"]
	set xrefPat(ext_s)	[list   "<e${wsid}>" "\[XrOld dependency {\\1}\]"]

	set xrefPat(parbreak)   [list "&p" "\[Xpar\]"]
	return
    }


    method crResolve {text} {
	# @c Resolves crossreferences found in the <a text>.
	# @a text: The text to reformat.
	# @r The <a text>, but crossreferences resolved into hyperlinks.

	# i. find the cross-references, and replace them with tcl-commands

	#::puts stderr "    text = $text"

	foreach p [lsort [array names xrefPat]] {
	    set pattern [lindex $xrefPat($p) 0]
	    set subst   [lindex $xrefPat($p) 1]

	    regsub -all $pattern $text $subst text
	}

	#::puts stderr "cmd text = $text"

	# protect special characters. Must be done before the
	# substitution, but not earlier. Afterward it would protect
	# the just inserted formatting commands, before it would
	# protect the autodoc commands unreadable from the regsub's.

	set text [$fmt quote $text]

	# ii. now execute the commands embedded into the text (only these!)
	set text [${this}_cr eval [list subst \
		-novariables -nobackslashes $text]]

	return $text
    }


    method Xpar {} {
	# @c Resolves & p into paragraph breaks. Used by <m crResolve>.
	$fmt getString {$fmt parbreak}
    }


    method Xri {idx name} {
	# @c Resolve crossreference based on one of the main indices.
	# @a idx: The name of the index to question.
	# @a name: The name of the referenced entity.
	# @r a hyperlink to the definition of the entity.

	return [$fmt markWithClass xref-$idx [$index($idx) ref $name]]
    }


    method Xrc {partref class name} {
	# @c Resolve crossreference to a part of a class.
	# @a partref: The method to call at the class index.
	# @a class:   The name of the class to search the part in.
	# @a name:    The name of the referenced part.
	# @r a hyperlink to the definition of the entity.

	return [$fmt markWithClass xref-$partref [$index(classes) $partref $class $name]]
    }


    method Xrcs {partref name} {
	# @c Resolve a short crossreference to a part of a class.
	# @a partref: The method to call at the class index.
	# @a name:    The name of the referenced part.
	# @r a hyperlink to the definition of the entity.

	# scan context stack for enclosing class. report an error if there is
	# none.

	foreach o $context {
	    if {[string compare [$o oinfo class] classDescription] == 0} {
		# expand to complete reference
		# -W- supress classinformation in text, but not the url.

		set classContext $o
		return [Xrc $partref [$o name] $name]
	    }
	}

	# no enclosing class, report a crossreference error to current context

	return [$fmt crError $name "Illegal shortcut to '$what' ($name)"]
    }


    method Xra {name} {
	# @c Resolve crossreference to a procedure argument.
	# @a name: The name of the referenced argument.
	# @r the <a name>, but specially formatted.

	# The context must be a procedure, report error if it is not

	set ctx [theContext]

	if {[string compare [$ctx oinfo class] procDescription] == 0} {
	    if {[$ctx hasArgument $name]} {
		return [$fmt markWithClass argument [$fmt strong $name]]
	    } else {
		return [$fmt crError $name "Unknown argument '$name'"]
	    }
	} else {
	    return [$fmt crError $name \
	    "Argument '$name', reference outside of procedure description ([$ctx oinfo class])"]
	}
    }


    method XrOld {what args} {
	# @c Crossreference using old syntax, just report as problem.
	# @a what: Type of reference
	# @a args: The name of the referenced entity.

	# report old syntax as errors.
	return [$fmt crError $args \
	"Old syntax used for reference to [$fmt markError $what] $args"]
    }



    method NewPage {file title {firstheading {}}} {
	# @c Calls are forwarded to <m genericFormatter:newPage>.
	# @c Additionally the standard jumpbar is generated too.
	# @a file:         See <m genericFormatter:newPage>.
	# @a title:        See <m genericFormatter:newPage>.
	# @a firstheading: See <m genericFormatter:newPage>.

	$fmt newPage $file $title $firstheading
	writeJumpbar
	return
    }


    method log {level text} {
	# @c Accessor for the log maintained by this object.
	# @a level: The importance level of the message.
	# @a text:  Text to log.

	$log log $level $text
	return
    }



    method nsContaining {name} {
	# @c Returns the namespace object describing the namespace
	# @c containing the object with the specified <a name>.
	# @c Will generate the necessary namespace object if not
	# @c already existing.
	#
	# @a name: The name of the object whose containing namespace
	# @a name: the caller is looking for.

	set parentName [string trimright [join [lrange [split $name :] 0 end-1] :] :]

	if {$parentName == {}} {
	    set parentName ::
	}

	if {[catch {set nsId [$index(namespaces) itemByName $parentName]}]} {
	    # Parent not found, so construct its object.

	    set nsId Namespace[::pool::serial::new]

	    namespaceDescription     $nsId        \
		    -name       $parentName       \
		    -dist       $this             \
		    -formatter  $fmt              \
		    -log        $log

	    $index(namespaces) addItem $nsId
	}

	return $nsId
    }
}


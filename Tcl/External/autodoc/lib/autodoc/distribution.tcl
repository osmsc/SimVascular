# -*- tcl -*-
# Automatically generated from file 'distribution.cls'.
# Date: Thu Sep 07 18:20:48 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> distribution <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Pool_Base	
	package require Pool_Net

# Namespace describing the class
namespace eval ::pool::oo::class::distribution {
    variable  _superclasses    {formatterInterface problems}
    variable  _scChainForward  distribution
    variable  _scChainBackward distribution
    variable  _classVariables  {}
    variable  _methods         {Author CleanImages CompleteDatabase CompleteDependencies CopyMoreFiles CurrentClass Excluded GatherStatistics GenerateImage HandleDocFiles HandleFiles HandlePackages HandlePredocFiles InitPatterns Maintainer NewPage PrepareCRefIp PrepareDocIp ReadDescription ReportNumber SearchDocFiles SearchForFiles SearchPackages SidebarLink StatText TrackAd TrackFormatter TrackOut TrackReply Write WriteDescription WriteHomepage WriteSidebar WriteStatistics Xpar XrOld Xra Xrc Xrcs Xri add2Sidebar classRef clear constructor crResolve depDef depRef destructor docfile fileRef getIndex imgConverter imgDef imgRef log methodRef nsContaining nsRef optionRef page pkgRef popContext procRef pushContext scan theContext varRef writeJumpbar xRef xrefDef}

    variable  _variables
    array set _variables  {imgS {distribution {isArray 1 initialValue {}}} imgC {distribution {isArray 1 initialValue {}}} index {distribution {isArray 1 initialValue {}}} jumpbar {distribution {isArray 1 initialValue {}}} attributeValue {distribution {isArray 1 initialValue {}}} xrefPat {distribution {isArray 1 initialValue {}}} docFileList {distribution {isArray 0 initialValue {}}} morePages {distribution {isArray 0 initialValue {}}} inDocFile {distribution {isArray 0 initialValue 0}} moreFiles {distribution {isArray 0 initialValue {}}} sidebarText {distribution {isArray 1 initialValue {}}} hasFiles {distribution {isArray 0 initialValue 0}} log {distribution {isArray 0 initialValue {}}} classContext {distribution {isArray 0 initialValue {}}} hasPackages {distribution {isArray 0 initialValue 0}} context {distribution {isArray 0 initialValue {}}} attributeName {distribution {isArray 1 initialValue {
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
    }}} attrs {distribution {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {up-link {distribution {-default {} -type ::pool::getopt::notype -action {} -class Up-link}} ptable {distribution {-default 0 -type ::pool::getopt::boolean -action {} -class Ptable}} psort {distribution {-default 1 -type ::pool::getopt::boolean -action {} -class Psort}} outputdir {distribution {-default {} -type ::pool::getopt::notype -action TrackOut -class Outputdir}} css {distribution {-default 1 -type ::pool::getopt::notype -action {} -class Css}} tables {distribution {-default 0 -type ::pool::getopt::boolean -action {} -class Tables}} fsort-fullpath {distribution {-default 1 -type ::pool::getopt::notype -action {} -class Fsort-fullpath}} up-imglink {distribution {-default 0 -type ::pool::getopt::boolean -action {} -class Up-imglink}} up-image {distribution {-default {} -type ::pool::getopt::notype -action {} -class Up-image}} adlocation {distribution {-default http://www.oche.de/~akupries/soft/autodoc/index.htm -type ::pool::getopt::notype -action TrackAd -class Adlocation}} no-problems {distribution {-default 0 -type ::pool::getopt::notype -action {} -class No-problems}} itk-opt-alias {distribution {-default {} -type ::pool::getopt::notype -action {} -class Itk-opt-alias}} proc-prefix {distribution {-default {} -type ::pool::getopt::notype -action {} -class Proc-prefix}} replyaddr {distribution {-default {} -type ::pool::getopt::notype -action TrackReply -class Replyaddr}} namespace-prefix {distribution {-default {} -type ::pool::getopt::notype -action {} -class Namespace-prefix}} clisttype {distribution {-default par -type ::pool::getopt::notype -action {} -class Clisttype}} class-prefix {distribution {-default {} -type ::pool::getopt::notype -action {} -class Class-prefix}} exclude {distribution {-default {} -type ::pool::getopt::notype -action {} -class Exclude}} file-prefix {distribution {-default {} -type ::pool::getopt::notype -action {} -class File-prefix}} up-title {distribution {-default {} -type ::pool::getopt::notype -action {} -class Up-title}} srcdir {distribution {-default {} -type ::pool::getopt::notype -action {} -class Srcdir}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {SidebarLink . TrackFormatter . StatText . CurrentClass . Xri . HandlePredocFiles . WriteSidebar . fileRef . crResolve . constructor . CompleteDatabase . WriteStatistics . destructor . SearchForFiles . TrackAd . Write . popContext . add2Sidebar . HandleDocFiles . docfile . nsRef . GenerateImage . procRef . imgRef . Author . writeJumpbar . SearchPackages . TrackOut . optionRef . GatherStatistics . WriteDescription . Xrcs . CleanImages . xRef . depRef . Excluded . clear . PrepareCRefIp . CopyMoreFiles . Xpar . imgDef . pushContext . ReportNumber . imgConverter . page . scan . PrepareDocIp . ReadDescription . getIndex . Maintainer . XrOld . nsContaining . xrefDef . varRef . HandleFiles . SearchDocFiles . pkgRef . depDef . WriteHomepage . HandlePackages . classRef . theContext . NewPage . CompleteDependencies . TrackReply . log . Xra . InitPatterns . Xrc . methodRef .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::distribution::Author {} {
    ::pool::oo::support::SetupVars distribution
    # @c Determines author of distribution.

	if {[::info exists attributeValue(author)]} {
	    if {[string length $attributeValue(author)] != 0} {
		return $attributeValue(author)
	    }
	}

	return [::pool::misc::currentUser]
}



proc ::pool::oo::class::distribution::CleanImages {} {
    ::pool::oo::support::SetupVars distribution
    # @c Removes all defined, yet unreferenced pictures from the output
	# @c directory.

	foreach iCode [array names imgS] {
	    if {[::info exists $imgS($iCode)]} {
		file delete $imgS($iCode)
	    }
	}

	return
}



proc ::pool::oo::class::distribution::CompleteDatabase {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::CompleteDependencies {internalPkgs} {
    ::pool::oo::support::SetupVars distribution
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
	    eval lappend attributeValue(dependencies)  [$p dependencies $internalPkgs]
	}

	set attributeValue(dependencies)  [::pool::list::uniq [lsort $attributeValue(dependencies)]]

	# check dependencies for missing locations

	#::puts "deps = <$attributeValue(dependencies)>"

	foreach d $attributeValue(dependencies) {
	    if {[string compare $d [depRef $d]] == 0} {
		$log log warning  External reference '$d': no web location defined
	    }
	}

	return
}



proc ::pool::oo::class::distribution::CopyMoreFiles {} {
    ::pool::oo::support::SetupVars distribution
    # @c Files marked as required (by '.doc'-files) are copied
	# @c into the html target directory.

	if {[llength $moreFiles] == 0} {return}

	foreach f $moreFiles {
	    file copy -force $f [file join $opt(-outputdir) [file tail $f]]
	}

	return
}



proc ::pool::oo::class::distribution::CurrentClass {} {
    ::pool::oo::support::SetupVars distribution
    # @r the handle of the class currently writing its documentation.
	# @r Different from <m theContext> as the current object can be one of
	# @r its methods.

	set o  $classContext
	set  classContext {}
	return $o
}



proc ::pool::oo::class::distribution::Excluded {filename} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::GatherStatistics {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::GenerateImage {converter in out} {
    ::pool::oo::support::SetupVars distribution
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

	    $fmt MakeError desc  "<Image: $in>" "image converter $converter missing"
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

		$fmt MakeError desc  "<Image: $in>" "$converter problem: $msg"
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



proc ::pool::oo::class::distribution::HandleDocFiles {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::HandleFiles {} {
    ::pool::oo::support::SetupVars distribution
    # @c Tell the found files to scan themselves.
	# @n Is done only if no packages were found.

	foreach f [$index(files) items] {
	    $log log debug scanning file [$f name]...
	    $f scan
	}

	return
}



proc ::pool::oo::class::distribution::HandlePackages {} {
    ::pool::oo::support::SetupVars distribution
    # @c Tell the found packages to scan themselves.

	foreach p [$index(packages) items] {
	    $p scan
	}

	return
}



proc ::pool::oo::class::distribution::HandlePredocFiles {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::InitPatterns {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::Maintainer {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::NewPage {file title {firstheading {}}} {
    ::pool::oo::support::SetupVars distribution
    # @c Calls are forwarded to <m genericFormatter:newPage>.
	# @c Additionally the standard jumpbar is generated too.
	# @a file:         See <m genericFormatter:newPage>.
	# @a title:        See <m genericFormatter:newPage>.
	# @a firstheading: See <m genericFormatter:newPage>.

	$fmt newPage $file $title $firstheading
	writeJumpbar
	return
}



proc ::pool::oo::class::distribution::PrepareCRefIp {ipName} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::PrepareDocIp {ipName} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::ReadDescription {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::ReportNumber {n singular plural} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::SearchDocFiles {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::SearchForFiles {} {
    ::pool::oo::support::SetupVars distribution
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

		fileDescription $fileId       -name   $fileName     -dist   $this         -formatter $fmt  -log    $log          -psort  $opt(-psort)  -ptable $opt(-ptable)

		lappend files         $fileId
		$index(files) addItem $fileId
	    }
	}

	ReportNumber [llength $files] file files
	return
}



proc ::pool::oo::class::distribution::SearchPackages {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::SidebarLink {p} {
    ::pool::oo::support::SetupVars distribution
    # @r a hyperlink pointing to the specified additional documentation
	# @r page <a p>.
	# @a p: The code of the page whose link shall be retrieved.

	return [$fmt link $sidebarText($p) $p]
}



proc ::pool::oo::class::distribution::StatText {statvar idx} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::TrackAd {o oldValue} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::TrackFormatter {o oldValue} {
    ::pool::oo::support::SetupVars distribution
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

	$fmt configure  -dist       $this              -outputdir  $opt(-outputdir)   -replyaddr  $opt(-replyaddr)   -adlocation $opt(-adlocation)  -css        $opt(-css)

	foreach i [array names index] {
	    $index($i) configure -formatter $fmt
	}
	return
}



proc ::pool::oo::class::distribution::TrackOut {o oldValue} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::TrackReply {o oldValue} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::Write {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::WriteDescription {} {
    ::pool::oo::support::SetupVars distribution
    # @c Writes out the distribution description.

	# list description attributes
	if {[llength $attrs] != 0} {
	    $fmt definitionList {
		$fmt mailToDefterm "Written by"  attributeValue(author)  attributeValue(author_address)

		$fmt mailToDefterm "Maintained by"  attributeValue(maintainer)  attributeValue(maintainer_address)

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



proc ::pool::oo::class::distribution::WriteHomepage {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::WriteSidebar {inTable} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::WriteStatistics {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::Xpar {} {
    ::pool::oo::support::SetupVars distribution
    # @c Resolves & p into paragraph breaks. Used by <m crResolve>.
	$fmt getString {$fmt parbreak}
}



proc ::pool::oo::class::distribution::XrOld {what args} {
    ::pool::oo::support::SetupVars distribution
    # @c Crossreference using old syntax, just report as problem.
	# @a what: Type of reference
	# @a args: The name of the referenced entity.

	# report old syntax as errors.
	return [$fmt crError $args  "Old syntax used for reference to [$fmt markError $what] $args"]
}



proc ::pool::oo::class::distribution::Xra {name} {
    ::pool::oo::support::SetupVars distribution
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
	    return [$fmt crError $name  "Argument '$name', reference outside of procedure description ([$ctx oinfo class])"]
	}
}



proc ::pool::oo::class::distribution::Xrc {partref class name} {
    ::pool::oo::support::SetupVars distribution
    # @c Resolve crossreference to a part of a class.
	# @a partref: The method to call at the class index.
	# @a class:   The name of the class to search the part in.
	# @a name:    The name of the referenced part.
	# @r a hyperlink to the definition of the entity.

	return [$fmt markWithClass xref-$partref [$index(classes) $partref $class $name]]
}



proc ::pool::oo::class::distribution::Xrcs {partref name} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::Xri {idx name} {
    ::pool::oo::support::SetupVars distribution
    # @c Resolve crossreference based on one of the main indices.
	# @a idx: The name of the index to question.
	# @a name: The name of the referenced entity.
	# @r a hyperlink to the definition of the entity.

	return [$fmt markWithClass xref-$idx [$index($idx) ref $name]]
}



proc ::pool::oo::class::distribution::add2Sidebar {aPage {text {}}} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::classRef {name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m classIndex:ref>
	# @a name: See <m classIndex:ref>

	return [$index(classes) ref $name]
}



proc ::pool::oo::class::distribution::clear {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::constructor {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::crResolve {text} {
    ::pool::oo::support::SetupVars distribution
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
	set text [${this}_cr eval [list subst  -novariables -nobackslashes $text]]

	return $text
}



proc ::pool::oo::class::distribution::depDef {name url} {
    ::pool::oo::support::SetupVars distribution
    # @c Defines additional information for a 'required' package,
	# @c to allow conversion of usage in descriptions into hyperlinks.
	# @a name: The name of the package
	# @a url:  Page to refer to for information about the package.

	$fmt pushClass xref-dep
	$fmt linkDef dep_$name $name $url
	$fmt popClass
	return
}



proc ::pool::oo::class::distribution::depRef {name} {
    ::pool::oo::support::SetupVars distribution
    # @c Converts the <a name> of an external package into a hyperlink.
	# @c The argument is returned unchanged, if that is not possible.
	# @a name: Name of package to link to.
	# @r a string containing a hyperlink to <a name>, if possible.

	set        text $name
	catch {set text [$fmt linkRef dep_$name]}
	return    $text
}



proc ::pool::oo::class::distribution::destructor {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::docfile {path} {
    ::pool::oo::support::SetupVars distribution
    # @c Marks file <a path> as required by the documentation.
	# @c It will be copied into the output directory later.
	# @a path: The path of the required file, relative to the
	# @a path: source directory of the distribution.

	if {! $inDocFile} {error "not in a '.doc'-file"}
	lappend moreFiles $path
	return
}



proc ::pool::oo::class::distribution::fileRef {name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m fileIndex:ref>
	# @a name: See <m fileIndex:ref>

	return [$index(files) ref $name]
}



proc ::pool::oo::class::distribution::getIndex {idxName} {
    ::pool::oo::support::SetupVars distribution
    # @r the object managing the specified index.
	# @a idxName: The internal name of the requested index.

	return $index($idxName)
}



proc ::pool::oo::class::distribution::imgConverter {code script} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::imgDef {code text converter ext basefile} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::imgRef {code} {
    ::pool::oo::support::SetupVars distribution
    # @c Return hyperlink to image <a code>.
	# @a code: Internal symbolic name of the requested image

	if {! [catch {set text [$fmt imgRef pic_$code]}]} {
	    unset imgS($code)
	    return [$fmt markWithClass xref-image $text]
	}

	return [$fmt MakeError desc  "Missing image $code"  [$fmt quote "missing image <${code}>"]]
}



proc ::pool::oo::class::distribution::log {level text} {
    ::pool::oo::support::SetupVars distribution
    # @c Accessor for the log maintained by this object.
	# @a level: The importance level of the message.
	# @a text:  Text to log.

	$log log $level $text
	return
}



proc ::pool::oo::class::distribution::methodRef {class name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m classIndex:mref>
	# @a class: See <m classIndex:mref>
	# @a name: See <m classIndex:mref>

	return [$index(classes) mref $class $name]
}



proc ::pool::oo::class::distribution::nsContaining {name} {
    ::pool::oo::support::SetupVars distribution
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

	    namespaceDescription     $nsId         -name       $parentName        -dist       $this              -formatter  $fmt               -log        $log

	    $index(namespaces) addItem $nsId
	}

	return $nsId
}



proc ::pool::oo::class::distribution::nsRef {name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m namespaceIndex:ref>
	# @a name: See <m namespaceIndex:ref>

	return [$index(namespaces) ref $name]
}



proc ::pool::oo::class::distribution::optionRef {class name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m classIndex:oref>
	# @a class: See <m classIndex:oref>
	# @a name: See <m classIndex:oref>

	return [$index(classes) oref $class $name]
}



proc ::pool::oo::class::distribution::page {} {
    ::pool::oo::support::SetupVars distribution
    # @r The filename of the distribution page.
	# @n The codes assumes that no more than one such page exists.
	return index.htm
}



proc ::pool::oo::class::distribution::pkgRef {name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m packageIndex:ref>
	# @a name: See <m packageIndex:ref>

	return [$index(packages) ref $name]
}



proc ::pool::oo::class::distribution::popContext {} {
    ::pool::oo::support::SetupVars distribution
    # @c Removes the topmost object from the stack of object writing their
	# @c documentation.

	::pool::list::shift context
}



proc ::pool::oo::class::distribution::procRef {name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m procIndex:ref>
	# @a name: See <m procIndex:ref>

	return [$index(procs) ref $name]
}



proc ::pool::oo::class::distribution::pushContext {object} {
    ::pool::oo::support::SetupVars distribution
    # @c Adds the specified <a object> to the top of the stack of objects
	# @c writing their documentation.
	#
	# @a object: The handle of the object now writing its documentation.

	::pool::list::unshift context $object
	return
}



proc ::pool::oo::class::distribution::scan {} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::theContext {} {
    ::pool::oo::support::SetupVars distribution
    # @r the handle of the object currently writing its output. If there is
	# @r no such this one is given to the caller.

	if {[llength $context] == 0} {
	    return $this
	} else {
	    return [lindex $context 0]
	}
}



proc ::pool::oo::class::distribution::varRef {class name} {
    ::pool::oo::support::SetupVars distribution
    # @c See <m classIndex:vref>
	# @a class: See <m classIndex:vref>
	# @a name: See <m classIndex:vref>

	return [$index(classes) vref $class $name]
}



proc ::pool::oo::class::distribution::writeJumpbar {{caller {}}} {
    ::pool::oo::support::SetupVars distribution
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



proc ::pool::oo::class::distribution::xRef {code} {
    ::pool::oo::support::SetupVars distribution
    # @c Return hyperlink to external page <a code>.
	# @a code: Internal symbolic name of external reference.
	if {! [catch {set text [$fmt linkRef xr_$code]}]} {
	    return $text
	}

	return [$fmt MakeError desc  "no link for $code"  [$fmt quote "no link for <${code}>"]]
}



proc ::pool::oo::class::distribution::xrefDef {code text url} {
    ::pool::oo::support::SetupVars distribution
    # @c Defines an external reference.
	# @a code: The internal symbolic name to reach this hyperlink
	# @a text: Text to use in the link.
	# @a url:  Page refered by the link.

	$fmt pushClass xref-xref
	$fmt linkDef xr_$code $text $url
	$fmt popClass
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::distribution::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::formatterInterface::loadClass
::pool::oo::class::problems::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences distribution

# Create object instantiation procedure
interp alias {} distribution {} ::pool::oo::support::New distribution

# -------------------------------


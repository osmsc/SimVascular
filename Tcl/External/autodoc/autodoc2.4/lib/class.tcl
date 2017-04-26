# -*- tcl -*-
# Automatically generated from file 'class.cls'.
# Date: Thu Sep 07 18:20:47 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> classDescription <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::classDescription {
    variable  _superclasses    {azIndexEntry problemsAndIndex}
    variable  _scChainForward  classDescription
    variable  _scChainBackward classDescription
    variable  _classVariables  {}
    variable  _methods         {ComponentDescriptionList ComponentList DependencyList GetInheritedEntities GetPartRecord MethodList OptionDescriptionList OptionList PostProcessInformation ScanMethods SetupAnchors SuperclassList VarDescriptionList VarList WriteHeading WriteMethods author authorSet clear completeKwIndex constructor dependencies firstLetter formatComponentList formatMethodList formatVarList getMRef getORef getOvDescription getPage getVRef hasMRef hasVariable itk_component keywords mref oref privateComponents privateMembers privateMethods procByName protectedComponents protectedMembers protectedMethods publicComponents publicMembers publicMethods refError scan sortMethods superclasses variableHasConfig vref write writeProblemPage}

    variable  _variables
    array set _variables  {keywords {classDescription {isArray 0 initialValue {}}} visibility {classDescription {isArray 1 initialValue {
	p,public {} p,protected {} p,private {}
	v,public {} v,protected {} v,private {}
	c,public {} c,protected {} c,private {}
    }}} variables {classDescription {isArray 0 initialValue {}}} ivariables {classDescription {isArray 0 initialValue {}}} anchor {classDescription {isArray 1 initialValue {}}} comment {classDescription {isArray 0 initialValue {}}} example {classDescription {isArray 0 initialValue {}}} seeAlso {classDescription {isArray 0 initialValue {}}} options {classDescription {isArray 0 initialValue {}}} ioptions {classDescription {isArray 0 initialValue {}}} superclasses {classDescription {isArray 0 initialValue {}}} bug {classDescription {isArray 0 initialValue {}}} note {classDescription {isArray 0 initialValue {}}} listtype {classDescription {isArray 0 initialValue {}}} components {classDescription {isArray 0 initialValue {}}} ovComment {classDescription {isArray 1 initialValue {}}} authorAddress {classDescription {isArray 0 initialValue {}}} danger {classDescription {isArray 0 initialValue {}}} scObj {classDescription {isArray 0 initialValue @@}} vinfo {classDescription {isArray 1 initialValue {}}} mref {classDescription {isArray 1 initialValue {}}} vref {classDescription {isArray 1 initialValue {}}} partInfo {classDescription {isArray 1 initialValue {}}} oref {classDescription {isArray 1 initialValue {}}} authorName {classDescription {isArray 0 initialValue {}}} methods {classDescription {isArray 0 initialValue {}}} imethods {classDescription {isArray 0 initialValue {}}} version {classDescription {isArray 0 initialValue {}}} date {classDescription {isArray 0 initialValue {}}} dependencies {classDescription {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {ptable {classDescription {-default {} -type ::pool::getopt::notype -action {} -class Ptable}} psort {classDescription {-default 1 -type ::pool::getopt::notype -action {} -class Psort}} file {classDescription {-default {} -type ::pool::getopt::notype -action {} -class File}} log {classDescription {-default {} -type ::pool::getopt::notype -action {} -class Log}} inline {classDescription {-default 0 -type ::pool::getopt::notype -action {} -class Inline}} spec {classDescription {-default {} -type ::pool::getopt::notype -action {} -class Spec}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {procByName . keywords . protectedComponents . GetInheritedEntities . privateComponents . getMRef . constructor . protectedMethods . privateMembers . variableHasConfig . itk_component . vref . WriteMethods . getOvDescription . publicMembers . VarList . superclasses . formatMethodList . GetPartRecord . SetupAnchors . OptionDescriptionList . completeKwIndex . oref . protectedMembers . getPage . ComponentList . clear . getVRef . scan . MethodList . formatComponentList . SuperclassList . mref . ComponentDescriptionList . WriteHeading . write . sortMethods . publicComponents . formatVarList . hasMRef . dependencies . privateMethods . firstLetter . VarDescriptionList . writeProblemPage . hasVariable . PostProcessInformation . author . DependencyList . getORef . ScanMethods . publicMethods . OptionList . refError . authorSet .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::classDescription::ComponentDescriptionList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a definition list containing the
	# @c descriptions of all defined components.

	if {[llength $components] != 0} {
	    $fmt hrule
	    $fmt setAnchor Components
	    $fmt pushClass components
	    $fmt section   [$fmt link Components "#ComponentsUp"]
	    $fmt blockClass {
		$fmt definitionList {
		    foreach citem $components {
			foreach {wtype c visi doc} $citem {break}

			$fmt setAnchor $anchor(c,$c)
			set cname $c
			set c [$fmt markWithClass component-name $c]
			if {[string compare $visi public]} {
			    $fmt pushClass visibility
			    set c "[$fmt markVisibility $visi] $c"
			    $fmt popClass
			}
			set c "$c [$fmt markWithClass component-type "($wtype)"]"
			$fmt defterm $c [getOvDescription c component-description $cname]
		    }
		}
	    }
	    $fmt popClass
	}

	return
}



proc ::pool::oo::class::classDescription::ComponentList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a string containing references to all
	# @c component descriptions.

	set pubs [publicComponents]
	set prot [protectedComponents]
	set priv [privateComponents]

	return [$fmt getString {
	    $fmt unset_termclasses
	    $fmt definitionList {
		if {$pubs != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility public]
		    $fmt popClass
		    $fmt defterm $title [formatComponentList public]
		}
		if {$prot != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility protected]
		    $fmt popClass
		    $fmt defterm $title [formatComponentList protected]
		}
		if {$priv != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility private]
		    $fmt popClass
		    $fmt defterm $title [formatComponentList private]
		}
	    }
	}] ; # {}
}



proc ::pool::oo::class::classDescription::DependencyList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a string containing references to the
	# @c packages required by the class.
	#
	# @r A string containing a comma separated list of package names, each
	# @r a hyperlink to a location describing the it.

	set text ""

	switch -exact -- $listtype {
	    comma {
		foreach d $dependencies {
		    append text "[$dist depRef $d], "
		}
		set text [string trimright $text ", "]
	    }
	    par {
		set text [list]
		foreach d $dependencies {
		    lappend text [$dist depRef $d]
		}
		set text [join $text [$fmt getString {$fmt parbreak}]]
	    }
	    default {
		error "Illegal listtype $listtype"
	    }
	}
	return $text
}



proc ::pool::oo::class::classDescription::GetInheritedEntities {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Used during the writing of the class description to obtain the
	# @c information about all inherited variables, options and methods.
}



proc ::pool::oo::class::classDescription::GetPartRecord {code name} {
    ::pool::oo::support::SetupVars classDescription
    # @r class and method object of the method <a name>, or an empty list.
	# @a code: Internal type code of the part. These are [strong m]ethod,
	# @a code: [strong o]ption and [strong v]ariable.
	# @a name: The name of the method to search for.

	if {![::info exists partInfo($code,$name)]} {
	    foreach sc $superclasses {
		# Skip superclasses not defined by this package.
		if {[catch {set sco [$opt(-index) itemByName $sc]}]} {
		    continue
		}

		set record [$sco GetPartRecord $code $name]

		if {[llength $record] != 0} {
		    set partInfo($code,$name) $record
		    return $record
		}
	    }

	    set partInfo($code,$name) {}
	    return {}
	} else {
	    return $partInfo($code,$name)
	}
}



proc ::pool::oo::class::classDescription::MethodList {} {
    ::pool::oo::support::SetupVars classDescription
    # @r a formatted string of short references to the methods
	# @r defined in the class.
	# @n This method assumes that it is called only if there are
	# @n methods defined. This assumption allowed simplification
	# @n of the internal logic.

	set pubs [sortMethods [publicMethods]]
	set prot [sortMethods [protectedMethods]]
	set priv [sortMethods [privateMethods]]

	return [$fmt getString {
	    $fmt unset_termclasses
	    $fmt definitionList {
		if {$pubs != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility public]
		    $fmt popClass
		    $fmt defterm $title [formatMethodList $pubs]
		}
		if {$prot != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility protected]
		    $fmt popClass
		    $fmt defterm $title [formatMethodList $prot]
		}
		if {$priv != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility private]
		    $fmt popClass
		    $fmt defterm $title [formatMethodList $priv]
		}
	    }
	}] ; # {}
}



proc ::pool::oo::class::classDescription::OptionDescriptionList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a definition list containing the
	# @c descriptions of all defined options.

	if {[llength $options] != 0} {
	    $fmt hrule
	    $fmt setAnchor Options
	    $fmt pushClass options
	    $fmt section   [$fmt link Options "#OptionsUp"]

	    $fmt blockClass {
		$fmt definitionList {
		    foreach oitem $options {
			foreach {cfg o init} $oitem {break}

			set vis ""
			if {$cfg || ([info exists oinfo($o)] && $oinfo($o))} {
			    # Option has config body, tell the user.
			    $fmt pushClass configbody
			    set vis " [$fmt markVisibility (configbody)]"
			    $fmt popClass
			}

			$fmt setAnchor $anchor(o,$o)

			set desc [getOvDescription o option-description $o]
			if {$init != {}} {
			    append desc [$fmt getString {$fmt parbreak}]
			    $fmt pushClass option-default
			    append desc [$fmt markVisibility "default value:"]
			    $fmt popClass
			    append desc " [$fmt markWithClass option-default-value $init]"
			}

			$fmt defterm "[$fmt markWithClass option-name -$o]$vis" $desc
		    }
		}
	    }
	    $fmt popClass
	}

	return
}



proc ::pool::oo::class::classDescription::OptionList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a string containing references to the
	# @c option descriptions.
	#
	# @r A string containing a comma separated list of option names, each
	# @r a hyperlink to the associated description.

	set text ""

	switch -exact -- $listtype {
	    comma {
		foreach oitem $options {
		    foreach {cfg o init} $oitem {break}
		    append text "[$fmt link $o "#$anchor(o,$o)"], "
		}
		set text [string trimright $text ", "]
	    }
	    par {
		set text [list]
		foreach oitem $options {
		    foreach {cfg o init} $oitem {break}
		    lappend text [$fmt link $o "#$anchor(o,$o)"]
		}
		set text [join $text [$fmt getString {$fmt parbreak}]]
	    }
	    default {
		error "Illegal listtype $listtype"
	    }
	}
	return $text
}



proc ::pool::oo::class::classDescription::PostProcessInformation {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Called to streamline the extracted embedded documentation.
	# @c This mainly consists of removing superfluous whitespace.
	# @c Additionally converts a comma separated list of index
	# @c phrases into a real tcl list.

	foreach i {date version} {
	    regsub -all "\n" [set $i] {\&p} $i
	}

	foreach i {comment danger note seeAlso bug} {
	    set text [::pool::string::removeWhitespace [set $i]]
	    set $i [string trim [::pool::string::oneLine $text]]
	}

	set keywords [::pool::string::removeWhitespace $keywords]
	set keywords [split [string trim $keywords ", \t"] ,]
	while {[::pool::list::delete keywords {}]} {}
	return
}



proc ::pool::oo::class::classDescription::ScanMethods {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method. Called to scan the definitions of all methods
	# @c of this class.

	foreach p $methods {
	    $p scan
	}
	return
}



proc ::pool::oo::class::classDescription::SetupAnchors {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method. Initializes the anchor array for all options
	# @c and variables.

	foreach oitem $options {
	    foreach {cfg o init} $oitem {break}

	    regsub -all {#}  $o {_} ox
	    set anchor(o,$o) o$ox
	    set partInfo(o,$o) [list $this "[page]#o$ox"]
	}

	foreach vitem $variables {
	    foreach {usage visi cfg v init} $vitem {break}

	    regsub -all {#}  $v {_} vx
	    set anchor(v,$v) v$vx
	    set partInfo(v,$v) [list $this "[page]#v$vx"]

	    lappend visibility(v,$visi) $partInfo(v,$v)
	}

	foreach citem $components {
	    foreach {wtype c visi doc} $citem {break}

	    regsub -all {#}  $c {_} cx
	    set anchor(c,$c) c$cx
	    set partInfo(c,$c) [list $this "[page]#c$cx"]
	    set ovComment(c,$c) $doc

	    lappend visibility(c,$visi) $partInfo(c,$c)
	}

	return
}



proc ::pool::oo::class::classDescription::SuperclassList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a string containing references to the
	# @c superclass descriptions.
	#
	# @r A string containing a comma separated list of superclass names,
	# @r each a hyperlink to the associated description.

	set text ""

	switch -exact -- $listtype {
	    comma {
		set text [list]
		foreach c $superclasses {
		    lappend text [$opt(-index) ref $c]
		}
		set text [join $text ", "]
	    }
	    par {
		set text [list]
		foreach c $superclasses {
		    lappend text [$opt(-index) ref $c]
		}
		set text [join $text [$fmt getString {$fmt parbreak}]]
	    }
	    default {
		error "Illegal listtype $listtype"
	    }
	}
	return $text
}



proc ::pool::oo::class::classDescription::VarDescriptionList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a definition list containing the
	# @c descriptions of all defined variables.

	if {[llength $variables] != 0} {
	    $fmt hrule
	    $fmt setAnchor Members
	    $fmt pushClass members
	    $fmt section   [$fmt link Membervariables "#MembersUp"]

	    $fmt blockClass {
		$fmt definitionList {
		    foreach vitem $variables {
			foreach {usage visi cfg v init} $vitem {break}

			$fmt setAnchor $anchor(v,$v)
			set vname $v

			set v [$fmt markWithClass variable-name $v]

			if {0 != [string compare $usage member]} {
			    $fmt pushClass common
			    set v "[$fmt markVisibility common] $v"
			    $fmt popClass
			}
			if {0 != [string compare $visi public]} {
			    $fmt pushClass visibility
			    set v "[$fmt markVisibility $visi] $v"
			    $fmt popClass
			}
			if {$cfg || ([info exists vinfo($v)] && $vinfo($v))} {
			    # Variable has config body, tell the user.
			    $fmt pushClass configbody
			    set v "$v [$fmt markVisibility (configbody)]"
			    $fmt popClass
			}

			set desc [getOvDescription v variable-description $vname]
			if {$init != {}} {
			    append desc [$fmt getString {$fmt parbreak}]
			    $fmt pushClass variable-default
			    append desc [$fmt markVisibility "initial value:"]
			    $fmt popClass
			    append desc " [$fmt markWithClass variable-default-value $init]"
			}
			$fmt unset_termclasses
			$fmt defterm $v $desc
		    }
		}
	    }
	    $fmt popClass
	}

	return
}



proc ::pool::oo::class::classDescription::VarList {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a string containing references to all
	# @c member descriptions.

	set pubs [publicMembers]
	set prot [protectedMembers]
	set priv [privateMembers]

	return [$fmt getString {
	    $fmt unset_termclasses
	    $fmt definitionList {
		if {$pubs != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility public]
		    $fmt popClass
		    $fmt defterm $title [formatVarList public]
		}
		if {$prot != {}} {
		    $fmt pushClass visibility
		    set title [$fmt markVisibility protected]
		    $fmt popClass
		    $fmt defterm $title [formatVarList protected]
		}
		if {$priv != {}} {
		    $fmt pushClass visibility
		    set  title [$fmt markVisibility private]
		    $fmt popClass
		    $fmt defterm $title [formatVarList private]
		}
	    }
	}] ; # {}
}



proc ::pool::oo::class::classDescription::WriteHeading {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Generates the header part of a class description.
	#
	# @/a mlist: The list of method objects. Used to create
	# @/a mlist: a comma separated list of method names referencing
	# @/a mlist: their descriptions later on the page

	$fmt pushAppendClass -header
	$fmt blockClass {
	    $fmt definitionList {
		if {[string length $authorName] > 0} {
		    if {
			!$opt(-inline) ||
			([string compare $authorName [$opt(-file) author]] != 0)
		    } {
			$fmt termclasses header-title header-author-value
			$fmt mailToDefterm "Written by"  authorName authorAddress
			$fmt unset_termclasses
		    }
		}

		$fmt termclasses header-title header-value
		$fmt formattedTermVar "Version"   version
		$fmt formattedTermVar "Dates"     date

		$fmt termclasses header-title header-description-value
		$fmt formattedTermVar Description comment

		$fmt termclasses header-title header-value

		if {! $opt(-inline)} {
		    $fmt defterm "Defined in" [$opt(-file) link]
		}

		if {[llength $dependencies] != 0} {
		    $fmt defterm "Depends on" [DependencyList]
		}

		$fmt formattedTermVar "See also" seeAlso
		$fmt formattedTermVar Danger     danger
		$fmt formattedTermVar Notes      note
		$fmt formattedTermVar "Bugs"     bug

		if {[llength $superclasses] != 0} {
		    $fmt defterm Superclasses [SuperclassList]
		}

		if {[llength $options] != 0} {
		    $fmt setAnchor OptionsUp
		    $fmt pushClass options
		    $fmt defterm [$fmt link Options "#Options"]  [OptionList]
		    $fmt popClass
		}
		if {[llength $components] != 0} {
		    $fmt setAnchor ComponentsUp
		    $fmt pushClass components
		    $fmt defterm [$fmt link Components "#Components"]  [ComponentList]
		    $fmt popClass
		}
		if {[llength $methods] != 0} {
		    $fmt setAnchor MethodsUp
		    $fmt pushClass methods
		    $fmt defterm [$fmt link Methods "#Methods"]  [MethodList]
		    $fmt popClass
		}
		if {[llength $variables] != 0} {
		    $fmt setAnchor MembersUp
		    $fmt pushClass members
		    $fmt defterm [$fmt link Membervariables "#Members"]  [VarList]
		    $fmt popClass
		}

		$fmt example Example $example
		$fmt unset_termclasses
	    }
	}
	$fmt popClass
	return
}



proc ::pool::oo::class::classDescription::WriteMethods {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method used by the page generator routine (<m write>) to
	# @c produce the output for all methods. Uses different separator
	# @c rules dependent on the setting of <o ptable>.
	#
	# @/a mList: The list of method objects to call.

	set mList [sortMethods $methods]

	$fmt hrule
	if {$opt(-ptable)} {
	    $fmt setAnchor Methods
	    $fmt pushClass methods
	    $fmt section   [$fmt link Methods "#MethodsUp"]
	    $fmt popClass
	    foreach p $mList {
		# no explicit visual separator required for table formatting
		$p write
	    }
	} else {
	    $fmt setAnchor Methods
	    $fmt pushClass methods
	    $fmt section   [$fmt link Methods "#MethodsUp"]
	    $fmt popClass
	    foreach p $mList {
		$fmt hrule
		$p write
	    }
	}
}



proc ::pool::oo::class::classDescription::author {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The author of the class
	return $authorName
}



proc ::pool::oo::class::classDescription::authorSet {author} {
    ::pool::oo::support::SetupVars classDescription
    # @c Called by the containing file to propagate its author information.
	# @a author: Author of containing file.

	if {[string length $authorName] == 0} {
	    set authorName $author
	}

	set currentAddr   [::pool::misc::currentAddress]
	set authorAddress [::pool::mail::addressB $authorName $currentAddr]

	foreach p $methods {
	    $p authorSet $authorName
	}
	return
}



proc ::pool::oo::class::classDescription::clear {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Resets state information.

	azIndexEntry_clear
	problemsAndIndex_clear
	return
}



proc ::pool::oo::class::classDescription::completeKwIndex {phrases} {
    ::pool::oo::support::SetupVars classDescription
    # @c Called by the containing file to propagate
	# @c its indexing information.
	# @c Completes the indexing of key phrases, propagates class
	# @c information down to all methods without index phrases, then
	# @c uses the union of all index phrases for the whole class.
	#
	# @a phrases: List of index phrases used by the containing file.

	# no propogation if we have our own keywords.
	if {[llength $keywords] != 0} {
	    return
	}

	set keywords $phrases
	set kwi     [$dist getIndex keywords]

	foreach m $methods {
	    append keywords " [$m keywords]"
	}

	set keywords [::pool::list::uniq [lsort $keywords]]

	# and use union to index the class itself

	foreach phrase $keywords {
	    $kwi addItem $phrase $this
	}

	return
}



proc ::pool::oo::class::classDescription::constructor {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Constructor. Initializes the parser functionality in
	# @c <f lib/classParse.tcl>. Also adds the class to the
	# @c containing namespace.

	[$dist nsContaining [name]] addClass $this
	class_util_init
	set entity class
	return
}



proc ::pool::oo::class::classDescription::dependencies {internal} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines all dependencies of this class.
	# @a internal: list of packages distributed here,
	# @a internal: to be removed from all dependency lists.
	# @r List containing all dependencies of this class.

	#puts stderr "// --> cdeps $internal | $dependencies"
	# i.  delete internal from current dependency list.
	# there is no need to merge method information,
	# this was done already, by <p cd_extract_definitions>.

	foreach d $internal {
	    while {[::pool::list::delete dependencies $d]} {}
	}

	#puts stderr "// --> cdeps = $dependencies"
	return $dependencies
}



proc ::pool::oo::class::classDescription::firstLetter {} {
    ::pool::oo::support::SetupVars classDescription
    # @r the first letter of the name of this index entry.

	# Skip over ':' (namespaces) but not for '::' alone.

	set n   $opt(-name)
	set pfx [$dist cget -class-prefix]
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



proc ::pool::oo::class::classDescription::formatComponentList {reqVisibility} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a string containing references to the
	# @c component descriptions with the specified visibility.
	#
	# @a reqVisibility: The visibility of the components to look at.
	#
	# @r A string containing a comma separated list of component names,
	# @r each a hyperlink to the associated description.

	set text ""

	switch -exact -- $listtype {
	    comma {
		foreach citem $components {
		    foreach {wtype c visi doc} $citem {break}
		    if {[string compare $visi $reqVisibility]} {continue}
		    append text "[$fmt link $c "#$anchor(c,$c)"], "
		}
		set text [string trimright $text ", "]
	    }
	    par {
		set text [list]
		foreach citem $components {
		    foreach {wtype c visi doc} $citem {break}
		    if {[string compare $visi $reqVisibility]} {continue}
		    lappend text [$fmt link $c "#$anchor(c,$c)"]
		}
		set text [join $text [$fmt getString {$fmt parbreak}]]
	    }
	    default {
		error "Illegal listtype $listtype"
	    }
	}
	return $text
}



proc ::pool::oo::class::classDescription::formatMethodList {mlist} {
    ::pool::oo::support::SetupVars classDescription
    # @c Takes a list of methods and returns a formatted string of
	# @c references.
	# @a mlist: The list of method objects to format.
	# @r a formatted string of references to the given methods.

	switch -exact -- $listtype {
	    comma {
		set text [list]
		foreach o $mlist {
		    lappend text [$o title 1]
		}
		return [join $text ", "]
	    }
	    par {
		set text [list]
		foreach o $mlist {
		    lappend text [$o title 1]
		}

		return [join $text [$fmt getString {$fmt parbreak}]]
	    }
	    default {
		error "Illegal listtype $listtype"
	    }
	}
}



proc ::pool::oo::class::classDescription::formatVarList {reqVisibility} {
    ::pool::oo::support::SetupVars classDescription
    # @c Internal method, generates a string containing references to the
	# @c variable descriptions.
	#
	# @a reqVisibility: The visibility of the members to look at.
	#
	# @r A string containing a comma separated list of variable names, each
	# @r a hyperlink to the associated description.

	set text ""

	switch -exact -- $listtype {
	    comma {
		foreach vitem $variables {
		    foreach {usage visi cfg v init} $vitem {break}
		    if {[string compare $visi $reqVisibility]} {continue}
		    append text "[$fmt link $v "#$anchor(v,$v)"], "
		}
		set text [string trimright $text ", "]
	    }
	    par {
		set text [list]
		foreach vitem $variables {
		    foreach {usage visi cfg v init} $vitem {break}
		    if {[string compare $visi $reqVisibility]} {continue}
		    lappend text [$fmt link $v "#$anchor(v,$v)"]
		}
		set text [join $text [$fmt getString {$fmt parbreak}]]
	    }
	    default {
		error "Illegal listtype $listtype"
	    }
	}
	return $text
}



proc ::pool::oo::class::classDescription::getMRef {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines wether <a name> is a method of the class or not.
	# @a name: The name to look for.
	# @r A link to the page containing the definition,
	# @r or the name marked as error.

	set mr [GetPartRecord m $name]

	if {[llength $mr] == 0} {
	    return [list 0 [refError method $name]]
	}

	return [list 1 [[lindex $mr 1] link]]
}



proc ::pool::oo::class::classDescription::getORef {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines wether <a name> is an option of the class or not.
	# @a name: The name to look for.
	# @r A link to the page containing the definition,
	# @r or the name marked as error.

	set or [GetPartRecord o $name]

	if {[llength $or] == 0} {
	    return [list 0 [refError option $name]]
	}

	$fmt pushClass xref-oref
	set link [$fmt link $name [lindex $or 1]]
	$fmt popClass
	return [list 1 $link]
}



proc ::pool::oo::class::classDescription::getOvDescription {which oclass name} {
    ::pool::oo::support::SetupVars classDescription
    # @r The description of the specified option or variable.
	#
	# @a which: A code indicating the type of <a name>. 'v' for variable,
	# @a which: 'o' for option.
	# @a name:  The name of the option/variable to look up.
	# @a oclass: Output class to use for markup.

	if {! [::info exists ovComment($which,$name)]} {
	    set text [$fmt missingDescError "No description for '$name'"]
	    # -W- problem
	} elseif {[string length $ovComment($which,$name)] == 0} {
	    set text [$fmt missingDescError "Empty description for '$name'"]
	    # -W- problem
	} else {
	    set text [$fmt markWithClass $oclass [$dist crResolve $ovComment($which,$name)]]
	}

	return $text
}



proc ::pool::oo::class::classDescription::getPage {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The url of the page containing the class description.

	if {0} {
	    if {$opt(-inline)} {
		return [$opt(-file) page]
	    }
	}

	set cname $opt(-name)
	regsub -all {::} $cname {_} cname
	return [$fmt pageFile c$cname]
	#return [$fmt pageFile c[::pool::serial::new]]
}



proc ::pool::oo::class::classDescription::getVRef {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines wether <a name> is a member variable of the class or
	# @c not.
	# @a name: The name to look for.
	# @r A link to the page containing the definition,
	# @r or the name marked as error.

	set vr [GetPartRecord v $name]

	if {[llength $vr] == 0} {
	    return [list 0 [refError variable $name]]
	}

	$fmt pushClass xref-vref
	set link [$fmt link $name [lindex $vr 1]]
	$fmt popClass
	return [list 1 $link]
}



proc ::pool::oo::class::classDescription::hasMRef {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines wether <a name> is a method of the class or not.
	# @a name: The name to look for.
	# @r a boolean value. [strong True] if the method exists, else
	# @r [strong false].

	set mr [GetPartRecord m $name]
	if {[llength $mr] == 0} {
	    return 0
	} else {
	    return 1
	}
}



proc ::pool::oo::class::classDescription::hasVariable {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Checks for existence of the <a name>d variable in the class.
	# @r A boolean value, 1 if the variable exists and 0 else.
	# @a name: Name of the variable to check.

	return [expr {[llength [GetPartRecord v $name]] > 0}]
}



proc ::pool::oo::class::classDescription::itk_component {itk_component add args} {
    ::pool::oo::support::SetupVars classDescription
    # @c Special method to handle itk_components embedded into
	# @c methods of a class. Is called by <m procDescription:scan>
	# @c if the object in question is not a procedure but a
	# @c method. The scan in question originates either from the
	# @c handling of detached methods in <m fileDescription:scan>
	# @c or from the immediate scan of non-detached methods.
	#
	# @a itk_component: Ignored. Dummy argument containing the
	# @a itk_component: name of the original command, 'itk_component'.
	# @a add:            Dummy argument, ignored.
	# @a args: ?-public|-protected|-private? name wtypedef ?code?

	set visi [lindex $args 0]
	if {[string match -* $visi]} {
	    set args [lrange $args 1 end]
	    set visi [string range $visi 1 end]
	} else {
	    set visi public
	}
	foreach {name wtypedef code} $args {break} ; # lassign

	set wtype ""
	set doc   ""

	foreach line [split $wtypedef \n] {
	    set line [string trim $line]
	    if {[string length $line] == 0} {continue}
	    if {![regexp ^# $line]} {
		# This line defines the widget type.
		set wtype [lindex [split $line] 0]
		break
	    }
	    # Handle documentation here !
	    # Ignore everything except @c

	    set line [string trimleft $line "#\t "]
	    if {![regexp ^@ $line]} {continue}
	    set line [string trimleft $line "@"]

	    regexp -indices "^(\[^ \t\]*)" $line dummy word
	    set start [lindex $word 0]
	    set end   [lindex $word 1]

	    set cmd  [string range $line $start $end]
	    set line [string range $line [incr end] end]

	    if {0 != [string compare $cmd c]} {
		continue
	    }

	    append doc " [string trimright $line]"
	}

	lappend components [list $wtype $name $visi $doc]
}



proc ::pool::oo::class::classDescription::keywords {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of kywords the class is indexed under.
	return $keywords
}



proc ::pool::oo::class::classDescription::mref {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines wether <a name> is a method of the class or not.
	# @a name: The name to look for.
	# @r A link to the page containing the definition,
	# @r or the name marked as error.

	if {![::info exists mref($name)]} {
	    set mref($name) [getMRef $name]
	}

	set ok [lindex $mref($name) 0]

	if {! $ok} {
	    refError method $name
	}

	return [lindex $mref($name) 1]
}



proc ::pool::oo::class::classDescription::oref {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines wether <a name> is an option of the class or not.
	# @a name: The name to look for.
	# @r A link to the page containing the definition,
	# @r or the name marked as error.

	if {![::info exists oref($name)]} {
	    set oref($name) [getORef $name]
	}

	set ok [lindex $oref($name) 0]

	if {! $ok} {
	    refError option $name
	}

	return [lindex $oref($name) 1]
}



proc ::pool::oo::class::classDescription::privateComponents {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of the private components of the class.
	return $visibility(c,private)
}



proc ::pool::oo::class::classDescription::privateMembers {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of the private members of the class.
	return $visibility(v,private)
}



proc ::pool::oo::class::classDescription::privateMethods {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of <c procDescription> objects which represent
	# @r the private methods of the class.
	return $visibility(p,private)
}



proc ::pool::oo::class::classDescription::procByName {name} {
    ::pool::oo::support::SetupVars classDescription
    # @r the object describing the <a name>d method or an empty list.
	# @a name: The name of the method requested by the caller.

	set result [GetPartRecord m $name]
	if {$result != {}} {
	    set result [lindex $result 1]
	}
	return $result
}



proc ::pool::oo::class::classDescription::protectedComponents {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of the protected components of the class.
	return $visibility(c,protected)
}



proc ::pool::oo::class::classDescription::protectedMembers {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of the protected members of the class.
	return $visibility(v,protected)
}



proc ::pool::oo::class::classDescription::protectedMethods {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of <c procDescription> objects which represent
	# @r the protected methods of the class.
	return $visibility(p,protected)
}



proc ::pool::oo::class::classDescription::publicComponents {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of the public components of the class.
	return $visibility(c,public)
}



proc ::pool::oo::class::classDescription::publicMembers {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of the public members of the class.
	return $visibility(v,public)
}



proc ::pool::oo::class::classDescription::publicMethods {} {
    ::pool::oo::support::SetupVars classDescription
    # @r The list of <c procDescription> objects which represent
	# @r the public methods of the class.
	return $visibility(p,public)
}



proc ::pool::oo::class::classDescription::refError {what name} {
    ::pool::oo::support::SetupVars classDescription
    # @r A string formatted as error for cross references to unknown
	# @r methods or options. Additionally adds the error to the list
	# @r of problems associated to the entity containing the bogus
	# @r cross reference.
	#
	# @a what: The type of the referenced entity.
	# @a name: The name of the unknown entity.

	return [$fmt crError $name "Reference to unknown $what '$name'"]
}



proc ::pool::oo::class::classDescription::scan {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Scans the specification of the class for embedded
	# @c documentation and definitions (members, methods and options)

	# i. extract class description

	set ignoreDesc 0
	set spec [split $opt(-spec) \n]

	# skip the first line, it just contains the tail of the class
	# intro (supperclasses).
	# In case of iTcl classes not even that.


	::pool::list::shift spec

	while {[llength $spec] > 0} {
	    set line [::pool::list::shift spec]
	    set line [string trim $line]
	    if {[string length $line] == 0} {continue}
	    if {![regexp ^# $line]} {
		# Ignore @index, @see, @comment, @author, @danger, @note
		# and any shortcuts of these from now on.

		set ignoreDesc 1
		continue
	    }
	    set line [string trimleft $line "#\t "]
	    if {![regexp ^@ $line]} {continue}
	    set line [string trimleft $line "@"]

	    regexp -indices "^(\[^ \t\]*)" $line dummy word
	    set start [lindex $word 0]
	    set end   [lindex $word 1]

	    set cmd  [string range $line $start $end]
	    set line [string range $line [incr end] end]

	    if {[llength [::info command cd_$cmd]] == 0} {
		continue
	    }

	    cd_$cmd [string trimright $line]
	}

	unset spec
	PostProcessInformation

	# ii. now get the members, ...
	set def [cd_extract_definitions  $opt(-name)  $opt(-log)   [$opt(-dist) cget -itk-opt-alias]  $opt(-spec)]

	set procs         [lindex $def 0]
	set components    [lindex $def 1]
	set options       [lindex $def 2]
	set variables     [lindex $def 3]
	set superclasses  [lindex $def 4]
	set dependencies  [lindex $def 5]

	# Remember the methods of the class and cause the system to
	# analyze them too. Record their visibility too.

	foreach {pname pspec} $procs {
	    set procId ${this}::Method[::pool::serial::new]

	    procDescription     $procId            -name       $pname             -parent     $this              -usage      [lindex $pspec 0]  -visibility [lindex $pspec 1]  -args       [lindex $pspec 2]  -body       [lindex $pspec 3]  -dist       $opt(-dist)        -formatter  $fmt               -log        $opt(-log)         -table      $opt(-ptable)


	    lappend methods $procId
	    set partInfo(m,$pname) [list $this $procId]

	    lappend visibility(p,[lindex $pspec 1]) $procId
	}

	ScanMethods
	SetupAnchors
	return
}



proc ::pool::oo::class::classDescription::sortMethods {mlist} {
    ::pool::oo::support::SetupVars classDescription
    # @r the specified list of methods sorted acccording
	# @r to the configured sorting option.
	#
	# @a mlist: The list of method objects to sort.

	if {$opt(-psort)} {
	    return [$fmt sortByName $mlist]
	} else {
	    return $mlist
	}
}



proc ::pool::oo::class::classDescription::superclasses {} {
    ::pool::oo::support::SetupVars classDescription
    # @r the list of superclasses for the class. Actually a list
	# @r of <c classDescription> objects.

	if {[string compare $scObj @@] == 0} {
	    set scObj [list]
	    foreach c $superclasses {
		if {![catch {set sc [$opt(-index) itemByName $c]}]} {
		    lappend scObj $sc
		}
	    }
	}

	return $scObj
}



proc ::pool::oo::class::classDescription::variableHasConfig {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Marks the <a name>d variable as one having a config-body
	# @c associated with them.
	# @a name: Name of the variable to mark.
	set vinfo($name) 1
	return
}



proc ::pool::oo::class::classDescription::vref {name} {
    ::pool::oo::support::SetupVars classDescription
    # @c Determines wether <a name> is a member variable of the class or
	# @c not.
	# @a name: The name to look for.
	# @r A link to the page containing the definition,
	# @r or the name marked as error.

	if {![::info exists vref($name)]} {
	    set vref($name) [getVRef $name]
	}

	set ok [lindex $vref($name) 0]

	if {! $ok} {
	    refError variable $name
	}

	return [lindex $vref($name) 1]
}



proc ::pool::oo::class::classDescription::write {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Generates the formatted text describing the class.

	$opt(-log) log debug writing class [name] ([page])
	set listtype [$dist cget -clisttype]

	#GetInheritedEntities

	$dist pushContext $this

	if {$opt(-inline)} {
	    $fmt pushClass class
	    $fmt chapter "Class '$opt(-name)'"
	} else {
	    $fmt  newPage [page] "Class '$opt(-name)'"
	    $fmt  pushClass class
	    $dist writeJumpbar
	}

	WriteHeading
	OptionDescriptionList
	ComponentDescriptionList
	WriteMethods
	VarDescriptionList

	if {! $opt(-inline)} {
	    $fmt closePage
	}

	$dist popContext
	$fmt  popClass
	return
}



proc ::pool::oo::class::classDescription::writeProblemPage {} {
    ::pool::oo::support::SetupVars classDescription
    # @c Writes a page containing the detailed problem description of
	# @c this class.

	$fmt  newPage [pPage] "Problems of class '[name]'"
	$dist writeJumpbar

	if {[numProblems] > 0} {
	    writeProblems
	}

	if {[numProblemObjects] > 0} {
	    $fmt section Methods
	    $fmt itemize {
		foreach p [$fmt sortByName $problemObjects] {
		    $fmt item [$fmt getString {
			$p writeProblems
		    }] ;#{}
		}
	    }
	}

	$fmt closePage
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::classDescription::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndexEntry::loadClass
::pool::oo::class::problemsAndIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences classDescription

# Create object instantiation procedure
interp alias {} classDescription {} ::pool::oo::support::New classDescription

# -------------------------------


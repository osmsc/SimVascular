# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: proc.cls,v 1.11 2000/09/05 20:10:43 aku Exp $
#
# @c Management of procedures and class methods.
# @s Procedures, methods
# @i procedure, method
# ----------------------------------------------


class procDescription : azIndexEntry problems {

    # @o parent: Handle of object containing the procedure.
    # @o parent: Can be a file or class (<c fileDescription>,
    # @o parent: <c classDescription>).
    # @o args:   List containing the names of all procedure arguments.
    # @o body:   Script containing the body of the procedure definition.
    # @o table:  Boolean flag. If set procedure documentation is written
    # @o table   as table.
    # @o log:    Handle of the <x syslogConnection> object to use for logging

    option parent
    option args
    option body
    option table -d 0
    option log

    # @o usage: Used to distinguish between class and member
    # @o usage: methods. Allowed values are [strong class]
    # @o usage: and [strong member]. The latter is the default.

    # @o visibility: One of [strong public], [strong protected] and
    # @o visibility: [strong private]. Determines the visibility of
    # @o visibility: the method outside of the class.

    option usage      -d member
    option visibility -d public


    # @v keywords: List of keywords associated to the procedure (by @index).
    # @v comment:  Description of procedure, as given by @comment.
    # @v danger:   Description of dangers in usage of the procedure,
    # @v danger:   as given by @danger.
    # @v note:     Notes about usage of the procedure, as given by @note.
    # @v result:   Description of procedure result if any.
    # @v arglist:  List containing the names of all arguments to the procedure.
    # @v anchor:   Name of the anchor associated to the procedure.

    var keywords
    var comment
    var danger
    var note
    var result
    var arglist
    var anchor ""

    # @v authorName:    Name of author, may contain a mail-address too.
    # @v authorName:    Specified via @author.
    # @v authorAddress: Mail address of author, as extracted
    # @v authorAddress: from <v authorName>.

    var authorName
    var authorAddress

    # @v bug:          Description of bugs associated to the procedure.
    # @v date:         Dates associated with the procedure.
    # @v version:      Version information associated with the procedure.
    # @v example:      Example associated with the procedure.

    var bug
    var date
    var version
    var example

    # @v argDef: Maps the arguments of the procedure/method to information
    # @v argDef: describing them (default value, textual description)

    var -array argDef


    # @v inhInfo: Information about inheritance (if this object
    # @v inhInfo: describes a method in a class). Already formatted
    # @v inhInfo: for display.

    var inhInfo @@



    method procDescription {} {
	# @c Constructor. Initializes the parser functionality in
	# @c <f lib/procParse.tcl>.

	if {0 != [string compare classDescription [$opt(-parent) oinfo class]]} {
	    [$dist nsContaining [name]] addProcedure $this
	}

	pd_util_init
	set entity proc
	return
    }



    method keywords {} {
	# @r The list of keywords this procedure is indexed under.
	return $keywords
    }



    method completeKwIndex {phrases} {
	# @c Called by the containing file (or class) to propagate its
	# @c indexing information.
	#
	# @a phrases: List of index phrases used by the containing file
	# @a phrases: or class.

	# no propogation if we have our own keywords.

	if {[llength $keywords] != 0} {
	    return
	}

	set keywords $phrases
	return
    }



    method authorSet {author} {
	# @c Called by the containing file or class to propagate its author
	# @c information.
	#
	# @a author:  Author of containing file.

	if {[string length $authorName] == 0} {
	    set authorName $author
	}

	set currentAddr   [::pool::misc::currentAddress]
	set authorAddress [::pool::mail::addressB $authorName $currentAddr]
	return
    }



    method scan {} {
	# @c Scans the procedure body for embedded documentation.

	# 0. Clear datastructures to allow repeated 'scan's
	set arglist [list]
	::pool::array::clear argDef

	# i. argument list
	foreach a $opt(-args) {
	    if {[llength $a] == 2} {
		set aname [lindex $a 0]
		set argDef($aname,default) 1
		set argDef($aname,defaultValue) [lindex $a 1]
	    } else {
		set aname $a
		set argDef($aname,default) 0
	    }

	    lappend arglist $aname
	    set argDef($aname,comment) ""
	}

	# ii. now get the information contained in comments
	#     inside the procedure body, just like for files

	set opt(-body) [split $opt(-body) \n]

	# Save for possible use in search for itk_components.
	set body $opt(-body)

	while {[llength $opt(-body)] > 0} {
	    set line [::pool::list::shift opt(-body)]
	    set line [string trim $line]
	    if {![regexp ^# $line]} {continue}
	    set line [string trimleft $line "#\t "]
	    if {![regexp ^@ $line]} {continue}
	    set line [string trimleft $line "@"]

	    regexp -indices "^(\[^ \t\]*)" $line dummy word
	    set start [lindex $word 0]
	    set end   [lindex $word 1]

	    set cmd  [string range $line $start $end]
	    set line [string range $line [incr end] end]

	    if {[llength [::info command pd_$cmd]] == 0} {
		continue
	    }

	    pd_$cmd [string trimright $line]
	}

	PostProcessInformation

	# If this procedure is actually a method of a class scan it
	# for contained 'itk_components'.

	set pclass [$opt(-parent) oinfo class]
	if {0 == [string compare classDescription $pclass]} {
	    # check for itk_component commands inside of the method
	    # body. Evaluate any that were found.

	    set cmd ""
	    set collect 0
	    set found 0

	    foreach line $body {
		if {$collect} {
		    #puts stderr "// p|itkc/a $line"
		    append cmd $line\n
		    if {[info complete $cmd]} {
			set collect 0

			# Don't evaluate it as a real command. The
			# completeness also means that we can words in
			# front and still have a valid command. So
			# prepend containing class and method name
			# before evaluation. This way we get the
			# correct arguments without losing control or
			# having to define a special itk_component
			# method.

			eval [list $opt(-parent)] itk_component $cmd
			set cmd ""
			incr found
			#puts stderr "// p|itkc/s -------------------------------------------"
		    }
		    continue
		}
		if {[regexp {^[ 	]*itk_component} $line]} {
		    #puts stderr "// p|itkc/s $line"
		    set cmd $line
		    set collect 1
		}
	    }

	    if {$found} {
		# Redo the anchoring so that it considers the new components.
		$opt(-parent) SetupAnchors
	    }
	}
	return
    }



    method write {} {
	# @c Generates the formatted text describing this procedure.
	# @c In contrast to files, packages and classes no separate page is
	# @c written. As this method is called from inside
	# @c <m fileDescription:write> (or <m classDescription:write>) the
	# @c description will go into this page. This is reflected by
	# @c <m pPage> too!

	# @n Dependent on the configuration either <m WriteStandard> or
	# @n <m WriteAsTable> is called to do the real work.

	$opt(-log) log debug writing procedure [name] ([page])

	#puts "$this writing html"

	$dist pushContext $this
	$fmt  pushClass proc
	$fmt  setAnchor [Anchor]

	if {$opt(-table)} {
	    WriteAsTable
	} else {
	    WriteStandard
	}

	ReportSpamArguments

	$dist popContext
	$fmt  popClass
	return
    }


    method title {{link 0}} {
	# @c Generate the title line of the description.
	# @a link: Boolean flag, optional. If set the generated line
	# @a link: will not contain the visibility information and the
	# @a link: name of the procedure/method will be a link to its
	# @a link: description.

	set title   ""
	set changes 0

	if {!$link} {
	    if {0 != [string compare $opt(-visibility) public]} {
		$fmt pushClass visibility
		append title [$fmt markVisibility $opt(-visibility)]
		$fmt popClass
		set changes 1
	    }
	}

	if {0 != [string compare $opt(-usage) member]} {
	    if {$changes} {
		append title " "
	    }

	    $fmt pushClass common
	    append title [$fmt markVisibility common]
	    $fmt popClass
	    set changes 1
	}

	if {$link} {
	    append title " [link]"
	} else {
	    append title " [$fmt markWithClass proc-name [name]]"
	}
	append  title " [WriteSimpleArglist]"
	return [string trim $title]
    }


    method WriteSimpleArglist {} {
	# @r a string containing the list of argument for the
	# @r procedure, without descriptions, etc.
	return [$fmt markWithClass arg-list "($arglist)"]
    }


    method GetDescription {} {
	# @c Retrieves the description of the procedure. May prepend
	# @c it with inheritance information (overridden base
	# @c classes). The string is [strong not] in printable form.
	# @r A string.

	set pclass [$opt(-parent) oinfo class]
	if {0 != [string compare classDescription $pclass]} {
	    return $comment
	}

	# Method in a class. Retrieve inheritance information if not
	# already known. Return a composite description.

	return [GetInhReferences]$comment
    }

    method GetInhReferences {} {
	# @c Computes inheritance information for the method.
	# @r A string.

	if {0 == [string compare @@ $inhInfo]} {
	    set inhInfo [list]
	    foreach sc [$opt(-parent) superclasses] {
		if {[$sc hasMRef $opt(-name)]} {
		    # Found a reference.
		    lappend inhInfo \
			    [$sc link]:[lindex [$sc getMRef $opt(-name)] 1]
		}
	    }
	}

	return $inhInfo
    }


    method WriteAsTable {} {
	# @c Generates the formatted text describing the procedure. This
	# @c method generates a tabular formatting.

	set pDesc [GetDescription]

	$fmt par [$fmt getString {
	    $fmt table border width=100% {
		# name
		$fmt table_row {
		    $fmt table_data colspan=2 {
			$fmt section [title]
		    }
		}

		# author reference
		#puts stderr "// proc|author|t  $authorName | [$opt(-parent) author]"
		if {[string length $authorName] > 0} {
		    if {[string compare $authorName [$opt(-parent) author]] != 0} {
			$fmt table_row {
			    $fmt table_data colspan=2 {
				$fmt write \
					[$fmt linkMail [$fmt strong by] \
					authorName authorAddress]
			    }
			}
		    }
		}

		$fmt formattedRowVar [$fmt strong "Version"]   version
		$fmt formattedRowVar [$fmt strong "Dates"]     date

		# description sections
		if {
		    ([string length $pDesc]  != 0) ||
		    (([string length $pDesc] == 0) &&
		     ([string length $result]  == 0))
		} {
		    # write comment section if text present or neither
		    # description nor description of result in existence.
		    # Result: A missing description is tolerated if a
		    # return value was described. It is assumed that this
		    # description is sufficient.
		    
		    $fmt table_row {
			$fmt table_data colspan=2 {
			    $fmt write [ProcDescription]
			}
		    }
		}

		$fmt exampleRow      [$fmt strong Example] $example
		$fmt formattedRowVar [$fmt strong Bugs]    bug
		$fmt formattedRowVar [$fmt strong Dangers] danger
		$fmt formattedRowVar [$fmt strong Notes]   note

		WriteArgumentsAsTable

		$fmt formattedRowVar [$fmt strong Returns] result
	    }
	}] ;#{}

	return
    }



    method ArgDescription {a} {
	# @c Internal method used by all procedures generating a formatted
	# @c procedure description.
	# @r the description of the given <a a>rgument or an error text.
	#
	# @a a: The name of the procedure argument to look at.

	if {[string length $argDef($a,comment)] == 0} {

	    return [$fmt missingDescError \
		    "Argument [$fmt markError $a] not documented"]
	} else {
	    return [$dist crResolve $argDef($a,comment)]
	}
    }



    method ArgName {a} {
	# @c Internal method used by all procedures generating a formatted
	# @c procedure description.
	# @r the given <a a>rgument itself, or the argument with its
	# @r defaultvalue attached to it.
	#
	# @a a: The name of the procedure argument to look at.

	if {$argDef($a,default)} {
	    # Argument has default value, add this to the name

	    if {[string length $argDef($a,defaultValue)] == 0} {
		return "$a (= \{\})"
	    } else {
		return "$a (= $argDef($a,defaultValue))"
	    }
	} else {
	    # Simple argument without default

	    return $a
	}
    }



    method ReportSpamArguments {} {
	# @c Report all arguments which were documented, but are
	# @c no arguments of the procedure.

	foreach key [array names argDef *,comment] {
	    set arg [lindex [split $key ,] 0]

	    if {[lsearch -exact $arglist $arg] < 0} {
		addProblem crossref \
			"Documented undefined argument [$fmt markError $arg]" \
			"[page]"
	    }
	}
	return
    }


    method hasArgument {a} {
	# @c Checks wether the procedure has an argument named <a a>.
	# @a a: The name of the possible argument to this procedure.
	# @r A boolean value. True if <a a> is an argument of this procedure,
	# @r or else False.

	return [::info exists argDef($a,default)]
    }



    method WriteArgumentsAsList {} {
	# @c Generates a definition list describing the arguments of this
	# @c procedure.

	if {[llength $arglist] != 0} {
	    set out [$fmt getString {
		$fmt definitionList {
		    $fmt termclasses argument-name argument-description
		    foreach a $arglist {
			$fmt defterm [ArgName $a] [ArgDescription $a]
		    }
		    $fmt unset_termclasses
		}
	    }] ;#{}
	    $fmt termclasses header-title header-value
	    $fmt defterm Arguments $out
	    $fmt unset_termclasses
	}
	return
    }



    method WriteArgumentsAsTable {} {
	# @c Generates a table describing the arguments of this procedure.

	if {[llength $arglist] != 0} {
	    foreach a $arglist {
		$fmt table_row {
		    $fmt pushClass argument-name
		    $fmt table_data {
			$fmt write "[$fmt strong Argument]: [ArgName $a]"
		    }
		    $fmt popClass

		    $fmt pushClass argument-description
		    $fmt table_data {
			$fmt write [ArgDescription $a]
		    }
		    $fmt popClass
		}
	    }
	}
	return
    }



    method ProcDescription {} {
	# @r a string containing the documentation of this procedure or an
	# @r error text.

	set    inh ""

	if {
	    (0 != [string compare $inhInfo @@]) &&
	    (0 != [string compare $inhInfo {}])
	} {
	    $fmt pushClass override
	    append inh "[$fmt markVisibility Overrides] "
	    $fmt popClass
	    append inh "[join [GetInhReferences] ", "]"
	    append inh  [$fmt getString {$fmt parbreak}]
	}

	if {[string length $comment] == 0} {

	    if {$result == {}} {
		return $inh[$fmt missingDescError "Documentation missing"]
	    } else {
		return $inh
	    }
	} else {
	    return $inh[$fmt markWithClass header-description-value [$dist crResolve $comment]]
	}
    }



    method WriteStandard {} {
	# @c Generates the formatted text describing the procedure. This
	# @c method generates a definition list.

	set pDesc [GetDescription]

	#$fmt pushAppendClass -header
	$fmt blockClass {
	    $fmt definitionList {

		set procout [$fmt getString {
		    $fmt definitionList {
			#puts stderr "// proc|author|d  $authorName | [$opt(-parent) author]"
			if {[string length $authorName] > 0} {
			    if {[string compare $authorName [$opt(-parent) author]] != 0} {
				$fmt termclasses header-title header-author-value
				$fmt mailToDefterm "Written by" \
					authorName authorAddress
				$fmt unset_termclasses
			    }
			}

			$fmt termclasses header-title header-value

			$fmt formattedTermVar "Version"   version
			$fmt formattedTermVar "Dates"     date
			
			if {
			    ([string length $pDesc]  != 0) ||
			    (([string length $pDesc] == 0) &&
			    ([string length $result]  == 0))
			} {
			    # Write comment section if text present or neither
			    # description nor description of result in existence.
			    # Result: A missing description is tolerated if a
			    # return value was described. It is assumed that this
			    # description is sufficient.

			    $fmt termclasses header-title {}
			    $fmt defterm Description [ProcDescription]
			}
			$fmt termclasses header-title header-value

			$fmt example Example $example

			$fmt formattedTermVar "Bugs"  bug
			$fmt formattedTermVar Dangers danger
			$fmt formattedTermVar Notes   note
		    
			WriteArgumentsAsList

			$fmt termclasses header-title header-value
			$fmt formattedTermVar Result  result
			$fmt unset_termclasses
		    }
		}] ;#{}

		if {[$fmt cget -css]} {
		    $fmt defterm [title] $procout
		} else {
		    $fmt defterm [$fmt strong [title]] $procout
		}
	    }
	}
	#$fmt popClass
	return
    }



    method getPage {} {
	# @r The url of the page containing the procedure description.

	return [$opt(-parent) page]#[Anchor]
    }



    method Anchor {} {
	# @r The name of the anchor at the start of the procedure description.

	#puts stdout "Proc === $this Anchor $opt(-name)"

	if {[string length $anchor] == 0} {
	    set pname $opt(-name)

	    if {0 == [string compare classDescription [$opt(-parent) oinfo class]]} {
		set pname [$opt(-parent) cget -name]_$pname
	    }

	    regsub -all {::} $pname {_} pname
	    regsub -all {#}  $pname {_} pname

	    set anchor p$pname
	    #set anchor p[::pool::serial::new]
	}

	return $anchor
    }



    method PostProcessInformation {} {
	# @c Called to streamline the extracted embedded documentation.
	# @c This mainly consists of removing superfluous whitespace.
	# @c Additionally converts a comma separated list of index
	# @c phrases into a real tcl list.

	foreach i {date version} {
	    regsub -all "\n" [set $i] {\&p} $i
	}

	foreach i {comment danger note result bug} {
	    set text [::pool::string::removeWhitespace [set $i]]
	    set $i   [string trim [::pool::string::oneLine $text]]
	}

	foreach aName $arglist {
	    set argComment \
		    [::pool::string::removeWhitespace $argDef($aName,comment)]

	    set argDef($aName,comment) \
		    [string trim [::pool::string::oneLine $argComment]]
	}

	set keywords [::pool::string::removeWhitespace $keywords]
	set keywords [split [string trim $keywords ", \t"] ,]

	while {[::pool::list::delete keywords {}]} {}
	return
    }



    method addProblem {category errortext url} {
	# @c Overrides the baseclass functionality (<m problems:addProblem>) to
	# @c allow the procedure to signal itself as problematic to its parent
	# @c (file or class).
	#
	# @a category:  Either [strong crossref] or [strong desc].
	# @a errortext: A description of the problem.
	# @a url:       Reference to the place of the problem.

	if {[numProblems] == 0} {
	    $opt(-parent) addProblemObject $this
	}

	problems_addProblem $category $errortext $url
	return
    }



    method pPage {} {
	# @c Special part of the problem reporting facility. Used by the
	# @c procedures parent to get a handle on the exact location of the
	# @c detailed problem description.
	# @r a reference to the exact location of the detailed problem
	# @r description for this procedure.

	return [$opt(-parent) pPage]#$this
    }


    method firstLetter {} {
	# @r the first letter of the name of this index entry.

	# Skip over ':' (namespaces) but not for '::' alone.

	set n   $opt(-name)
	set pfx [$dist cget -proc-prefix]
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

    if {0} {
	method firstLetter {} {
	    # @c Overrides base class (<m azIndexEntry:firstLetter>)
	    # @c to use the first letter of the actual procedure as indexing
	    # @c criterium, [strong not] the first letter of the namespace path.

	    set pname [lindex [split $opt(-name) :] end]

	    #regexp -- {^[^a-zA-Z]*([a-zA-Z])} $pname dummy letter
	    #return $letter
	    return [string index $pname 0]
	}
    }


}




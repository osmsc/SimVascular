# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: genericFormatter.cls,v 1.6 2000/09/05 20:10:43 aku Exp $
#
# @c The base class of all formatters
# @s Base class of all formatters
# @i Output formatter, formatting output, interface to formatter
# ----------------------------------------------------------------------


class genericFormatter : distInterface {

    # @c This class defines the interface used by the autodoc engine to produce
    # @c the documentation from data embedded into tcl code.


    # @o css: Boolean option to control support for cascading style
    # @o css: sheets (CSS). Support is enabled by default.

    option css -d 1

    # @o outputdir: Path to the directory to store the generated files into.

    option outputdir

    # @o replyaddr: Address of person to reply to in case of problems with
    # @o replyaddr: the documented distribution.

    option replyaddr

    # @o adlocation: Location of the Autodoc documentation.  Required for
    # @o adlocation: generation of backreferences for any generated page.

    option adlocation -d ""


    # @o ip: Requests the formatter to use the specified interpreter for
    # @o ip: script evaluation instead of uplevel. Only if not empty.

    option ip


    # @v extension: The extension to add to a page name to convert it into the
    # @v extension: name of the associated file (if there is any). Has to
    # @v extension: contain the separating dot or whatever is used on the
    # @v extension: particular platform to separate file names adn their
    # @v extension: extensions.

    var extension "."

    # @v currentPage: A token allowing the high level formatting routines to
    # @v currentPage: use the current page as target of hyperlinks.

    var currentPage ""



    # -------------------------------------
    # handle pages

    method pageFile {pageName} {
	# @c Converts the name of page into the name of the file containing it.
	# @a pageName: Guess what :-)
	# @r the name of the file containing the specified page.

	return ${pageName}${extension}
    }


    method clear {} {
	# @c Clear internal state, prepare for new scan.
	error "Abstract method called, was not overidden by subclass"
    }


    method newPage {file title {firstheading {}}} {
	# @c Start a new page, implicitly completes the current page.
	# @a file:  name of file to contain the generated page
	# @a title: string to be used as title of the page
	# @a firstheading: string to use in toplevel heading. Defaults
	# @a firstheading: to <a title>. Required to allow hyperlinks
	# @a firstheading: in toplevel headings without violating
	# @a firstheading: HTML syntax in the title.

	error "Abstract method called, was not overidden by subclass"
    }



    method closePage {} {
	# @c Completes the generation of the current page

	error "Abstract method called, was not overidden by subclass"
    }



    method prepareForOutput {} {
	# @c Called just before the generation of output starts. Checks for the
	# @c existence of a target directory and creates it, if necessary.

	if {[string length $opt(-outputdir)] == 0} {
	    error "no target directory given"
	}

	if {! [file exists $opt(-outputdir)]} {
	    file mkdir $opt(-outputdir)
	}
    }


    method getString {script} {
	# @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then returned
	# @c as the result of the call.
	#
	# @a script: The tcl code to execute in the calling context.
	# @r a string containing all output produced by the <a script>

	error "Abstract method called, was not overidden by subclass"
    }



    method write {text} {
	# @c Has to write the specified <a text> into the current page.
	# @a text: The string to place into the current page.

	error "Abstract method called, was not overidden by subclass"
    }




    method par {args} {
	# @c Writes a paragraph into the current page, uses all arguments as
	# @c one string.
	#
	# @a args: The text to format and write as paragraph. Actually a list
	# @a args: of arguments put together into one string

	error "Abstract method called, was not overidden by subclass"
    }


    method parbreak {} {
	# @c Writes a paragraph break into the current page.

	error "Abstract method called, was not overidden by subclass"
    }


    method ampersand {} {
	# @c Writes an ampersand ([ampersand]) into the current page.

	error "Abstract method called, was not overidden by subclass"
    }


    method hrule {} {
	# @c Writes a horizontal rule into the current page.

	error "Abstract method called, was not overidden by subclass"
    }


    method strong {text} {
	# @c Adds the appropriate formatting to the given <a text> to emphasize
	# @c it as strong, then returns the result.
	#
	# @a text: The string to mark as strong.
	# @r The emphasized <a text>.

	error "Abstract method called, was not overidden by subclass"
    }

    method sample {text} {
	# @c Adds the appropriate formatting to the given <a text> to emphasize
	# @c it as sample program output, then returns the result.
	#
	# @a text: The string to mark as sample.
	# @r The emphasized <a text>.

	error "Abstract method called, was not overidden by subclass"
    }


    method emph {text} {
	# @c Adds the appropriate formatting to the given <a text> to make
	# @c it emphasized, then returns the result.
	#
	# @a text: The string to mark as sample.
	# @r The emphasized <a text>.

	error "Abstract method called, was not overidden by subclass"
    }


    method preformatted {text} {
	# @c Adds the appropriate formatting to the given <a text> to preserve
	# @c its exact structure, then returns the result.
	#
	# @a text: The string to mark as preformatted text.
	# @r The emphasized <a text>.

	error "Abstract method called, was not overidden by subclass"
    }


    method section {title} {
	# @c Adds a section <a title> to the current page.
	# @a title: The text of the title.

	error "Abstract method called, was not overidden by subclass"
    }


    method chapter {title} {
	# @c Adds a chapter <a title> to the current page.
	# @a title: The text of the title.

	error "Abstract method called, was not overidden by subclass"
    }


    method link {text url} {
	# @c Combines its arguments into a hyperlink having the <a text> and
	# @c pointing to the location specified via <a url>
	#
	# @a text: The string to use as textual part of the hyperlink.
	# @a url:  The location to point at.
	# @r the formatted hyperlink.

	error "Abstract method called, was not overidden by subclass"
    }


    method linkDef {code text url} {
	# @c The same as in <m link>, but the result is stored internally
	# @c instead, using <a code> as reference.
	#
	# @a code: The identifier for storage and retrieval of the hyperlink.
	# @a text: The string to use as textual part of the hyperlink.
	# @a url:  The location to point at.

	error "Abstract method called, was not overidden by subclass"
    }


    method linkRef {code} {
	# @r the hyperlink generated by <m linkDef> and then stored under
	# @r <a code>.
	#
	# @a code: The identifier for storage and retrieval of the hyperlink.

	error "Abstract method called, was not overidden by subclass"
    }


    method imgDef {code text geometry imgfile} {
	# @c Stores an hyperlink to an image under <a code>, allowing later
	# @c retrieval via <m imgRef>.
	#
	# @a code:     The identifier for storage and retrieval of the image
	# @a code:     link.
	# @a geometry: A list containing the width and height of the image, in
	# @a geometry: this order. Can be empty. Used to insert geometry
	# @a geometry: information into the link, for better display even if
	# @a geometry: the image is not loaded.
	# @a text:     Alternative text describing the contents of the picture.
	# @a imgfile:  The location to point at, i.e. the image file.

	error "Abstract method called, was not overidden by subclass"
    }


    method imgRef {code} {
	# @r the image link generated by <m imgDef> and then stored under
	# @r <a code>.
	#
	# @a code: The identifier for storage and retrieval of the image link.

	error "Abstract method called, was not overidden by subclass"
    }


    method table {args} {
	# @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table. The arguments before the scripts are interpreted
	# @c as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	error "Abstract method called, was not overidden by subclass"
    }


    method table_row {args} {
	# @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table row. The arguments before the script are interpreted
	# @c as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	error "Abstract method called, was not overidden by subclass"
    }


    method table_data {args} {
	# @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table cell. The arguments before the script are interpreted
	# @c as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	error "Abstract method called, was not overidden by subclass"
    }


    method table_head {args} {
	# @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table cell formatted as heading. The arguments before the
	# @c script are interpreted as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	error "Abstract method called, was not overidden by subclass"
    }


    method caption {args} {
	# @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table caption. The arguments before the script are
	# @c interpreted as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	error "Abstract method called, was not overidden by subclass"
    }


    method getAnchor {name} {
	# @c Generates a <a name>d anchor and returns the HTML to the caller.
	# @a name: The name of the generated anchor.
	# @r the HTML string defining the <a name>d anchor.

	error "Abstract method called, was not overidden by subclass"
    }


    method setAnchor {name} {
	# @c Generates a <a name>d anchor at the current location in the
	# @c current page.
	# @a name: The name of the generated anchor.

	error "Abstract method called, was not overidden by subclass"
    }


    method definitionList {script} {
	# @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then formatted
	# @c as definition list.
	#
	# @a script: The tcl code to execute in the calling context.

	error "Abstract method called, was not overidden by subclass"
    }


    # @v termclass: Output class to use for a term.
    # @v defclass: Output class to use for a term definition
    var termclass {}
    var defclass  {}
    method termclasses {tc dc} {
	# @c Sets <v termclass> and <v defclass>.
	# @a tc: Value for <v termclass>.
	# @a dc: Value for <v defclass>.

	if {!$opt(-css)} {
	    return
	}

	set termclass $tc
	set defclass $dc
    }

    method unset_termclasses {} {
	# @c Unsets <v termclass> and <v defclass>.
	set termclass ""
	set defclass  ""
    }

    method defterm {term text} {
	# @c Generates an item in a definition list.
	# @a term: The name of the thing to explain.
	# @a text: The text explaining the <a term>.

	error "Abstract method called, was not overidden by subclass"
    }


    method defterm2 {term} {
	# @c Generates an item in a definition list.
	# @a term: The name of the thing to explain. But without explanation.

	error "Abstract method called, was not overidden by subclass"
    }


    method itemize {script} {
	# @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then formatted
	# @c as itemized list.
	#
	# @a script: The tcl code to execute in the calling context.

	error "Abstract method called, was not overidden by subclass"
    }


    method enumerate {script} {
	# @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then formatted
	# @c as enumerated list.
	#
	# @a script: The tcl code to execute in the calling context.

	error "Abstract method called, was not overidden by subclass"
    }


    method item {text} {
	# @c Generates an item in an itemized list.
	# @a text: The paragraph to format as item in the list.

	error "Abstract method called, was not overidden by subclass"
    }


    method quote {string} {
	# @c Takes the specified <a string>, add protective signs to all
	# @c character (sequences) having special meaning for the formatter
	# @c and returns the so enhanced text.
	#
	# @a string: The string to protect against interpretation by the
	# @a string: formatter.
	# @r a string containing no unprotected special character (sequences).

	error "Abstract method called, was not overidden by subclass"
    }


    method markError {text} {
	# @c Formats the incoming <a text> as error and returns the modified
	# @c information.
	#
	# @a text: The text to reformat.
	# @r a string containing the given <a text> formatted as error.

	error "Abstract method called, was not overidden by subclass"
    }

    method markVisibility {text} {
	# @c Formats the incoming <a text> for display as
	# @c visibility/usage add-on to a variable or method
	# @c description.
	#
	# @a text: The text to reformat.
	# @r a string containing the reformatted <a text>.

	error "Abstract method called, was not overidden by subclass"
    }

    # -------------------------------------
    # higher level procedures providing complexer formatting of whole text
    # blocks. Built upon the low-level method declared before, and therefore
    # independent of the particular system.

    method MakeError {category output error} {
	# @c Internal method to generate a problem report. The report is added
	# @c to the object currently writing its documentation linking it to
	# @c the place of the problem.
	#
	# @a category: Category of the problem, either [strong desc] or
	# @a category: [strong crossref]
	# @a output: The text to print at the place of the problem.
	# @a error: The text to use in the problem report to describe it.
	#
	# @r a string containing the <a output> formatted as problem and having
	# @r an anchor the report can link to.

	set anchor xr[::pool::serial::new]

	[$dist theContext] addProblem desc $error "${currentPage}#${anchor}"
	$dist log error "${currentPage}#${anchor}: $error"

	# fake out the -ip mechanism, enforce evaluation here !

	set ipSave   $opt(-ip)
	set opt(-ip) {}

	set     result [$this getAnchor $anchor]
	append  result [$this markError $output]

	set opt(-ip) $ipSave

	return [$this markAppendClass -${category}-error $result]
    }


    method missingDescError {errorText} {
	# @c Generates a documention missing problem at the place of its
	# @c calling. Uses <m MakeError> as workhorse.
	#
	# @a errorText: The text to use in the problem report to describe it.

	return [MakeError desc {not documented} $errorText]
    }


    method crError {outputText errorText} {
	# @c Generates a crossreference problem at the place of its calling.
	# @c Uses <m MakeError> as workhorse.
	#
	# @a outputText: The text to print at the place of the problem.
	# @a errorText:  The text to use in the problem report to describe it.

	return [MakeError crossref $outputText $errorText]
    }



    # definition list blocks

    method formattedTerm {term text} {
	# @c Like <m defterm>, but crossreferences in <a text> are resolved.
	# @a term: The name of the thing to explain.
	# @a text: The text explaining the <a term>.

	$this defterm $term [string trim [$dist crResolve $text]]
	return
    }



    method formattedTermVar {term var} {
	# @c Same as <m formattedTerm>, but the explanation is specified as
	# @c name of a variable. An empty explanation causes the system to
	# @c ignore the call.
	#
	# @a term: The name of the thing to explain.
	# @a var:  The name of the variable containing the epxlanatory text.

	upvar $var v

	if {[string length $v] != 0} {
	    #termclasses [getClass]-title [getClass]-${var}-value
	    formattedTerm $term $v
	    #unset_termclasses
	}

	return
    }



    method formattedRow {term text} {
	# @c See <m formattedTerm>, but writes out a table row, not a term of
	# @c a definition list.
	# @a term: The name of the thing to explain.
	# @a text: The text explaining the <a term>.

	$this table_row {
	    $this table_data colspan=2 {
		$this write "${term}: $text"
	    }
	}
	return
    }



    method formattedRowVar {term var} {
	# @c Same as <m formattedRow>, but the explanation is specified as
	# @c name of a variable. An empty explanation causes the system to
	# @c ignore the call. Crossreferences are resolved too.
	#
	# @a term: The name of the thing to explain.
	# @a var:  The name of the variable containing the epxlanatory text.

	upvar $var v

	if {[string length $v] != 0} {
	    formattedRow $term [$dist crResolve $v]
	}

	return
    }



    method termVar {term var} {
	# @c Same as <m formattedTerm>, but the explanation is specified as
	# @c name of a variable. An empty explanation causes the system to
	# @c ignore the call. There is no crossreference resolution.
	#
	# @a term: The name of the thing to explain.
	# @a var:  The name of the variable containing the epxlanatory text.

	# var = member variable

	upvar $var v

	if {[string length $v] != 0} {
	    $this defterm $term $v
	}

	return
    }



    method sortByName {objList} {
	# @c Sorts the specified list of objects alphabetically in ascending
	# @c order by the name of the objects.
	# @r the sorted list.
	# @a objList: List of object handles. The objects in it have to
	# @a objList: understand the [strong name] method.

	set olist ""
	foreach o $objList {
	    lappend olist [list [$o name] $o]
	}

	return [::pool::list::projection [lsort -index 0 $olist] 1]
    }



    method linkCommaList {objList} {
	# @c Takes the specified list of objects and converts it into a comma
	# @c separated list of hyperlinks to the pages describing them.
	# @a objList: List of object handles. The objects in it have to
	# @a objList: understand the [strong link] method.
	# @r a string containing several hyperlinks.

	set text [list]

	foreach o $objList {
	    lappend text [$o link]
	}

	return [join $text ", "]
    }



    method linkList {objList} {
	# @c Takes the specified list of objects and converts it into a 
	# @c list of hyperlinks to the pages describing them. The hyperlinks
	# @c are separated by line-breaks.
	# @a objList: List of object handles. The objects in it have to
	# @a objList: understand the [strong link] method.
	# @r a string containing several hyperlinks.

	set text [list]

	foreach o $objList {
	    lappend text [$o link]
	}

	return [join $text [$this getString {$this parbreak}]]
    }



    method commaList {textList} {
	# @c Takes the specified list of strings and converts it into a comma
	# @c separated list.
	# @a textList: List of strings.
	# @r a string separating the incoming texts by commas.

	return [join $textList ", "]
    }


    method sortedObjectList {objlist} {
	# @c Takes the specified list of objects, sorts them by name, then
	# @c generates a definition list containing hyperlinks to the object
	# @c pages as terms and their short descriptions as explanation.
	#
	# @a objlist: List of object handles. The objects in it have to
	# @a objlist: understand the methods [strong link] and [strong short].

	$this definitionList {
	    foreach obj [sortByName $objlist] {
		# Get short description from object
		# Use name and page to construct the hyperlink

		set shortDescription [$obj short]

		if {[string length $shortDescription] != 0} {
		    $this defterm [$obj link] [$dist crResolve $shortDescription]
		} else {
		    $this defterm2 [$obj link]
		}
	    }
	}

	return
    }



    method mailToDefterm {prefix nameVar addrVar} {
	# @c Writes hyperlink for a person and its mail address.
	#
	# @a prefix: String to write before the actual hyperlink
	# @a nameVar: Name of the variable containing the name to write.
	# @a addrVar: Name of the variable containing the address.

	upvar $nameVar nvar
	upvar $addrVar avar

	set name $nvar
	set addr $avar

	# remove address from name, no need for duplication
	regsub -- "$addr" $name {} name
	regsub -- {<>}    $name {} name
	set name [string trim $name]

	if {[string length $addr] != 0} {
	    $this defterm $prefix [$this link $name "mailto:$addr"]
	} else {
	    # no address available, therefore no hyperlink
	    # CSS makes things different.

	    if {$opt(-css)} {
		$this defterm $prefix $name
	    } else {
		$this defterm $prefix [$this strong $name]
	    }
	}

	return
    }



    method linkMail {prefix nameVar addrVar} {
	# @c Generates hyperlink for name (in attr)
	#
	# @a prefix: String to write before the actual hyperlink
	# @a nameVar: Name of the variable containing the name to write.
	# @a addrVar: Name of the variable containing the address.
	# @r A string containing a hyperlink to the given mail address.


	upvar $nameVar nvar
	upvar $addrVar avar

	set name $nvar
	set addr $avar

	# remove address from name, no need for duplication
	regsub -- "$addr" $name {} name
	regsub -- {<>}    $name {} name
	set name [string trim $name]

	if {[string length $addr] != 0} {
	    return "$prefix [$this link $name "mailto:$addr"]"
	} else {
	    # no address available, therefore no hyperlink
	    return "$prefix [$this strong $name]"
	}

	return
    }


    method example {term text} {
	# @c Render an example <a text> as part of a definition
	# @c list. The formatting of the <a text> is preserved.
	# @a term: The name of the thing to explain.
	# @a text: The text used to explain the <a term>.

	if {[string length $text] != 0} {
	    pushClass example
	    set ex [$this getString {$this preformatted $text}]
	    popClass
	    $this termVar $term ex
	}
    }

    method exampleRow {term text} {
	# @c Render an example <a text> as part of a 2-column table
	# @c The formatting of the <a text> is preserved.
	# @a term: The name of the thing to explain.
	# @a text: The text used to explain the <a term>.

	if {[string length $text] != 0} {
	    set ex [$this getString {$this preformatted $text}]
	    set pb [$this getString {$this parbreak}]

	    $this table_row {
		$this table_data colspan=2 {
		    $this write "${term}:$pb$ex"
		}
	    }
	}
    }


    # New code to manage output 'class'information usable for CSS
    # (HTML). Generic enough to be of use for other modules as well.

    # @v cstack: Stack of currently active output classes. Only the
    # @v cstack: top of the stack is used in the current output. The TOS
    # @v cstack: is at the first position of the list.

    var cstack {}

    method popClass {} {
	# @c Removes the output class at the top of the stack from
	# @c the stack. Is a no-op for an empty stack.

	set cstack [lrange $cstack 1 end]
	return
    }


    method popClassAll {} {
	# @c Clears the stack of all output classes.

	set cstack [list]
	return
    }


    method pushClass {name} {
	# @c Activates the output class <a name>, i.e. pushes it onto
	# @c the stack.
	# @a name: The name of the output class to activate.

	if {!$opt(-css)} {
	    return
	}

	set cstack [linsert $cstack 0 $name]
	return
    }


    method pushAppendClass {name} {
	# @c Like <m pushClass>, but not quite. Takes the top element
	# @c of the stack and pushes a class whose name is the
	# @c concatenation of the name of the top element and of the
	# @c argument <a name>. This allows code to push
	# @c specializations of the current output class without much
	# @c effort.
	# @a name: The name of the specialization to activate.

	if {!$opt(-css)} {
	    return
	}

	set cstack [linsert $cstack 0 [lindex $cstack 0]$name]
	return
    }


    method getClass {} {
	# @r Returns the currently active output class.
	return [lindex $cstack 0]
    }


    method blockClass {script} {
	# @c Encloses a block of output with a marker for an output class.
	# @a script: Script to execute to create the output to enclose in
	# @a script: the markers.

	error "Abstract method called, was not overidden by subclass"
    }


    method markWithClass {class text} {
	# @c Uses the specified output <a class> to mark the given <a text>
	# @c and returns the marked text.
	# @a text: The text to mark with an output <a class>.
	# @a class: The class to use as marker.
	# @r Default implementation, returns the <a text> unchanged.
	return $text
    }

    method markAppendClass {class text} {
	# @c Uses the specified output <a class> [strong refinement]
	# @c to mark the given <a text> and returns the marked text.
	# @a text: The text to mark with an output <a class>.
	# @a class: The refinement to add to the current class to get
	# @a class: the marker.
	# @r the marked text.

	if {!$opt(-css)} {
	    return $text
	}

	pushAppendClass $class
	set text [$this markWithClass [getClass] $text]
	popClass
	return $text
    }
}




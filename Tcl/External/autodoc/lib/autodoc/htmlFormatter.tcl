# -*- tcl -*-
# Automatically generated from file 'htmlFormatter.cls'.
# Date: Thu Sep 07 18:20:49 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> htmlFormatter <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
# Hack. Create a dummy 'option' command to suppress the '::option'
	# alias of '::cgi_option', as '::option' is used by the OO kernel as
	# well, and the alias will interfere with that.

	if {[llength [info commands option]] == 0} {
	    proc option {} {}

	    package require cgi

	    # force cgi commands into the interpreter
	    catch {cgi_error_occurred}

	    rename option {}
	} else {
	    # Tk loaded, no need to fake out the cgi library

	    package require cgi
	    # force cgi commands into the interpreter
	    catch {cgi_error_occurred}
	}

	proc __cgi__htmlf_vv {var_val} {
	    if {[regexp "style=(.*)" $var_val dummy str]} {
		return "style=\"$str\""
	    } elseif {[regexp "class=(.*)" $var_val dummy str]} {
		return "class=\"$str\""
	    } else {
		return $a
	    }
	}

	# Fix problem in cgi 0.8.
	proc cgi_span {args} {
	    set buf "<span"
	    foreach a [lrange $args 0 [expr [llength $args]-2]] {
		append buf " [__cgi__htmlf_vv $a]"
	    }
	    return "$buf>[lindex $args end]</span>"
	}

	# names an anchor so that it can be linked to
	proc cgi_anchor_name {name} {
	    return "<a name=\"$name\"></a>"
	}

# Namespace describing the class
namespace eval ::pool::oo::class::htmlFormatter {
    variable  _superclasses    genericFormatter
    variable  _scChainForward  htmlFormatter
    variable  _scChainBackward htmlFormatter
    variable  _classVariables  {}
    variable  _methods         {RecordPage ampersand blockClass caption chapter clear closePage constructor definitionList defterm defterm2 emph enumerate getAnchor getString hrule imgDef imgRef item itemize link linkDef linkRef markError markVisibility markWithClass newPage par parbreak preformatted quote sample section setAnchor strong table table_data table_head table_row write}

    variable  _variables
    array set _variables  {pages {htmlFormatter {isArray 1 initialValue {}}} footer {htmlFormatter {isArray 0 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {table . parbreak . hrule . sample . emph . imgRef . closePage . ampersand . markVisibility . linkRef . imgDef . strong . section . linkDef . definitionList . quote . constructor . getString . setAnchor . newPage . table_row . defterm2 . blockClass . table_head . table_data . write . getAnchor . par . RecordPage . preformatted . markError . markWithClass . enumerate . caption . link . chapter . itemize . defterm . item . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::htmlFormatter::RecordPage {pagefile} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Internal method used by <m newPage> to keep track of all generated
	# @c files. Trying to write a file twice causes an exception aborting
	# @c the engine.
	#
	# @a pagefile: The name of the to write.

	if {[::info exists pages($pagefile)]} {
	    error "page $pagefile already written"
	}

	set pages($pagefile) .
	return
}



proc ::pool::oo::class::htmlFormatter::ampersand {} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Writes an ampersand ([ampersand]) into the current page.
	return [cgi_amp]
}



proc ::pool::oo::class::htmlFormatter::blockClass {script} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Encloses a block of output with a marker for an output class.
	# @a script: Script to execute to create the output to enclose in
	# @a script: the markers.

	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		cgi_division [__cgi__htmlf_vv class=$ocl] {
		    $opt(-ip) eval $script
		}
	    } else {
		uplevel cgi_division [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		$opt(-ip) eval $script
	    } else {
		uplevel $script
	    }
	}
}



proc ::pool::oo::class::htmlFormatter::caption {args} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table caption. The arguments before the script are
	# @c interpreted as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	set script [::pool::list::pop args]
	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_caption $args  [list [__cgi__htmlf_vv class=$ocl]]  [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_caption $args [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_caption $args [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_caption $args [list $script]
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::chapter {title} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Adds a chapter <a title> to the current page.
	# @a title: The text of the title.

	if {[set ocl [getClass]] != {}} {
	    cgi_h1 [__cgi__htmlf_vv class=$ocl] $title
	} else {
	    cgi_h1 $title
	}
	return
}



proc ::pool::oo::class::htmlFormatter::clear {} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Clear internal state, prepare for new scan.
	::pool::array::clear pages
}



proc ::pool::oo::class::htmlFormatter::closePage {} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Completes the generation of the current page

	pushClass generated-by

	if {[string length $footer] == 0} {
	    set app  "AutoDoc 2.4"
	    set now  [::pool::date::now]

	    if {$opt(-css)} {
		set user [cgi_link _  [::pool::misc::currentUser]  "mailto:$opt(-replyaddr)"  [__cgi__htmlf_vv class=[getClass]]]

		if {[string length $opt(-adlocation)] != 0} {
		    set app [cgi_link _ $app $opt(-adlocation)  [__cgi__htmlf_vv class=[getClass]]]
		}
	    } else {
		set user [cgi_link _ [::pool::misc::currentUser]  "mailto:$opt(-replyaddr)"]

		if {[string length $opt(-adlocation)] != 0} {
		    set app [cgi_link _ $app $opt(-adlocation)]
		}
	    }


	    set footer "Generated by $app at $now, invoked by $user"
	}

	# auto footer (page generated by whom, where, when ?)
	cgi_hr

	if {$opt(-css)} {
	    cgi_p [__cgi__htmlf_vv class=[getClass]] $footer
	} else {
	    cgi_p align=right $footer
	}

	popClassAll

	_cgi_body_end
	_cgi_html_end

	# Reset the internal flag signaling a done header
	global _cgi
	unset  _cgi(head_done)

	::pool::cgi::closePage

	set currentPage {}
	return
}



proc ::pool::oo::class::htmlFormatter::constructor {} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Constructor, initializes the file extension.

	set extension .html
}



proc ::pool::oo::class::htmlFormatter::definitionList {script} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then formatted
	# @c as definition list.
	#
	# @a script: The tcl code to execute in the calling context.

	if {[string length $opt(-ip)] > 0} {
	    cgi_definition_list {
		$opt(-ip) eval $script
	    }
	} else {
	    uplevel cgi_definition_list [list $script]
	}
}



proc ::pool::oo::class::htmlFormatter::defterm {term text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Generates an item in a definition list.
	# @a term: The name of the thing to explain.
	# @a text: The text explaining the <a term>.

	if {$termclass != {}} {
	    cgi_term [markWithClass $termclass $term]
	} else {
	    cgi_term $term
	}
	if {$defclass != {}} {
	    cgi_term_definition [markWithClass $defclass $text]
	} else {
	    cgi_term_definition $text
	}
	return
}



proc ::pool::oo::class::htmlFormatter::defterm2 {term} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Generates an item in a definition list.
	# @a term: The name of the thing to explain. But without explanation.

	if {$termclass != {}} {
	    cgi_term [markWithClass $termclass $term]
	} else {
	    cgi_term $term
	}
	return
}



proc ::pool::oo::class::htmlFormatter::emph {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Adds the appropriate formatting to the given <a text> to make
	# @c it emphasized, then returns the result.
	#
	# @a text: The string to mark as sample.
	# @r The emphasized <a text>.

	if {[set ocl [getClass]] != {}} {
	    return "<em [__cgi__htmlf_vv class=$ocl]>$text</em>"
	} else {
	    return [cgi_emphasis $text]
	}
}



proc ::pool::oo::class::htmlFormatter::enumerate {script} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then formatted
	# @c as itemized list.
	#
	# @a script: The tcl code to execute in the calling context.

	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		cgi_number_list [__cgi__htmlf_vv class=$ocl] {
		    $opt(-ip) eval $script
		}
	    } else {
		uplevel cgi_number_list [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		cgi_number_list {
		    $opt(-ip) eval $script
		}
	    } else {
		uplevel cgi_number_list [list $script]
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::getAnchor {name} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Generates a <a name>d anchor and returns the HTML to the caller.
	# @a name: The name of the generated anchor.
	# @r the HTML string defining the <a name>d anchor.

	return [cgi_anchor_name $name]
}



proc ::pool::oo::class::htmlFormatter::getString {script} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then returned
	# @c as the result of the call.
	#
	# @a script: The tcl code to execute in the calling context.
	# @r a string containing all output produced by the <a script>

	if {[string length $opt(-ip)] > 0} {
	    return [::pool::cgi::getString {
		$opt(-ip) eval $script
	    }] ;#{}
	} else {
	    return [::pool::cgi::getString {
		uplevel $script
	    }] ;#{}
	}
}



proc ::pool::oo::class::htmlFormatter::hrule {} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Writes a horizontal rule into the current page.

	if {[set ocl [getClass]] != {}} {
	    cgi_hr [__cgi__htmlf_vv class=$ocl]
	} else {
	    cgi_hr
	}
	return
}



proc ::pool::oo::class::htmlFormatter::imgDef {code text geometry imgfile} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Stores an hyperlink to an image under <a code>, allowing later
	# @c retrieval via <m imgRef>.
	#
	# @a code:     The identifier for storage and retrieval of the image
	# @a code:     link.
	# @a text:     Alternative text describing the contents of the picture.
	# @a geometry: A list containing the width and height of the image, in
	# @a geometry: this order. Can be empty. Used to insert geometry
	# @a geometry: information into the link, for better display even if
	# @a geometry: the image is not loaded.
	# @a imgfile:  The location to point at, i.e. the image file.

	set w [lindex $geometry 0]
	set h [lindex $geometry 1]

	if {[set ocl [getClass]] != {}} {
	    if {([string length $w] == 0) || ([string length $h] == 0)} {
		cgi_imglink $code $imgfile [__cgi__htmlf_vv class=$ocl] "alt=$text"
	    } else {
		cgi_imglink $code $imgfile [__cgi__htmlf_vv class=$ocl] "alt=$text"  "width=$w" "height=$h"
	    }
	} else {
	    if {([string length $w] == 0) || ([string length $h] == 0)} {
		cgi_imglink $code $imgfile "alt=$text"
	    } else {
		cgi_imglink $code $imgfile "alt=$text" "width=$w" "height=$h"
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::imgRef {code} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @r the image link generated by <m imgDef> and then stored under
	# @r <a code>.
	#
	# @a code: The identifier for storage and retrieval of the image link.

	return [cgi_imglink $code]
}



proc ::pool::oo::class::htmlFormatter::item {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Generates an item in an itemized list.
	# @a text: The paragraph to format as item in the list.

	if {[set ocl [getClass]] != {}} {
	    cgi_li [__cgi__htmlf_vv class=$ocl] $text
	} else {
	    cgi_li $text
	}
	return
}



proc ::pool::oo::class::htmlFormatter::itemize {script} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified <a script> in the calling context and
	# @c captures any generated output in a string, which is then formatted
	# @c as itemized list.
	#
	# @a script: The tcl code to execute in the calling context.

	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		cgi_bullet_list [__cgi__htmlf_vv class=$ocl] {
		    ::$opt(-ip) eval $script
		}
	    } else {
		uplevel cgi_bullet_list [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		cgi_bullet_list {
		    ::$opt(-ip) eval $script
		}
	    } else {
		uplevel cgi_bullet_list [list $script]
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::link {text url} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Combines its arguments into a hyperlink having the <a text> and
	# @c pointing to the location specified via <a url>
	#
	# @a text: The string to use as textual part of the hyperlink.
	# @a url:  The location to point at.
	# @r the formatted hyperlink.

	if {[set ocl [getClass]] != {}} {
	    return [cgi_link _ $text $url [__cgi__htmlf_vv class=$ocl]]
	} else {
	    return [cgi_link _ $text $url]
	}
}



proc ::pool::oo::class::htmlFormatter::linkDef {code text url} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c The same as in <m link>, but the result is stored internally
	# @c instead, using <a code> as reference.
	#
	# @a code: The identifier for storage and retrieval of the hyperlink.
	# @a text: The string to use as textual part of the hyperlink.
	# @a url:  The location to point at.

	if {[set ocl [getClass]] != {}} {
	    cgi_link $code $text $url [__cgi__htmlf_vv class=$ocl]
	} else {
	    cgi_link $code $text $url
	}
	return
}



proc ::pool::oo::class::htmlFormatter::linkRef {code} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @r the hyperlink generated by <m linkDef> and then stored under
	# @r <a code>.
	#
	# @a code: The identifier for storage and retrieval of the hyperlink.

	return [cgi_link $code]
}



proc ::pool::oo::class::htmlFormatter::markError {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Formats the incoming <a text> as error and returns the modified
	# @c information.
	#
	# @a text: The text to reformat.
	# @r a string containing the given <a text> formatted as error.

	if {$opt(-css)} {
	    return $text ; # caller defines semantics and thus color
	} else {
	    return [cgi_font color=red $text]
	}
}



proc ::pool::oo::class::htmlFormatter::markVisibility {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Formats the incoming <a text> for display as
	# @c visibility/usage add-on to a variable or method
	# @c description.
	#
	# @a text: The text to reformat.
	# @r a string containing the reformatted <a text>.

	if {[set ocl [getClass]] != {}} {
	    return [markWithClass $ocl $text]
	} else {
	    return [cgi_font color=green $text]
	}
}



proc ::pool::oo::class::htmlFormatter::markWithClass {class text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Uses the specified output <a class> to mark the given <a text>
	# @c and returns the marked text.
	# @a text: The text to mark with an output <a class>.
	# @a class: The class to use as marker.
	# @r Returns the marked <a text>.

	if {!$opt(-css)} {
	    return $text
	} else {
	    return [cgi_span class=$class $text]
	}
}



proc ::pool::oo::class::htmlFormatter::newPage {file title {firstheading {}}} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Start a new page, implicitly completes the current page.
	# @a file:  name of file to contain the generated page
	# @a title: string to be used as title of the page
	# @a firstheading: string to use in toplevel heading. Defaults
	# @a firstheading: to <a title>. Required to allow hyperlinks
	# @a firstheading: in toplevel headings without violating
	# @a firstheading: HTML syntax in the title.

	popClassAll

	RecordPage      $file
	set currentPage $file

	if {[string length $firstheading] == 0} {
	    set firstheading $title
	}


	if {
	    ([string compare [file extension $file] ".htm"] != 0) &&
	    ([string compare [file extension $file] ".html"] != 0)
	} {
	    set file ${file}.html
	}

	::pool::cgi::openPage [file join $opt(-outputdir) $file]

	_cgi_html_start

	cgi_head {
	    cgi_title $title
	    cgi_relationship stylesheet styles.css type=text/css
	}

	_cgi_body_start
	cgi_h1 $firstheading
	return
}



proc ::pool::oo::class::htmlFormatter::par {args} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Writes a paragraph into the current page, uses all arguments as
	# @c one string.
	#
	# @a args: The text to format and write as paragraph. Actually a list
	# @a args: of arguments put together into one string

	if {[set ocl [getClass]] != {}} {
	    eval cgi_p [__cgi__htmlf_vv class=$ocl] $args
	} else {
	    eval cgi_p $args
	}
	return
}



proc ::pool::oo::class::htmlFormatter::parbreak {} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Writes a paragraph break into the current page.

	cgi_br
	return
}



proc ::pool::oo::class::htmlFormatter::preformatted {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Adds the appropriate formatting to the given <a text> to preserve
	# @c its exact structure, then returns the result.
	#
	# @a text: The string to mark as preformatted text.
	# @r The emphasized <a text>.

	if {[set ocl [getClass]] != {}} {
	    return [cgi_preformatted [__cgi__htmlf_vv class=$ocl] {cgi_puts $text}]
	} else {
	    return [cgi_preformatted {cgi_puts $text}]
	}
}



proc ::pool::oo::class::htmlFormatter::quote {string} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Takes the specified <a string>, add protective signs to all
	# @c character (sequences) having special meaning for the formatter
	# @c and returns the so enhanced text.
	#
	# @a string: The string to protect against interpretation by the
	# @a string: formatter.
	# @r a string containing no unprotected special character (sequences).

	return [cgi_quote_html $string]
}



proc ::pool::oo::class::htmlFormatter::sample {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Adds the appropriate formatting to the given <a text> to
        # @c emphasize it as sample program output, then returns the result.
	#
	# @a text: The string to mark as sample.
	# @r The emphasized <a text>.

	if {[set ocl [getClass]] != {}} {
	    return "<samp [__cgi__htmlf_vv class=$ocl]>$text</samp>"
	} else {
	    return [cgi_sample $text]
	}
}



proc ::pool::oo::class::htmlFormatter::section {title} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Adds a section <a title> to the current page.
	# @a title: The text of the title.

	if {[set ocl [getClass]] != {}} {
	    cgi_h2 [__cgi__htmlf_vv class=$ocl] $title
	} else {
	    cgi_h2 $title
	}
	return
}



proc ::pool::oo::class::htmlFormatter::setAnchor {name} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Generates a <a name>d anchor at the current location in the
	# @c current page.
	# @a name: The name of the generated anchor.

	# @d Usable only in conjunction with cgi 0.7,
	# @d and not cgi 0.4, as for earlier versions of autodoc.

	cgi_puts [cgi_anchor_name $name]
	return
}



proc ::pool::oo::class::htmlFormatter::strong {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Adds the appropriate formatting to the given <a text> to emphasize
	# @c it as strong, then returns the result.
	#
	# @a text: The string to mark as strong.
	# @r The emphasized <a text>.

	if {[set ocl [getClass]] != {}} {
	    return [cgi_span class=$ocl $text]
	} else {
	    return [cgi_bold $text]
	}
}



proc ::pool::oo::class::htmlFormatter::table {args} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table. The arguments before the scripts are interpreted
	# @c as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	set script [::pool::list::pop args]

	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table $args  [list [__cgi__htmlf_vv class=$ocl]]  [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table $args [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table $args [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table $args [list $script]
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::table_data {args} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table cell. The arguments before the script are interpreted
	# @c as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	set script [::pool::list::pop args]
	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table_data $args  [list [__cgi__htmlf_vv class=$ocl]]  [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table_data $args [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table_data $args [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table_data $args [list $script]
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::table_head {args} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table cell formatted as heading. The arguments before the
	# @c script are interpreted as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	set script [::pool::list::pop args]
	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table_head $args  [list [__cgi__htmlf_vv class=$ocl]]  [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table_head $args [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table_head $args [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table_head $args [list $script]
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::table_row {args} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Executes the specified script (last argument) in the calling
	# @c context, captures the produced formatted text and organizes it
	# @c into a table row. The arguments before the script are interpreted
	# @c as 'name=value'-style parameterization.
	#
	# @a args: A list of 'name=value' parameters and a script to evaluate
	# @a args: in the calling context (last element).

	set script [::pool::list::pop args]
	if {[set ocl [getClass]] != {}} {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table_row $args  [list [__cgi__htmlf_vv class=$ocl]]  [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table_row $args [list [__cgi__htmlf_vv class=$ocl]] [list $script]
	    }
	} else {
	    if {[string length $opt(-ip)] > 0} {
		eval cgi_table_row $args [list [list $opt(-ip) eval $script]]
	    } else {
		uplevel cgi_table_row $args [list $script]
	    }
	}
	return
}



proc ::pool::oo::class::htmlFormatter::write {text} {
    ::pool::oo::support::SetupVars htmlFormatter
    # @c Has to write the specified <a text> into the current page.
	# @a text: The string to place into the current page.

	cgi_puts $text
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::htmlFormatter::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::genericFormatter::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences htmlFormatter

# Create object instantiation procedure
interp alias {} htmlFormatter {} ::pool::oo::support::New htmlFormatter

# -------------------------------


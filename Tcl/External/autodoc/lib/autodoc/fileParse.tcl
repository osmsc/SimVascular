# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: fileParse.tcl,v 1.6 2000/09/05 20:10:43 aku Exp $
#
# @c Helper procedures used by <c fileDescription>-objects to extract file
# @c level documentation and defined entities (procedures, classes).
# @s <c fileDescription> helper procedures.
# @i helper procedures, documentation parsing, definition extraction
#-----------------------------------------------------------------------
package require Pool_Base

proc file_util_init {} {
    # @c Noop. Just an entrypoint for autoloading.
}


# shortcuts
interp alias {} fd_c {} fd_comment
interp alias {} fd_d {} fd_danger
interp alias {} fd_n {} fd_note
interp alias {} fd_s {} fd_short
interp alias {} fd_i {} fd_index

interp alias {} fd_b {} fd_bug


proc fd_bug {line} {
    # @c Process @bug, @b commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  bug bug
    append bug " $line"
    return
}


proc fd_date {line} {
    # @c Process @date commands. No shortcut, @d is already used for @danger.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output.

    upvar  date date
    append date "\n[string trim $line]"
    set    date [string trimleft $date \n]
    return
}


proc fd_version {line} {
    # @c Process @version commands. No shortcut, @v is already used for @var.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output.

    upvar  version version
    append version "\n[string trim $line]"
    set    version [string trimleft $version \n]
    return
}


proc fd_comment {line} {
    # @c Process @comment, @c commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  comment comment
    append comment " $line"
    return
}


proc fd_short {line} {
    # @c Process @short, @s commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  shortDescription shortDescription
    append shortDescription " $line"
    return
}


proc fd_danger {line} {
    # @c Process @danger, @d commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  danger danger
    append danger " $line"
    return
}


proc fd_note {line} {
    # @c Process @note, @n commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  note note
    append note " $line"
    return
}


proc fd_see {line} {
    # @c Process @see commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  seeAlso seeAlso
    append seeAlso " $line"
    return
}


proc fd_index {line} {
    # @c Process @index, @i commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  keywords keywords
    append keywords ", $line"
    return
}


proc fd_author {line} {
    # @c Process @author commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar authorName authorName
    set   authorName $line
    return
}


proc fd_extract_definitions {log file} {
    # @c extracts the procedure and class definitions contained in
    # @c the <a file>.
    # @a file: name of the file to scan.
    # @a log: reference to logger object.
    # @r A 4-element list. First element is list of procedure-, second a list
    # @r of class-definitions. Next to last a list of packages the file depends
    # @r on. At last a list of detached method definitions for <x iTcl> classes.
    # @r &p The first two and the last list are readable by 'array set', keys are
    # @r procedure-, class- and method-names. &p Procedure value is a 2-element list
    # @r containing the list of formal parameters (form usable by 'proc') and
    # @r the procedures body. Class value is its specification script. Method
    # @r value is either argument list and body, or body alone (config methods
    # @r for options).

    interp create _e -safe
    interp share  {} stdout _e
    #interp expose _e source
    interp alias  _e rem {} ::pool::string::removeComments

    _e eval {
	set   __classes__(_)    {}
	set   __procedures__(_) {}
	set   __dependencies__  {}
	set   __itcl_procedures__(_) {}


	unset __classes__(_)
	unset __procedures__(_)
	unset __itcl_procedures__(_)

	rename proc    _proc
	#rename package _package
	#rename unknown _unknown

	_proc class {name args} {

	    # This handles both my (Pool) classes and iTcl classes.
	    # The deeper parsing of classes and their differences
	    # are handled in <f lib/classParse.tcl>

	    #	    puts "found class $name"
	    global __classes__  __dependencies__
	    set    __classes__($name) $args

	    # check the class specification for required packages

	    set body [rem [lindex $args end]]

	    while {[regexp {package[ 	]+require[ 	]+([a-zA-Z0-9_]*)} \
		    $body dummy matchVar]} {
		if {[string length $matchVar] > 0} {
		    lappend __dependencies__ $matchVar
		}
		#::puts "regsub $dummy"
		regsub $dummy $body {} body
	    }

	    return
	}


	_proc proc {name arglist body} {
	    #	    puts "found proc $name"
	    global __procedures__ __dependencies__
	    set    __procedures__($name) [list $arglist $body]

	    # check for required packages in procedures too.
	    set body [rem $body]

	    while {[regexp {package[ 	]+require[ 	]+([a-zA-Z0-9_]*)} \
		    $body dummy matchVar]} {
		if {[string length $matchVar] > 0} {
		    lappend __dependencies__ $matchVar
		}
		#::puts "regsub $dummy"
		regsub $dummy $body {} body
	    }

	    #uplevel _proc [list $name] [list $arglist] [list $body]
	    return
	}

	# Support for iTcl, methods of a class can be written in a
	# detached form. Two variants are possible: body and
	# configbody. Use a new variable to communicate them to the caller.

	_proc body {name arglist body} {
	    global __itcl_procedures__ __dependencies__
	    set    __itcl_procedures__(m,$name) [list $arglist $body]

	    # check for required packages in procedures too.
	    set body [rem $body]

	    while {[regexp {package[ 	]+require[ 	]+([a-zA-Z0-9_]*)} \
		    $body dummy matchVar]} {
		if {[string length $matchVar] > 0} {
		    lappend __dependencies__ $matchVar
		}
		#::puts "regsub $dummy"
		regsub $dummy $body {} body
	    }

	    #uplevel _proc [list $name] [list $arglist] [list $body]
	    return
	}

	_proc configbody {varname body} {
	    global __itcl_procedures__ __dependencies__
	    set    __itcl_procedures__(v,$varname) $body

	    # check for required packages in procedures too.
	    set body [rem $body]

	    while {[regexp {package[ 	]+require[ 	]+([a-zA-Z0-9_]*)} \
		    $body dummy matchVar]} {
		if {[string length $matchVar] > 0} {
		    lappend __dependencies__ $matchVar
		}
		#::puts "regsub $dummy"
		regsub $dummy $body {} body
	    }

	    #uplevel _proc [list $name] [list $arglist] [list $body]
	    return
	}


	_proc unknown {args} {
	    #puts stdout "f| unknown $args" ; return ""
	    #puts stdout "unknown: $args"
	    #return {}
	}


	_proc package {cmd args} {
	    global  __dependencies__
	    if {[string compare $cmd require] == 0} {
		#::puts "immed: package require [lindex $args 0]"
		lappend __dependencies__ [lindex $args 0]
	    }

	    #uplevel _package $cmd $args
	    return
	}

	_proc namespace {args} {
	    # Ignore any namespace activity.
	}
    } ;# end '_e eval' {}

    # Read file here, eval it in safe interpreter, after deactivation of all
    # 'source'commands!

    set text [read [set f [open $file r]]]
    close $f
    regsub -all {source} $text {#source} text

    set fail [catch {_e eval $text} msg]

    #set fail [catch {_e eval "source $file"} msg]
    if {$fail} {
	$log log warning $file: $msg
	#global       errorCode  errorInfo
	#puts stderr "$errorCode $errorInfo"
    }

    set result [list \
	    [_e eval array get __procedures__]   \
	    [_e eval array get __classes__]      \
	    [_e eval       set __dependencies__] \
	    [_e eval array get __itcl_procedures__]]
    interp delete _e

    return $result
}


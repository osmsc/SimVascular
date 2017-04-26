# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: classParse.tcl,v 1.3 2000/09/05 20:10:42 aku Exp $
#
# @c Helper procedures used by <c classDescription>-objects to extract class
# @c level documentation and defined entities (methods, options, members).
# @s <c classDescription> helper procedures.
# @i helper procedures, documentation parsing, definition extraction
#-----------------------------------------------------------------------
package require Pool_Base

proc class_util_init {} {
    # @c Noop. Just an entrypoint for autoloading.
}


# shortcuts
interp alias {} cd_c  {} cd_comment
interp alias {} cd_d  {} cd_danger
interp alias {} cd_n  {} cd_note
interp alias {} cd_i  {} cd_index
interp alias {} cd_o  {} cd_option
interp alias {} cd_v  {} cd_var
interp alias {} cd_m  {} cd_var
interp alias {} cd_member {} cd_var
interp alias {} cd_ex {} cd_example
interp alias {} cd_b  {} cd_bug


proc cd_bug {line} {
    # @c Process @bug, @b commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  bug bug
    append bug " $line"
    return
}


proc cd_date {line} {
    # @c Process @date commands. No shortcut, @d is already used for @danger.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output.

    upvar  date date
    append date "\n[string trim $line]"
    set    date [string trimleft $date \n]
    return
}


proc cd_example {line} {
    # @c Process @example, @ex commands.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output. Leading whitespace is
    # @a line: preserved, trailing whitespace not.

    upvar ignoreDesc ignoreDesc
    if {$ignoreDesc} {return}

    upvar  example example
    append example "\n[string trimright $line]"
    set    example [string trimleft $example \n]
    return
}


proc cd_version {line} {
    # @c Process @version commands. No shortcut, @v is already used for @var.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output.

    upvar  version version
    append version "\n[string trim $line]"
    set    version [string trimleft $version \n]
    return
}


proc cd_comment {line} {
    # @c Process @comment, @c commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar comment    comment
    upvar ignoreDesc ignoreDesc

    if {$ignoreDesc} {return}

    append comment " $line"
    return
}


proc cd_danger {line} {
    # @c Process @danger, @d commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar danger     danger
    upvar ignoreDesc ignoreDesc

    if {$ignoreDesc} {return}

    append danger " $line"
    return
}


proc cd_note {line} {
    # @c Process @note, @n commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar note       note
    upvar ignoreDesc ignoreDesc

    if {$ignoreDesc} {return}

    append note " $line"
    return
}


proc cd_see {line} {
    # @c Process @see commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar seeAlso    seeAlso
    upvar ignoreDesc ignoreDesc

    if {$ignoreDesc} {return}

    append seeAlso " $line"
    return
}


proc cd_index {line} {
    # @c Process @index, @i commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar keywords   keywords
    upvar ignoreDesc ignoreDesc

    if {$ignoreDesc} {return}

    append keywords ", $line"
    return
}


proc cd_author {line} {
    # @c Process @author commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar authorName authorName
    upvar ignoreDesc ignoreDesc

    if {$ignoreDesc} {return}

    set authorName $line
    return
}


proc cd_option {line} {
    # @c Process @option, @o commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar ovComment ovComment
    set line [string trimleft $line]

    regexp -indices "^(\[^ \t\]*)" $line dummy word
    set a [lindex $word 0]
    set e [lindex $word 1]

    set o    [string trimright [string range $line $a $e] :]
    set line [string range $line [incr e] end]

    append ovComment(o,$o) " $line"
    return
}


proc cd_var {line} {
    # @c Process @var, @v, @member, @m commands. The latter 2 are old-style
    # @c commands and will be obsolete in future releases.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar ovComment ovComment
    set line [string trimleft $line]

    regexp -indices "^(\[^ \t\]*)" $line dummy word
    set a [lindex $word 0]
    set e [lindex $word 1]

    set v    [string trimright [string range $line $a $e] :]
    set line [string range $line [incr e] end]

    append ovComment(v,$v) " $line"
    return
}


proc cd_classvar {line} {
    # @c Process @classvar, @cv commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar ovComment ovComment
    set line [string trimleft $line]

    regexp -indices "^(\[^ \t\]*)" $line dummy word
    set a [lindex $word 0]
    set e [lindex $word 1]

    set v    [string trimright [string range $line $a $e] :]
    set line [string range $line [incr e] end]

    append ovComment(cv,$v) " $line"
    return
}


proc cd_extract_definitions {name log itk_opt_alias spec} {
    # @c extracts the method, member and option definitions
    # @c contained in the class-<a spec>.
    # @a spec: tcl code containing the specification to scan.
    # @a name: name of class to analyse
    # @a log: reference to logger object
    # @a itk_opt_alias: See <o distribution/itk-opt-alias>.
    # @r A 5-element list. First element is a list of procedure-definitions,
    # @r followed by the lists of options, members and superclasses. At last
    # @r the list of packages the class depends on.
    # @r Procedure definitions are keyed by name and contain argument list,
    # @r body, visibility and class/object flag (<x iTcl> allows class methods
    # @r and variables). See <p fd_extract_definitions> too for the basic
    # @r format of procedure definitions. 

    set sList [::pool::list::prev $spec]
    set spec  [::pool::list::last $spec]

    if {[string compare [lindex $sList 0] ":"] == 0} {
	# First part of specification contained superclass information.
	::pool::list::shift sList
    } else {
	# No superclasses. May get some added in case of a iTcl definition.
	set sList {}
    }

    interp create _e -safe
    interp share  {} stdout _e
    interp share  {} stderr _e
    interp expose _e source
    interp alias  _e rem {} ::pool::string::removeComments

    _e eval {
	set __vars__       ""
	set __opts__       ""
	set __deps__       ""
	set __super__      ""
	set __procedures__ ""
	set __components__ ""

	# visibility, default: public
	set __visi__ public

	# member/class, default: member
	set __usage__ member


	proc inherit {args} {
	    global __super__
	    eval lappend __super__ $args
	    return
	}

	proc destructor {body} {
	    public method destructor {} $body
	}

	proc constructor {arglist args} {
	    set body [lindex $args end]
	    # -w- handle init value ?
	    public method constructor $arglist $body
	}

	proc public {args} {
	    global __visi__
	    set    __visi__ public
	    if {[llength $args] == 1} {
		eval  [lindex $args 0]
	    } else {
		eval  $args
	    }
	    set    __visi__ public
	}

	proc protected {args} {
	    global __visi__
	    set    __visi__ protected
	    if {[llength $args] == 1} {
		eval  [lindex $args 0]
	    } else {
		eval  $args
	    }
	    set    __visi__ public
	}

	proc private {args} {
	    global __visi__
	    set    __visi__ private
	    if {[llength $args] == 1} {
		eval  [lindex $args 0]
	    } else {
		eval  $args
	    }
	    set    __visi__ public
	}

	proc variable {name {init {}} {configbody {}}} {
	    global  __vars__ __visi__

	    if {$configbody == {}} {
		lappend __vars__ [list member $__visi__ 0 $name $init]
	    } else {
		lappend __vars__ [list member $__visi__ 1 $name $init]
	    }
	    return
	}

	proc common {vname {init {}}} {
	    global  __vars__ __visi__
	    lappend __vars__ [list class $__visi__ 0 $vname $init]
	    if {$init != {}} {
		uplevel 1 [list set $vname $init]
	    }
	    return
	}


	# - existing definitions for my classes -
	# - partially modified to handle iTcl   -

	proc var {args} {
	    global  __vars__ __visi__

	    if {[string compare [lindex $args 0] -array] == 0} {
		lappend __vars__ [list member $__visi__ 0 [lindex $args 1] [lindex $args 2]]
	    } else {
		lappend __vars__ [list member $__visi__ 0 [lindex $args 0] [lindex $args 1]]
	    }
	    return
	}

	proc option {name args} {
	    global  __opts__

	    # Process args to find a default value.
	    set init {}
	    foreach {key val} $args {
		switch -glob -- $key {
		    -d -
		    -de -
		    -def -
		    -defa -
		    -defau -
		    -defaul -
		    -default {
			set init $val
			break
		    }
		    default {
			# ignore all other options
		    }
		}
	    }

	    lappend __opts__ [list 0 $name $init]
	    return
	}

	proc itk_option {
	    define option resourceName resourceClass init {configBody {}}
	} {
	    # itk_option define -myopt myopt Myopt "my opt value"
	    global  __opts__

	    if {[string match -* $option]} {
		set option [string range $option 1 end]
	    }

	    if {$configBody == {}} {
		lappend __opts__ [list 0 $option $init]
	    } else {
		lappend __opts__ [list 1 $option $init]
	    }
	    return
	}


	proc itk_component {add args} {
	    #puts stderr "// itk_component $add $args"
	    # args = [-public|-protected|-private] name wtypedef [code]

	    global __components__

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

	    lappend __components__ [list $wtype $name $visi $doc]
	}


	proc init {script} {
	    global __deps__

	    #puts stderr "// init class - $script - $__deps__"
	    # Handle class initialization code.

	    set script [rem $script]
	    #puts stderr "// init class --- $script"

	    while {[regexp {package[ 	]+require[ 	]+([a-zA-Z0-9_]*)} \
		    $script dummy matchVar]} {
		#puts stderr "// init class --- $matchVar"
		if {[string length $matchVar] > 0} {
		    lappend __deps__ $matchVar
		}
		#::puts "regsub $dummy"
		regsub $dummy $script {} script
	    }
	    #puts stderr "// init class ------- $__deps__"
	    return
	}


	proc method {name {arglist {}} {body {}}} {
	    #	    puts "found proc $name"
	    global  __procedures__ __deps__ __visi__ __usage__
	    lappend __procedures__ $name [list $__usage__ $__visi__ $arglist $body]

	    if {$body == {}} {
		# iTcl class, body is detached.
		return
	    }

	    # check for required packages inside of methods.
	    set body [rem $body]

	    while {[regexp {package[ 	]+require[ 	]+([a-zA-Z0-9_]*)} \
		    $body dummy matchVar]} {
		if {[string length $matchVar] > 0} {
		    lappend __deps__ $matchVar
		}
		#::puts "regsub $dummy"
		regsub $dummy $body {} body
	    }


	    # check for itk_component commands inside of the method
	    # body. Evaluate any that were found.

	    set cmd ""
	    set collect 0
	    foreach line [split $body \n] {
		if {$collect} {
		    #puts stderr "// itkc/a $line"
		    append cmd $line\n
		    if {[info complete $cmd]} {
			set collect 0
			catch {eval $cmd}
			set cmd ""
		    }
		    continue
		}
		if {[regexp {^[ 	]*itk_component} $line]} {
		    #puts stderr "// itkc/s $line"
		    set cmd $line
		    set collect 1
		}
	    }
	    return
	}

	proc unknown {args} {}
	proc package {cmd args} {
	    global  __deps__
	    if {[string compare $cmd require] == 0} {
		lappend __deps__ [lindex $args 0]
	    }
	    return
	}

	# - new for itcl: class methods are defined via 'proc'

	rename proc _proc
	_proc  proc {name {arglist {}} {body {}}} {
	    global __usage__
	    set    __usage__ class
	    method $name $arglist $body
	    set    __usage__ member
	    return
	}
    }

    if {$itk_opt_alias != {}} {
	_e eval [list interp alias {} $itk_opt_alias {} itk_option]
    }

    set fail [catch {_e eval $spec} msg]
    if {$fail} {
	$log log warning $name: $msg
    }

    if {[_e eval {llength __super__}] > 0} {
	# Retrieve additionally found superclasses (iTcl).
	eval lappend sList [_e eval {set __super__}]
    }

    set result [list                     \
	    [_e eval set __procedures__] \
	    [_e eval set __components__] \
	    [_e eval set __opts__]       \
	    [_e eval set __vars__]       \
	    $sList                       \
	    [_e eval set __deps__]]

    interp delete _e

    return $result
}


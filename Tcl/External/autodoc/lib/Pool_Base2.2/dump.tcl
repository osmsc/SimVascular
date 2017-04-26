# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS:	$Id: dump.tcl,v 1.4 1999/02/14 21:38:44 aku Exp $
#
# @c Dump various interpreter information into strings,
# @c for save and later restoration. The information is
# @c packed into sourceable tcl scripts thus making
# @c restauration trivial.
#
# @s Dump datastructures into sourceable strings.
# @i dump datastructures, info dump
# --------------------

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval dump {
	variable version @base:mFullVersion@
	namespace export *

	# persistent information for option processors used by here

	::pool::array::def    varOptions
	::pool::getopt::defOption varOptions array \
		-type    ::pool::dump::varopt  \
		-default compact

	::pool::array::def    nsOptions
	::pool::getopt::defOption nsOptions array  \
		-type    ::pool::dump::varopt  \
		-default compact

	::pool::getopt::defOption nsOptions proc \
		-type    ::pool::dump::nsopt \
		-default on

	::pool::getopt::defOption nsOptions var  \
		-type    ::pool::dump::nsopt \
		-default on

	::pool::getopt::defOption nsOptions ns   \
		-type    ::pool::dump::nsopt \
		-default on

	::pool::getopt::defOption nsOptions imports \
		-type    ::pool::dump::nsopt    \
		-default on
    }
}

# ----------------------------------------------------------
# type checkers used by the option processors
# ----------------------------------------------------------

proc ::pool::dump::varopt {o v} {
    # @c Internal type checker for option '-array'. Accepts
    # @c only 'verbose' and 'copmpact'
    #
    # @a o: The name of the option to check.
    # @a v: The value to check.
    # @r A boolean value. True signals acceptance of <a v>.

    switch -- $v {
	compact -
	verbose {return 1}
    }
    return 0
}


proc ::pool::dump::nsopt {o v} {
    # @c Internal type checker for all options except '-array'.
    # @c Accepts 'on', 'off' and 'copmpact'
    #
    # @a o: The name of the option to check.
    # @a v: The value to check.
    # @r A boolean value. True signals acceptance of <a v>.

    switch -- $v {
	compact -
	on      -
	off     {return 1}
    }
    return 0
}


# ----------------------------------------------------------
# The exported procedures

proc ::pool::dump::var {args} {
    # @c Dumps a global (or procedure local) variable and its contents
    # @c into a string. Evaluating the string will restore the variable.
    # @c See <p ::pool::dump::nsvar> too.

    # @a args: A list of options and their values, followed
    # @a args: by the name of the variable. The only option
    # @a args: known to this procedure is '-array'. Allowed
    # @a args: values are 'compact' and 'verbose', the first
    # @a args: is used as default. Only dumping of arrays is
    # @a args: affected by this option. In compact format an
    # @a args: 'array set' statement will be generated,
    # @a args: otherwise a sequence of individual 'set's.

    # @r A string containing a tcl statement to restore the
    # @r specified variable and its contents.

    # @i variable dump

    variable varOptions
    set args [::pool::getopt::process varOptions $args opt]

    if {$args == {}} {
	error "variable missing"
    }

    set    varName [lindex $args 0]
    upvar $varName v

    if {[array exists v]} {
	# "v" is an array. Differentiate between empty and filled
	# ones. In case of the latter the format requires attention
	# too.

	if {[array size v] == 0} {
	    # Empty arrays are tricky, we have to
	    # generate and delete a dummy entry to
	    # ensure its existence.

	    set     code "array set [list $varName] [list _ _]; "
	    append  code "unset [list ${varName}(_)]"
	    return $code
	} else {
	    # Array containing data is easier. Use the format
	    # information to differentiate between efficient
	    # and easier to read formats.

	    switch -- $opt(-array) {
		compact {
		    return "array set [list $varName] [array get v]"
		}
		verbose {
		    set code ""
		    foreach key [lsort [array names v]] {
			append code "set [list "${varName}($key)"] "
			append code "[list $v($key)]\n"
		    }
		    return $code
		}
	    }
	}
    } elseif {[info exists v]} {
	# "v" is a scalar variable. A simple 'set' is enough, whatever
	# the contents.

	return [list set $varName $v]
    } else {
	error "::pool::dump::var: unknown variable '$varName'."
    }
}



proc ::pool::dump::nsvar {args} {
    # @c Dumps a namespace variable and its contents into a
    # @c string. Evaluating the string will restore the variable.
    # @c See <p ::pool::dump::var> too. Expects to be called in the
    # @c namespace containing the variable.

    # @a args: A list of options and their values, followed
    # @a args: by the name of the variable. The only option
    # @a args: known to this procedure is '-array'. Allowed
    # @a args: values are 'compact' and 'verbose', the first
    # @a args: is used as default. Only dumping of arrays is
    # @a args: affected by this option. In compact format an
    # @a args: 'array set' statement will be generated,
    # @a args: otherwise a sequence of individual 'set's.
    # @r A string containing a tcl statement to restore the
    # @r specified variable and its contents.

    # @i variable dump

    variable varOptions
    set args [::pool::getopt::process varOptions $args opt]

    if {$args == {}} {
	error "variable missing"
    }

    set    varName [lindex $args 0]
    upvar $varName v

    if {[array exists v]} {
	# "v" is an array. Differentiate between empty and filled
	# ones. In case of the latter the format requires attention
	# too.

	set code "variable  [list $varName]\n"

	if {[array size v] == 0} {
	    # Empty arrays are tricky, we have to
	    # generate and delete a dummy entry to
	    # ensure its existence.

	    append  code "array set [list $varName] [list _ _]; "
	    append  code "unset [list ${varName}(_)]"
	    return $code
	} else {
	    # Array containing data is easier. Use the format
	    # information to differentiate between efficient
	    # and easier to read formats.

	    switch -- $opt(-array) {
		compact {
		    append  code [list array set $varName [array get v]]
		    return $code
		}
		verbose {
		    foreach key [lsort [array names v]] {
			append code "set [list "${varName}($key)"] "
			append code "[list $v($key)]\n"
		    }
		    return $code
		}
	    }
	}
    } elseif {[info exists v]} {
	# "v" is a scalar variable. A simple 'set' is enough, whatever
	# the contents.

	return [list variable $varName $v]
    } else {
	error "::pool::dump::nsvar: unknown variable ;$varName'."
    }
}



proc ::pool::dump::proc {procName} {
    # @c Dumps procedure <a procName> into a string.
    # @c Evaluating the string in a tcl interpreter
    # @c will restore the procedure and add it to
    # @c that interpreter.

    # @a procName: The name of the procedure to dump.
    # @a procName: Absolute and/or relative namespace
    # @a procName: identifiers are allowed here.

    # @r A string containing a tcl statement to restore
    # @r the procedure definition.

    # @d Qualifying namespaces are removed from the
    # @d procedure name in the returned statement

    # @i procedure dump

    set formals {}
    foreach arg [info args $procName] {
	if {[info default $procName $arg def]} {
	    lappend formals [list $arg $def]
	} else {
	    lappend formals $arg
	}
    }

    set p [::namespace tail $procName]

    return [list proc $p $formals [info body $procName]]
}



proc ::pool::dump::namespace {args} {
    # @c Dumps a namespace and its contents into a string.
    # @c Evaluating the string will restore the namespace.
    # @a args: A list of options and their values, followed
    # @a args: by the name of the namespace. The options
    # @a args: known to this procedure are '-proc', '-var',
    # @a args: '-ns', '-imports' and '-array'. Allowed
    # @a args: values are 'on', 'off' and 'compact'. The
    # @a args: single exception to this is '-array',
    # @a args: see <p ::pool::dump::var> for more. The value of an
    # @a args: option determines whether the associated part
    # @a args: of the namespace is dumped (on), left out (off)
    # @a args: or in a short form (compact). The latter can
    # @a args: be a simple statement (variables, procedures),
    # @a args: or a comment (imported commands, nested namespaces).
    # @r A string containing a tcl statement to restore the
    # @r specified namespace and its contents.
    # @i namespace dump

    variable nsOptions
    set args [::pool::getopt::process nsOptions $args opt]

    if {$args == {}} {
	error "missing namespace"
    }

    set nsName [lindex $args 0]
    set code "namespace [::namespace tail $nsName] \{\n"
    set n 0

    # Dump variables first, then procedures and imported commands.
    # At last recurse down into nested namespaces (in case of -ns on).

    set varList [::pool::list::filter \
	    [::namespace inscope $nsName info vars] [info globals]]

    if {$varList != {}} {
	switch -- $opt(-var) {
	    off {
		# User requested not to dump variables
	    }
	    on {
		# Dump variable contents, full form

		append code "    # -- variables --\n\n"
		foreach varName [lsort $varList] {
		    set varCode [::namespace inscope $nsName \
			    ::pool::dump::nsvar -array $opt(-array) $varName]
		    append code "[::pool::string::indent $varCode "    "]\n"
		}
		set n 1
	    }
	    compact {
		# Dump variables in short form, without contents.

		append code "    # -- variables --\n\n"
		foreach varName [lsort $varList] {
		    append code "    variable $varName\n"
		}
		set n 1
	    }
	}
    }


    set procList [::namespace inscope $nsName info procs]

    if {$procList != {}} {
	switch -- $opt(-proc) {
	    off {
		# User requested not to dump procedures
	    }
	    on {
		# Dump procedure definition, full form

		if {$n} {append code "\n"}

		append code "    # -- procedures --\n"

		foreach procName [lsort $procList] {
		    set fail [catch {
			append code "\n    "
			append code \
				"[::pool::dump::proc ${nsName}::${procName}]\n"
		    } msg] ;# {}
		    if {$fail} {
			append code "    $nsName / $procName = $msg\n"
		    }
		}

		set n 1
	    }
	    compact {
		# Dump procedure definitions in short form,
		# without arguments and body

		if {$n} {append code "\n"}

		append code "    # -- procedures --\n"

		foreach procName [lsort $procList] {
		    append code "    $procName \{\} \{\}"
		}

		set n 1
	    }
	}
    }

    # <enhance@14/1999/ak>
    # Feb 14, 1999. ak / Replacing the inner [filter ...] by variable,
    # using a special loop to get at the command in the namespace more
    # easily. This should fix the problem with imported commands with a
    # cousin at the toplevel too. Now who proposed that on c.l.t ?
    # Bryan Oakley or Donal K. Fellows, I think. It was some months ago
    # and I am unable to remember clearly :-(.

    set nsCmds {}
    foreach c [info commands ${nsName}::*] {
	regsub "^${n}::" $c {} c
	lappend nsCmds $c
    }

    set iCmdList [::pool::list::filter $nsCmds $procList]

    #    [::pool::list::filter [::namespace eval $nsName info commands]
    #    [info commands]] = nsCmds, old way.
    #
    # the statement above is not foolproof, it will omit any imported
    # command having a cousin at the toplevel !!


    if {$iCmdList != {}} {
	switch -- $opt(-imports) {
	    off {
		# User requested not to dump imported commands
	    }
	    on {
		# Dump imported commands, full form

		if {$n} {append code "\n"}

		append code "    # -- imported commands --\n\n"
		set maxLen [::pool::list::lengthOfLongestEntry $iCmdList]

		foreach procName [lsort $iCmdList] {
		    append code "    namespace import "
		    append code \
			    "[::namespace inscope $nsName \
			    namespace origin $procName]"
		    #append code " # -> $procName"
		    append code "\n"
		}

		set n 1
	    }
	    compact {
		# Dump imported commands in short form (comments)

		if {$n} {append code "\n"}

		append code "    # -- imported commands --\n\n"
		set maxLen [::pool::list::lengthOfLongestEntry $iCmdList]

		foreach procName [lsort $iCmdList] {
		    append code "    # $procName"
		    append code \
			    "[::pool::string::blank \
			    [expr {$maxLen-[string length $procName]}]] "
		    append code "<- "
		    append code \
			    "[::namespace inscope $nsName \
			    namespace origin $procName]\n"
		}

		set n 1
	    }
	}
    }


    set subSpaceList [::namespace children $nsName]

    if {$subSpaceList != {}} {
	switch -- $opt(-ns) {
	    off {
		# User requested not to dump nested namespaces
	    }
	    on {
		# Dump nested namespaces, full form

		if {$n} {append code "\n"}

		append code "    # -- nested namespaces --\n"

		foreach subSpace [lsort $subSpaceList] {
		    append code \
			    "\n[::pool::string::indent \
			    [namespace \
			    -proc    $opt(-proc) \
			    -var     $opt(-var)  \
			    -ns      $opt(-ns)    \
			    -imports $opt(-imports) \
			    -array   $opt(-array) $subSpace] "    "]\n"
		}

		set n 1
	    }
	    compact {
		# Dump nested namespaces in short form (comments)

		if {$n} {append code "\n"}

		append code "    # -- nested namespaces --\n"

		foreach subSpace [lsort $subSpaceList] {
		    append code \
			    "    # namespace [::namespace tail $subSpace]\n"
		}

		set n 1
	    }
	}
    }

    # Ok, everything is collected, close and return the statement

    append code "\}\n"
    return $code
}



proc ::pool::dump::callstack {{stackName {}}} {
    # @c Returns a string containing the procedure callstack
    # @c at the place of the procedures calling
    #
    # @a stackName: Name given to this trace
    #
    # @i stack trace, tracing the stack

    if {$stackName == {}} {
	set result "callstack\n"
    } else {
	set result "callstack ($stackName)\n"
    }
    append  result "---------------------------------------------\n"

    # (skip over invocation of this procedure!)
    set  n [info level]

    while {$n > 0} {
	append result "\t$n:\t[uplevel #$n ::namespace current] [info level $n]\n"
	incr n -1
    }

    append  result "---------------------------------------------\n"
    return $result
}


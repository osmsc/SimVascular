# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: getopt.tcl,v 1.8 1998/09/30 19:04:55 aku Exp $
#
# @c Option processors useable for commandline processing,
# @c evaluation of argument lists given to vararg-procedures
# @c or evaluation of widget options.
#
# @s Option processors
#
# @i option processing, commandline processing
# @i vararg procedures, widget options

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval getopt {
	variable version @base:mFullVersion@
	namespace export *

	# Constant option definition used by 'setup' (the option
	# processor uses itself here!)
	#
	# The shortcut aliases are handcrafted, 'defShortcuts'
	# is not yet available.

	variable  setupDef
	array set setupDef {
	    -type    {::pool::getopt::nonempty ::pool::getopt::notype}
	    -default {::pool::getopt::notype   {}}
	    a,-t	-type
	    a,-ty	-type
	    a,-typ	-type
	    a,-d	-default
	    a,-de	-default
	    a,-def	-default
	    a,-defa	-default
	    a,-defau	-default
	    a,-defaul	-default
	}
    }
}


proc ::pool::getopt::defOption {optDef option args} {
    # @c Convenience procedure helping in the setup of an array
    # @c containing option and alias definitions. Shields users
    # @c from the internal representation of an option/alias
    # @c definition. This procedure places an option definition
    # @c into the array.
    #
    # @a optDef: The name of the array to place the new definition into.
    # @a option: The name of the specified option, without a preceding '-'.
    #
    # @a args:   The specification, given as <option,value>-pairs.
    # @a args:   Processed options are -type and -default.&p
    # @a args:   '-type' will accept every non-empty string and defaults
    # @a args:   to <p ::pool::getopt::notype>. The value will be interpreted
    # @a args:   later as the name of a procedure having 2 arguments and
    # @a args:   returning a boolean value. The arguments will be the name of
    # @a args:   an option and the value given to it, in this order. A result
    # @a args:   of 'false' will be interpreted as 'The value given to the
    # @a args:   option is illegal'.&p
    # @a args:   '-default' will accept everything and defaults to the
    # @a args:   empty string.

    upvar $optDef def
    variable setupDef

    process setupDef $args setup

    set def(-$option) [list $setup(-type) $setup(-default)]
    return
}


proc ::pool::getopt::defAlias {optDef alias option} {
    # @c Convenience procedure helping in the setup of an array
    # @c containing option and alias definitions. Shields users
    # @c from the internal representation of an option/alias
    # @c definition. This procedure places an alias definition
    # @c into the array.
    #
    # @a optDef: The name of the array to place the new definition into.
    # @a alias:  The name of the new alias, without a preceding '-'.
    # @a option: The name of the option the alias refers to, without a
    # @a option: preceding '-'.

    upvar $optDef def
    set def(a,-$alias) -$option
    return
}


proc ::pool::getopt::changeDefault {optDef option newDefault} {
    # @c Convenience procedure easing the way to change the default value of an
    # @c option.
    #
    # @a optDef:     The name of the array holding the option definition.
    # @a option:     The name of the change to change.
    # @a newDefault: The new value to use as default.

    upvar $optDef def
    ::pool::list::exchange def(-$option) 1 $newDefault
    return
}


proc ::pool::getopt::defShortcuts {optDef} {
    # @c Computes the full set of unique shortcuts for a given a set of
    # @c option definitions and adds these as aliases to the array.
    # @c Existing aliases are treated like options.
    #
    # @a optDef: The name of the array to place the shortcuts into.

    upvar $optDef def

    ::pool::array::def temp

    foreach o [array names def -*] {
	set temp([::pool::string::stripPrefix $o -]) .
    }

    foreach a [array names def a,-*] {
	set temp([::pool::string::stripPrefix $a a,-]) .
    }

    ::pool::string::prefixMap temp

    foreach k [array names temp] {
	set oa $temp($k)

	if {[info exists def(a,-$oa)]} {
	    # The shortcut references an alias, convert this
	    # into a reference to the original option

	    set def(a,-$k) $def(a,-$oa)
	} else {
	    # The shortcut references an option, insert it as direct alias.
	    set def(a,-$k) -$oa
	}
    }

    return
}


proc ::pool::getopt::process {optDef optlist optval} {
    # @c Parses <a optlist> as a list of option-value pairs followed
    # @c by normal arguments. The end of the option sequence is
    # @c detected by the presence of arguments not beginning with '-'
    # @c or the single option '--'. Only options and aliases defined
    # @c in <a optDef> are allowed. Values given to an alias are
    # @c stored under the name of the option, *not* the alias. All
    # @c values are stored in the array <a optval>. The option-names
    # @c are used as keys, including the '-'!
    #
    # @c The storage array is initialized with the default values of
    # @c the allowed options. The moment all option values are known
    # @c and not changing anymore the 'type' procedures are called with
    # @c option-names and -values to determine the legality of the
    # @c specified value. The return value 'False' signals an illegal
    # @c value.

    # @a optDef:  The name of the array containing the option and alias
    # @a optDef:  definitions to recognize.
    # @a optlist: The list of arguments to parse.
    # @a optval:  The name of the array to hold the found values.

    # @r A list containing the arguments not processed here.

    upvar $optDef def
    upvar $optval val

    initValues def val

    if {$optlist == {}} {
	return $optlist
    }

    parseArguments def optlist val
    checkValues    def val
    return $optlist
}



proc ::pool::getopt::processOpt {optDef optlist optval} {
    # @c Basically the same functionality as <p ::pool::getopt::process>,
    # @c but with the following differences:&p
    # @c The storage array is *not* initialized with the default values.&p
    # @c The <optlist> must not contain arguments after the
    # @c <option,value>-sequence.&p
    # @c There is no return value.

    # @a optDef:  The name of the array containing the option and alias
    # @a optDef:  definitions to recognize here.
    # @a optlist: The list of arguments to parse.
    # @a optval:  The name of the array to hold the found values.

    upvar $optDef def
    upvar $optval val

    if {$optlist == {}} {
	return
    }

    if {([llength $optlist] % 2) == 1} {
	error "illegal number of item in optlist, must be even"
    }

    # 'array set' might be faster, but handling aliases
    # afterward is impossible as we have no way of knowing
    # wether a particular alias came before or after its
    # non-alias cousins. So we have to do it the hard way!
    #
    # array set val $optlist

    parseArguments def optlist val
    checkValues    def val
    return
}



proc ::pool::getopt::initValues {optDef optVal} {
    # @c Initializes the given storage array with the default values
    # @c of the options in the definition array.

    # @a optDef:  The name of the array containing the option and alias
    # @a optDef:  definitions and their default values
    # @a optVal:  The name of the array to initalize.

    upvar $optDef def
    upvar $optVal val

    foreach option [array names def -*] {
	set val($option) [lindex $def($option) 1]
    }

    return
}



proc ::pool::getopt::checkValues {optDef optVal} {
    # @c Checks the values in the given array using the type checker
    # @c procedures mentioned in the definition array.

    # @a optDef:  The name of the array containing the option and alias
    # @a optDef:  definitions and their type checkers.
    # @a optVal:  The name of the array containing the values to check

    upvar $optDef def
    upvar $optVal val

    foreach o [array names val] {
	if {![[lindex $def($o) 0] $o $val($o)]} {
	    #::puts "checking [lindex $def($o) 0] $o <$val($o)>"
	    error "invalid value given to option $o: $val($o)"
	}
    }

    return
}



proc ::pool::getopt::parseArguments {optDef optList optVal} {
    # @c This is the main parser procedure.

    # @a optDef:  The name of the array containing the option and alias
    # @a optDef:  definitions to recognize here.
    # @a optList: The name of the variable containing the list of arguments
    # @a optList: to parse.
    # @a optVal:  The name of the array to hold the found values.

    upvar $optDef  def
    upvar $optList optlist
    upvar $optVal  val

    while {$optlist != {}} {
	# As long as we have arguments

	set option [lindex $optlist 0]

	switch -glob -- $option {
	    -- {
		# We got the special option separating options and
		# non-option arguments. Remove it from the list,
		# then stop the processor.

		::pool::list::shift optlist
		return
	    }
	    -* {
		# We possibly got an option. Remove it from the
		# argument list, together with its value. Map aliases
		# to their real option, then check wether the option
		# is known or not. If yes, store the value, else raise
		# an error.

		::pool::list::shift optlist
		set optValue [::pool::list::shift optlist]

		if {[info exists def(a,$option)]} {
		    set option $def(a,$option)
		}

		if {[info exists def($option)]} {
		    set val($option) $optValue
		    continue
		}

puts stdout [::pool::dump::callstack getopt-error]
		error "unknown option: $option"
	    }
	    default {
		# A non-option argument. We have left the option-
		# sequence now, stop the processor.

		return
	    }
	}
    }

    return
}



# --- --- --- --- --- --- --- --- ---
# Basic type checker procedures
# --- --- --- --- --- --- --- --- ---


proc ::pool::getopt::notype {o v} {
    # @c This type checker does no checking at all, it just accepts
    # @c everything given to it.

    # @a o: The option whose value is checked.
    # @a v: The value to check.

    # @r Always true, signaling acceptance of the value in <a v>.

    return 1
}



proc ::pool::getopt::nonempty {o v} {
    # @c This type checker accepts every value
    # @c different from the emtpy string/list

    # @a o: The option whose value is checked.
    # @a v: The value to check.

    # @r A boolean value. True if <a v> was not the empty string/list.

    return [expr {($v == {}) ? 0 : 1 }]
}



proc ::pool::getopt::boolean {o v} {
    # @c This type checker accepts only boolean values as recognized by
    # @c the core function Tcl_GetBoolean.

    # @a o: The option whose value is checked.
    # @a v: The value to check.

    # @r A boolean value. True if <a v> contained a boolean value.

    switch -- [string tolower $v] {
	0     -
	1     -
	yes   -
	no    -
	true  -
	false -
	on    -
	off   {
	    return 1
	}
	default {
	    if {[integer $o $v]} {
		return 1
	    }

	    return 0
	}
    }
}



proc ::pool::getopt::integer {o v} {
    # @c This type checker accepts only integer numbers.

    # @a o: The option whose value is checked.
    # @a v: The value to check.

    # @r A boolean value. True if <a v> contained an integer.

    return [regexp {^[0-9]+$} $v]
}


proc ::pool::getopt::number {o v} {
    # @c This type checker accepts all numbers, it makes no
    # @c distinction between integers and floats.

    # @a o: The option whose value is checked.
    # @a v: The value to check.

    # @r A boolean value. True if <a v> contained a number.

    return [expr {! [catch {expr {int($v)}}]}]
}


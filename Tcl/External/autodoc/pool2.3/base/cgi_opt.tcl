# -*- tcl -*-
#
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
#	(C) 1999 Andreas Kupries <a.kupries@westend.cm>
#
# CVS: $Id: cgi_opt.tcl,v 1.1 1999/02/14 19:48:12 aku Exp $
#
# @c Defines an option handling package like the standard one coming with
# @c Pool_base, see <f base/getopt.tcl>, but using [strong {key=value}] pairs
# @c to specify data instead of [strong {-key value}] as is usual. This is
# @c done to blend in with the standard attribute handling of cgi and HTML.
# @c Uses the functionality of <f base/getopt.tcl> internally. Especially the
# @c typecheckers are borrowed from that part of the Pool.
#
# @s Option handling
# @i options, key, value, attribute, cgi, html

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

source [file join [::pool::file::here] getopt.tcl]

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval cgi {
	variable version @base:mFullVersion@
	namespace export *

	# Get some important interface procedure from 'getopt'.

	namespace import ::pool::getopt::defOption
	namespace import ::pool::getopt::defAlias
	namespace import ::pool::getopt::changeDefault
	namespace import ::pool::getopt::defShortcuts

	# -----------------------------------------------------
    }
}

# -----------------------------------------------------
# Now we are ready to define our unique processing
# functionality.

proc ::pool::cgi::process {optDef optlist optval} {
    # @c Parses <a optlist> as a list of key=value elements followed
    # @c by normal arguments. The end of the option sequence is
    # @c detected by the presence of arguments not containing '='.
    # @c Only options and aliases defined in <a optDef> are allowed.
    # @c Values given to an alias are stored under the name of the
    # @c option, *not* the alias. All values are stored in the array
    # @c <a optval>. The option-names are used as keys.
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



proc ::pool::cgi::processOpt {optDef optlist optval} {
    # @c Basically the same functionality as <p ::pool::cgi::process>,
    # @c but with the following differences:&p The storage array is
    # @c [strong not] initialized with the default values.&p
    # @c The <optlist> must not contain arguments after the
    # @c key=value elements.&p There is no return value.

    # @a optDef:  The name of the array containing the option and alias
    # @a optDef:  definitions to recognize here.
    # @a optlist: The list of arguments to parse.
    # @a optval:  The name of the array to hold the found values.

    upvar $optDef def
    upvar $optval val

    if {$optlist == {}} {
	return
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



proc ::pool::cgi::initValues {optDef optVal} {
    # @c Initializes the given storage array with the default values
    # @c of the options in the definition array.

    # @a optDef:  The name of the array containing the option and alias
    # @a optDef:  definitions and their default values
    # @a optVal:  The name of the array to initalize.

    upvar $optDef def
    upvar $optVal val

    foreach option [array names def -*] {
	# cut the '-', it is not used here.
	set option [string range $option 1 end]
	set val(-$option) [lindex $def(-$option) 1]
    }

    return
}



proc ::pool::cgi::checkValues {optDef optVal} {
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
	    error "invalid value given to attribute $o: $val($o)"
	}
    }

    return
}



proc ::pool::cgi::parseArguments {optDef optList optVal} {
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
	    *=* {
		# We possibly got an attribute. Remove it from the
		# argument list, together with its value. Map aliases
		# to their real option, then check wether the option
		# is known or not. If yes, store the value, else raise
		# an error.

		::pool::list::shift optlist
		set optValue  [lindex [split $option =] 1]
		set option   -[lindex [split $option =] 0]

		if {[info exists def(a,$option)]} {
		    set option $def(a,$option)
		}

		if {[info exists def($option)]} {
		    set val($option) $optValue
		    continue
		}

		#puts stdout [::pool::dump::callstack cgi-error]
		parray def
		error "unknown attribute: $option"
	    }
	    default {
		# A non-attribute argument. We have left the attribute-
		# sequence now, stop the processor.

		return
	    }
	}
    }

    return
}




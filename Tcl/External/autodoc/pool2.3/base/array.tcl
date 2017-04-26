# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: array.tcl,v 1.5 1998/06/01 19:55:13 aku Exp $
#
# @c Convenient array procedures
# @s Array procedures.
# @i Array procedures

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval array {
	variable version @base:mFullVersion@
	namespace export *
    }
}


proc ::pool::array::def {name} {
    # @c Creates an array-variable of <a name>. Destroys an existing
    # @c variable of the given name.
    #
    # @a name: name of the variable to define.
    #
    # @i define array, array definition

    upvar $name array
    catch {unset array}
    set   array(_) {}
    unset array(_)
    return
}


proc ::pool::array::clear {a {pattern {}}} {
    # @c          Clear the array <a a> or parts of it (keys
    # @c          matching the <a pattern>).
    #
    # @a a:       name of the array variable to modify.
    # @a pattern: Clear entries matching the pattern only, or
    # @a pattern: all, if default is used
    #
    # @i clearing an array, array clearing

    upvar $a array

    if {$pattern != {}} {
	# use pattern, clear only matching entries
	foreach key [array names array $pattern] {
	    unset array($key)
	}
    } else {
	# remove all entries in the array
	foreach key [array names array] {
	    unset array($key)
	}
    }

    return
}


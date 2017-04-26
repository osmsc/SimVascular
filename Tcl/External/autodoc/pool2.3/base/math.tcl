# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS:	$Id: math.tcl,v 1.2 2000/07/31 19:15:15 aku Exp $
#
# @c Some mathematical procedures
# @s Mathematical procedures
# --------------------


package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval math {
	variable version @base:mFullVersion@
	namespace export *
    }
}



proc ::pool::math::min {x y} {
    # @a x: First number to check
    # @a y: Second number to check
    # @r Minimum of <a x> and <a y>.
    # @i minimum search

    if {$x < $y} {
	return $x
    } else {
	return $y
    }
}



proc ::pool::math::max {x y} {
    # @a x: First number to check
    # @a y: Second number to check
    # @r Maximum of <a x> and <a y>.
    # @i maximum search

    if {$x > $y} {
	return $x
    } else {
	return $y
    }
}



# Same as above, but for an arbitrary number of arguments

proc ::pool::math::minVarargs {args} {
    # @c Determines the minimum of an arbitrary number of
    # @c arguments. Uses <p ::pool::math::minList> to accomplish this.
    # @a args: list of numbers to search the minimum in.
    # @r Minimum element in  <a args>.
    # @i minimum search

    return [minList $args]
}



proc ::pool::math::maxVarargs {args} {
    # @c Determines the maximum of an arbitrary number of
    # @c arguments. Uses <p ::pool::math::maxList> to accomplish this.
    # @a args: list of numbers to search the maximum in.
    # @r Maximum element in  <a args>.
    # @i maximum search

    return [maxList $args]
}



proc ::pool::math::minList {list} {
    # @c Determines the minimum number contained in <a list>.
    # @a list: list of numbers to search the minimum in.
    # @r Minimum element in  <a list>.
    # @i minimum search

    set min [::pool::list::shift list]
    foreach e $list {
	setMin min $e
    }
    return $min
}



proc ::pool::math::maxList {list} {
    # @c Determines the maximum number contained in <a list>.
    # @a list: list of numbers to search the maximum in.
    # @r Maximum element in  <a list>.
    # @i maximum search

    set max [::pool::list::shift list]
    foreach e $list {
	setMax max $e
    }
    return $max
}



# setmax / setmin copied from exmh-2.0beta/lib/utils.tcl

proc ::pool::math::setMax {varName value} {
    # @author Brent Welch <welch@ajubasolutions.com>

    # @c Set the variable <a varName> to the maximum of its
    # @c current and the specified <a value>.
    # @a varName: The name of the variable to maximize.
    # @a value: The value to compare against.
    # @r 1 if the value of the variable, 0 else.
    # @i maximum search

    upvar $varName var
    if {![info exists var] || ($value > $var)} {
	set var $value
	return 1
    } 

    return 0
}


proc ::pool::math::setMin {varName value} {
    # @author Brent Welch <welch@ajubasolutions.com>

    # @c Set the variable <a varName> to the minimum of its
    # @c current and the specified <a value>.
    # @a varName: The name of the variable to minimize.
    # @a value: The value to compare against.
    # @r 1 if the value of the variable, 0 else.
    # @i minimum search

    upvar $varName var
    if {![info exists var] || ($value < $var)} {
	set var $value
	return 1
    } 

    return 0
}


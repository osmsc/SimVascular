# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS : $Id: lists.tcl,v 1.11 2000/07/31 19:15:15 aku Exp $
#
# @c Collection of useful list operations
# @s list operations
# @i list operations
# --------------------------

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval list {
	variable version @base:mFullVersion@
	namespace export *
    }
}


proc ::pool::list::head {list} {
    # @r The first element of <a list>.
    # @a list: The list to look at.

    return [lindex $list 0]
}



proc ::pool::list::tail {list} {
    # @r Everything behind the first element of <a list>.
    # @a list: The list to look at.

    return [lrange $list 1 end]
}



proc ::pool::list::last {list} {
    # @r The last element of <a list>.
    # @a list: The list to look at.

    return [lindex $list end]
}



proc ::pool::list::prev {list} {
    # @r Everything before the last element of <a list>.
    # @a list: The list to look at.

    if {$list == {}} {
	return {}
    } else {
	return [lreplace $list end end]
    }
}



proc ::pool::list::shift {listVar} {
    # @c The list stored in the variable <a listVar> is shifted down by one.
    #
    # @a listVar: name of the variable containing the list to manipulate.
    #
    # @r The first element of the list stored in <a listVar>,
    # @r or {} for an empty list. The latter is not a sure signal,
    # @r as the list may contain empty elements.

    upvar $listVar list

    if {[llength $list] == 0} {
	return {}
    } else {
	set first [lindex $list 0]
	set list  [lrange $list 1 end]
	return $first
    }
}


proc ::pool::list::prepend {listVar newElement} {
    # @c The list stored in the variable <a listVar> is shifted up by one.
    # @c <a newElement> is inserted afterward into the now open head position.
    #
    # @a listVar:    The name of the variable containing the list to
    # @a listVar:    manipulate.
    # @a newElement: Data to insert before the head of the list.
    #
    # @n The same as <p ::pool::list::unshift>, just under a different name.
    #
    # @r <a newElement>

    upvar $listVar list

    if {{} == $list} {
	# no deletion, just insert before current first element
	lappend list $newElement
    } else {
	set list [lreplace $list 0 -1 $newElement]
    }
    return $newElement
}


proc ::pool::list::unshift {listVar newElement} {
    # @c The list stored in the variable <a listVar> is shifted up by one.
    # @c <a newElement> is inserted afterward into the now open head position.
    #
    # @a listVar:    The name of the variable containing the list to
    # @a listVar:    manipulate.
    # @a newElement: Data to insert before the head of the list.
    #
    # @n The same as <p ::pool::list::prepend>, just under a different name.
    #
    # @r <a newElement>

    upvar $listVar list

    if {{} == $list} {
	# no deletion, just insert before current first element
	lappend list $newElement
    } else {
	set list [lreplace $list 0 -1 $newElement]
    }
    return $newElement
}



proc ::pool::list::push {listvar args} {
    # @c The same as 'lappend', provided for symmetry only.
    #
    # @a listvar: The name of the variable containing the list to
    # @a listvar: manipulate.
    # @a args:    List of objects to append to the list.
    #
    # @r As of 'lappend'.

    upvar $listvar list
    return [eval lappend list $args]
}



proc ::pool::list::pop {listVar} {
    # @c Removes the last element of the list
    # @c contained in variable <a listVar>.
    #
    # @r The last element of the list, or {} in case of an empty list.
    #
    # @a listVar: name of variable containing the list to manipulate.

    upvar $listVar list

    if {[llength $list] == 0} {
	return {}
    } else {
	set lastItem [lindex   $list end]
	set list     [lreplace $list end end]
	return $lastItem
    }
}



proc ::pool::list::remove {listVar position} {
    # @c Removes the item at <a position> from the list
    # @c stored in variable <a listVar>.
    #
    # @r The changed list.
    #
    # @a listVar:  The name of variable containing the list to manipulate.
    # @a position: index of the element to remove.

    upvar $listVar list
    return [set list [lreplace $list $position $position]]
}



proc ::pool::list::reverse {list} {
    # @r Returns the reversed <a list>.
    # @a list: the list to manipulate.

    # quick exit for simple case
    if {{} == $list} {
	return {}
    }

    # revert list
    set result ""
    set  i [llength $list]
    incr i -1
    while {$i >= 0} {
	lappend result [lindex $list $i]
	incr i -1
    }

    return $result
}



proc ::pool::list::uniq {list} {
    # @c Removes duplicate entries from <a list>.
    # @r The modified list.
    # @a list: The list to manipulate.

    if {[llength $list] < 2} {
	# quick exit for simple cases
	return $list
    }

    # <list> contains at least 2 elements.

    set result ""
    ::pool::array::def known

    foreach item $list {
	if {[info exists known($item)]} {
	    continue
	}
	lappend result $item
	set known($item) 1
    }

    return $result
}



# lassign / ldelete were copied from exmh-2.0beta/lib/utils.tcl

proc ::pool::list::assign {varList list} {
    # @author Brent Welch <welch@ajubasolutions.com>

    # @c Assign a set of variables from a list of values.
    # @c If there are more values than variables, they are
    # @c ignored. If there are fewer values than variables,
    # @c the variables get the empty string.
    #
    # @a varList: List of variables to assign the values to.
    # @a list:    The list to assign to the variables.

    if {[string length $list] == 0} {
	foreach var $varList {
	    uplevel [list set $var {}]
	}
    } else {
	# thats a hack here, uses the new capabilities of 'foreach'
	# to handle a list of variables.
	uplevel [list foreach $varList $list { break }]
    }

    return
}



proc ::pool::list::delete {listVar value} {
    # @author Brent Welch <welch@ajubasolutions.com>

    # @c Delete an item from the list stored in <a listVar>, by <a value>.
    # @r 1 if the item was present, else 0.
    #
    # @a listVar: The name of the variable containing the list to
    # @a listVar: manipulate.
    # @a value:   The value searched (and deleted from the list).

    upvar $listVar list

    if ![info exist list] {
	return 0
    }

    set ix [lsearch $list $value]

    if {$ix >= 0} {
	set list [lreplace $list $ix $ix]
	return 1
    } else {
	return 0
    }
}



proc ::pool::list::filter {list pattern} {
    # @c All words contained in the list <a pattern>
    # @c are removed from <a list>.
    # @c In set-notation: result = list - pattern

    # @r Setdifference of <a list> and <a pattern>

    # @a list:    The list to filter
    # @a pattern: The list of words to remove from <a list>

    set res {}
    foreach w $list {
	if {[lsearch $pattern $w] < 0} {
	    lappend res $w
	}
    }

    return $res
}



proc ::pool::list::match {list pattern} {
    # @c All words not contained in list <a pattern>
    # @c are removed from <a list>.
    # @c In set-notation: result = intersect (list, pattern).
    # @c This is not completely true, duplicate entries in 'list' remain in the
    # @c result, given that they appear at all.

    # @r Nearly the intersection of <a list> and <a pattern>

    # @a list:    The list to filter
    # @a pattern: The list of words to accept in <a list>

    set res {}
    foreach w $list {
	if {[lsearch $pattern $w] < 0} {
	    continue
	}
	lappend res $w
    }

    return $res
}




proc ::pool::list::lengthOfLongestEntry {list} {
    # @c Determines the length of the longest entry contained
    # @c in the <a list>.

    # @a list: The list to look at.

    # @r The length of the longest entry.

    set ml 0

    foreach s $list {
	set len [string length $s]
	if {$len > $ml} {
	    set ml $len
	}
    }

    return $ml
}



proc ::pool::list::apply {cmd list} {
    # @c Applies <a cmd> to all entries of <a list> and concatenates
    # @c the individual results into a single list. The <a cmd>
    # @c must accept exactly one argument.

    # @a list: The list to look at.
    # @a cmd:  The command executed for each entry.

    # @r A list containing all results of the application of <a cmd>
    # @r to the <a list>.

    set res {}
    foreach e $list {
	lappend res [uplevel $cmd $e]
    }
    return $res
}



proc ::pool::list::projection {list column} {
    # @c Treats <a list> as list of lists and extracts
    # @c the <a column>'th element of each list item.
    # @c If <a list> is seen as matrix, then the procedure
    # @c returns the data of the specified <a column>.
    #
    # @r A list containing the extracted items.
    #
    # @a list: The list to search through.
    # @a column: Index of the column to extract from <a list>.

    set cdata ""
    foreach item $list {
	lappend cdata [lindex $item $column]
    }
    return $cdata
}


proc ::pool::list::exchange {listVar position newItem} {
    # @c Removes the item at <a position> from the list stored
    # @c in variable <a listVar> and inserts <a newItem> in
    # @c its place.
    #
    # @argument listVar: Name of variable containing the list
    # @argument listVar: to be manipulated.
    # @argument position: Index of the element to remove.
    # @argument newItem:  The element to insert into the place
    # @argument newItem:  of the removed one.
    #
    # @result The changed list.

    upvar $listVar list
    return [set list [lreplace $list $position $position $newItem]]
}


proc ::pool::list::select {list indices} {
    # @author: Christopher Nelson <chris@pinebush.com>
    # @c General permutation / selection of list elements. Takes the elements
    # @c of <a list> whose <a indices> were given to the command and returns
    # @c a new list containing them, in the specified order.
    # @a list: The list to select from, the list to permute.
    # @a indices: A list containing the indices of the elements to select.
    # @r is a list containing the selected elementes, in the order specified
    # @r by <a indices>.

    set result {}

    foreach i $indices {
	lappend result [lindex $list $i]
    }

    return $result
}


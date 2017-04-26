# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/monthList.cls'.
# Date: Thu Sep 14 23:03:53 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> monthList <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Pool_GuiBase

# Namespace describing the class
namespace eval ::pool::oo::class::monthList {
    variable  _superclasses    valueManager
    variable  _scChainForward  monthList
    variable  _scChainBackward monthList
    variable  _classVariables  {}
    variable  _methods         {OnWrap SetupList TrackUserChanges constructor createSubwidgets down setBindings setBindingsTo up updateDisplay}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {onwrap {monthList {-default {} -type ::pool::getopt::notype -action {} -class Onwrap}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {down . createSubwidgets . TrackUserChanges . up . updateDisplay . setBindingsTo . SetupList . constructor . setBindings . OnWrap .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::monthList::OnWrap {direction} {
    ::pool::oo::support::SetupVars monthList
    # @c Evaluates the script associated with wraparounds.
	# @a direction: The direction of the current wraparound, has to be one
	# @a direction: of 'up' or 'down'.

	if {[string compare $opt(-onwrap) ""] == 0} {
	    return
	}

	uplevel #0 $opt(-onwrap) $direction
	return
}



proc ::pool::oo::class::monthList::SetupList {} {
    ::pool::oo::support::SetupVars monthList
    # @c Initializes the internal listbox, adds the names of all months.

	$this.monthlist delete 0 end

	foreach m {1 2 3 4 5 6 7 8 9 10 11 12} {
	    $this.monthlist insert end  [::pool::string::cap [::pool::date::monthName $m]]
	}

	return
}



proc ::pool::oo::class::monthList::TrackUserChanges {} {
    ::pool::oo::support::SetupVars monthList
    # @c Callback. Used by the internal listbox to forward changes made to
	# @c the display into the internal datastructures.

	set               m [$this.monthlist curselection]
	incr              m
	configure -value $m
	return
}



proc ::pool::oo::class::monthList::constructor {} {
    ::pool::oo::support::SetupVars monthList
    # @c Initialize the value to the current month if not set already by
	# @c the user.

	if {[string compare $opt(-value) ""] == 0} {
	    ::pool::date::split [::pool::date::now] dummy opt(-value) dummy
	}
	return
}



proc ::pool::oo::class::monthList::createSubwidgets {} {
    ::pool::oo::support::SetupVars monthList
    # @c Generate the subwidgets and their layout.

	listbox $this.monthlist                 -highlightthickness  0          -selectmode          single     -width               12         -height              12         -bd                  0          -relief              flat

	SetupList

	pack $this.monthlist -side left -fill both -expand 1
	return
}



proc ::pool::oo::class::monthList::down {} {
    ::pool::oo::support::SetupVars monthList
    # @c Callback. Decrements the chosen month by one.
	# @c Triggers a wraparound at the start of the year.

	set m $opt(-value)
	if {$m == 1} {
	    set m 12
	    OnWrap down
	} else {
	    incr m -1
	}

	configure -value $m
	return
}



proc ::pool::oo::class::monthList::setBindings {} {
    ::pool::oo::support::SetupVars monthList
    # @c Associate bindings for this widget with its internal components.

	bind _${this}_tracksel [list ${this}::TrackUserChanges]

	bind _${this}_keys +                 [list ${this}::up]
	bind _${this}_keys -                 [list ${this}::down]
	bind _${this}_keys <Key-KP_Add>      [list ${this}::up]
	bind _${this}_keys <Key-KP_Subtract> [list ${this}::down]

	::pool::ui::prependBindTag $this.monthlist _${this}_keys
	::pool::ui::appendBindTag  $this.monthlist _${this}_tracksel
	return
}



proc ::pool::oo::class::monthList::setBindingsTo {w} {
    ::pool::oo::support::SetupVars monthList
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag $w _${this}_keys
	return
}



proc ::pool::oo::class::monthList::up {} {
    ::pool::oo::support::SetupVars monthList
    # @c Callback. Increments the chosen month by one.
	# @c Triggers a wraparound at the end of the year.

	set m $opt(-value)

	if {$m == 12} {
	    set m 1
	    OnWrap up
	} else {
	    incr m
	}

	configure -value $m
}



proc ::pool::oo::class::monthList::updateDisplay {} {
    ::pool::oo::support::SetupVars monthList
    # @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display.

	$this.monthlist selection clear 0 end
	$this.monthlist selection set [expr {$opt(-value) - 1}]
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::monthList::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences monthList

# Create object instantiation procedure
interp alias {} monthList {} ::pool::oo::support::New monthList

# -------------------------------


# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/monthListTix.cls'.
# Date: Thu Sep 14 23:03:53 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> monthListTix <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
# this browser does not use a list, but a TIX combobox.
	package require Tix
	package require Pool_GuiBase

# Namespace describing the class
namespace eval ::pool::oo::class::monthListTix {
    variable  _superclasses    valueManager
    variable  _scChainForward  monthListTix
    variable  _scChainBackward monthListTix
    variable  _classVariables  {}
    variable  _methods         {OnWrap SetupList TrackUserChanges constructor createSubwidgets down setBindings setBindingsTo up updateDisplay}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {onwrap {monthListTix {-default {} -type ::pool::getopt::notype -action {} -class Onwrap}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {down . createSubwidgets . TrackUserChanges . up . updateDisplay . setBindingsTo . SetupList . constructor . setBindings . OnWrap .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::monthListTix::OnWrap {direction} {
    ::pool::oo::support::SetupVars monthListTix
    # @c executes the script associated with wraparounds
	# @a direction: direction of wraparound, one of 'up' and 'down'.

	if {{} == $opt(-onwrap)} {
	    return
	}

	uplevel #0 $opt(-onwrap) $direction
	return
}



proc ::pool::oo::class::monthListTix::SetupList {} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Initializes the internal combobox, adds the names of all months.

	$this.months subwidget listbox delete 0 end

	foreach m {1 2 3 4 5 6 7 8 9 10 11 12} {
	    $this.months subwidget listbox insert end  [::pool::string::cap [::pool::date::monthName $m]]
	}

	return
}



proc ::pool::oo::class::monthListTix::TrackUserChanges {newvalue} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Callback. Used by the internal tix combobox to forward external
	# @c changes to the display to the internal datastructures.
	#
	# @a newvalue: The new value displayed by the combobox.

	configure -value [::pool::date::monthNumber $newvalue]
	return
}



proc ::pool::oo::class::monthListTix::constructor {} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Initialize the value to the current month if not set already by
	# @c the user.

	if {[string compare $opt(-value) ""] == 0} {
	    ::pool::date::split [::pool::date::now] dummy opt(-value) dummy
	}
	return
}



proc ::pool::oo::class::monthListTix::createSubwidgets {} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Generate the subwidgets and their layout.

	tixComboBox $this.months                       -dropdown 1                            -editable            0                 -grab                local             -selectmode          immediate         -highlightthickness  0                 -bd                  0                 -relief              flat

	SetupList

	pack $this.months -side left -fill both -expand 1

	after idle $this.months configure -command  [list [list $this TrackUserChanges]]
	return
}



proc ::pool::oo::class::monthListTix::down {} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Decrements the chosen month by one.
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



proc ::pool::oo::class::monthListTix::setBindings {} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Associate bindings for this widget with its internal components.

	bind _${this}_keys +                 [list ${this}::up]
	bind _${this}_keys -                 [list ${this}::down]
	bind _${this}_keys <Key-KP_Add>      [list ${this}::up]
	bind _${this}_keys <Key-KP_Subtract> [list ${this}::down]

	::pool::ui::prependBindTag $this.months _${this}_keys
	return
}



proc ::pool::oo::class::monthListTix::setBindingsTo {w} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag $w _${this}_keys
	return
}



proc ::pool::oo::class::monthListTix::up {} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Increments the chosen month by one.
	# @c Triggers a wraparound at the end of the year.

	set m $opt(-value)

	if {$m == 12} {
	    set m 1
	    OnWrap up
	} else {
	    incr m
	}

	configure -value $m
	return
}



proc ::pool::oo::class::monthListTix::updateDisplay {} {
    ::pool::oo::support::SetupVars monthListTix
    # @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display.

	# Set combobox to the string corresponding to the currently chosen
	# month

	set index    [expr {$opt(-value) - 1}]
	set newValue [$this.months subwidget listbox get $index]

	$this.months configure -value $newValue
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::monthListTix::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences monthListTix

# Create object instantiation procedure
interp alias {} monthListTix {} ::pool::oo::support::New monthListTix

# -------------------------------


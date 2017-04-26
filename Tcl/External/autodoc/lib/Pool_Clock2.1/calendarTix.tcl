# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/calendarTix.cls'.
# Date: Thu Sep 14 23:03:52 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> calendarTix <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Tix
	package require Pool_GuiBase

# Namespace describing the class
namespace eval ::pool::oo::class::calendarTix {
    variable  _superclasses    valueManager
    variable  _scChainForward  calendarTix
    variable  _scChainBackward calendarTix
    variable  _classVariables  {}
    variable  _methods         {MaxDay TrackDay TrackMonth TrackOrder TrackYear WrapY constructor createSubwidgets setBindings setBindingsTo updateDisplay}

    variable  _variables
    array set _variables  {monlen {calendarTix {isArray 0 initialValue {}}} year {calendarTix {isArray 0 initialValue {}}} day {calendarTix {isArray 0 initialValue {}}} month {calendarTix {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {order {calendarTix {-default ymd -type ::pool::ui::ymdOrder -action TrackOrder -class Order}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {MaxDay . createSubwidgets . updateDisplay . TrackOrder . setBindingsTo . TrackYear . constructor . setBindings . TrackDay . TrackMonth . WrapY .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::calendarTix::MaxDay {} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Determines the value triggering an upward wraparound.
	# @r Lowest value above the length of the month considered
	# @r as invalid for the day widget.

	return [expr {1+$monlen}]
}



proc ::pool::oo::class::calendarTix::TrackDay {d} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Callback for subordinate day widget.
	# @c Executed every time its value is set (not necessarily changed).
	# @n Does nothing, if no change took place (avoids infinite recursion).
	# @a d: The (possibly) new value of the chosen day.
	# @c Touching the lower or upper bound triggers a decrement/increment
	# @c operation for month and year (ripple counter, wrap around).

	if {$d == 0} {
	    # wrap down
	    $this.month down
	    set d $monlen
	} elseif {$d == (1+$monlen)} {
	    # wrap up
	    $this.month up
	    set d 1
	}

	configure -value [::pool::date::join $year $month $d]
	return
}



proc ::pool::oo::class::calendarTix::TrackMonth {m} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Callback for subordinate month widget.
	# @c Executed every time its value is set (not necessarily changed).
	# @n Does nothing, if no change took place (avoids infinite recursion).
	# @a m: The (possibly) new value of the chosen month.

	set month $m
	configure -value [::pool::date::join $year $m $day]
	return
}



proc ::pool::oo::class::calendarTix::TrackOrder {o oldValue} {
    ::pool::oo::support::SetupVars calendarTix
    # @c The widget defined allows arbitrary ordering of its
	# @c components. The corresponding option is -order.
	# @c This method is called everytime the option was set
	# @c and executes the necessary relayout.
	#
	# @a o: The name of the changed option, always '-order'.
	# @a oldValue: The old value of the option.

	switch $opt(-order) {
	    ymd {
		pack $this.year  -side left -fill both -expand 0 -in $this
		pack $this.month -side left -fill both -expand 1 -in $this
		pack $this.day   -side left -fill both -expand 0 -in $this
	    }
	    ydm {
		pack $this.year  -side left -fill both -expand 0 -in $this
		pack $this.day   -side left -fill both -expand 0 -in $this
		pack $this.month -side left -fill both -expand 1 -in $this
	    }
	    dym {
		pack $this.day   -side left -fill both -expand 0 -in $this
		pack $this.year  -side left -fill both -expand 0 -in $this
		pack $this.month -side left -fill both -expand 1 -in $this
	    }
	    myd {
		pack $this.month -side left -fill both -expand 1 -in $this
		pack $this.year  -side left -fill both -expand 0 -in $this
		pack $this.day   -side left -fill both -expand 0 -in $this
	    }
	    mdy {
		pack $this.month -side left -fill both -expand 1 -in $this
		pack $this.day   -side left -fill both -expand 0 -in $this
		pack $this.year  -side left -fill both -expand 0 -in $this
	    }
	    dmy {
		pack $this.day   -side left -fill both -expand 0 -in $this
		pack $this.month -side left -fill both -expand 1 -in $this
		pack $this.year  -side left -fill both -expand 0 -in $this
	    }
	}

	return
}



proc ::pool::oo::class::calendarTix::TrackYear {y} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Callback for subordinate year widget.
	# @c Executed every time its value is set (not necessarily changed).
	# @n Does nothing, if no change took place (avoids infinite recursion).
	# @a y: The (possibly) new value of the chosen year.

	set year $y
	configure -value [::pool::date::join $y $month $day]
	return
}



proc ::pool::oo::class::calendarTix::WrapY {d} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Increment/decrement operator for subordinate year widget.
	# @a d: direction of wrap, must be one of 'up' or 'down'.

	switch $d {
	    up      {$this.year incr}
	    down    {$this.year decr}
	    default {error "illegal wrap direction $d"}
	}
	return
}



proc ::pool::oo::class::calendarTix::constructor {} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Initializes the value to the current date if not set already by
	# @c the user.

	set now [::pool::date::now]

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) $now
	}

	# Compute derived information for the first time.

	::pool::date::split $now year month day
	set monlen  [::pool::date::monthLength [::pool::date::2month $opt(-value)]]
	return
}



proc ::pool::oo::class::calendarTix::createSubwidgets {} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Called by the framework to generate the subwidgets and their
	# @c layout.

	tixControl $this.year                  -value              $year      -integer            1          -min                1800       -highlightthickness 0          
		
	monthListTix $this.month               -value              $month     -highlightthickness 0          -relief             sunken     -bd                 2          -onwrap             [list ${this}::WrapY]

	tixControl $this.day                        -value              $day            -highlightthickness 0               -min                0               -max                [MaxDay]

	$this.year  configure -command [list ${this}::TrackYear]
	$this.month configure -command [list ${this}::TrackMonth]
	$this.day   configure -command [list ${this}::TrackDay]

	# Layout dependent on value of -order.
	TrackOrder -order {}
	return
}



proc ::pool::oo::class::calendarTix::setBindings {} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Adds various keyboard accelerators to the calendar components.

	$this.month setBindingsTo $this
	$this.month setBindingsTo $this.year
	$this.month setBindingsTo $this.day

	bind _${this}_keys <Key-Left>  [list ${this}.day  decr]
	bind _${this}_keys <Key-Right> [list ${this}.day  incr]
	bind _${this}_keys <Key-Up>    [list ${this}.year incr]
	bind _${this}_keys <Key-Down>  [list ${this}.year decr]

	::pool::ui::prependBindTag $this.year  _${this}_keys
	::pool::ui::prependBindTag $this.month _${this}_keys
	::pool::ui::prependBindTag $this.day   _${this}_keys
	return
}



proc ::pool::oo::class::calendarTix::setBindingsTo {w} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	$this.month setBindingsTo  $w
	::pool::ui::prependBindTag $w _${this}_keys
	return
}



proc ::pool::oo::class::calendarTix::updateDisplay {} {
    ::pool::oo::support::SetupVars calendarTix
    # @c Method required by superclass <c valueManager>
	# @c to propagate changes to the value into the display.

	::pool::date::split $opt(-value) year month day
	set monlen  [::pool::date::monthLength [::pool::date::2month $opt(-value)]]

	$this.year  configure -value $year
	$this.month configure -value $month
	$this.day   configure -value $day   -max [MaxDay]
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::calendarTix::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences calendarTix

# Create object instantiation procedure
interp alias {} calendarTix {} ::pool::oo::support::New calendarTix

# -------------------------------


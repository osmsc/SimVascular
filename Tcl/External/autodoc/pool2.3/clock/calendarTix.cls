# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Clock @clock:mFullVersion@
#
# CVS: $Id: calendarTix.cls,v 1.2 1998/06/02 20:05:09 aku Exp $
#
# @c Calendar widget to choose a date.
# @s Calendar widget, tix
# @i calendar, choosing a date, date choice, tix
# @see <c monthListTix>, <c calendar>
# -------------------------------------------


class calendarTix : valueManager {

    init {
	package require Tix
	package require Pool_GuiBase
    }

    # @o order: Selection and order of the subwidgets.
    option order -d {ymd} -a TrackOrder -t  ::pool::ui::ymdOrder

    # Information derived from opt(-value)
    #
    # @v year:   Currently chosen year
    # @v month:  Currently chosen month
    # @v day:    Currently chosen day in the month
    # @v monlen: Length of the currently chosen date

    var year
    var month
    var day
    var monlen


    method calendarTix {} {
	# @c Initializes the value to the current date if not set already by
	# @c the user.

	set now [::pool::date::now]

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) $now
	}

	# Compute derived information for the first time.

	::pool::date::split $now year month day
	set monlen \
		[::pool::date::monthLength [::pool::date::2month $opt(-value)]]
	return
    }



    method createSubwidgets {} {
	# @c Called by the framework to generate the subwidgets and their
	# @c layout.

	tixControl $this.year                 \
		-value              $year     \
		-integer            1         \
		-min                1800      \
		-highlightthickness 0         \

		
	monthListTix $this.month              \
		-value              $month    \
		-highlightthickness 0         \
		-relief             sunken    \
		-bd                 2         \
		-onwrap             [list ${this}::WrapY]

	tixControl $this.day                       \
		-value              $day           \
		-highlightthickness 0              \
		-min                0              \
		-max                [MaxDay]

	$this.year  configure -command [list ${this}::TrackYear]
	$this.month configure -command [list ${this}::TrackMonth]
	$this.day   configure -command [list ${this}::TrackDay]

	# Layout dependent on value of -order.
	TrackOrder -order {}
	return
    }



    method setBindings {} {
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



    method setBindingsTo {w} {
	# @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	$this.month setBindingsTo  $w
	::pool::ui::prependBindTag $w _${this}_keys
	return
    }



    method updateDisplay {} {
	# @c Method required by superclass <c valueManager>
	# @c to propagate changes to the value into the display.

	::pool::date::split $opt(-value) year month day
	set monlen \
		[::pool::date::monthLength [::pool::date::2month $opt(-value)]]

	$this.year  configure -value $year
	$this.month configure -value $month
	$this.day   configure -value $day   -max [MaxDay]
	return
    }



    method TrackYear  {y} {
	# @c Callback for subordinate year widget.
	# @c Executed every time its value is set (not necessarily changed).
	# @n Does nothing, if no change took place (avoids infinite recursion).
	# @a y: The (possibly) new value of the chosen year.

	set year $y
	configure -value [::pool::date::join $y $month $day]
	return
    }



    method TrackMonth {m} {
	# @c Callback for subordinate month widget.
	# @c Executed every time its value is set (not necessarily changed).
	# @n Does nothing, if no change took place (avoids infinite recursion).
	# @a m: The (possibly) new value of the chosen month.

	set month $m
	configure -value [::pool::date::join $year $m $day]
	return
    }



    method TrackDay {d} {
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



    method WrapY {d} {
	# @c Increment/decrement operator for subordinate year widget.
	# @a d: direction of wrap, must be one of 'up' or 'down'.

	switch $d {
	    up      {$this.year incr}
	    down    {$this.year decr}
	    default {error "illegal wrap direction $d"}
	}
	return
    }



    method MaxDay {} {
	# @c Determines the value triggering an upward wraparound.
	# @r Lowest value above the length of the month considered
	# @r as invalid for the day widget.

	return [expr {1+$monlen}]
    }



    method TrackOrder {o oldValue} {
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
}


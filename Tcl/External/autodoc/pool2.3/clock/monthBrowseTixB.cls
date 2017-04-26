# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Clock @clock:mFullVersion@
#
# CVS: $Id: monthBrowseTixB.cls,v 1.2 1998/06/02 20:05:09 aku Exp $
#
# @c Widget to choose month and year
# @s Year/month choice, tix
# @i calendar, choosing month and year, year/month choice, tix
# @see <c monthList>, <c calendarTix>
# -----------------------------------------------

class monthBrowserTixB : valueManager {

    init {
	package require Pool_GuiBase
	package require Tix
    }


    # the stored value is a aggregation of month and year in the format mm/yyyy

    # parameters

    # @o charwidth: Width of the widget in characters.
    option charwidth -d 12 -a TrackCharWidth 

    # @o order: Order of components: The year browser is packed to the left or
    # @o order: right of the month list.

    option order -d ym -a TrackOrder -t ::pool::ui::ymOrder



    method monthBrowserTixB {} {
	# @c Initialize the value to the current month and year, if not set
	# @c already by the user.

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) [::pool::date::2month [::pool::date::now]]
	}
	return
    }



    method createSubwidgets {} {
	# @c Generate the subwidgets and their layout.

	tixControl $this.year                    \
		-integer            1             \
		-min                1800           \
		-highlightthickness 0               \
		-width              $opt(-charwidth) \
		-command            [list ${this}::TrackYear]

	monthListTix $this.monthlist                      \
		-bd                 2                      \
		-relief             sunken                  \
		-highlightthickness 0                        \
		-width              $opt(-charwidth)          \
		-command            [list ${this}::TrackMonth] \
		-onwrap             [list ${this}::OnWrap]

	# Layout dependent on value of -order.
	TrackOrder -order {}
	return
    }



    method setBindings {} {
	# @c Adds various keyboard accelerators to the month browser.

	bind _${this}_keys <Key-Up>    [list ${this}.year incr]
	bind _${this}_keys <Key-Down>  [list ${this}.year decr]

	::pool::ui::prependBindTag $this.year       _${this}_keys
	::pool::ui::prependBindTag $this.monthlist  _${this}_keys
	::pool::ui::prependBindTag $this            _${this}_keys

	$this.monthlist setBindingsTo $this
	$this.monthlist setBindingsTo $this.year
	return
    }



    method setBindingsTo {w} {
	# @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag    $w  _${this}_keys
	$this.monthlist setBindingsTo $w
	return
    }



    method TrackCharWidth {o oldValue} {
	# @c Executed whenever the width of the widget is changed by the
	# @c outside.
	#
	# @a o: The name of the changed option, always '-charwidth'.
	# @a oldValue: The old value of the option.

	$this.year      configure -charwidth $opt(-charwidth)
	$this.monthlist configure -width     $opt(-charwidth)
	return
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
	    ym {
		pack $this.year      -side left -fill both -expand 0 -in $this
		pack $this.monthlist -side left -fill both -expand 1 -in $this
	    }
	    my {
		pack $this.monthlist -side left -fill both -expand 1 -in $this
		pack $this.year      -side left -fill both -expand 0 -in $this
	    }
	}
	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c valueManager> to
	# @c propagate changes to the value into the display.

	::pool::date::splitMonth $opt(-value) year month

	$this.year      configure -value $year
	$this.monthlist configure -value $month
	return
    }



    method TrackYear {year} {
	# @c Callback. Used by the internal year browser to integrate changes
	# @c to the year into the overall value. Executed every time the year
	# @c changed its value.
	#
	# @a year: The (possibly) new value of the chosen year.

	::pool::date::splitMonth $opt(-value) dummy month

	configure -value [::pool::date::joinMonth $year $month]
	return
    }



    method TrackMonth {month} {
	# @c Callback. Used by the internal month list to integrate changes
	# @c to the month into the overall value. Executed every time the month
	# @c changed its value.
	#
	# @a month: The new value of the chosen month.

	::pool::date::splitMonth $opt(-value) year dummy

	configure -value [::pool::date::joinMonth $year $month]
	return
    }



    method OnWrap {dir} {
	# @c Increment/decrement operator for internal year browser.
	# @a dir: direction of wrap, must be one of 'up' or 'down'.

	switch $dir {
	    up      {$this.year incr}
	    down    {$this.year decr}
	    default {error "illegal wrap direction"}
	}
	return
    }
}


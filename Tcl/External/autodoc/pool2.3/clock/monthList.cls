# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Clock @clock:mFullVersion@
#
# CVS: $Id: monthList.cls,v 1.2 1998/06/02 20:05:09 aku Exp $
#
# @c Widget to choose a month by name (english).
# @s Month choice (by name, english)
# @i calendar, choosing a month, month choice
# @see <c monthListTix>, <c calendar>
# -------------------------------------------------


class monthList : valueManager {

    init {
	package require Pool_GuiBase
    }

    # @o onwrap: Script to evaluate in the case of a wrap around, either at the
    # @o onwrap: start or the end of the year. The evaluation takes place
    # @o onwrap: before the execution of <o valueManager:command>. A single
    # @o onwrap: argument is appended before the actual evaluation, it
    # @o onwrap: specifies the direction of the wrap. Possible values are 'up'
    # @o onwrap: (wrap 12 -> 1) and 'down' (wrap 1->12). A possible use is the
    # @o onwrap: modification of an associated yearBrowser.

    option onwrap -d ""


    method monthList {} {
	# @c Initialize the value to the current month if not set already by
	# @c the user.

	if {[string compare $opt(-value) ""] == 0} {
	    ::pool::date::split [::pool::date::now] dummy opt(-value) dummy
	}
	return
    }


    method createSubwidgets {} {
	# @c Generate the subwidgets and their layout.

	listbox $this.monthlist                \
		-highlightthickness  0         \
		-selectmode          single    \
		-width               12        \
		-height              12        \
		-bd                  0         \
		-relief              flat

	SetupList

	pack $this.monthlist -side left -fill both -expand 1
	return
    }



    method setBindings {} {
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



    method setBindingsTo {w} {
	# @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag $w _${this}_keys
	return
    }



    method SetupList {} {
	# @c Initializes the internal listbox, adds the names of all months.

	$this.monthlist delete 0 end

	foreach m {1 2 3 4 5 6 7 8 9 10 11 12} {
	    $this.monthlist insert end \
		    [::pool::string::cap [::pool::date::monthName $m]]
	}

	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display.

	$this.monthlist selection clear 0 end
	$this.monthlist selection set [expr {$opt(-value) - 1}]
	return
    }



    method TrackUserChanges {} {
	# @c Callback. Used by the internal listbox to forward changes made to
	# @c the display into the internal datastructures.

	set               m [$this.monthlist curselection]
	incr              m
	configure -value $m
	return
    }



    method up {} {
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



    method down {} {
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



    method OnWrap {direction} {
	# @c Evaluates the script associated with wraparounds.
	# @a direction: The direction of the current wraparound, has to be one
	# @a direction: of 'up' or 'down'.

	if {[string compare $opt(-onwrap) ""] == 0} {
	    return
	}

	uplevel #0 $opt(-onwrap) $direction
	return
    }
}


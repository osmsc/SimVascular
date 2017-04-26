# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Clock @clock:mFullVersion@
#
# CVS: $Id: monthListTix.cls,v 1.3 1998/11/12 21:48:07 aku Exp $
#
# @c Widget to choose a month by name.
# @s Month choice, tix
# @i calendar, choosing a month, month choice, tix
# @see <c monthList>, <c calendarTix>
# ---------------------------------------

class monthListTix : valueManager {

    init {
	# this browser does not use a list, but a TIX combobox.
	package require Tix
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


    method monthListTix {} {
	# @c Initialize the value to the current month if not set already by
	# @c the user.

	if {[string compare $opt(-value) ""] == 0} {
	    ::pool::date::split [::pool::date::now] dummy opt(-value) dummy
	}
	return
    }



    method createSubwidgets {} {
	# @c Generate the subwidgets and their layout.

	tixComboBox $this.months                      \
		-dropdown 1                           \
		-editable            0                \
		-grab                local            \
		-selectmode          immediate        \
		-highlightthickness  0                \
		-bd                  0                \
		-relief              flat

	SetupList

	pack $this.months -side left -fill both -expand 1

	after idle $this.months configure -command \
		[list [list $this TrackUserChanges]]
	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display.

	# Set combobox to the string corresponding to the currently chosen
	# month

	set index    [expr {$opt(-value) - 1}]
	set newValue [$this.months subwidget listbox get $index]

	$this.months configure -value $newValue
	return
    }



    method setBindings {} {
	# @c Associate bindings for this widget with its internal components.

	bind _${this}_keys +                 [list ${this}::up]
	bind _${this}_keys -                 [list ${this}::down]
	bind _${this}_keys <Key-KP_Add>      [list ${this}::up]
	bind _${this}_keys <Key-KP_Subtract> [list ${this}::down]

	::pool::ui::prependBindTag $this.months _${this}_keys
	return
    }



    method setBindingsTo {w} {
	# @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag $w _${this}_keys
	return
    }



    method SetupList {} {
	# @c Initializes the internal combobox, adds the names of all months.

	$this.months subwidget listbox delete 0 end

	foreach m {1 2 3 4 5 6 7 8 9 10 11 12} {
	    $this.months subwidget listbox insert end \
		    [::pool::string::cap [::pool::date::monthName $m]]
	}

	return
    }



    method TrackUserChanges {newvalue} {
	# @c Callback. Used by the internal tix combobox to forward external
	# @c changes to the display to the internal datastructures.
	#
	# @a newvalue: The new value displayed by the combobox.

	configure -value [::pool::date::monthNumber $newvalue]
	return
    }



    method up {} {
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



    method down {} {
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



    method OnWrap {direction} {
	# @c executes the script associated with wraparounds
	# @a direction: direction of wraparound, one of 'up' and 'down'.

	if {{} == $opt(-onwrap)} {
	    return
	}

	uplevel #0 $opt(-onwrap) $direction
	return
    }
}


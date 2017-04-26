# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Clock @clock:mFullVersion@
#
# CVS: $Id: monthBrowse.cls,v 1.2 1998/06/02 20:05:09 aku Exp $
#
# @c Widget to choose month and year
# @s Year/month choice
# @i calendar, choosing month and year, year/month choice
# @see <c monthList>, <c yearBrowser>, <c calendar>
# -----------------------------------------------

class monthBrowser : valueManager {

    init {
	package require Pool_GuiBase
    }

    # the stored value is a aggregation of month and year in the format mm/yyyy

    # parameters

    # @o charwidth: Width of the widget in characters.
    option charwidth -d 12 -a TrackCharWidth 


    method monthBrowser {} {
	# @c Initialize the value to the current month and year, if not set
	# @c already by the user.

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) [::pool::date::2month [::pool::date::now]]
	}
	return
    }


    method createSubwidgets {} {
	# @c Called by the framework to generate the subwidgets and their
	# @c layout.

	yearBrowser $this.yc                         \
		-highlightthickness 0                \
		-charwidth          $opt(-charwidth) \
		-command            [list ${this}::TrackYear]

	monthList $this.ml                                     \
		-bd                 2                          \
		-relief             sunken                     \
		-highlightthickness 0                          \
		-width              $opt(-charwidth)           \
		-command            [list ${this}::TrackMonth] \
		-onwrap             $this.yc

	pack $this.yc -side top -fill both -expand 0
	pack $this.ml -side top -fill both -expand 1
	return
    }



    method setBindings {} {
	# @c Adds various keyboard accelerators to the month browser.

	setBindingsTo $this
	return
    }



    method setBindingsTo {w} {
	# @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	$this.yc setBindingsTo $w
	$this.ml setBindingsTo $w
	return
    }



    method TrackCharWidth {o oldValue} {
	# @c Executed whenever the width of the widget is changed by the
	# @c outside.
	#
	# @a o: The name of the changed option, always '-charwidth'.
	# @a oldValue: The old value of the option.

	$this.yc config -charwidth $opt(-charwidth)
	$this.ml config -width     $opt(-charwidth)
	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display.

	::pool::date::splitMonth $opt(-value) y m

	$this.yc configure -value $y
	$this.ml configure -value $m
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

	$this config -value [::pool::date::joinMonth $year $month]
	return
    }
}


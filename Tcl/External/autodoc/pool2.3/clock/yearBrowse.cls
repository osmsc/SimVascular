# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Clock @clock:mFullVersion@
#
# CVS: $Id: yearBrowse.cls,v 1.2 1998/06/02 20:05:10 aku Exp $
#
# @c Widget to choose a year, effectively a spin button.
# @s Year choice
# @i calendar, choosing a year, year choice
# @see <c calendar>
# -------------------------------

class yearBrowser : valueManager {

    init {
	package require Pool_GuiBase
    }

    # @o charwidth: Number of characters shown

    option charwidth -d 5 -a TrackCharWidth

    init {
	bind YearBrowser <Key-greater> {%w::up}
	bind YearBrowser <Key-less>    {%w::down}
    }



    method yearBrowser {} {
	# @c Initialize the value to the current year if not set already by the
	# @c user.

	if {[string compare $opt(-value) ""] == 0} {
	    ::pool::date::split [::pool::date::now] opt(-value) dummy dummy
	}
	return
    }



    method createSubwidgets {} {
	# @c Create the internal widgets and their layout.

	set w $this

	frameWidget configure -relief flat -bd 0

	button $this.up                                \
		-bd                 3                  \
		-text               >                  \
		-relief             raised             \
		-command            [list ${this}::up] \
		-highlightthickness 0

	button $this.down                                \
		-bd                 3                    \
		-text               <                    \
		-relief             raised               \
		-command            [list ${this}::down] \
		-highlightthickness 0

	label  $this.display                          \
		-bd                 3                 \
		-width              $opt(-charwidth)  \
		-relief             sunken            \
		-highlightthickness 0

	# - now define the layout

	pack $this.down    -side left -fill both -expand 0
	pack $this.display -side left -fill both -expand 1
	pack $this.up      -side left -fill both -expand 0
	return
    }


    method setBindings {} {
	# @c Associate bindings for this widget with its internal components.

	bind _${this}_keys <Key-greater> [list ${this}::up]
	bind _${this}_keys <Key-less>    [list ${this}::down]

	::pool::ui::prependBindTag $this.down    _${this}_keys
	::pool::ui::prependBindTag $this.display _${this}_keys
	::pool::ui::prependBindTag $this.up      _${this}_keys
	return
    }



    method setBindingsTo {w} {
	# @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag $w  _${this}_keys
	return
    }



    method TrackCharWidth {o oldValue} {
	# @c Executed whenever the width of the widget is changed by the
	# @c outside.
	#
	# @a o: The name of the changed option, always '-charwidth'.
	# @a oldValue: The old value of the option.

	$this.display config -width $opt(-charwidth)
	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c valueManager>
	# @c to propagate changes to the value into the display.

	$this.display configure -text $opt(-value)
	return
    }



    method up {} {
	# @c Callback. Used by the incrementer button to add one to the year.

	configure -value [expr {$opt(-value) + 1}]
	return
    }



    method down {} {
	# @c callback used by decrementer button to change the year

	configure -value [expr {$opt(-value) - 1}]
	return
    }
}


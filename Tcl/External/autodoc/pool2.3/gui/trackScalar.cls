# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# 1998 -- Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: trackScalar.cls,v 1.1 1998/06/01 19:55:59 aku Exp $
#
# @c Generation and maintenance of a variable watcher display.
# @s Watch the contents of a variable.
# @i watch variable, variable watching, animated feedback, feedback
# -------------------------------------------

class trackScalar : watchManager {

    # @c Instances of this class are coupled to a scalar variable, then display
    # @c its current contents, tracking any changes made to it. Although the
    # @c purpose of the class is the same as for <c watchScalar> the means of
    # @c displaying is different. While the former only shows the current
    # @c value this widget will display the entire of the variable. A
    # @c scrollable text widget is used to do this.

    # @o varnamecolor:  The name of the color to use for the variable name.
    # @o varvaluecolor: The name of the color to use for the variable contents.
    # @o numbercolor:   The name of the color to use for the history numbers.

    option varnamecolor  -d red
    option varvaluecolor -d blue
    option numbercolor   -d black

    # @v line: Counts the number of written so far. Alternative meaning: The
    # @v line: number of changes made to the contents of the variable
    # @v line: specified in <o variable>.

    var line 1


    method createSubwidgets {} {
	# @c Called after object construction. Generates the internal widgets
	# @c and their layout.

	# This widget not only traces the variable contents, but changes to
	# '-variable' too. The latter cause a reset of the display.

	scrollbar    $this.s
	text         $this.t ;# -width $opt(-width) -height $opt(-height)
	::pool::ui::multiScroll $this.s vertical $this.t

	pack $this.s -side left -expand 0 -fill both
	pack $this.t -side left -expand 1 -fill both

	$this.t tag configure varname  -foreground $opt(-varnamecolor)
	$this.t tag configure varvalue -foreground $opt(-varvaluecolor)
	$this.t tag configure number   -foreground $opt(-numbercolor)
	$this.t configure -state disabled

	ResetDisplay
	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c watchManager> to propagate
	# @c changes to the value into the display.

	$this.t configure -state normal
	$this.t insert end "[format %5d $line] " number
	$this.t insert end "$value\n"            varvalue
	$this.t configure -state disabled

	incr line

	#update idletasks
	return
    }



    method ResetDisplay {} {
	# @c Clears the display, then writes the current contents of the
	# @c asssociated variable into it. Used to refressh the display
	# @c after changes to the option <o variable>.

	set line 1

	$this.t configure -state normal
	$this.t delete 1.0 end
	$this.t insert end "$opt(-variable)\n" varname
	$this.t configure -state disabled

	updateDisplay
	return
    }



    method TrackVariable {o oldValue} {
	# @c Overide superclass definition to allow us the insertion of our
	# @c own code into the action following the change of the variable
	# @c the widget is connected to.
	#
	# @a o:        The name of the changed option.
	# @a oldValue: The value of the option before the change.

	watchManager_TrackVariable $o $oldValue
	ResetDisplay
	return
    }
}


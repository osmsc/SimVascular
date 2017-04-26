# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# 1998 -- Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: watchScalar.cls,v 1.1 1998/06/01 19:56:00 aku Exp $
#
# @c Generation and maintenance of a variable watcher display.
# @s Watch the contents of a variable.
# @i watch variable, variable watching, animated feedback, feedback
# -------------------------------------------

class watchScalar : watchManager {

    # @c Instances of this class are coupled to a scalar variable, then display
    # @c its current contents, tracking any changes made to it.


    method createSubwidgets {} {
	# @c Called after object construction. Generates the internal widgets
	# @c and their layout.

	# On the left a label showing the name of the tracked variable.
	# On the right its value.
	# Between them a label to show the assignment operator

	label $this.name  -textvariable "${this}::opt(-variable)"
	label $this.sep   -text         ":="
	label $this.value -text         $value

	pack $this.name  -side left  -fill both -expand 0 -ipady 1m
	pack $this.sep   -side left  -fill both -expand 0 -ipady 1m
	pack $this.value -side right -fill both -expand 1 -ipady 1m
	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c watchManager> to propagate
	# @c changes to the value into the display.

	$this.value configure -text $value

	#update idletasks
	return
    }
}


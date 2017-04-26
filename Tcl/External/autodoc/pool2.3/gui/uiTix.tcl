# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: uiTix.tcl,v 1.2 1998/06/02 20:05:24 aku Exp $
#
# @c Helper procedures for manipulation of user interfaces.
# @c Depends on <d Tix>.
# @s Helper procedures for manipulation of user interfaces.
#
# @i User interface manipulation
# @i interface manipulation
# @i manipulation of user interfaces

package require Tcl 8.0
package require Pool_Base
package require Tix



# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval ui {
	variable version @gui:mFullVersion@
	namespace export *

	# event flag used by the 'vwait' in 'nyiTix'.
	variable nyiWait 0
    }
}


# Add subdirectory of script location to picture search path of Tix

tix addbitmapdir [file join [::pool::file::here] img]


proc ::pool::ui::nyiTix {args} {
    # @c Shows a modal dialog warning the user about
    # @c entering a missing part of the application.
    # @a args: Additional to text to display in the dialog.

    # Use background of main window here, preserving any color scheme

    set color [. cget -bg]

    toplevel    .nyi -bg $color
    wm withdraw .nyi
    wm title    .nyi "Under construction"

    label  .nyi.p                                            \
	    -bg                 $color                       \
	    -image              [tix getimage construction3] \
	    -highlightthickness 0                            \
	    -relief             raised                       \
	    -bd                 2                            \
	    -anchor             c

    if {{} == $args} {
	button .nyi.m -text "Under construction"
    } else {
	button .nyi.m -text $args
    }

    pack .nyi.p -side left -fill both -expand no  -ipady 2m -ipadx 2m
    pack .nyi.m -side left -fill both -expand yes ;#-pady 1m -padx 1m

    .nyi.m configure                             \
	    -relief raised                       \
	    -highlightthickness 0                \
	    -bg $color                           \
	    -command {set ::pool::ui::nyiWait 0}

    wm deiconify .nyi
    vwait       ::pool::ui::nyiWait
    destroy      .nyi
    return
}


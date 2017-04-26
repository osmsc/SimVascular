# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: dialog.cls,v 1.3 1998/11/02 22:24:14 aku Exp $
#
# @c base class of all megadialogs
# @s megadialog base
# @i megadialog base, dialog base class
# -------------------------------------------

class dialog : widget {
    # @c This is the base class of all megadialogs.

    # @o title: The string to display as title of the dialog.
    # @o menu:  The menubar to display at the top of the dialog.

    option title -a TrackTitle
    option menu  -a TrackMenu

    method dialog {} {
	# @c Dialog constructor. Just change the type of the megawidget
	# @c container, the superclass (<c widget>) will handle everything else
	# @c for us.

	set widgetType toplevel
    }


    method createSubwidgets {} {
	# @c We don't construct subwidgets here, there is no need to. But the
	# @c initial title must be set here.

	wm title $this $opt(-title)
	return
    }


    method TrackTitle {option oldValue} {
	# @c Configure procedure. Propagates changes to the option -title into
	# @c the user interface.
	#
	# @a option:   The name of the changed option.
	# @a oldValue: The value the option had before the change.

	wm title $this $opt(-title)
	return
    }


    method TrackMenu {option oldValue} {
	# @c Configure procedure. Propagates changes to the option -menu into
	# @c the user interface.
	#
	# @a option:   The name of the changed option.
	# @a oldValue: The value the option had before the change.

	frameWidget configure -menu $opt(-menu)
	return
    }
}


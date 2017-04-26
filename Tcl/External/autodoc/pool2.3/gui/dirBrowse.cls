# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: dirBrowse.cls,v 1.1 1998/06/01 19:55:58 aku Exp $
#
# @c Choice of a directory
# @s Choice of a directory
# @i Choice of a directory
# -----------------------------

class dirBrowser : okCancelDialog {
    # @c Instances of this dialog allow
    # @c the user to select a directory.

    init {
	package require Tix
    }


    method dirBrowser {} {
	# @c Constructor. Forces a specific dialog title.

	set opt(-title) "Select a directory"
    }


    method createSubwidgets {} {
	# @c Plug the directory browser widget provided by <dep Tix> into
	# @c the childsite of the general dialog.

	set w [subwidget childsite]

	tixDirSelectBox $w.dsb -relief raised -bd 1
	pack            $w.dsb -side top -expand 1 -fill both

	hideFeedback
	return
    }



    method HandleButton {button} {
	# @c Overide the method from <c multipleChoiceDialog>. This is
	# @c required as we want to add a second argument to the called
	# @c command, the path of the chosen directory. For 'cancel' this
	# @c argument will be empty. Evaluates the script given to the
	# @c option -command and destroys the dialog afterward.
	#
	# @a button: Symbolic name of the invoked button.

	if {[string compare $button cancel] == 0} {
	    set path {}
	} else {
	    set path [[subwidget childsite].dsb cget -value]
	}

	if {$opt(-command) != {}} {
	    uplevel #0 $opt(-command) $button $path
	}

	delete
	return
    }
}


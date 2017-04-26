# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: mcDialog.cls,v 1.3 2000/07/31 19:15:24 aku Exp $
#
# @c Base class of all megadialogs with a button bar
# @s Base of dialogs with buttonbar
# @i dialog with buttonbar, feedback, stateline
# -------------------------------------------

class multipleChoiceDialog : feedbackDialog {
    # @c This class is the base of all dialogs containing a stateline
    # @c (inherited) and a button bar at their bottom.

    init {
	#package require Tix
    }

    # @o command: The script evaluate after the invocation of a registered
    # @o command: button. The symbolic name of the button will be appended
    # @o command: as its argument.

    option command -default {}

    # @v bbox: Reference to the internal buttonbox widget.

    var bbox {}


    method createSubwidgets {} {
	# @c Create the widgets required by this dialog, then place them
	# @c appropriately. The childsite of the superclass is used to place
	# @c our buttonbox and then redefined to our childsite.

	set w    [subwidget childsite]
	set bbox $w._bbox

	addSubwidget childsite [frame $w._child -relief raised -bd 1]
#	tixButtonBox $bbox -orient horizontal   -relief raised -bd 1
	actionrow    $bbox -orient horizontal   -relief raised -bd 1

	pack $w._child -side top -fill both -expand 1
	pack $bbox     -side top -fill both -expand 0
	return
    }


    method addButton {name text} {
	# @c Accessor allowing the registration of an arbitrary set of buttons.
	# @c Every button registered with this method can be retrieved via
	# @c <m widget:subwidget>, the <a name> specified here is its handle
	# @c for this too.
	#
	# @a name: The symbolic name of the registered button.
	# @a text: The text to display in the button.

#	$bbox add $name        \
#		-text    $text \
#		-command [list ${this}::HandleButton $name]

	$bbox add $name $text [list ${this}::HandleButton $name]

	addSubwidget $name [$bbox subwidget $name]
	return
    }


    method HandleButton {button} {
	# @c Internal callback. Invoked by the activation of a registered
	# @c button. Evaluates the script given to the option -command and
	# @c destroys the dialog afterward.
	#
	# @a button: Symbolic name of the invoked button.

	if {$opt(-command) != {}} {
	    uplevel #0 $opt(-command) $button
	}

	delete
	return
    }
}


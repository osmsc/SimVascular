# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: fbDialog.cls,v 1.1 1998/06/01 19:55:58 aku Exp $
#
# @c base class of all megadialogs containing a stateline for feedback
# @s base of dialogs with stateline for feedback
# @i dialog with feedback, feedback, stateline
# -------------------------------------------

class feedbackDialog : dialog {
    # @c This is the base class of all dialogs with a stateline at the bottom.
    # @c Additionally employs the notion of a child site to allow for easy
    # @c customization by derived classes and other users.&p
    #
    # @c The user visible components are 'childsite' and 'stateline'.

    # No special constructor.

    method createSubwidgets {} {
	# @c Create and place child site and stateline. Both are user visible
	# @c components. The stateline is placed at the bottom, the child site
	# @c above that. Only the child site reacts to changes in the size of
	# @c the dialog.

	addSubwidget childsite [frame     $this._child]
	addSubwidget stateline [stateline $this._sl -relief raised -bd 1]

	pack $this._child -side top    -fill both -expand 1
	pack $this._sl    -side bottom -fill both -expand 0
	return
    }



    method hideFeedback {{hide 1}} {
	# @c Allows users to hide and display the stateline.
	#
	# @a hide: Boolean flag. A value of true (default) signals the widget
	# @a hide: to hide the statteline. It will show it for
	# @a hide: <a hide> == false.

	if {$hide} {
	    pack forget $this._sl
	} else {
	    pack $this._sl -side bottom -fill both -expand 0
	}
	return
    }



    method setText {handle text} {
	# @c Allows users to set text into the stateline without resorting to
	# @c 'x subwidget stateline setText ...'. Offers additional
	# @c functionality besides that simple forwarding by enforcing the
	# @c visibility of the stateline.
	#
	# @a handle: The symbolic name associated to the message. Can be used
	# @a handle: between messages from several different sources.
	# @a text:   The text to show in the stateline.

	hideFeedback off
	$this._sl setText $handle $text
	return
    }
}


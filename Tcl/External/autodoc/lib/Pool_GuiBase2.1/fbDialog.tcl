# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/fbDialog.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> feedbackDialog <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::feedbackDialog {
    variable  _superclasses    dialog
    variable  _scChainForward  feedbackDialog
    variable  _scChainBackward feedbackDialog
    variable  _classVariables  {}
    variable  _methods         {createSubwidgets hideFeedback setText}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . setText . hideFeedback .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::feedbackDialog::createSubwidgets {} {
    ::pool::oo::support::SetupVars feedbackDialog
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



proc ::pool::oo::class::feedbackDialog::hideFeedback {{hide 1}} {
    ::pool::oo::support::SetupVars feedbackDialog
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



proc ::pool::oo::class::feedbackDialog::setText {handle text} {
    ::pool::oo::support::SetupVars feedbackDialog
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::feedbackDialog::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::dialog::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences feedbackDialog

# Create object instantiation procedure
interp alias {} feedbackDialog {} ::pool::oo::support::New feedbackDialog

# -------------------------------


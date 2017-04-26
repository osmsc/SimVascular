# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/mcDialog.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> multipleChoiceDialog <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
#package require Tix

# Namespace describing the class
namespace eval ::pool::oo::class::multipleChoiceDialog {
    variable  _superclasses    feedbackDialog
    variable  _scChainForward  multipleChoiceDialog
    variable  _scChainBackward multipleChoiceDialog
    variable  _classVariables  {}
    variable  _methods         {HandleButton addButton createSubwidgets}

    variable  _variables
    array set _variables  {bbox {multipleChoiceDialog {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {command {multipleChoiceDialog {-default {} -type ::pool::getopt::notype -action {} -class Command}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {HandleButton . createSubwidgets . addButton .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::multipleChoiceDialog::HandleButton {button} {
    ::pool::oo::support::SetupVars multipleChoiceDialog
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



proc ::pool::oo::class::multipleChoiceDialog::addButton {name text} {
    ::pool::oo::support::SetupVars multipleChoiceDialog
    # @c Accessor allowing the registration of an arbitrary set of buttons.
	# @c Every button registered with this method can be retrieved via
	# @c <m widget:subwidget>, the <a name> specified here is its handle
	# @c for this too.
	#
	# @a name: The symbolic name of the registered button.
	# @a text: The text to display in the button.

#	$bbox add $name         #		-text    $text  #		-command [list ${this}::HandleButton $name]

	$bbox add $name $text [list ${this}::HandleButton $name]

	addSubwidget $name [$bbox subwidget $name]
	return
}



proc ::pool::oo::class::multipleChoiceDialog::createSubwidgets {} {
    ::pool::oo::support::SetupVars multipleChoiceDialog
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::multipleChoiceDialog::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::feedbackDialog::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences multipleChoiceDialog

# Create object instantiation procedure
interp alias {} multipleChoiceDialog {} ::pool::oo::support::New multipleChoiceDialog

# -------------------------------


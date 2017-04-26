# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/ocDialog.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> okCancelDialog <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::okCancelDialog {
    variable  _superclasses    multipleChoiceDialog
    variable  _scChainForward  okCancelDialog
    variable  _scChainBackward okCancelDialog
    variable  _classVariables  {}
    variable  _methods         {createSubwidgets setBindings}

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
    array set _methodTable  {createSubwidgets . setBindings .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::okCancelDialog::createSubwidgets {} {
    ::pool::oo::support::SetupVars okCancelDialog
    # @c Well, just add 2 buttons to the buttonbar inherited from the
	# @c superclass.

	addButton ok     Ok
	addButton cancel Cancel
	return
}



proc ::pool::oo::class::okCancelDialog::setBindings {} {
    ::pool::oo::support::SetupVars okCancelDialog
    # @c Let the buttons react to 'return' and 'escape' keys.

	set w [subwidget ok]
	bind  [winfo toplevel $w] <Return>   [list $w invoke]
	bind  [winfo toplevel $w] <KP_Enter> [list $w invoke]

	set w [subwidget cancel]
	bind  [winfo toplevel $w] <Key-Escape> [list $w invoke]
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::okCancelDialog::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::multipleChoiceDialog::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences okCancelDialog

# Create object instantiation procedure
interp alias {} okCancelDialog {} ::pool::oo::support::New okCancelDialog

# -------------------------------


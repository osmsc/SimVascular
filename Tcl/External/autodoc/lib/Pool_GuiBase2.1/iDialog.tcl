# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/iDialog.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> infoDialog <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::infoDialog {
    variable  _superclasses    multipleChoiceDialog
    variable  _scChainForward  infoDialog
    variable  _scChainBackward infoDialog
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


proc ::pool::oo::class::infoDialog::createSubwidgets {} {
    ::pool::oo::support::SetupVars infoDialog
    # @c Well, just add the button to the buttonbar inherited from the
	# @c superclass.

	addButton ok Ok
	return
}



proc ::pool::oo::class::infoDialog::setBindings {} {
    ::pool::oo::support::SetupVars infoDialog
    # @c Let the button react to the 'return' key.

	set w [subwidget ok]
	bind  [winfo toplevel $w] <Return>   [list $w invoke]
	bind  [winfo toplevel $w] <KP_Enter> [list $w invoke]
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::infoDialog::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::multipleChoiceDialog::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences infoDialog

# Create object instantiation procedure
interp alias {} infoDialog {} ::pool::oo::support::New infoDialog

# -------------------------------


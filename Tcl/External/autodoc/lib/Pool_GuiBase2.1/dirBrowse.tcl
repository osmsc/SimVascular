# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/dirBrowse.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> dirBrowser <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Tix

# Namespace describing the class
namespace eval ::pool::oo::class::dirBrowser {
    variable  _superclasses    okCancelDialog
    variable  _scChainForward  dirBrowser
    variable  _scChainBackward dirBrowser
    variable  _classVariables  {}
    variable  _methods         {HandleButton constructor createSubwidgets}

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
    array set _methodTable  {HandleButton . createSubwidgets . constructor .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::dirBrowser::HandleButton {button} {
    ::pool::oo::support::SetupVars dirBrowser
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



proc ::pool::oo::class::dirBrowser::constructor {} {
    ::pool::oo::support::SetupVars dirBrowser
    # @c Constructor. Forces a specific dialog title.

	set opt(-title) "Select a directory"
}



proc ::pool::oo::class::dirBrowser::createSubwidgets {} {
    ::pool::oo::support::SetupVars dirBrowser
    # @c Plug the directory browser widget provided by <dep Tix> into
	# @c the childsite of the general dialog.

	set w [subwidget childsite]

	tixDirSelectBox $w.dsb -relief raised -bd 1
	pack            $w.dsb -side top -expand 1 -fill both

	hideFeedback
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::dirBrowser::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::okCancelDialog::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences dirBrowser

# Create object instantiation procedure
interp alias {} dirBrowser {} ::pool::oo::support::New dirBrowser

# -------------------------------


# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/dialog.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> dialog <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::dialog {
    variable  _superclasses    widget
    variable  _scChainForward  dialog
    variable  _scChainBackward dialog
    variable  _classVariables  {}
    variable  _methods         {TrackMenu TrackTitle constructor createSubwidgets}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {menu {dialog {-default {} -type ::pool::getopt::notype -action TrackMenu -class Menu}} title {dialog {-default {} -type ::pool::getopt::notype -action TrackTitle -class Title}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . constructor . TrackMenu . TrackTitle .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::dialog::TrackMenu {option oldValue} {
    ::pool::oo::support::SetupVars dialog
    # @c Configure procedure. Propagates changes to the option -menu into
	# @c the user interface.
	#
	# @a option:   The name of the changed option.
	# @a oldValue: The value the option had before the change.

	frameWidget configure -menu $opt(-menu)
	return
}



proc ::pool::oo::class::dialog::TrackTitle {option oldValue} {
    ::pool::oo::support::SetupVars dialog
    # @c Configure procedure. Propagates changes to the option -title into
	# @c the user interface.
	#
	# @a option:   The name of the changed option.
	# @a oldValue: The value the option had before the change.

	wm title $this $opt(-title)
	return
}



proc ::pool::oo::class::dialog::constructor {} {
    ::pool::oo::support::SetupVars dialog
    # @c Dialog constructor. Just change the type of the megawidget
	# @c container, the superclass (<c widget>) will handle everything else
	# @c for us.

	set widgetType toplevel
}



proc ::pool::oo::class::dialog::createSubwidgets {} {
    ::pool::oo::support::SetupVars dialog
    # @c We don't construct subwidgets here, there is no need to. But the
	# @c initial title must be set here.

	wm title $this $opt(-title)
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::dialog::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences dialog

# Create object instantiation procedure
interp alias {} dialog {} ::pool::oo::support::New dialog

# -------------------------------


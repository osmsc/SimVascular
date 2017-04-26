# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/gPopupMenu.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> genericPopupMenu <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::genericPopupMenu {
    variable  _superclasses    widget
    variable  _scChainForward  genericPopupMenu
    variable  _scChainBackward genericPopupMenu
    variable  _classVariables  {}
    variable  _methods         {InvokeEntry addEntries addEntry associate createSubwidgets entryconfigure show showRelative width}

    variable  _variables
    array set _variables  {entry {genericPopupMenu {isArray 1 initialValue {}}} entries {genericPopupMenu {isArray 0 initialValue 0}}}

    variable  _options
    array set _options  {command {genericPopupMenu {-default {} -type ::pool::getopt::notype -action {} -class Command}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {entryconfigure . width . associate . createSubwidgets . show . showRelative . InvokeEntry . addEntry . addEntries .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::genericPopupMenu::InvokeEntry {command} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Internal method, called upon invocation of a menu entry.
	# @a command: Symbolic name of the invoked entry.

	if {$opt(-command) == {}} {
	    return
	}

	uplevel #0 $opt(-command) [list $this] [list $command]
	return
}



proc ::pool::oo::class::genericPopupMenu::addEntries {spec} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Adds a bunch of entries to the popup menu.
	# @a spec: A list suitable for usage with 'array set'.
	# @a spec: The first item of each pair is the command
	# @a spec: code to give to the external script
	# @a spec: (<o command>) upon invocation
	# @a spec: of the entry. It serves as symbolic name of
	# @a spec: the entry too. The 2nd item in each pair is
	# @a spec: the string to display in the entry. A command
	# @a spec: of '-' indicates a separator line. The display
	# @a spec: string is ignored in this case, but has to
	# @a spec: be present nevertheless. A command name has
	# @a spec: to be unique over all menubuttons added to
	# @a spec: a menubar.

	foreach {command text} $spec {
	    if {[string compare $command -] == 0} {
		# Separator
		$this._m add separator
	    } else {
		# Standard button

		$this._m add command          -label     $text     -underline -1        -command   [list ${this}::InvokeEntry $command]

		set entry($command) $entries
	    }

	    incr entries
	}

	return
}



proc ::pool::oo::class::genericPopupMenu::addEntry {command {underline -1} {name {}}} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Adds a new menu entry to the popup menu.
	# @a name: String to display in the new entry. The special
	# @a name: value '-' forces generation of a separator line.
	# @a underline: Index of the character in <a name> to underline.
	# @a command: Symbolic name of command associated to the entry

	if {"$command" == "-"} {
	    $this._m add separator
	} else {
	    $this._m add command          -label     $name      -underline $underline  -command   [list ${this}::InvokeEntry $command]

	    set entry($command) $entries
	}

	incr entries
	return
}



proc ::pool::oo::class::genericPopupMenu::associate {w cmd} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Associate the popup menu with widget <a w>, evaluate <a cmd> upon
	# @c invokation of a menu entry. The association takes the form of a
	# @c binding of mouse button 2 causing the display of the menu relative
	# @c to <a w>.
	#
	# @a w:   Path to the widget to add the menu to.
	# @a cmd: Script to invoke upon activation of a menu
	# @a cmd: entry. Changes <o command>.

	configure -command $cmd

	bind $w <2> [list ${this}::showRelative $w %x %y]
	return
}



proc ::pool::oo::class::genericPopupMenu::createSubwidgets {} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Generate the internal widget. No placement yet, this is done later
	# @c and explicitly (see <m show> and <m showRelative>)

	menu  $this._m -tearoff 0
	return
}



proc ::pool::oo::class::genericPopupMenu::entryconfigure {command args} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Accessor method allowing the reconfiguration of all entries in the
	# @c menubar. Access is given based upon the symbolic name of the
	# @c entry. The mapping to the menu widget of the entry and its index
	# @c in that is done here.
	#
	# @a command: Symbolic name of the command to operate on.
	# @a args:    List of option, value pairs.

	set index $entry($command)

	eval $this._m entryconfigure $index $args
	return
}



proc ::pool::oo::class::genericPopupMenu::show {x y} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Show the popup menu and wait for selection or cancellation.
	#
	# @a x: Place to show the menu at, relative to the rootwindow of the
	# @a x: display.
	# @a y: Place to show the menu at, relative to the rootwindow of the
	# @a y: display.

	tk_popup $this._m $x $y
	return
}



proc ::pool::oo::class::genericPopupMenu::showRelative {w x y} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @c Show the popup menu and wait for selection or cancellation.
	#
	# @a w: Path to widget used as root of the coordinates.
	# @a x: Place to show the menu at, relative to widget <a w>.
	# @a y: Place to show the menu at, relative to widget <a w>.

	set x [expr {$x + [winfo rootx $w] - ([winfo reqwidth $this._m] / 2)}]
	set y [expr {$y + [winfo rooty $w] + 10}]

	tk_popup $this._m $x $y
	return
}



proc ::pool::oo::class::genericPopupMenu::width {} {
    ::pool::oo::support::SetupVars genericPopupMenu
    # @r Retrieve the width of the menu.
	return [winfo reqwidth $this._m]
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::genericPopupMenu::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences genericPopupMenu

# Create object instantiation procedure
interp alias {} genericPopupMenu {} ::pool::oo::support::New genericPopupMenu

# -------------------------------


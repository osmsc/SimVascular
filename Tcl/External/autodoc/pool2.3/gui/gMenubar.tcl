# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/gMenubar.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> genericMenubar <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::genericMenubar {
    variable  _superclasses    widget
    variable  _scChainForward  genericMenubar
    variable  _scChainBackward genericMenubar
    variable  _classVariables  {}
    variable  _methods         {InvokeEntry addMenu createSubwidgets entryconfigure}

    variable  _variables
    array set _variables  {entry {genericMenubar {isArray 1 initialValue {}}}}

    variable  _options
    array set _options  {command {genericMenubar {-default {} -type ::pool::getopt::notype -action {} -class Command}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {entryconfigure . createSubwidgets . addMenu . InvokeEntry .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::genericMenubar::InvokeEntry {command} {
    ::pool::oo::support::SetupVars genericMenubar
    # @c Internal method, called upon invocation of a menu entry.
	# @a command: Symbolic name of the invoked entry.

	if {$opt(-command) == {}} {
	    return
	}

	uplevel #0 $opt(-command) [list $this] [list $command]
	return
}



proc ::pool::oo::class::genericMenubar::addMenu {name underline spec} {
    ::pool::oo::support::SetupVars genericMenubar
    # @c Adds a new menubutton and its entries to the menubar.

	# @a name:      String to display in the new button
	# @a underline: Index of the character in <a name> to underline.
	#
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


	set m m_[::pool::serial::new]
	set i 1

	$this._m add cascade            -label     $name        -menu      $this._m.$m  -underline $underline

	menu $this._m.$m
	# 0 = index of tearoff entry

	foreach {command text} $spec {
	    if {[string compare $command -] == 0} {
		# Separator
		$this._m.$m add separator
	    } else {
		# Standard button

		$this._m.$m add command  -label   $text  -command [list ${this}::InvokeEntry $command]

		set entry($command) [list $m $i]
	    }

	    incr i
	}

	return
}



proc ::pool::oo::class::genericMenubar::createSubwidgets {} {
    ::pool::oo::support::SetupVars genericMenubar
    # @c Generate the menubar, place it in the toplevel, use the new menu
	# @c mechanism of tk.

	menu  $this._m -tearoff 0
	after idle [winfo toplevel $this] configure -menu $this._m
	return
}



proc ::pool::oo::class::genericMenubar::entryconfigure {command args} {
    ::pool::oo::support::SetupVars genericMenubar
    # @c Accessor method allowing the reconfiguration of all entries in the
	# @c menubar. Access is given based upon the symbolic name of the
	# @c entry. The mapping to the menu widget of the entry and its index
	# @c in that is done here.
	#
	# @a command: Symbolic name of the command to operate on.
	# @a args:    List of option, value pairs.

	set menu  [lindex $entry($command) 0]
	set index [lindex $entry($command) 1]

	eval $this._m.$menu entryconfigure $index $args
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::genericMenubar::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences genericMenubar

# Create object instantiation procedure
interp alias {} genericMenubar {} ::pool::oo::support::New genericMenubar

# -------------------------------


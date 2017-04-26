# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/yearBrowse.cls'.
# Date: Thu Sep 14 23:03:53 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> yearBrowser <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
bind YearBrowser <Key-greater> {%w::up}
	bind YearBrowser <Key-less>    {%w::down}

# Namespace describing the class
namespace eval ::pool::oo::class::yearBrowser {
    variable  _superclasses    valueManager
    variable  _scChainForward  yearBrowser
    variable  _scChainBackward yearBrowser
    variable  _classVariables  {}
    variable  _methods         {TrackCharWidth constructor createSubwidgets down setBindings setBindingsTo up updateDisplay}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {charwidth {yearBrowser {-default 5 -type ::pool::getopt::notype -action TrackCharWidth -class Charwidth}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {down . createSubwidgets . up . updateDisplay . setBindingsTo . constructor . setBindings . TrackCharWidth .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::yearBrowser::TrackCharWidth {o oldValue} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c Executed whenever the width of the widget is changed by the
	# @c outside.
	#
	# @a o: The name of the changed option, always '-charwidth'.
	# @a oldValue: The old value of the option.

	$this.display config -width $opt(-charwidth)
	return
}



proc ::pool::oo::class::yearBrowser::constructor {} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c Initialize the value to the current year if not set already by the
	# @c user.

	if {[string compare $opt(-value) ""] == 0} {
	    ::pool::date::split [::pool::date::now] opt(-value) dummy dummy
	}
	return
}



proc ::pool::oo::class::yearBrowser::createSubwidgets {} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c Create the internal widgets and their layout.

	set w $this

	frameWidget configure -relief flat -bd 0

	button $this.up                                 -bd                 3                   -text               >                   -relief             raised              -command            [list ${this}::up]  -highlightthickness 0

	button $this.down                                 -bd                 3                     -text               <                     -relief             raised                -command            [list ${this}::down]  -highlightthickness 0

	label  $this.display                           -bd                 3                  -width              $opt(-charwidth)   -relief             sunken             -highlightthickness 0

	# - now define the layout

	pack $this.down    -side left -fill both -expand 0
	pack $this.display -side left -fill both -expand 1
	pack $this.up      -side left -fill both -expand 0
	return
}



proc ::pool::oo::class::yearBrowser::down {} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c callback used by decrementer button to change the year

	configure -value [expr {$opt(-value) - 1}]
	return
}



proc ::pool::oo::class::yearBrowser::setBindings {} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c Associate bindings for this widget with its internal components.

	bind _${this}_keys <Key-greater> [list ${this}::up]
	bind _${this}_keys <Key-less>    [list ${this}::down]

	::pool::ui::prependBindTag $this.down    _${this}_keys
	::pool::ui::prependBindTag $this.display _${this}_keys
	::pool::ui::prependBindTag $this.up      _${this}_keys
	return
}



proc ::pool::oo::class::yearBrowser::setBindingsTo {w} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag $w  _${this}_keys
	return
}



proc ::pool::oo::class::yearBrowser::up {} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c Callback. Used by the incrementer button to add one to the year.

	configure -value [expr {$opt(-value) + 1}]
	return
}



proc ::pool::oo::class::yearBrowser::updateDisplay {} {
    ::pool::oo::support::SetupVars yearBrowser
    # @c Method required by the superclass <c valueManager>
	# @c to propagate changes to the value into the display.

	$this.display configure -text $opt(-value)
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::yearBrowser::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences yearBrowser

# Create object instantiation procedure
interp alias {} yearBrowser {} ::pool::oo::support::New yearBrowser

# -------------------------------


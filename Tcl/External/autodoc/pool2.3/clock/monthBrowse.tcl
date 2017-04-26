# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/monthBrowse.cls'.
# Date: Thu Sep 14 23:03:52 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> monthBrowser <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Pool_GuiBase

# Namespace describing the class
namespace eval ::pool::oo::class::monthBrowser {
    variable  _superclasses    valueManager
    variable  _scChainForward  monthBrowser
    variable  _scChainBackward monthBrowser
    variable  _classVariables  {}
    variable  _methods         {TrackCharWidth TrackMonth TrackYear constructor createSubwidgets setBindings setBindingsTo updateDisplay}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {charwidth {monthBrowser {-default 12 -type ::pool::getopt::notype -action TrackCharWidth -class Charwidth}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . updateDisplay . setBindingsTo . TrackYear . constructor . setBindings . TrackCharWidth . TrackMonth .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::monthBrowser::TrackCharWidth {o oldValue} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Executed whenever the width of the widget is changed by the
	# @c outside.
	#
	# @a o: The name of the changed option, always '-charwidth'.
	# @a oldValue: The old value of the option.

	$this.yc config -charwidth $opt(-charwidth)
	$this.ml config -width     $opt(-charwidth)
	return
}



proc ::pool::oo::class::monthBrowser::TrackMonth {month} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Callback. Used by the internal month list to integrate changes
	# @c to the month into the overall value. Executed every time the month
	# @c changed its value.
	#
	# @a month: The new value of the chosen month.

	::pool::date::splitMonth $opt(-value) year dummy

	$this config -value [::pool::date::joinMonth $year $month]
	return
}



proc ::pool::oo::class::monthBrowser::TrackYear {year} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Callback. Used by the internal year browser to integrate changes
	# @c to the year into the overall value. Executed every time the year
	# @c changed its value.
	#
	# @a year: The (possibly) new value of the chosen year.

	::pool::date::splitMonth $opt(-value) dummy month

	configure -value [::pool::date::joinMonth $year $month]
	return
}



proc ::pool::oo::class::monthBrowser::constructor {} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Initialize the value to the current month and year, if not set
	# @c already by the user.

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) [::pool::date::2month [::pool::date::now]]
	}
	return
}



proc ::pool::oo::class::monthBrowser::createSubwidgets {} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Called by the framework to generate the subwidgets and their
	# @c layout.

	yearBrowser $this.yc                          -highlightthickness 0                 -charwidth          $opt(-charwidth)  -command            [list ${this}::TrackYear]

	monthList $this.ml                                      -bd                 2                           -relief             sunken                      -highlightthickness 0                           -width              $opt(-charwidth)            -command            [list ${this}::TrackMonth]  -onwrap             $this.yc

	pack $this.yc -side top -fill both -expand 0
	pack $this.ml -side top -fill both -expand 1
	return
}



proc ::pool::oo::class::monthBrowser::setBindings {} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Adds various keyboard accelerators to the month browser.

	setBindingsTo $this
	return
}



proc ::pool::oo::class::monthBrowser::setBindingsTo {w} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	$this.yc setBindingsTo $w
	$this.ml setBindingsTo $w
	return
}



proc ::pool::oo::class::monthBrowser::updateDisplay {} {
    ::pool::oo::support::SetupVars monthBrowser
    # @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display.

	::pool::date::splitMonth $opt(-value) y m

	$this.yc configure -value $y
	$this.ml configure -value $m
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::monthBrowser::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences monthBrowser

# Create object instantiation procedure
interp alias {} monthBrowser {} ::pool::oo::support::New monthBrowser

# -------------------------------


# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/monthBrowseTixA.cls'.
# Date: Thu Sep 14 23:03:52 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> monthBrowserTixA <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Pool_GuiBase
	package require Tix

# Namespace describing the class
namespace eval ::pool::oo::class::monthBrowserTixA {
    variable  _superclasses    valueManager
    variable  _scChainForward  monthBrowserTixA
    variable  _scChainBackward monthBrowserTixA
    variable  _classVariables  {}
    variable  _methods         {OnWrap TrackCharWidth TrackMonth TrackYear constructor createSubwidgets setBindings setBindingsTo updateDisplay}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {charwidth {monthBrowserTixA {-default 12 -type ::pool::getopt::notype -action TrackCharWidth -class Charwidth}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . updateDisplay . setBindingsTo . TrackYear . constructor . setBindings . OnWrap . TrackCharWidth . TrackMonth .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::monthBrowserTixA::OnWrap {dir} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Increment/decrement operator for internal year browser.
	# @a dir: direction of wrap, must be one of 'up' or 'down'.

	switch -- $dir {
	    up      {$this.year incr}
	    down    {$this.year decr}
	    default {error "illegal wrap direction"}
	}
	return
}



proc ::pool::oo::class::monthBrowserTixA::TrackCharWidth {o oldValue} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Executed whenever the width of the widget is changed by the
	# @c outside.
	#
	# @a o: The name of the changed option, always '-charwidth'.
	# @a oldValue: The old value of the option.

	$this.year      configure -charwidth $opt(-charwidth)
	$this.monthlist configure -width     $opt(-charwidth)
	return
}



proc ::pool::oo::class::monthBrowserTixA::TrackMonth {month} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Callback. Used by the internal month list to integrate changes
	# @c to the month into the overall value. Executed every time the month
	# @c changed its value.
	#
	# @a month: The new value of the chosen month.

	::pool::date::splitMonth $opt(-value) year dummy

	configure -value [::pool::date::joinMonth $year $month]
	return
}



proc ::pool::oo::class::monthBrowserTixA::TrackYear {year} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Callback. Used by the internal year browser to integrate changes
	# @c to the year into the overall value. Executed every time the year
	# @c changed its value.
	#
	# @a year: The (possibly) new value of the chosen year.

	::pool::date::splitMonth $opt(-value) dummy month

	configure -value [::pool::date::joinMonth $year $month]
	return
}



proc ::pool::oo::class::monthBrowserTixA::constructor {} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Initialize the value to the current month and year, if not set
	# @c already by the user.

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) [::pool::date::2month [::pool::date::now]]
	}
	return
}



proc ::pool::oo::class::monthBrowserTixA::createSubwidgets {} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Generate the subwidgets and their layout.

	tixControl $this.year                     -integer            1              -min                1800            -highlightthickness 0                -width              $opt(-charwidth)  -command            [list ${this}::TrackYear]

	monthList $this.monthlist                          -bd                 2                       -relief             sunken                   -highlightthickness 0                         -width              $opt(-charwidth)           -command            [list ${this}::TrackMonth]  -onwrap             [list ${this}::OnWrap]

	pack $this.year      -side top -fill both -expand 0
	pack $this.monthlist -side top -fill both -expand 1
	return
}



proc ::pool::oo::class::monthBrowserTixA::setBindings {} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Adds various keyboard accelerators to the month browser.

	bind _${this}_keys <Key-Up>    [list ${this}.year incr]
	bind _${this}_keys <Key-Down>  [list ${this}.year decr]

	::pool::ui::prependBindTag $this.year       _${this}_keys
	::pool::ui::prependBindTag $this.monthlist  _${this}_keys
	::pool::ui::prependBindTag $this            _${this}_keys

	$this.monthlist setBindingsTo $this
	$this.monthlist setBindingsTo $this.year
	return
}



proc ::pool::oo::class::monthBrowserTixA::setBindingsTo {w} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag    $w  _${this}_keys
	$this.monthlist setBindingsTo $w
	return
}



proc ::pool::oo::class::monthBrowserTixA::updateDisplay {} {
    ::pool::oo::support::SetupVars monthBrowserTixA
    # @c Method required by the superclass <c valueManager> to
	# @c propagate changes to the value into the display.

	::pool::date::splitMonth $opt(-value) year month

	$this.year      configure -value $year
	$this.monthlist configure -value $month
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::monthBrowserTixA::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences monthBrowserTixA

# Create object instantiation procedure
interp alias {} monthBrowserTixA {} ::pool::oo::support::New monthBrowserTixA

# -------------------------------


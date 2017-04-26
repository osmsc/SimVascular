# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/monthBrowseTixB.cls'.
# Date: Thu Sep 14 23:03:53 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> monthBrowserTixB <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Pool_GuiBase
	package require Tix

# Namespace describing the class
namespace eval ::pool::oo::class::monthBrowserTixB {
    variable  _superclasses    valueManager
    variable  _scChainForward  monthBrowserTixB
    variable  _scChainBackward monthBrowserTixB
    variable  _classVariables  {}
    variable  _methods         {OnWrap TrackCharWidth TrackMonth TrackOrder TrackYear constructor createSubwidgets setBindings setBindingsTo updateDisplay}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {order {monthBrowserTixB {-default ym -type ::pool::ui::ymOrder -action TrackOrder -class Order}} charwidth {monthBrowserTixB {-default 12 -type ::pool::getopt::notype -action TrackCharWidth -class Charwidth}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . TrackOrder . updateDisplay . setBindingsTo . TrackYear . constructor . setBindings . OnWrap . TrackCharWidth . TrackMonth .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::monthBrowserTixB::OnWrap {dir} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Increment/decrement operator for internal year browser.
	# @a dir: direction of wrap, must be one of 'up' or 'down'.

	switch $dir {
	    up      {$this.year incr}
	    down    {$this.year decr}
	    default {error "illegal wrap direction"}
	}
	return
}



proc ::pool::oo::class::monthBrowserTixB::TrackCharWidth {o oldValue} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Executed whenever the width of the widget is changed by the
	# @c outside.
	#
	# @a o: The name of the changed option, always '-charwidth'.
	# @a oldValue: The old value of the option.

	$this.year      configure -charwidth $opt(-charwidth)
	$this.monthlist configure -width     $opt(-charwidth)
	return
}



proc ::pool::oo::class::monthBrowserTixB::TrackMonth {month} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Callback. Used by the internal month list to integrate changes
	# @c to the month into the overall value. Executed every time the month
	# @c changed its value.
	#
	# @a month: The new value of the chosen month.

	::pool::date::splitMonth $opt(-value) year dummy

	configure -value [::pool::date::joinMonth $year $month]
	return
}



proc ::pool::oo::class::monthBrowserTixB::TrackOrder {o oldValue} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c The widget defined allows arbitrary ordering of its
	# @c components. The corresponding option is -order.
	# @c This method is called everytime the option was set
	# @c and executes the necessary relayout.
	#
	# @a o: The name of the changed option, always '-order'.
	# @a oldValue: The old value of the option.

	switch $opt(-order) {
	    ym {
		pack $this.year      -side left -fill both -expand 0 -in $this
		pack $this.monthlist -side left -fill both -expand 1 -in $this
	    }
	    my {
		pack $this.monthlist -side left -fill both -expand 1 -in $this
		pack $this.year      -side left -fill both -expand 0 -in $this
	    }
	}
	return
}



proc ::pool::oo::class::monthBrowserTixB::TrackYear {year} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Callback. Used by the internal year browser to integrate changes
	# @c to the year into the overall value. Executed every time the year
	# @c changed its value.
	#
	# @a year: The (possibly) new value of the chosen year.

	::pool::date::splitMonth $opt(-value) dummy month

	configure -value [::pool::date::joinMonth $year $month]
	return
}



proc ::pool::oo::class::monthBrowserTixB::constructor {} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Initialize the value to the current month and year, if not set
	# @c already by the user.

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) [::pool::date::2month [::pool::date::now]]
	}
	return
}



proc ::pool::oo::class::monthBrowserTixB::createSubwidgets {} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Generate the subwidgets and their layout.

	tixControl $this.year                     -integer            1              -min                1800            -highlightthickness 0                -width              $opt(-charwidth)  -command            [list ${this}::TrackYear]

	monthListTix $this.monthlist                       -bd                 2                       -relief             sunken                   -highlightthickness 0                         -width              $opt(-charwidth)           -command            [list ${this}::TrackMonth]  -onwrap             [list ${this}::OnWrap]

	# Layout dependent on value of -order.
	TrackOrder -order {}
	return
}



proc ::pool::oo::class::monthBrowserTixB::setBindings {} {
    ::pool::oo::support::SetupVars monthBrowserTixB
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



proc ::pool::oo::class::monthBrowserTixB::setBindingsTo {w} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag    $w  _${this}_keys
	$this.monthlist setBindingsTo $w
	return
}



proc ::pool::oo::class::monthBrowserTixB::updateDisplay {} {
    ::pool::oo::support::SetupVars monthBrowserTixB
    # @c Method required by the superclass <c valueManager> to
	# @c propagate changes to the value into the display.

	::pool::date::splitMonth $opt(-value) year month

	$this.year      configure -value $year
	$this.monthlist configure -value $month
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::monthBrowserTixB::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences monthBrowserTixB

# Create object instantiation procedure
interp alias {} monthBrowserTixB {} ::pool::oo::support::New monthBrowserTixB

# -------------------------------


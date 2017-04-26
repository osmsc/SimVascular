# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/calendar.cls'.
# Date: Thu Sep 14 23:03:52 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> calendar <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Pool_GuiBase

# Namespace describing the class
namespace eval ::pool::oo::class::calendar {
    variable  _superclasses    valueManager
    variable  _scChainForward  calendar
    variable  _scChainBackward calendar
    variable  _classVariables  {}
    variable  _methods         {TrackDay TrackDayrelief TrackHeading TrackMonth TrackSunday TrackWeekno TrackYear constructor createSubwidgets setBindings setBindingsTo updateDisplay}

    variable  _variables
    array set _variables  {year {calendar {isArray 0 initialValue {}}} day {calendar {isArray 0 initialValue {}}} month {calendar {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {sunday {calendar {-default red -type ::pool::getopt::notype -action TrackSunday -class Sunday}} heading {calendar {-default black -type ::pool::getopt::notype -action TrackHeading -class Heading}} dayrelief {calendar {-default sunken -type ::pool::getopt::notype -action ::pool::ui::relief -class Dayrelief}} weekno {calendar {-default black -type ::pool::getopt::notype -action TrackWeekno -class Weekno}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackSunday . setBindings . TrackMonth . setBindingsTo . constructor . TrackWeekno . updateDisplay . TrackDayrelief . TrackDay . createSubwidgets . TrackHeading . TrackYear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::calendar::TrackDay {d} {
    ::pool::oo::support::SetupVars calendar
    # @c Callback for subordinate day widget.
	# @c Executed every time its value is set (not necessarily changed).
	# @n Does nothing, if no change took place (avoids infinite recursion).
	# @a d: The (possibly) new value of the chosen day.

	configure -value [::pool::date::join $year $month $d]
	return
}



proc ::pool::oo::class::calendar::TrackDayrelief {o oldValue} {
    ::pool::oo::support::SetupVars calendar
    # @c Executed whenever the relief of the buttons is set.
	#
	# @a o: The name of the changed option, always '-dayrelief'.
	# @a oldValue: The old value of the option.

	$this.day configure -dayrelief $opt(-dayrelief)
	return
}



proc ::pool::oo::class::calendar::TrackHeading {o oldValue} {
    ::pool::oo::support::SetupVars calendar
    # @c Executed whenever the color of the heading is changed.
	#
	# @a o: The name of the changed option, always '-heading'.
	# @a oldValue: The old value of the option.

	$this.day configure -heading $opt(-heading)
	return
}



proc ::pool::oo::class::calendar::TrackMonth {m} {
    ::pool::oo::support::SetupVars calendar
    # @c Callback for subordinate month widget.
	# @c Executed every time its value is changed.
	# @a m: The new value of the chosen month.

	set month $m
	$this.day configure -month [::pool::date::joinMonth $year $m]
	configure           -value [::pool::date::join      $year $m $day]
	return
}



proc ::pool::oo::class::calendar::TrackSunday {o oldValue} {
    ::pool::oo::support::SetupVars calendar
    # @c Executed whenever the color of the sunday column
	# @c requires a refresh.
	#
	# @a o: The name of the changed option, always '-sunday'.
	# @a oldValue: The old value of the option.

	$this.day configure -sunday $opt(-sunday)
	return
}



proc ::pool::oo::class::calendar::TrackWeekno {o oldValue} {
    ::pool::oo::support::SetupVars calendar
    # @c Executed whenever the color of the weeknumber
	# @c column requires a refresh.
	#
	# @a o: The name of the changed option, always '-weekno'.
	# @a oldValue: The old value of the option.

	$this.day configure -weekno $opt(-weekno)
	return
}



proc ::pool::oo::class::calendar::TrackYear {y} {
    ::pool::oo::support::SetupVars calendar
    # @c Callback for subordinate year widget.
	# @c Executed every time its value is changed.
	# @a y: The new value of the chosen year.

	set year $y

	$this.day configure -month [::pool::date::joinMonth $y $month]
	configure           -value [::pool::date::join      $y $month $day]
	return
}



proc ::pool::oo::class::calendar::constructor {} {
    ::pool::oo::support::SetupVars calendar
    # @c Initializes the value to the current date if not set already by
	# @c the user.

	set now [::pool::date::now]

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) $now
	}

	# Compute derived information for the first time.

	::pool::date::split $now year month day
	return
}



proc ::pool::oo::class::calendar::createSubwidgets {} {
    ::pool::oo::support::SetupVars calendar
    # @c Called by the framework to generate the subwidgets and their
	# @c layout.

	yearBrowser $this.year              -value              $year   -highlightthickness 0
		
	monthList $this.month                  -value              $month     -highlightthickness 0          -relief             sunken     -bd                 2          -onwrap             $this.year

	dayBrowser $this.day                        -value              $day            -highlightthickness 0               -heading            $opt(-heading)  -sunday             $opt(-sunday)   -weekno             $opt(-weekno)   -onwrap             $this.month

	label $this.date                       -bd                 3          -relief             groove     -text               {}         -highlightthickness 0

	$this.year  configure -command [list ${this}::TrackYear]
	$this.month configure -command [list ${this}::TrackMonth]
	$this.day   configure -command [list ${this}::TrackDay]

	grid $this.year   -column 0 -row 0 -sticky swen -in $this
	grid $this.month  -column 0 -row 1 -sticky swen -in $this
	grid $this.day    -column 1 -row 1 -sticky swen -in $this
	grid $this.date   -column 1 -row 0 -sticky swen -in $this

	grid columnconfigure $this 0 -weight 1
	grid columnconfigure $this 1 -weight 1
	grid rowconfigure    $this 0 -weight 1
	grid rowconfigure    $this 1 -weight 1
	return
}



proc ::pool::oo::class::calendar::setBindings {} {
    ::pool::oo::support::SetupVars calendar
    # @c Adds various keyboard accelerators to the calendar components.

	$this.day   setBindingsTo $this
	$this.day   setBindingsTo $this.year
	$this.day   setBindingsTo $this.month
	$this.day   setBindingsTo $this.date

	$this.month setBindingsTo $this
	$this.month setBindingsTo $this.day
	$this.month setBindingsTo $this.year
	$this.month setBindingsTo $this.date

	$this.year  setBindingsTo $this
	$this.year  setBindingsTo $this.day
	$this.year  setBindingsTo $this.month
	$this.year  setBindingsTo $this.date
	return
}



proc ::pool::oo::class::calendar::setBindingsTo {w} {
    ::pool::oo::support::SetupVars calendar
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	$this.day   setBindingsTo $w
	$this.month setBindingsTo $w
	$this.year  setBindingsTo $w
	return
}



proc ::pool::oo::class::calendar::updateDisplay {} {
    ::pool::oo::support::SetupVars calendar
    # @c Method required by the superclass <c valueManager>
	# @c to propagate changes to the value into the display.

	::pool::date::split $opt(-value) year month day

	$this.year   configure -value $year
	$this.month  configure -value $month
	$this.day    configure -value $day  -month [::pool::date::2month $opt(-value)]
	$this.date   configure -text   [clock format [clock scan $opt(-value)] -format {%d. %B %Y}]

	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::calendar::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences calendar

# Create object instantiation procedure
interp alias {} calendar {} ::pool::oo::support::New calendar

# -------------------------------


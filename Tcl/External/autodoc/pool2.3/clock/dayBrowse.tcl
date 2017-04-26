# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/clock/dayBrowse.cls'.
# Date: Thu Sep 14 23:03:52 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> dayBrowser <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Global initialization code
package require Pool_GuiBase

# Namespace describing the class
namespace eval ::pool::oo::class::dayBrowser {
    variable  _superclasses    valueManager
    variable  _scChainForward  dayBrowser
    variable  _scChainBackward dayBrowser
    variable  _classVariables  {}
    variable  _methods         {GetOffset OnWrap RefreshDay RefreshDisplay TrackDayrelief TrackHeading TrackMonth TrackSunday TrackWeekno constructor createSubwidgets downOne downSeven setBindings setBindingsTo upOne upSeven updateDisplay}

    variable  _variables
    array set _variables  {chosen {dayBrowser {isArray 0 initialValue -1}} monlen {dayBrowser {isArray 0 initialValue {}}} y {dayBrowser {isArray 0 initialValue {}}} m {dayBrowser {isArray 0 initialValue {}}} offset {dayBrowser {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {sunday {dayBrowser {-default red -type ::pool::getopt::notype -action TrackSunday -class Sunday}} heading {dayBrowser {-default black -type ::pool::getopt::notype -action TrackHeading -class Heading}} dayrelief {dayBrowser {-default sunken -type ::pool::getopt::notype -action ::pool::ui::relief -class Dayrelief}} weekno {dayBrowser {-default black -type ::pool::getopt::notype -action TrackWeekno -class Weekno}} month {dayBrowser {-default {} -type ::pool::getopt::notype -action TrackMonth -class Month}} onwrap {dayBrowser {-default {} -type ::pool::getopt::notype -action {} -class Onwrap}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {downSeven . TrackSunday . downOne . setBindings . TrackMonth . setBindingsTo . upSeven . TrackWeekno . constructor . upOne . updateDisplay . TrackDayrelief . createSubwidgets . TrackHeading . RefreshDisplay . RefreshDay . GetOffset . OnWrap .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::dayBrowser::GetOffset {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Internal method. Computes the weekday associated to
	# @c the first day in a month. This is used to correctly
	# @c indent the topmost row of day buttons.

	return [clock format [clock scan $m/01/$y] -format {%w}]
}



proc ::pool::oo::class::dayBrowser::OnWrap {direction} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Propagates wraparound events, if possible
	# @a direction: direction of wrap, one 'up' or
	# @a direction: 'down' respectively.

	if {[string compare $opt(-onwrap) ""] == 0} {
	    return
	}

	uplevel #0 $opt(-onwrap) $direction
	return
}



proc ::pool::oo::class::dayBrowser::RefreshDay {storeChange day} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Refreshes the day buttons after a change of the current value.
	#
	# @a storeChange: 1 if called by day button <a day>. This requires
	# @a storeChange: propagation of the new value to all internal data
	# @a storeChange: structures. 0 makes internal changes visible to the
	# @a storeChange: user, by changing the appearance of the buttons.
	#
	# @a day: Relevant for <a storeChange>=1, index of activated button.

	# change last day back to normal, then compute button of new day,
	# at last show the new day using the active relief

	if {$storeChange} {
	    # stop possible infinite recursion
	    if {$day == $opt(-value)} {
		return
	    }
	} else {
	    set day $opt(-value)
	}

	if {$chosen >= 0} {
	    $this.d_[format %02d $chosen] configure -relief flat
	}

	set chosen [expr {$day + $offset}]

	$this.d_[format %02d $chosen] configure -relief $opt(-dayrelief)

	if {$storeChange} {
	    configure -value $day
	}

	return
}



proc ::pool::oo::class::dayBrowser::RefreshDisplay {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Refreshes the area containing the day buttons according
	# @c to changes in day, month or year.

	set  ml     $monlen
	set  off    [GetOffset]
	set  chosen -1

	incr ml $off

	# revert everything into initial state

	for {set i 0} {$i < 42} {incr i} {
	    $this.d_[format %02d $i] configure  -text    {}                 -command {}                 -relief  flat               -state   disabled
	}

	foreach i {1 2 3 4 5 6} {
	    $this.wnr_$i configure -text {}
	}

	# now configure the really used buttons

	for {set i $off; set j 1} {$i < $ml} {incr i; incr j} {
	    $this.d_[format %02d $i] configure                  -text    $j                                 -relief  flat                               -command [list ${this}::RefreshDay 1 $j]  -state   normal
	}

	# don't forget update of weeknumbers

	set wk   [clock format [clock scan $m/01/$y]      -format %U]
	set wend [clock format [clock scan $m/$monlen/$y] -format %U]

	set wk   [::pool::date::StripLeadingZeros $wk]
	set wend [::pool::date::StripLeadingZeros $wend]

	foreach i { 1 2 3 4 5 6} {
	    if {$wk > $wend} {
		break
	    }

	    $this.wnr_$i configure -text $wk
	    incr wk
	}

	# BEWARE: buttons running from 00..41
	#         days    running from 01..<ml>
	# an additional adjustement is required

	incr off -1

	set offset $off

	RefreshDay 0 ""
	return
}



proc ::pool::oo::class::dayBrowser::TrackDayrelief {o oldValue} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Executed whenever the relief of the buttons is set.
	#
	# @a o: The name of the changed option, always '-dayrelief'.
	# @a oldValue: The old value of the option.

	if {[string compare $chosen ""] == 0} {
	    # no day selected, nothing to do.
	    return
	}

	$this.d_[format %02d $chosen] configure -relief $opt(-dayrelief)
	return
}



proc ::pool::oo::class::dayBrowser::TrackHeading {o oldValue} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Executed whenever the color of the heading is changed.
	#
	# @a o: The name of the changed option, always '-heading'.
	# @a oldValue: The old value of the option.

	foreach i {0 1 2 3 4 5 6} {
	    $this.wkd_$i configure -fg $opt(-heading)
	}

	# Regenerate the colors at the left and right side, they were
	# overwritten by the loop above

	TrackSunday -sunday {}
	TrackWeekno -weekno {}
	return
}



proc ::pool::oo::class::dayBrowser::TrackMonth {o oldValue} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Executed every time the month/year information
	# @c is changed.
	#
	# @a o: The name of the changed option, always '-month'.
	# @a oldValue: The old value of the option.

	# Update derived information, ...

	::pool::date::splitMonth $opt(-month) y m
	set monlen [::pool::date::monthLength $opt(-month)]

	# ... then refresh the display

	RefreshDisplay

	if {$opt(-value) > $monlen} {
	    # Correct for choice at end of month
	    # Avoid conversion errors

	    configure -value $monlen
	}

	return
}



proc ::pool::oo::class::dayBrowser::TrackSunday {o oldValue} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Executed whenever the color of the sunday column
	# @c requires a refresh.
	#
	# @a o: The name of the changed option, always '-sunday'.
	# @a oldValue: The old value of the option.

	$this.wkd_0 configure -fg $opt(-sunday)

	foreach i {00 07 14 21 28 35} {
	    $this.d_$i configure -fg $opt(-sunday)
	}

	return
}



proc ::pool::oo::class::dayBrowser::TrackWeekno {o oldValue} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Executed whenever the color of the weeknumber
	# @c column requires a refresh.
	#
	# @a o: The name of the changed option, always '-weekno'.
	# @a oldValue: The old value of the option.

	foreach i {0 1 2 3 4 5 6} {
	    $this.wnr_$i configure -fg $opt(-weekno)
	}

	return
}



proc ::pool::oo::class::dayBrowser::constructor {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Initializes the value to the current day if not set already by the
	# @c user. Initializes the month/year information to the current
	# @c month/year if not already set by the user.

	::pool::date::split [::pool::date::now] year month day

	if {[string compare $opt(-value) ""] == 0} {
	    set opt(-value) $day
	}

	if {[string compare $opt(-month) ""] == 0} {
	    set opt(-month) [::pool::date::joinMonth $year $month]
	}

	# Compute derived information for the first time.

	::pool::date::splitMonth $opt(-month) y m

	set monlen [::pool::date::monthLength $opt(-month)]

	return
}



proc ::pool::oo::class::dayBrowser::createSubwidgets {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Called by the framework to generate the subwidgets and their
	# @c layout.


	# weekday names as headings, weeknumbers at right side

	foreach i {0 1 2 3 4 5 6} {

	    # short weekday name
	    set wdn [::pool::string::cap  [string range [::pool::date::weekdayName $i] 0 1]]

	    label $this.wkd_$i                 -highlightthickness 0      -bd                 3      -anchor             e      -relief             flat   -text               $wdn

	    label $this.wnr_$i                 -highlightthickness 0      -bd                 3      -anchor             e      -relief             flat   -text               {}
	}

	# main area of buttons

	for {set i 0} {$i < 42} {incr i} {
	    button $this.d_[format %02d $i]   -highlightthickness 0     -bd                 3     -anchor             e     -relief             flat  -text               {}
	}

	# now define the layout
	
	foreach i {0 1 2 3 4 5 6} {
	    grid $this.wkd_$i -row 0 -column $i -sticky swen
	}

	foreach row {1 2 3 4 5 6} {
	    set i [expr {7*($row-1)}]
	    # column count of 'i' done in inner loop via 'incr' !

	    foreach col {0 1 2 3 4 5 6} {
		#set i [expr {$col + 7*($row -1)}]

		grid $this.d_[format %02d $i]  -row $row -column $col -sticky swen
		incr i
	    }

	    grid $this.wnr_$row -row $row -column 7 -sticky swen
	}

	grid $this.wnr_0 -row 0 -column 7 -sticky swen
	$this.wnr_0 configure -text Weekno

	foreach c {0 1 2 3 4 5 6 7} {grid columnconfigure $this $c -weight 1}
	foreach r {0 1 2 3 4 5 6}   {grid rowconfigure    $this $r -weight 1}

	# initialize colors
	# -- must be done after prop by superclass!! AfterCons
	TrackHeading -heading {}

	RefreshDisplay
	return
}



proc ::pool::oo::class::dayBrowser::downOne {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Decrements chosen day by one. Touching the lower bound triggers
	# @c a wrap-around to the highest value possible. This event
	# @c might be propagated.

	set v $opt(-value)

	if {$v == 1} {
	    OnWrap down

	    # this might change the parameter month! and therefore monlen.

	    set  v $monlen
	} else {
	    incr v -1
	}

	configure -value $v
	return
}



proc ::pool::oo::class::dayBrowser::downSeven {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Increments chosen day by seven (ahead a week). Touching the
	# @c upper bound triggers a wrap-around. This event might be
	# @c propagated.

	set  v $opt(-value)
	incr v 7

	if {$v > $monlen} {
	    set v [expr {$v - $monlen}]
	    OnWrap up
	}

	configure -value $v
	return
}



proc ::pool::oo::class::dayBrowser::setBindings {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Adds various keyboard accelerators to the daybrowser.

	bind _${this}_keys <Key-Left>  [list ${this}::downOne]
	bind _${this}_keys <Key-Right> [list ${this}::upOne]
	bind _${this}_keys <Key-Up>    [list ${this}::upSeven]
	bind _${this}_keys <Key-Down>  [list ${this}::downSeven]

	::pool::ui::prependBindTag $this _${this}_keys

	foreach w [winfo children $this] {
	    ::pool::ui::prependBindTag $w _${this}_keys
	}

	return
}



proc ::pool::oo::class::dayBrowser::setBindingsTo {w} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Adds various keyboard accelerators to the given widget.
	# @a w: The widget the accelerators are added to.

	::pool::ui::prependBindTag $w _${this}_keys
	return
}



proc ::pool::oo::class::dayBrowser::upOne {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Increments the chosen day by one. Touching the upper bound
	# @c triggers a wrap-around to the lowest value possible. This event
	# @c might be propagated.

	set v $opt(-value)

	if {$v == $monlen} {
	    OnWrap up

	    # this might change the parameter month! and therefore monlen.

	    set v 1
	} else {
	    incr v
	}

	configure -value $v
	return
}



proc ::pool::oo::class::dayBrowser::upSeven {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Decrements chosen day by seven (back a week). Touching the
	# @c lower bound triggers a wrap-around. This event might be
	# @c propagated.

	set  v $opt(-value)
	incr v -7

	if {$v < 1} {
	    OnWrap down

	    # this might change the parameter month! and therefore monlen.

	    set v [expr {$monlen + $v}]
	}

	configure -value $v
	return
}



proc ::pool::oo::class::dayBrowser::updateDisplay {} {
    ::pool::oo::support::SetupVars dayBrowser
    # @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display. Requests are simply
	# @c forwarded to <m dayBrowser:RefreshDay>

	RefreshDay 0 ""
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::dayBrowser::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences dayBrowser

# Create object instantiation procedure
interp alias {} dayBrowser {} ::pool::oo::support::New dayBrowser

# -------------------------------


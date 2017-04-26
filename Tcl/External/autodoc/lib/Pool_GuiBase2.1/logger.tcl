# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/logger.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> logger <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::logger {
    variable  _superclasses    widget
    variable  _scChainForward  logger
    variable  _scChainBackward logger
    variable  _classVariables  {}
    variable  _methods         {TrackTHeight TrackTWidth clear constructor createSubwidgets levelcolor log}

    variable  _variables
    array set _variables  {lcolor {logger {isArray 1 initialValue {}}}}

    variable  _options
    array set _options  {twidth {logger {-default 80 -type ::pool::getopt::notype -action TrackTWidth -class Twidth}} level {logger {-default debug -type ::pool::syslog::logLevel -action {} -class Level}} theight {logger {-default 10 -type ::pool::getopt::notype -action TrackTHeight -class Theight}} slow {logger {-default 0 -type ::pool::getopt::boolean -action {} -class Slow}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . TrackTWidth . constructor . log . TrackTHeight . clear . levelcolor .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::logger::TrackTHeight {o oldv} {
    ::pool::oo::support::SetupVars logger
    # @c Configure procedure. Propagates changes to the height of the
	# @c widget into the display.
	#
	# @a o:    The changed option.
	# @a oldv: The old value of the option.

	$this.t configure -height $opt(-theight)
	return
}



proc ::pool::oo::class::logger::TrackTWidth {o oldv} {
    ::pool::oo::support::SetupVars logger
    # @c Configure procedure. Propagates changes to the width of the
	# @c widget into the display.
	#
	# @a o:    The changed option.
	# @a oldv: The old value of the option.

	$this.t configure -width $opt(-twidth)
	return
}



proc ::pool::oo::class::logger::clear {} {
    ::pool::oo::support::SetupVars logger
    # @c Clear log
	$this.t delete 1.0 end
	return
}



proc ::pool::oo::class::logger::constructor {} {
    ::pool::oo::support::SetupVars logger
    # @c Constructor. Reads the level colors from the syslog facility of
	# @c Pool, see <f base/syslog.tcl>, to allow changes without affecting
	# @c the defaults.

	foreach lv [::pool::syslog::levels] {
	    set lcolor($lv) [::pool::syslog::2color $lv]
	}
}



proc ::pool::oo::class::logger::createSubwidgets {} {
    ::pool::oo::support::SetupVars logger
    # @c Create and pack the internally used widgets (text, scrollbar)

	scrollbar    $this.s
	text         $this.t -width $opt(-twidth) -height $opt(-theight)
	::pool::ui::multiScroll $this.s vertical $this.t

	pack $this.s -side left -expand 0 -fill both
	pack $this.t -side left -expand 1 -fill both

	# initialize tags for colorized background

	foreach lv [::pool::syslog::levels] {
	    if {$lcolor($lv) != {}} {
		$this.t tag configure $lv -background $lcolor($lv)
	    }
	}

	return
}



proc ::pool::oo::class::logger::levelcolor {level color} {
    ::pool::oo::support::SetupVars logger
    # @c Changes the <a color> used to display messages of <a level>.
	# @c Affects all messages, even already added ones.
	# @a level: The name of the level to change the color for.
	# @a color: The new color to use.

	if {![::info exists lcolor($level)]} {
	    error "unknown message level $level"
	}

	set lcolor($level) $color

	if {$color == {}} {
	    $this.t tag configure $level -background [frameWidget cget -bg]
	} else {
	    $this.t tag configure $level -background $color
	}
	return
}



proc ::pool::oo::class::logger::log {level text} {
    ::pool::oo::support::SetupVars logger
    # @c Adds <a text> to log, under the given <a level>. Ignores all
	# @c messages with a <a level> below <o level>.
	# @a level: Message level, used as tag.
	# @a text:  Text to log

	if {[::pool::syslog::levelCmp $level $opt(-level)] < 0} {
	    return
	}

	$this.t insert end "$text\n" $level
	$this.t see end

	if {$opt(-slow)} {
	    update idletasks
	    update
	}

	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::logger::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences logger

# Create object instantiation procedure
interp alias {} logger {} ::pool::oo::support::New logger

# -------------------------------


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: logger.cls,v 1.1 1998/06/01 19:55:59 aku Exp $
#
# @c Logger based upon modified text widget. Suitable for usage in
# @c conjunction with <p ::pool::syslog::syslog>.
# @s Log widget
# @i syslog, log widget
# -----------------------------

class logger : widget {

    # @o slow: Boolean flag. If set this widget will cause an
    # @o slow: update cycle of the display after each message
    # @o slow: added and displayed.

    option slow -d 0 -t ::pool::getopt::boolean

    # @o level: The lowest level a message must have to be displayed
    # @o level: by this widget

    option level -d debug -t ::pool::syslog::logLevel

    # @o theight: Width to be requested by the internal text-widget.
    # @o twidth: Width to be requested by the internal text-widget.

    option theight -d 10 -a TrackTHeight
    option twidth  -d 80 -a TrackTWidth

    # @v lcolor: Array mapping from level names to the colors used as
    # @v lcolor: background for the messages of this level.

    var -array lcolor


    method logger {} {
	# @c Constructor. Reads the level colors from the syslog facility of
	# @c Pool, see <f base/syslog.tcl>, to allow changes without affecting
	# @c the defaults.

	foreach lv [::pool::syslog::levels] {
	    set lcolor($lv) [::pool::syslog::2color $lv]
	}
    }


    method createSubwidgets {} {
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


    method log {level text} {
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


    method clear {} {
	# @c Clear log
	$this.t delete 1.0 end
	return
    }


    method levelcolor {level color} {
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


    method TrackTHeight {o oldv} {
	# @c Configure procedure. Propagates changes to the height of the
	# @c widget into the display.
	#
	# @a o:    The changed option.
	# @a oldv: The old value of the option.

	$this.t configure -height $opt(-theight)
	return
    }


    method TrackTWidth {o oldv} {
	# @c Configure procedure. Propagates changes to the width of the
	# @c widget into the display.
	#
	# @a o:    The changed option.
	# @a oldv: The old value of the option.

	$this.t configure -width $opt(-twidth)
	return
    }
}


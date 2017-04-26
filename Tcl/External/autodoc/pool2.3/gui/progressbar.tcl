# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/progressbar.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> progressbar <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::progressbar {
    variable  _superclasses    valueManager
    variable  _scChainForward  progressbar
    variable  _scChainBackward progressbar
    variable  _classVariables  {}
    variable  _methods         {SetDimensions TrackBarColor TrackBarLength TrackBarWidth TrackGeometry TrackOrientation constructor createSubwidgets setBindings updateDisplay}

    variable  _variables
    array set _variables  {orientation {progressbar {isArray 0 initialValue {}}} barItem {progressbar {isArray 0 initialValue {}}} pos {progressbar {isArray 0 initialValue 0.0}}}

    variable  _options
    array set _options  {orientation {progressbar {-default horizontal -type ::pool::ui::orientation -action TrackOrientation -class Orientation}} barcolor {progressbar {-default red -type ::pool::getopt::notype -action TrackBarColor -class Barcolor}} barwidth {progressbar {-default 20 -type ::pool::getopt::notype -action TrackBarWidth -class Barwidth}} barlength {progressbar {-default 100 -type ::pool::getopt::notype -action TrackBarLength -class Barlength}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackBarLength . createSubwidgets . TrackBarColor . TrackOrientation . TrackGeometry . updateDisplay . SetDimensions . constructor . setBindings . TrackBarWidth .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::progressbar::SetDimensions {} {
    ::pool::oo::support::SetupVars progressbar
    # @c Updates the internal information about the drawn bar. Executed
	# @c during initialization or changes to the widget orientation.

	switch -- $orientation {
	    x {$this._c config -width $opt(-barlength) -height $opt(-barwidth)}
	    y {$this._c config -width $opt(-barwidth)  -height $opt(-barlength)}
	}

	$this._c itemconfigure $barItem -width [expr {2.0*$opt(-barwidth)}]
	return
}



proc ::pool::oo::class::progressbar::TrackBarColor {o oldValue} {
    ::pool::oo::support::SetupVars progressbar
    # @c Configure procedure. Propagates changes to the color of the bar
	# @c into the display.
	#
	# @a o:        The changed option.
	# @a oldValue: The old value of the option.

	$this._c itemconfigure $barItem        -fill         $opt(-barcolor)  -activefill   $opt(-barcolor)  -disabledfill $opt(-barcolor)
	return
}



proc ::pool::oo::class::progressbar::TrackBarLength {o oldValue} {
    ::pool::oo::support::SetupVars progressbar
    # @c Configure procedure. Propagates changes to the length of the bar
	# @c into the display.
	#
	# @a o:        The changed option.
	# @a oldValue: The old value of the option.

	# size of long dimension (horizontal: width, vertical: height)

	switch -- $orientation {
	    x {$this._c config -width  $opt(-barlength)}
	    y {$this._c config -height $opt(-barlength)}
	}

	updateDisplay
	return
}



proc ::pool::oo::class::progressbar::TrackBarWidth {o oldValue} {
    ::pool::oo::support::SetupVars progressbar
    # @c Configure procedure. Propagates changes to the width of the bar
	# @c into the display.
	#
	# @a o:        The changed option.
	# @a oldValue: The old value of the option.

	# size of small dimension (horizontal: height, vertical: width)

	switch -- $orientation {
	    x {$this._c config -height $opt(-barwidth)}
	    y {$this._c config -width  $opt(-barwidth)}
	}

	$this._c itemconfigure $barItem -width [expr {2.0 * $opt(-barwidth)}]

	# no update of display required, pixel position not changed here.
	return
}



proc ::pool::oo::class::progressbar::TrackGeometry {w h} {
    ::pool::oo::support::SetupVars progressbar
    # @c Executed for 'Configure' events, i.e. resizing operations. Updates
	# @c the internal information about the drawn bar, then refreshes the
	# @c display.
	#
	# @a w: New width  of the widget.
	# @a h: New height of the widget.

	switch -- $orientation {
	    x {set opt(-barwidth) $h; set opt(-barlength) $w}
	    y {set opt(-barwidth) $w; set opt(-barlength) $h}
	}

	SetDimensions
	updateDisplay
	return
}



proc ::pool::oo::class::progressbar::TrackOrientation {o oldValue} {
    ::pool::oo::support::SetupVars progressbar
    # @c Configure procedure. Propagates changes to the orientation of the
	# @c bar into the display.
	#
	# @a o:        The changed option.
	# @a oldValue: The old value of the option.

	set orientation [::pool::ui::MsConvertDirection $opt(-orientation)]

	SetDimensions
	updateDisplay
	return
}



proc ::pool::oo::class::progressbar::constructor {} {
    ::pool::oo::support::SetupVars progressbar
    # @c Constructor. Initializes the value of the inherited option
	# @c '-value' to zero.

	if {$opt(-value) == {}} {
	    set opt(-value) 0.0
	}

	set orientation [::pool::ui::MsConvertDirection $opt(-orientation)]
	return
}



proc ::pool::oo::class::progressbar::createSubwidgets {} {
    ::pool::oo::support::SetupVars progressbar
    # @c Called after object construction. Generates the internal widgets
	# @c and their layout.

	canvas $this._c -bg $opt(-background) -bd 0 -highlightthickness 0
	pack   $this._c       -side   top   -fill   both  -expand true  -padx   0     -pady   0     -ipadx  0     -ipady  0
   
	set barItem [$this._c create line 0 0 0 0]

	$this._c itemconfigure $barItem        -fill         $opt(-barcolor)  -activefill   $opt(-barcolor)  -disabledfill $opt(-barcolor)

	SetDimensions
	return
}



proc ::pool::oo::class::progressbar::setBindings {} {
    ::pool::oo::support::SetupVars progressbar
    # @c Called after widget construction and layout. Adds the bindings
	# @c required to make the widget reactive to changes in the enviroment.
	# @c Here we track changes to the geometry, as imposed by the user or
	# @c containing geometry managers.

	bind $this._c <Configure> [list ${this} TrackGeometry %w %h]
	return
}



proc ::pool::oo::class::progressbar::updateDisplay {} {
    ::pool::oo::support::SetupVars progressbar
    # @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display. Converts the percentage
	# @c value into a pixelposition and then executes a redraw of the bar.

	set pos [expr {$opt(-barlength) * 0.01 * double ($opt(-value))}]

	switch -- $orientation {
	    x {
		$this._c coords $barItem  0.0  0.0          $pos 0.0
	    }

	    y {
		$this._c coords $barItem   0.0 $opt(-barlength)  0.0 [expr {$opt(-barlength) - $pos}]
	    }
	}

	update idletasks
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::progressbar::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::valueManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences progressbar

# Create object instantiation procedure
interp alias {} progressbar {} ::pool::oo::support::New progressbar

# -------------------------------


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# 1995     -- Andreas Kupries <aku@kisters.de>
# 1996/7/8 -- Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: progressbar.cls,v 1.1 1998/06/01 19:55:59 aku Exp $
#
# @c Generation and maintenance of progressbars
# @s Progressbar widget
# @i progressbar, animated feedback, feedback
# -------------------------------------------

class progressbar : valueManager {

    # @o barcolor: Color of the bar, defaults to 'red'.

    option barcolor -d red -a TrackBarColor

    # @o barwidth: width of the bar in pixels for vertical
    # @o barwidth: orientation, height else.

    option barwidth -d 20 -a TrackBarWidth

    # @o barlength: Length of the bar in pixels
    # @o barlength: (height for vertical orientation).

    option barlength -d 100 -a TrackBarLength

    # @o orientation: Orientation of the progressbar.

    option orientation -d horizontal -a TrackOrientation \
	    -t ::pool::ui::orientation

    # @v pos: Pixel position of the bar, derived from the value of
    # @v pos: option -value.

    var pos 0.0

    # @v barItem: Index of the canvas item used as bar.

    var barItem

    # @v orientation:  Internal orientation code of the bar, derived from the
    # @v orientation:  value of option -orientation.

    var orientation



    method progressbar {} {
	# @c Constructor. Initializes the value of the inherited option
	# @c '-value' to zero.

	if {$opt(-value) == {}} {
	    set opt(-value) 0.0
	}

	set orientation [::pool::ui::MsConvertDirection $opt(-orientation)]
	return
    }


    method createSubwidgets {} {
	# @c Called after object construction. Generates the internal widgets
	# @c and their layout.

	canvas $this._c -bg $opt(-background) -bd 0 -highlightthickness 0
	pack   $this._c      \
		-side   top  \
		-fill   both \
		-expand true \
		-padx   0    \
		-pady   0    \
		-ipadx  0    \
		-ipady  0
   
	set barItem [$this._c create line 0 0 0 0]

	$this._c itemconfigure $barItem       \
		-fill         $opt(-barcolor) \
		-activefill   $opt(-barcolor) \
		-disabledfill $opt(-barcolor)

	SetDimensions
	return
    }



    method setBindings {} {
	# @c Called after widget construction and layout. Adds the bindings
	# @c required to make the widget reactive to changes in the enviroment.
	# @c Here we track changes to the geometry, as imposed by the user or
	# @c containing geometry managers.

	bind $this._c <Configure> [list ${this} TrackGeometry %w %h]
	return
    }



    method TrackBarColor {o oldValue} {
	# @c Configure procedure. Propagates changes to the color of the bar
	# @c into the display.
	#
	# @a o:        The changed option.
	# @a oldValue: The old value of the option.

	$this._c itemconfigure $barItem       \
		-fill         $opt(-barcolor) \
		-activefill   $opt(-barcolor) \
		-disabledfill $opt(-barcolor)
	return
    }



    method TrackBarWidth {o oldValue} {
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



    method TrackBarLength {o oldValue} {
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



    method TrackOrientation {o oldValue} {
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


    method TrackGeometry {w h} {
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



    method updateDisplay {} {
	# @c Method required by the superclass <c valueManager> to propagate
	# @c changes to the value into the display. Converts the percentage
	# @c value into a pixelposition and then executes a redraw of the bar.

	set pos [expr {$opt(-barlength) * 0.01 * double ($opt(-value))}]

	switch -- $orientation {
	    x {
		$this._c coords $barItem \
			0.0  0.0         \
			$pos 0.0
	    }

	    y {
		$this._c coords $barItem  \
			0.0 $opt(-barlength) \
			0.0 [expr {$opt(-barlength) - $pos}]
	    }
	}

	update idletasks
	return
    }



    method SetDimensions {} {
	# @c Updates the internal information about the drawn bar. Executed
	# @c during initialization or changes to the widget orientation.

	switch -- $orientation {
	    x {$this._c config -width $opt(-barlength) -height $opt(-barwidth)}
	    y {$this._c config -width $opt(-barwidth)  -height $opt(-barlength)}
	}

	$this._c itemconfigure $barItem -width [expr {2.0*$opt(-barwidth)}]
	return
    }
}


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: ui.tcl,v 1.3 1999/06/06 20:34:50 aku Exp $
#
# @c Helper procedures for manipulation of user interfaces.
# @s Helper procedures for manipulation of user interfaces.
#
# @i User interface manipulation
# @i interface manipulation
# @i manipulation of user interfaces

package require Tcl 8.0
package require Pool_Base


# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval ui {
	variable version @guibase:mFullVersion@
	namespace export *

	# conversion table from directions to scrollcommands (only the
	# relevant prefix is stored here.

	variable  scrollcmd
	array set scrollcmd {
	    x          x
	    horizontal x
	    horizonta  x
	    horizont   x
	    horizon    x
	    horizo     x
	    horiz      x
	    hori       x
	    hor        x
	    ho         x
	    h          x
	    y          y
	    vertical   y
	    vertica    y
	    vertic     y
	    verti      y
	    vert       y
	    ver        y
	    ve         y
	    v          y
	}


	# options recognized by the packed separator

	variable pSepOption

	::pool::getopt::defOption pSepOption in
	::pool::getopt::defOption pSepOption orientation \
		-d h -t ::pool::ui::orientation

	::pool::getopt::defShortcuts pSepOption


	# options recognized by the gridded separator

	variable gSepOption

	::pool::getopt::defOption gSepOption in
	::pool::getopt::defOption gSepOption orientation \
		-d h -t ::pool::ui::orientation

	::pool::getopt::defOption gSepOption row    -t ::pool::getopt::integer
	::pool::getopt::defOption gSepOption column -t ::pool::getopt::integer
	::pool::getopt::defOption gSepOption span   -t ::pool::getopt::integer

	::pool::getopt::defShortcuts gSepOption
    }
}


proc ::pool::ui::mapWindow {w args} {
    # @c Executes the partial command stored in <a args> for
    # @c window <a w> and all its children.
    # @a w: top of window hierarchy to traverse
    # @a args: partial command to execute

    # @i window hierarchy traversal, scan windows,
    # @i traverse window hierarchy, window traversal

    catch {
	eval $w $args
    }

    foreach sub [winfo children $w] {
	catch {
	    eval mapWindow $sub $args
	}
    }

    return
}



proc ::pool::ui::multiScrollList {scrollbar dir widgets} {
    # @c Binds the <a scrollbar> to all specified <a widgets> to let them
    # @c scroll together.
    #
    # @a dir:       Scroll direction.
    # @a scrollbar: Scrollbar to manipulate all <a widgets>
    # @a widgets:   List of widgets to synchronize via <a scrollbar>.

    # @i synchronous scrolling

    set dir [MsConvertDirection $dir]

    $scrollbar configure \
	    -command [list ::pool::ui::MsHandleScrollbar $widgets $dir]

    foreach w $widgets {
	$w configure -${dir}scrollcommand \
		[list ::pool::ui::MsHandleWidget $scrollbar $widgets $dir]
    }

    return
}


proc ::pool::ui::multiScroll {scrollbar dir args} {
    # @c Essentially the same as <p ::pool::ui::multiScrollList>. The
    # @c difference: The widgets to scroll as unit are specified by a variable
    # @c number of arguments, instead of a list.
    #
    # @a dir:       Scroll direction
    # @a scrollbar: Scrollbar to manipulate all widgets in <a args>.
    # @a args:      List of widgets to synchronize via <a scrollbar>.

    # @i synchronous scrolling

    multiScrollList $scrollbar $dir $args
    return
}


proc ::pool::ui::MsHandleScrollbar {widgets dir args} {
    # @c Scrollbar callback. Just propagates the given scroll data (in
    # @c <a args>) to the associated <a widgets>.
    #
    # @a widgets: List of synchronized widgets.
    # @a dir:     Scroll direction.
    # @a args:    Scroll information, as given by tk.

    foreach w $widgets {
	eval $w ${dir}view $args
    }

    return
}


proc ::pool::ui::MsHandleWidget {scrollbar widgets dir first last} {
    # @c Callback for listboxes bound to <a scrollbar>. Updates the
    # @c <a scrollbar> and all <a widgets> connected to it.
    #
    # @n This code doesn't care to exclude the invoking widget from the
    # @n update. It assumes that the invoker detects and aborts the possible
    # @n looping.
    #
    # @a scrollbar: Scrollbar widget connected to all <a widgets>.
    # @a widgets:   List of widgets synchronized by <a scrollbar>.
    # @a dir:       Scroll direction.
    # @a first:     Standard scroll parameter, as given by Tk.
    # @a last:      Standard scroll parameter, as given by Tk.

    $scrollbar set $first $last

    foreach w $widgets {
	eval $w ${dir}view moveto $first
    }

    return
}



proc ::pool::ui::MsConvertDirection {dir} {
    # @c Converts the specified direction into the subcommand to use for
    # @c scrolling (either xscrollcommand or yscrollcommand).
    #
    # @a dir: The scroll direction, possible values are 'x', 'y',
    # @a dir: 'horizontal', 'vertical' and all unique prefixes.
    #
    # @r The unique prefix of the scrollcommand to give to the scrollbar
    # @r widget, i.e. 'x' or 'y'.

    variable scrollcmd
    if {! [orientation {} $dir]} {
	error "unknown direction $dir"
    }

    return $scrollcmd($dir)
}


proc ::pool::ui::orientation {o v} {
    # @c Type checker procedure. Accepts only the keys of 'scrollcmd' as
    # @c directional values.
    #
    # @a o: The name of the option to check.
    # @a v: The value to check
    # @r A boolean value. True signal acceptance of <a v>.

    variable scrollcmd
    return [info exists scrollcmd($v)]
}



proc ::pool::ui::relief {o v} {
    # @c Type checker procedure. Accepts only the standard relief codes.
    #
    # @a o: The name of the option to check.
    # @a v: The value to check
    # @r A boolean value. True signal acceptance of <a v>.

    switch -- $v {
	raised -
	sunken -
	flat   -
	ridge  -
	solid  -
	groove {return 1}
    }
    return 0
}



proc ::pool::ui::ymOrder {o v} {
    # @c Type checker procedure. Accepts the order codes used by
    # @c <c monthBrowserTixB>.
    #
    # @a o: The name of the option to check.
    # @a v: The value to check
    # @r A boolean value. True signal acceptance of <a v>.

    switch -- $v {
	ym -
	my {return 1}
    }
    return 0
}



proc ::pool::ui::ymdOrder {o v} {
    # @c Type checker procedure. Accepts the order codes used by
    # @c <c calendarTix>.
    #
    # @a o: The name of the option to check.
    # @a v: The value to check
    # @r A boolean value. True signal acceptance of <a v>.

    switch -- $v {
	ymd -
	ydm -
	dym -
	myd -
	mdy -
	dmy {return 1}
    }
    return 0
}


proc ::pool::ui::packSeparator {w args} {
    # @c Generates a horizontal/vertical separator bar named <a w>. The
    # @c separator is actually a frame, but forced into a thin line by the
    # @c 'pack' geometry manager.
    #
    # @a w:    name of the separator window.
    # @a args: List of <option,value>-pairs. 
    # @a args: Accepts '-orientation', '-in' and all unique prefixes.

    # @i separator bars

    variable pSepOption

    frame $w -relief flat -bd 2 -bg black

    ::pool::getopt::initValues pSepOption oVal
    set oVal(-in) [winfo parent $w]

    ::pool::getopt::processOpt pSepOption $args oVal

    switch -exact -- [MsConvertDirection $oVal(-orientation)] {
	x {
	    pack $w -side top  -fill x -expand 1 -pady 1m -in $oVal(-in)
	}
	y {
	    pack $w -side left -fill y -expand 1 -pady 1m -in $oVal(-in)
	}
    }

    return
}



proc ::pool::ui::gridSeparator {w args} {
    # @c Generates a horizontal/vertical separator bar named <a w>. The
    # @c separator is actually a frame, but forced into a thin line by the
    # @c 'grid' geometry manager.
    #
    # @a w:    Name of the separator window.
    # @a args: List of <option,value>-pairs.  Accepts '-orientation', '-in',
    # @a args: '-row', '-column', '-span' and all unique prefixes.

    # @i separator bars

    variable gSepOption

    frame $w -relief flat -bd 2 -bg black

    ::pool::getopt::initValues gSepOption oVal
    set oVal(-in) [winfo parent $w]

    ::pool::getopt::processOpt gSepOption $args oVal

    switch -exact -- [MsConvertDirection $oVal(-orientation)] {
	x {
	    $w configure -height 1

	    grid $w -row        $oVal(-row)    \
		    -column     $oVal(-column) \
		    -columnspan $oVal(-span)   \
		    -sticky     we             \
		    -in         $oVal(-in)
	}
	y {
	    $w configure -width 1

	    grid $w -row     $oVal(-row)    \
		    -column  $oVal(-column) \
		    -rowspan $oVal(-span)   \
		    -sticky  sn             \
		    -in      $oVal(-in)
	}
    }

    return
}


proc ::pool::ui::center {w} {
    # @c Centers the widget <a w> on the screen.
    # @n Does not work for the main window ('.').
    # @a w: The path of the window to center on the screen.

    wm withdraw $w
    update idletasks

    set p [winfo parent $w]

    set sWidth  [winfo screenwidth  $w]
    set sHeight [winfo screenheight $w]

    set wrWidth  [winfo reqwidth $w]
    set wrHeight [winfo reqheight $w]

    set x [expr {$sWidth/2  - $wrWidth/2  - [winfo vrootx $p]}]
    set y [expr {$sHeight/2 - $wrHeight/2 - [winfo vrooty $p]}]

    wm geometry  $w +$x+$y
    wm deiconify $w
    return
}


proc ::pool::ui::centerMain {w h} {
    # @c Centers the main window on the screen. Uses information from
    # @c `wm geometry` to calculate the positioning.
    # @a w: Requested width of the main window.
    # @a h: Requested height of the main window.

    wm withdraw .
    update idletasks

    wm geometry  . ${w}x${h}

    set x [expr [winfo screenwidth  .]/2 - $w/2  - [winfo vrootx .]]
    set y [expr [winfo screenheight .]/2 - $h/2  - [winfo vrooty .]]

    wm geometry  . +$x+$y
    wm deiconify .
    return
}


proc ::pool::ui::nyi {args} {
    # @c Shows a modal dialog warning the user about
    # @c entering a missing part of the application.
    # @a args: Additional to text to display in the dialog.

    # @i not-yet-implemented dialog, under construction, incompletion hints
    # @see <p ::pool::ui::nyiTix>

    if {$args == {}} {
	tk_dialog .nyi Info "Under construction" warning 0 Ok
    } else {
	tk_dialog .nyi Info "Under construction: $args" warning 0 Ok
    }

    return
}



proc ::pool::ui::prependBindTag {w tag} {
    # @c Add the <a tag> to the binding tags of <a w>. The new tag is added at
    # @c the front of the current tag-list.
    #
    # @a w:   The widget to add the <a tag> to.
    # @a tag: The name of the tag to add to widget <a w>.

    set                   tags [bindtags $w]
    ::pool::list::unshift tags $tag

    bindtags $w $tags
    return
}



proc ::pool::ui::appendBindTag {w tag} {
    # @c Add the <a tag> to the binding tags of <a w>. The new tag is added
    # @c behind the end  of the current tag-list.
    #
    # @a w:   The widget to add the <a tag> to.
    # @a tag: The name of the tag to add to widget <a w>.

    set     tags [bindtags $w]
    lappend tags $tag

    bindtags $w $tags
    return
}



proc ::pool::ui::bool2state {booleanValue} {
    # @c Converts a boolean value as accepted by 'expr', 'if',
    # @c etc. into a state value as accepted by most widgets
    # @c (option -state). True is equivalent to 'normal', false
    # @c means 'disabled'.
    #
    # @a booleanValue: The value to convert.
    # @r is one of 'normal' and 'disabled'.

    #                             true v     false v
    return [expr {$booleanValue ? "normal" : "disabled"}]
}


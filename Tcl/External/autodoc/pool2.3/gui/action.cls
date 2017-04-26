# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase
#
# 1995   -- Andreas Kupries <aku@kisters.de>
# 1996/7 -- Andreas Kupries <a.kupries@westend.com>
# 1999   -- Andreas Kupries <a.kupries@westend.com>
#
# CVS : $Id: action.cls,v 1.7 2000/08/01 15:07:34 aku Exp $
#
# @c button rows
# @s button rows
# @i button rows, widgets
# -------------------------------

class actionrow : widget {
    # @c Maintains a row of buttons and associates commands.

    # if DEFAULT specifies a button, this one
    # is highlighted by an outer frame and will be invoked
    # with <RETURN> / <ENTER>.
    #
    # VAR specifies the global variable to store the index
    # of the button invoked by the user.
    #
    # the indices are counted from 0 (leftmost button (for -orient horizontal))

    # @o fill:        Fill flag to use to pack each button
    # @o padx:        Horizontal padding to use during packing of each button.
    # @o pady:        Vertical padding to use during packing of each button.
    # @o orientation: Orientation of the button row.
    # @o default:     Index of the default button to invoke the complete action
    # @o escape:      Index of the default button to cancel

    option fill        -d none       -a Repack
    option padx        -d 0          -a Repack
    option pady        -d 0          -a Repack
    option orientation -d horizontal -a Repack
    option default     -d -1
    option escape      -d -1

    # @v n: Counter, contains the number of buttons added so far.
    var n 0

    # @v names: Map from symbolic names to button locations
    var -array names {}


    method createSubwidgets   {} {
	# @c Generates subordinate widgets and their layout.
	# @c Here only the master frame requires configuration.
	# @c The buttons will be added later via <m add>.
	# @n Called automatically by the object framework.

	frameWidget configure \
		-bg                 $opt(-background)         \
		-highlightthickness $opt(-highlightthickness) \
		-bd                 $opt(-border)             \
		-relief             $opt(-relief)
	return
    }


    method Repack {} {
	# @c Called after changes to the value of some options.
	# @c Executes a relayout of the widget.

	doForSub "pack forget %b"
	doForSub [list pack %b \
		-side   [cvtOrientation $opt(-orientation)] \
		-in     $this        \
		-expand 1            \
		-padx   $opt(-padx)  \
		-pady   $opt(-pady)  \
		-fill   $opt(-fill)]
	return
    }


    method doForSub {cmd} {
	# @c Executes the <a cmd> for all buttons which are part of the widget.
	# @a cmd: Script to be executed. Occurences of %b will be
	# @a cmd: substituted with the path of the current button.

	for {set i 0} {$i < $n} {incr i} {
	    if {$i == $opt(-default)} {
		set w $this.default
	    } else {
		set w $this.b$i
	    }
	    regsub -- {%b} $cmd $w cmdE
	    eval $cmdE
	}
    }


    method cvtOrientation {o} {
	# @c converts row orientation <a o> into
	# @c a value acceptable to 'pack -side'.
	# @a o: orientation to convert.

	switch -- $o {
	    horizontal {return left}
	    vertical   {return top}
	    backward   {return right}
	    upward     {return bottom}
	    default    {"error illegal orientation $o"}
	}
    }


    method add {name text command} {
	# @c Adds a new button to the row, labels it with
	# @c <a text> and performs the necessary setup so
	# @c that <a command> is executed in case of its
	# @c invocation.
	# @a text: text to use as label of the new button
	# @a command: script to execute in case of an
	# @a command: invocation of the new button.
	# @a name: Symbolic name of the new button.

	set  place $n
	incr n
	set  names($name) $place

	set b    $opt(-background)
	set f    $opt(-foreground)
	set h    $opt(-highlightthickness)
	set side [cvtOrientation $opt(-orientation)]

	if {$place == $opt(-default)} {
	    frame  $this.default        -bg $b -highlightthickness $h -relief sunken -bd 2
	    button $this.b$place -fg $f -bg $b -highlightthickness $h

	    pack $this.default		\
		    -in     $this	\
		    -side   $side	\
		    -expand 1		\
		    -padx   $opt(-padx)	\
		    -pady   $opt(-pady)	\
		    -fill   $opt(-fill)

	    pack $this.b$place		\
		    -in $this.default	\
		    -padx 2m		\
		    -pady 2m

	    # fast invocation of default
	    bind [winfo toplevel $this] <Return> "$this.b$place invoke"
	} else {
	    button $this.b$place -fg $f -bg $b -highlightthickness $h

	    pack $this.b$place		\
		    -in     $this	\
		    -side   $side	\
		    -expand 1		\
		    -padx   $opt(-padx)	\
		    -pady   $opt(-pady)	\
		    -fill   $opt(-fill)
	}

	if {$place == $opt(-escape)} {
	    # allow fast cancel
	    bind [winfo toplevel $this] <Key-Escape> "$this.b$place invoke"
	}

	addSubwidget $name $this.b$place

	$this.b$place configure -text $text -command $command
    }


    method change {name newtext} {
	# @c Changes the text associated to the button
	# @c with the symbolic <a name> to <a newtext>.
	# @a newtext: text to place into the button.
	# @a name: Symbolic name of the button to change.

	set place $names($name)

	$this.b$place configure -text $newtext
	return
    }
}


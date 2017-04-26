# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: gPopupMenu.cls,v 1.2 1998/09/30 19:05:02 aku Exp $
#
# @c Generic popup menu widget
# @s Generic popup menu widget
# @i popup, generic popup menu
# -----------------------------

class genericPopupMenu : widget {
    # @c Instances of this class maintains a popup menu

    # @o command: Script to execute upon invocation of a menu entry

    option command -d {}

    # @v entries: Number of entries added so far.

    var entries 0

    # @v entry: Mapping from symbolic names to menu entries

    var -array entry




    method createSubwidgets {} {
	# @c Generate the internal widget. No placement yet, this is done later
	# @c and explicitly (see <m show> and <m showRelative>)

	menu  $this._m -tearoff 0
	return
    }



    method addEntry {command {underline -1} {name {}}} {
	# @c Adds a new menu entry to the popup menu.
	# @a name: String to display in the new entry. The special
	# @a name: value '-' forces generation of a separator line.
	# @a underline: Index of the character in <a name> to underline.
	# @a command: Symbolic name of command associated to the entry

	if {"$command" == "-"} {
	    $this._m add separator
	} else {
	    $this._m add command         \
		    -label     $name     \
		    -underline $underline \
		    -command   [list ${this}::InvokeEntry $command]

	    set entry($command) $entries
	}

	incr entries
	return
    }


    method addEntries {spec} {
	# @c Adds a bunch of entries to the popup menu.
	# @a spec: A list suitable for usage with 'array set'.
	# @a spec: The first item of each pair is the command
	# @a spec: code to give to the external script
	# @a spec: (<o command>) upon invocation
	# @a spec: of the entry. It serves as symbolic name of
	# @a spec: the entry too. The 2nd item in each pair is
	# @a spec: the string to display in the entry. A command
	# @a spec: of '-' indicates a separator line. The display
	# @a spec: string is ignored in this case, but has to
	# @a spec: be present nevertheless. A command name has
	# @a spec: to be unique over all menubuttons added to
	# @a spec: a menubar.

	foreach {command text} $spec {
	    if {[string compare $command -] == 0} {
		# Separator
		$this._m add separator
	    } else {
		# Standard button

		$this._m add command         \
			-label     $text    \
			-underline -1       \
			-command   [list ${this}::InvokeEntry $command]

		set entry($command) $entries
	    }

	    incr entries
	}

	return
    }



    method entryconfigure {command args} {
	# @c Accessor method allowing the reconfiguration of all entries in the
	# @c menubar. Access is given based upon the symbolic name of the
	# @c entry. The mapping to the menu widget of the entry and its index
	# @c in that is done here.
	#
	# @a command: Symbolic name of the command to operate on.
	# @a args:    List of option, value pairs.

	set index $entry($command)

	eval $this._m entryconfigure $index $args
	return
    }



    method show {x y} {
	# @c Show the popup menu and wait for selection or cancellation.
	#
	# @a x: Place to show the menu at, relative to the rootwindow of the
	# @a x: display.
	# @a y: Place to show the menu at, relative to the rootwindow of the
	# @a y: display.

	tk_popup $this._m $x $y
	return
    }


    method showRelative {w x y} {
	# @c Show the popup menu and wait for selection or cancellation.
	#
	# @a w: Path to widget used as root of the coordinates.
	# @a x: Place to show the menu at, relative to widget <a w>.
	# @a y: Place to show the menu at, relative to widget <a w>.

	set x [expr {$x + [winfo rootx $w] - ([winfo reqwidth $this._m] / 2)}]
	set y [expr {$y + [winfo rooty $w] + 10}]

	tk_popup $this._m $x $y
	return
    }



    method width {} {
	# @r Retrieve the width of the menu.
	return [winfo reqwidth $this._m]
    }



    method associate {w cmd} {
	# @c Associate the popup menu with widget <a w>, evaluate <a cmd> upon
	# @c invokation of a menu entry. The association takes the form of a
	# @c binding of mouse button 2 causing the display of the menu relative
	# @c to <a w>.
	#
	# @a w:   Path to the widget to add the menu to.
	# @a cmd: Script to invoke upon activation of a menu
	# @a cmd: entry. Changes <o command>.

	configure -command $cmd

	bind $w <2> [list ${this}::showRelative $w %x %y]
	return
    }



    method InvokeEntry {command} {
	# @c Internal method, called upon invocation of a menu entry.
	# @a command: Symbolic name of the invoked entry.

	if {$opt(-command) == {}} {
	    return
	}

	uplevel #0 $opt(-command) [list $this] [list $command]
	return
    }
}


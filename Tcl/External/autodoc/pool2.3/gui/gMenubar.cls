# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: gMenubar.cls,v 1.2 1998/09/30 19:05:02 aku Exp $
#
# @c Generic menubar widget
# @s Generic menubar widget
# @i menubar, generic menubar
# -----------------------------

class genericMenubar : widget {
    # @c Instances of this class maintain a generic menubar

    # @o command: Script to execute upon invocation of a menu entry. Two
    # @o command: arguments are added before any evaluation. These are the path
    # @o command: to the menubar invoking the command and the symbolic name of
    # @o command: the invoked command itself.

    option command -d {}

    # @v entry: Mapping from symbolic names to menu entries

    var -array entry



    method createSubwidgets {} {
	# @c Generate the menubar, place it in the toplevel, use the new menu
	# @c mechanism of tk.

	menu  $this._m -tearoff 0
	after idle [winfo toplevel $this] configure -menu $this._m
	return
    }


    method addMenu {name underline spec} {
	# @c Adds a new menubutton and its entries to the menubar.

	# @a name:      String to display in the new button
	# @a underline: Index of the character in <a name> to underline.
	#
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


	set m m_[::pool::serial::new]
	set i 1

	$this._m add cascade           \
		-label     $name       \
		-menu      $this._m.$m \
		-underline $underline

	menu $this._m.$m
	# 0 = index of tearoff entry

	foreach {command text} $spec {
	    if {[string compare $command -] == 0} {
		# Separator
		$this._m.$m add separator
	    } else {
		# Standard button

		$this._m.$m add command \
			-label   $text \
			-command [list ${this}::InvokeEntry $command]

		set entry($command) [list $m $i]
	    }

	    incr i
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

	set menu  [lindex $entry($command) 0]
	set index [lindex $entry($command) 1]

	eval $this._m.$menu entryconfigure $index $args
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


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: watchman.cls,v 1.1 1998/06/01 19:56:00 aku Exp $
#
# @c management for option -variable of a widget displaying a single
# @c value. Actually a stripped down version of <c valueManager>.
#
# @s value management (-value), as in <dep Tix>
# @i value management, -value, widgets
# -----------------------------------------------------------


class watchManager : widget {
    # @c Defines and manages the option '-variable'. Derived classes must
    # @c provide a method 'updateDisplay'. It will be called after changes to
    # @c the value and has to refresh the shown information according to the
    # @c changed value.

    # @v value: The value managed by instances of this
    # @v value: class and all its derived classes.

    # @o variable: Name of the (global) variable associated to the widget.
    # @o variable: Any changes to its contents are propagated into the widget
    # @o variable: and vice versa.

    var    value
    option variable -d "" -a TrackVariable



    method watchManager {} {
	# @c Special constructor. Schedules the execution of the real
	# @c initialization to happen after the standard initialization and
	# @c the creation of all component widgets of the derived class.

	${this}::AfterCons ${this}::InitializeManager
    }


    method ~watchManager {} {
	# @c Special destructor. Removes the association between the widget
	# @c and the variable specified in '-variable', if the latter is not
	# @c empty. This is accomplished through the deletion of the variable
	# @c trace set earlier by this widget.

	if {$opt(-variable) == {}} {
	    return
	}

	upvar #0 $opt(-variable) v

	trace vdelete v w ${this}::TrackVarContents
	return
    }



    method updateDisplay {} {
	# @c Dummy method, must be overridden by derived classes.
	# @c This one will only throw an error.

	error "subclass did not provide 'updateDisplay'"
    }



    method TrackVariable {o oldValue} {
	# @c Configure procedure. Used to track changes to the value of
	# @c -variable. Removes the traces set upon the old associated
	# @c variable, then links in the new variable and its contents.
	#
	# @a o:        The name of the changed option.
	# @a oldValue: The value of the option before the change.

	# We can be sure that the value did change! The runtime support
	# already filters out 'configure' operations not changing the option.

	if {$oldValue != {}} {
	    # We had an associated variable, now delete this association.

	    upvar #0 $oldValue oldVar
	    trace vdelete oldVar w ${this}::TrackVarContents
	}

	if {$opt(-variable) != {}} {
	    # We got a new associated variable, build up the link. Create the
	    # variable if not already existing.

	    upvar #0 $opt(-variable) v

	    if {[uplevel #0 info exists [list $opt(-variable)]]} {
		# This variable exists, link it in, use its value
		
		set value $v
	    } else {
		# This variable does not exist; set it here, use the
		# current widget value.

		set v $value
	    }

	    trace variable v w ${this}::TrackVarContents
	}

	return
    }



    method TrackVarContents {var idx op} {
	# @c Internal trace callback to monitor the value of the variable
	# @c associated to the widget.
	#
	# @a var: Standard trace argument, base name of traced variable
	# @a idx: Standard trace argument, index of traced variable, if an
	# @a idx: array item
	# @a op:  Standard trace argument, operation invoking the trace.

	upvar #0 $opt(-variable) v

	set value $v

	${this}::updateDisplay
	return
    }



    method InitializeManager {} {
	# @c Special method, is called after the completion of the
	# @c construction of widget and its components. Initializes the value
	# @c of the widget according to the contents of the associated
	# @c variable, if defined.

	TrackVariable -variable {}
	${this}::updateDisplay
	return
    }
}


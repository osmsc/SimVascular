# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: watchaman.cls,v 1.1 1998/06/01 19:56:00 aku Exp $
#
# @c management for option -variable of a widget displaying an array.
# @c Actually a stripped down version of <c valueManager>.
#
# @s value management (-value), as in <dep Tix>
# @i value management, -value, widgets
# -----------------------------------------------------------


class watchAManager : widget {
    # @c Defines and manages the option '-variable'. Derived classes must
    # @c provide the methods 'initDisplay', 'updateDisplay' and 'clearDisplay'.
    # @c They have to refresh the shown information according to the changed
    # @c value.

    # @o variable: Name of the (global) variable associated to the widget.
    # @o variable: Any changes to its contents are propagated into the widget
    # @o variable: and vice versa.

    option variable -d "" -a TrackVariable

    # operation in {u, w}

    # @v operation: The last operation on the array we are connected to, as
    # @v operation: given by the trace callback (<m TrackVarContents>).

    # @v item: The key used by the last operation on the array we are connected
    # @v item: to, as given by the trace callback (<m TrackVarContents>).

    var operation
    var item



    method watchAManager {} {
	# @c Special constructor. Schedules the execution of the real
	# @c initialization to happen after the standard initialization and
	# @c the creation of all component widgets of the derived class.

	${this}::AfterCons ${this}::InitializeManager
    }


    method ~watchAManager {} {
	# @c Special destructor. Removes the association between the widget
	# @c and the variable specified in '-variable', if the latter is not
	# @c empty. This is accomplished through the deletion of the variable
	# @c trace set earlier by this widget.

	if {$opt(-variable) == {}} {
	    return
	}

	upvar #0 $opt(-variable) v

	trace vdelete v wu ${this}::TrackVarContents
	return
    }



    method updateDisplay {} {
	# @c Dummy method, must be overridden by derived classes.
	# @c This one will only throw an error.

	error "subclass did not provide 'updateDisplay'"
    }



    method initDisplay {} {
	# @c Dummy method, must be overridden by derived classes.
	# @c This one will only throw an error.

	error "subclass did not provide 'initDisplay'"
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
	    trace vdelete oldVar wu ${this}::TrackVarContents

	    ${this}::clearDisplay
	}

	if {$opt(-variable) != {}} {
	    # We got a new associated variable, build up the link.

	    upvar #0 $opt(-variable) v

	    if {[uplevel #0 info exists [list $opt(-variable)]]} {
		# This variable exists, link it in, use its value
		
		${this}::initDisplay
	    }

	    trace variable v wu ${this}::TrackVarContents
	}

	return
    }



    method TrackVarContents {var idx op} {
	# @c Internal trace callback to monitor the value of the array variable
	# @c associated to the widget.
	#
	# @a var: Standard trace argument, base name of traced variable
	# @a idx: Standard trace argument, name of array item.
	# @a op:  Standard trace argument, operation invoking the trace.

	upvar #0 $opt(-variable) v

	if {[string compare $idx ""] == 0} {
	    # operation on the array as whole.

	    if {[string compare $op u] == 0} {
		# ignore deletion of the whole array.
		return
	    }

	    error "write on whole array impossible, or -variable no pointer to an array"
	}

	set operation $op
	set item      $idx

	${this}::updateDisplay
	return
    }


    method InitializeManager {} {
	# @c Special method, is called after the completion of the
	# @c construction of widget and its components. Initializes the value
	# @c of the widget according to the contents of the associated
	# @c variable, if defined.

	TrackVariable -variable {}
	return
    }
}


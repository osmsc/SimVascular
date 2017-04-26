# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: valueman.cls,v 1.1 1998/06/01 19:56:00 aku Exp $
#
# @c management for options -value, -variable and -command of
# @c a widget using a single value.  Actually snarfed from <dep Tix>
# @c and adapted to our oo system.
#
# @s value management (-value, -command, -variable), as in <dep Tix>
# @i value management, -value, -variable, -command, widgets
# -----------------------------------------------------------


class valueManager : widget {
    # @c Defines and manages the options '-value', '-variable', '-command' and
    # @c their interactions. Derived classes must provide a method
    # @c 'updateDisplay'. It will be called after changes to the value and has
    # @c to refresh the shown information according to the changed value.


    # @o command: Script to evaluate after changes to the
    # @o command: <o value>. A single argument is appended,
    # @o command: it contains the new value given to the widget.

    # @o value: The value managed by instances of this
    # @o value: class and all its derived classes.

    # @o variable: Name of the (global) variable associated to the widget.
    # @o variable: Any changes to its contents are propagated into the widget
    # @o variable: and vice versa.

    option command  -d ""
    option value    -d "" -a TrackValue
    option variable -d "" -a TrackVariable



    method valueManager {} {
	# @c Special constructor. Schedules the execution of the real
	# @c initialization to happen after the standard initialization and
	# @c the creation of all component widgets of the derived class.

	${this}::AfterCons ${this}::InitializeManager
    }


    method ~valueManager {} {
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



    method TrackValue {o oldValue} {
	# @c Configure procedure. Internal method used to track changes made
	# @c to the contents of option '-value'. Updates the associated global
	# @c variable, executes the specified command, then shows the new
	# @c value in the display. As both setting the -variable and execution
	# @c of the -command are allowed to change the -value this order must
	# @c not be changed or else we will be left with an inaccurate display.
	#
	# @a o:        The name of the changed option.
	# @a oldValue: The value of the option before the change.

	# We can be sure that the value did change! The runtime support
	# already filters out 'configure' operations not changing the option.

	UpdateVariable

	if {[string compare $oldValue $opt(-value)] == 0} {
	    # The update of the associated variable changed the contents of
	    # -value back to its old value (= Some trace on the associated
	    # variable rejected the change). Going on makes no sense.
	    return
	}

	ExecuteCmd

	if {[string compare $oldValue $opt(-value)] == 0} {
	    # The execution of the specified command changed the contents of
	    # -value back to its old value, some constraint in there rejected
	    # the change. Going on makes no sense.
	    return
	}

	${this}::updateDisplay
	return
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

	    if {[uplevel #0 info exists [list $opt(-variable)]]} {
		# This variable exists, link it in, use its value, don't
		# forget to evaluate the command.
		
		upvar #0 $opt(-variable) v

		set opt(-value) $v
		trace variable v w ${this}::TrackVarContents

		ExecuteCmd
	    } else {
		# This variable does not exist; let's set it here, use the
		# current widget value.

		upvar #0 $opt(-variable) v
		set v $opt(-value)
		trace variable v w ${this}::TrackVarContents
	    }
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

	# Incorporate the change made to the variable via 'configure'. The
	# runtime support will filter it out if there was no real change.
	# Write back the old widget value if an error occurred.

	upvar #0 $opt(-variable) v

	set fail [catch {configure -value $v}]
	if {$fail} {
	    set v $opt(-value)
	}

	return
    }




    method UpdateVariable {} {
	# @c Called after changes to the value. Updates the
	# @c associated global variable, if defined.
	#
	# @n Some technicalities to note:&p
	# @n The internal trace is temporarily removed to avoid a (possibly
	# @n infinite) recursive invocation of traces. The value of the global
	# @n variable is reread after its setting to catch restrictions made
	# @n by other traces.&p
	#
	# @n The code is originally from <d Tix>, and was modified to fit into
	# @n this oo framework.

	if {$opt(-variable) == {}} {
	    # No variable associated to the widget, nothing to do.
	    return
	}

	upvar #0 $opt(-variable) v

	trace vdelete  v w ${this}::TrackVarContents
	set            v   $opt(-value)
	trace variable v w ${this}::TrackVarContents

	set opt(-value) $v
	return
    }


    method ExecuteCmd {} {
	# @c Executes the tcl script associated to changes of the widget
	# @c value, if defined.
	#
	# @n Technicalities as in <m UpdateVariable>.

	if {$opt(-command) == {}} {
	    # No command to evaluate, nothing to do.
	    return
	}

	if {$opt(-variable) == {}} {
	    # No associated variable to consider here, just execute the
	    # command.

	    uplevel #0 $opt(-command) $opt(-value)
	} else {
	    # Avoid interference by associated variable, reread a possibly
	    # changed value after the evaluation.

	    upvar #0 $opt(-variable) v

	    trace vdelete  v w ${this}::TrackVarContents
	    uplevel #0 $opt(-command) $opt(-value)
	    trace variable v w ${this}::TrackVarContents

	    set opt(-value) $v
	}

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


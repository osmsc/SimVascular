# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/watchman.cls'.
# Date: Thu Sep 14 23:03:58 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> watchManager <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::watchManager {
    variable  _superclasses    widget
    variable  _scChainForward  watchManager
    variable  _scChainBackward watchManager
    variable  _classVariables  {}
    variable  _methods         {InitializeManager TrackVarContents TrackVariable constructor destructor updateDisplay}

    variable  _variables
    array set _variables  {value {watchManager {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {variable {watchManager {-default {} -type ::pool::getopt::notype -action TrackVariable -class Variable}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackVarContents . updateDisplay . InitializeManager . constructor . destructor . TrackVariable .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::watchManager::InitializeManager {} {
    ::pool::oo::support::SetupVars watchManager
    # @c Special method, is called after the completion of the
	# @c construction of widget and its components. Initializes the value
	# @c of the widget according to the contents of the associated
	# @c variable, if defined.

	TrackVariable -variable {}
	${this}::updateDisplay
	return
}



proc ::pool::oo::class::watchManager::TrackVarContents {var idx op} {
    ::pool::oo::support::SetupVars watchManager
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



proc ::pool::oo::class::watchManager::TrackVariable {o oldValue} {
    ::pool::oo::support::SetupVars watchManager
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



proc ::pool::oo::class::watchManager::constructor {} {
    ::pool::oo::support::SetupVars watchManager
    # @c Special constructor. Schedules the execution of the real
	# @c initialization to happen after the standard initialization and
	# @c the creation of all component widgets of the derived class.

	${this}::AfterCons ${this}::InitializeManager
}



proc ::pool::oo::class::watchManager::destructor {} {
    ::pool::oo::support::SetupVars watchManager
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



proc ::pool::oo::class::watchManager::updateDisplay {} {
    ::pool::oo::support::SetupVars watchManager
    # @c Dummy method, must be overridden by derived classes.
	# @c This one will only throw an error.

	error "subclass did not provide 'updateDisplay'"
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::watchManager::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences watchManager

# Create object instantiation procedure
interp alias {} watchManager {} ::pool::oo::support::New watchManager

# -------------------------------


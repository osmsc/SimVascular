# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/watchaman.cls'.
# Date: Thu Sep 14 23:03:58 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> watchAManager <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::watchAManager {
    variable  _superclasses    widget
    variable  _scChainForward  watchAManager
    variable  _scChainBackward watchAManager
    variable  _classVariables  {}
    variable  _methods         {InitializeManager TrackVarContents TrackVariable constructor destructor initDisplay updateDisplay}

    variable  _variables
    array set _variables  {operation {watchAManager {isArray 0 initialValue {}}} item {watchAManager {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {variable {watchAManager {-default {} -type ::pool::getopt::notype -action TrackVariable -class Variable}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackVarContents . updateDisplay . InitializeManager . constructor . initDisplay . destructor . TrackVariable .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::watchAManager::InitializeManager {} {
    ::pool::oo::support::SetupVars watchAManager
    # @c Special method, is called after the completion of the
	# @c construction of widget and its components. Initializes the value
	# @c of the widget according to the contents of the associated
	# @c variable, if defined.

	TrackVariable -variable {}
	return
}



proc ::pool::oo::class::watchAManager::TrackVarContents {var idx op} {
    ::pool::oo::support::SetupVars watchAManager
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



proc ::pool::oo::class::watchAManager::TrackVariable {o oldValue} {
    ::pool::oo::support::SetupVars watchAManager
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



proc ::pool::oo::class::watchAManager::constructor {} {
    ::pool::oo::support::SetupVars watchAManager
    # @c Special constructor. Schedules the execution of the real
	# @c initialization to happen after the standard initialization and
	# @c the creation of all component widgets of the derived class.

	${this}::AfterCons ${this}::InitializeManager
}



proc ::pool::oo::class::watchAManager::destructor {} {
    ::pool::oo::support::SetupVars watchAManager
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



proc ::pool::oo::class::watchAManager::initDisplay {} {
    ::pool::oo::support::SetupVars watchAManager
    # @c Dummy method, must be overridden by derived classes.
	# @c This one will only throw an error.

	error "subclass did not provide 'initDisplay'"
}



proc ::pool::oo::class::watchAManager::updateDisplay {} {
    ::pool::oo::support::SetupVars watchAManager
    # @c Dummy method, must be overridden by derived classes.
	# @c This one will only throw an error.

	error "subclass did not provide 'updateDisplay'"
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::watchAManager::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences watchAManager

# Create object instantiation procedure
interp alias {} watchAManager {} ::pool::oo::support::New watchAManager

# -------------------------------


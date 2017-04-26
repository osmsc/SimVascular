# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/base/sequencer.cls'.
# Date: Thu Sep 14 23:03:44 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> sequencer <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::sequencer {
    variable  _superclasses    {}
    variable  _scChainForward  sequencer
    variable  _scChainBackward sequencer
    variable  _classVariables  {}
    variable  _methods         {Event OnDone OnLine OnNext Receive Timeout errorInfo event next state wait}

    variable  _variables
    array set _variables  {nextMethod {sequencer {isArray 0 initialValue {}}} lineMethod {sequencer {isArray 0 initialValue {}}} state {sequencer {isArray 0 initialValue {}}} after {sequencer {isArray 0 initialValue {}}} error {sequencer {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {timeout {sequencer {-default {} -type ::pool::getopt::notype -action {} -class Timeout}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {OnNext . OnLine . state . wait . errorInfo . event . Event . OnDone . Timeout . Receive . next .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::sequencer::Event {event arglist} {
    ::pool::oo::support::SetupVars sequencer
    # @c The real event handler. Execution is set up by <m event>. Takes
	# @c the same arguments.

	# @a event: Name of event to raise. Allowed values are 'error',
	# @a event: 'timeout', 'eof', 'line', 'next' and 'done'.

	# @a arglist: Arbitrary arguments given to the event. Only 'error' and
	# @a arglist: 'line' actually use arguments (the first one only), all
	# @a arglist: else ignore this information.

	set state $event
	if {"$event" == "error"} {
	    set error $arglist
	}

	switch -- $event {
	    error   -
	    timeout -
	    eof     -
	    done    {
		if {[catch {$this OnDone} errmsg]} {
		    # errors in callback are reported via 'bgerror'.
		    global errorInfo

		    $this delete
		    error "$errmsg $errorInfo"
		}

		$this delete
	    }
	    next    {
		if {[catch {$this OnNext} errmsg]} {
		    # errors in the callback are reported via 'bgerror'.
		    global errorInfo

		    event error "$errmsg $errorInfo"
		    puts "-- event -- not a return --"
		    exit
		}
	    }
	    line {
		if {[catch {$this OnLine [lindex $arglist 0]} errmsg]} {
		    # errors in callback are reported via 'bgerror'.
		    global errorInfo

		    event error "$errmsg $errorInfo"
		    puts "-- event -- not a return --"
		    exit
		}
	    }
	    default {
		event error "unknown event \"$event\""
		    puts "-- event -- not a return --"
		    exit
	    }
	}
}



proc ::pool::oo::class::sequencer::OnDone {} {
    ::pool::oo::support::SetupVars sequencer
    # @c Abstract method. Called by the framework if the FA is done with
	# @c its work (= upon event 'done').
}



proc ::pool::oo::class::sequencer::OnLine {line} {
    ::pool::oo::support::SetupVars sequencer
    # @c Called by the framework to proceed after receiving a 'line' event.
	# @c The default implementation uses <v lineMethod> to call the
	# @c correct handler method.
	#
	# @a line: Contains the received information.

	if {$lineMethod != ""} {
	    return [$this $lineMethod $line]
	} else {
	    error "no line handler defined"
	}
}



proc ::pool::oo::class::sequencer::OnNext {} {
    ::pool::oo::support::SetupVars sequencer
    # @c Called by the framework to proceed to the next step in the
	# @c sequence (upon event 'next'). The default implementation uses
	# @c <v nextMethod> to call the correct method.

	if {$nextMethod != ""} {
	    return [$this $nextMethod]
	} else {
	    error "no sucessor defined"
	}
}



proc ::pool::oo::class::sequencer::Receive {channel} {
    ::pool::oo::support::SetupVars sequencer
    # @c Callback executed in case of data arriving at <a channel>. May
	# @c raise 'eof' and 'line' events in the sequencer. Will disable the
	# @c timeout in this cases. In case of having received an incomplete
	# @c line the system will just go to sleep again, to wait for more
	# @c data.
	#
	# @a channel: Name of channel the sequencer waited for.
	
	if {[eof $channel]} {
	    catch {after cancel $after}
	    set after ""
	    fileevent $channel readable {}
	    event eof
		    puts "-- event -- not a return --"
		    exit
	}

	if {[gets $channel line] < 0} {
	    # incomplete line, wait for more
	    return
	}

	catch {after cancel $after}
	set after ""
	fileevent $channel readable {}

	event line $line
	puts "-- event -- not a return --"
	exit
}



proc ::pool::oo::class::sequencer::Timeout {channel} {
    ::pool::oo::support::SetupVars sequencer
    # @c Callback executed in case of a timeout during the wait for input
	# @c at <a channel>. Removes the fileevent handler, then raises the
	# @c 'timeout' event in the sequencer.
	#
	# @a channel: Name of channel the sequencer waited for.
	
	set after ""
	fileevent $channel readable {}

	event timeout
	puts "-- event -- not a return --"
	exit
}



proc ::pool::oo::class::sequencer::errorInfo {} {
    ::pool::oo::support::SetupVars sequencer
    # @r The error information of this sequencer.

	return $error
}



proc ::pool::oo::class::sequencer::event {event args} {
    ::pool::oo::support::SetupVars sequencer
    # @c Raises <a event> in the given sequencer. Automatically the last
	# @c command executed in the surounding context, i.e behaves as
	# @c 'return'. The actual handling of the event is delayed by 'after'
	# @c and done inside <m Event>.
	#
	# @n Raising 'done' executes 'OnDone' and then automatically destroys
	# @n the sequencer
	#
	# @a event: Name of event to raise. Allowed values are 'error',
	# @a event: 'timeout', 'eof', 'line', 'next' and 'done'.

	# @a args: Arbitrary arguments given to the event. Only 'error' and
	# @a args: 'line' actually use arguments (the first one only), all else
	# @a args: ignore this information.

	#puts "args = $event <$args>"
	if {0} {
	    if {"$event" == "error"} {
		::puts "[::pool::dump::callstack "ev error $args"]"
	    }
	}

	if {$args == {}} {
	    after 1 $this Event $event {{}}
	} else {
	    after 1 $this Event $event [list $args]
	}

	# behave as if equivalent to 'return' command.
	return -code return
}



proc ::pool::oo::class::sequencer::next {method} {
    ::pool::oo::support::SetupVars sequencer
    # @c Defines a method to be executed if the 'next' event was triggered.
	# @c Removes any existing 'line' handler.
	#
	# @a method: The method to set as 'next' handler.

	set nextMethod $method
	set lineMethod {}
	return
}



proc ::pool::oo::class::sequencer::state {} {
    ::pool::oo::support::SetupVars sequencer
    # @r The state of this sequencer.

	return $state
}



proc ::pool::oo::class::sequencer::wait {channel method} {
    ::pool::oo::support::SetupVars sequencer
    # @c Convenience procedure to setup the sequencer to wait for input on
	# @c a <a channel>. After receiving a complete line the appropriate
	# @c event will be raised. The wait will be able to time out if such
	# @c information is part of the sequencer configuration. Removes any
	# @c existing 'next' handler .
	#
	# @a channel: Name of channel to wait on for input.
	# @a method:  Name of the method to execute after a line was received.

	if {$opt(-timeout) != {}} {
	    set after [after $opt(-timeout) $this Timeout $channel]
	}

	fileevent $channel readable [list $this Receive $channel]

	set nextMethod {}
	set lineMethod $method
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::sequencer::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods sequencer
::pool::oo::support::FixOptions sequencer

# Create object instantiation procedure
interp alias {} sequencer {} ::pool::oo::support::New sequencer

# -------------------------------


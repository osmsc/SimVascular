# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net
#
# CVS: $Id: sequencer.cls,v 1.1 1998/06/01 19:55:15 aku Exp $
#
# @c Framework for building sequencers. Currently used by the smtp and pop3
# @c implementations. See <xref seq_explain> for more information and
# @c <f net/pop3/*> and <f net/smtp/*> for examples of its usage.
# @s Sequencer framework
# @i Sequencer, State machines, finite automatons
# -----------------------------

class sequencer {

    # @o timeout: Timeout in milliseconds.

    option timeout -d ""

    # @v state: The current state of the sequencer. One of: error, timeout,
    # @v state: eof, done, next or line. Equal to the last event executed by
    # @v state: us.

    # @v error: Error message placed into the sequencer by a derived class.

    var state ""
    var error ""

    # @v nextMethod: Name of the method to call upon receiving the 'next'
    # @v nextMethod: event.

    var nextMethod ""

    # @v lineMethod: Name of the method to call upon receiving the 'line'
    # @v lineMethod: event.

    var lineMethod ""

    # @v after: The handle of the timeout set via <m wait>.

    var after



    method OnDone {} {
	# @c Abstract method. Called by the framework if the FA is done with
	# @c its work (= upon event 'done').
    }


    method OnNext {} {
	# @c Called by the framework to proceed to the next step in the
	# @c sequence (upon event 'next'). The default implementation uses
	# @c <v nextMethod> to call the correct method.

	if {$nextMethod != ""} {
	    return [$this $nextMethod]
	} else {
	    error "no sucessor defined"
	}
    }


    method OnLine {line} {
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


    method state {} {
	# @r The state of this sequencer.

	return $state
    }


    method errorInfo {} {
	# @r The error information of this sequencer.

	return $error
    }


    method event {event args} {
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


    method Event {event arglist} {
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


    method wait {channel method} {
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


    method Timeout {channel} {
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


    method Receive {channel} {
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


    method next {method} {
	# @c Defines a method to be executed if the 'next' event was triggered.
	# @c Removes any existing 'line' handler.
	#
	# @a method: The method to set as 'next' handler.

	set nextMethod $method
	set lineMethod {}
	return
    }
}


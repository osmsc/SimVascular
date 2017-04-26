# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: smtp.cls,v 1.1 1998/06/01 19:56:54 aku Exp $
#
# @c Management of SMTP connections
# @s SMTP conection management
# @i SMTP, management of SMTP connections
# -----------------------------

class smtpConnection {
    # @c Instances of this class manages a connection to an smtp demon. The
    # @c actual execution of command-reply sequences is delegated to sequencer
    # @c classes derived from <c smtpSequencer>. The methods encapsulating the
    # @c access to these low-level exchanges are <m Open>, <m Close>, <m Data>
    # @c and <m Prepare>. Based on these primitives a stateful high-level
    # @c interface is formed (<m open>, <m close> and <m put>). These methods
    # @c call the appropriate primitives according to the state of the
    # @c connection. I expect, that <m put> will be the most used method of
    # @c this class.

    # @o maxtries:   Specifies the maximum allowed number of trials to connect.
    # @o maxtries:   Defaults to 1.
    # @o retrydelay: Specifies the time to wait (in milliseconds) after a
    # @o retrydelay: failure before doing the next try. Defaults to 10 seconds.
    # @o host:       Specifies the host the demon to connect to resides on.
    # @o host:       Defaults to 'localhost'.
    # @o helo:       Specifies the string to use as argument for the HELO
    # @o helo:       command sent to the demon after its greeting.
    # @o timeout:    defines the number of milliseconds to wait before
    # @o timeout:    aborting a smtp command without having a response.
    # @o progress:   If not empty, a command to evaluate with current
    # @o progress:   connection and number of bytes transfered so far as
    # @o progress:   arguments.
    # @o blocksize:  Companion option to <o progress>, optional. Defines the
    # @o blocksize:  size of the blocks to transfer between invocations of
    # @o blocksize:  <o progress>. Ignored if <o progress> is empty.

    option helo       -d ""        -t ::pool::getopt::nonempty
    option maxtries   -d 1         -t ::pool::getopt::integer
    option retrydelay -d 10000     -t ::pool::getopt::integer
    option host       -d localhost -t ::pool::getopt::nonempty
    option timeout    -d ""
    option progress   -d ""
    option blocksize  -d 1024      -t ::pool::getopt::integer

    # @v sock:  The handle of the channel controlled by this object
    # @v state: The state of the last executed command.
    # @v error: The error message of the last executed, failed command.

    var sock   ""
    var state  ""
    var error  ""

    # @v opState: Contains the state of the currently running highlevel
    # @v opState: transaction.

    var -array opState {}

    # -W- use opState to ward off tries to execute multiple operations at once.


    method smtpConnection {} {
	# @c Constructor. Just logs the event.

	::pool::syslog::syslog info $this created
	return
    }


    method ~smtpConnection {} {
	# @c Destructor. Closes an active socket and logs the event.

	ClearSocket

	::pool::syslog::syslog info $this deleted
	return
    }


    method state {} {
	# @r the state of the SMTP connection.

	return $state
    }


    method errorInfo {} {
	# @r the error information of the SMTP connection.
	# @r Valid only in case of state = error.

	return $error
    }


    method ClearSocket {} {
	# @c Closes the connection to the smtp demon described
	# @c by this object.

	catch {::close $sock}
	set    sock ""

	::pool::syslog::syslog info $this channel closed
	return
    }


    method SetSock {s} {
	# @c Accessor method, used by the <c smtpOpenSeq> sequencer to transfer
	# @c information about the channel representing the connection to the
	# @c smtp demon.
	#
	# @a s: The handle of the channel representing the connection to the
	# @a s: smtp demon.

	set sock $s
	return
    }


    # ----------------------------------------------------
    # low level sequencers


    method Open {completionMethod} {
	# @c Opens a connection to the smtp demon described by this object.
	# @c Configures a <c smtpOpenSeq> object and then delegates the work
	# @c to it.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$opt(-helo)  == {}} {
	    error "no HELO text specified"
	}

	# create the sequencer ...

	smtpOpenSeq ${this}_open \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       $completionMethod \
		-maxtries   $opt(-maxtries)   \
		-retrydelay $opt(-retrydelay) \
		-host       $opt(-host)       \
		-helo       $opt(-helo)

	# ... and start its operation.

	${this}_open event next
	return
    }



    method Close {completionMethod} {
	# @c Close connection to the smtp demon described by this object.
	# @c Configures a <c smtpCloseSeq> object and then delegates the work
	# @c to it.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	# create the sequencer ...

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$sock == {}} {
	    error "no connection to smtp demon"
	}

	smtpCloseSeq ${this}_close \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       $completionMethod \
		-sock       $sock

	# ... and start its operation.

	${this}_close event next
	return
    }


    method Data {completionMethod message {msgIsString 0}} {
	# @c Executes the transfer of a message body via SMTP protocol.
	# @c Configures a <c smtpDataSeq> object and then delegates the work
	# @c to it.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.
	#
	# @a message: Handle of the channel containing the message to send over
	# @a message: (or the message itself (<a msgIsString> = TRUE)).
	#
	# @a msgIsString: A boolean value. Set if <a message> is no channel
	# @a msgIsString: handle, but the message itself.

	if {$message          == {}} {
	    error "no message channel specified"
	}
	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$sock             == {}} {
	    error "no connection to smtp demon"
	}

	# create the sequencer ...

	smtpDataSeq ${this}_data              \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       $completionMethod \
		-sock       $sock             \
		-progress   $opt(-progress)   \
		-blocksize  $opt(-blocksize)  \
		-message    $message          \
		-string     $msgIsString

	# ... and start its operation.

	${this}_data event next
	return
    }


    method Prepare {completionMethod from to} {
	# @c Prepares the transfer of a mail message by specifying sender and
	# @c recipients to the smtp demon described by this object. Configures
	# @c a <c smtpPrepareSeq> object and then delegates the work to it.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	# @a from: The address of the sender.
	# @a to: A list containing the addresses of the intended receivers.

	# create the sequencer ...

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$from             == {}} {
	    error "no message sender specified"
	}
	if {$to               == {}} {
	    error "no list of receivers specified"
	}
	if {$sock == {}} {
	    error "no connection to smtp demon"
	}

	smtpPrepareSeq ${this}_prep           \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       $completionMethod \
		-sock       $sock             \
		-from       $from             \
		-to         $to

	# ... and start its operation.

	${this}_prep event next
	return
    }


    # ----------------------------------------------------
    # high level sequencing


    method Finish {{seq {}}} {
	# @c Called by all highlevel sequencers at the end of their operation.
	# @c Retrieves the state of the invoking sequencers and changes the
	# @c state of the connection accordingly. Detection of errors cause the
	# @c shutdown of the connection to the demon.
	#
	# @a seq: Handle of the sequencer finishing its operation. Empty if
	# @a seq: the requested operation was a no-op. In that case it was
	# @a seq: called immediately too.

	if {$seq == {}} {
	    ::pool::syslog::syslog info $this done

	    # fake a done state
	    set state done
	} else {
	    set state [$seq state]

	    if {[string compare $state error] == 0} {
		set error [$seq errorInfo]
		::pool::syslog::syslog error $this $error
	    } else {
		::pool::syslog::syslog info $this $state
	    }

	    if {[string compare $state "done"] != 0} {
		ClearSocket
	    }
	}

	# Clear state before execution of callback as it may
	# try to setup another command with its state.

	set cmd $opState(-command)
	::pool::array::clear opState

	#::puts "uplevel #0 <$cmd> <$this>"
	uplevel #0 $cmd $this
	return
    }


    method close {args} {
	# @c Closes the connection to the smtp demon. The low-level method
	# @c <m Close> is used to execute the task. Configured by a list of
	# @c option/value pairs.
	# @i close smtp connection
	#
	# @a args: List of option/value pairs.&p Recognized and
	# @a args: required is -command.&p It defines a script
	# @a args: to be executed after the transaction completed.

	::pool::syslog::syslog info $this close

	::pool::array::def           oDef
	::pool::getopt::defOption    oDef command -t ::pool::getopt::nonempty
	::pool::getopt::defShortcuts oDef
	::pool::getopt::initValues   oDef       opState
	::pool::getopt::processOpt   oDef $args opState
	unset oDef

	if {$sock == {}} {
	    # nothing to be done, already down
	    after 1 $this Finish
	} else {
	    # use the low level sequencer to get the connecction down and
	    # report at the usual location afterward.

	    Close Finish
	}

	return
    }


    method open {args} {
	# @c Opens the connection to the smtp demon. The low-level method
	# @c <m Open> is used to execute the task. Configured by a list of
	# @c option/value pairs.
	# @i open smtp connection
	#
	# @a args: List of option/value pairs.&p Recognized and
	# @a args: required is -command.&p It defines a script
	# @a args: to be executed after the transaction completed.

	::pool::syslog::syslog info $this open

	::pool::array::def           oDef
	::pool::getopt::defOption    oDef command -t ::pool::getopt::nonempty
	::pool::getopt::defShortcuts oDef
	::pool::getopt::initValues   oDef       opState
	::pool::getopt::processOpt   oDef $args opState
	unset oDef

	if {$sock != {}} {
	    # nothing to be done, already open.
	    after 1 $this Finish
	} else {
	    # use the low level sequencer to get the connecction up and
	    # report at the usual location afterward.

	    Open Finish
	}

	return
    }



    method put {args} {
	# @c Send a mail to the smtp demon. The low-level methods <m Prepare>
	# @c and <m Data> are used to execute the task. Configured by a list of
	# @c option/value pairs. Will open the connection if necessary (via
	# @c <m Open>).
	# @i send mail
	#
	# @a args: List of option/value pairs.&p Recognized are -command,
	# @a args: -message, -from, -to and -string.&p Required are -command,
	# @a args: -message, -from and -to.&p -command specifies a script to
	# @a args: be executed after completion.&p -message is interpreted
	# @a args: as channel containing the message to be send, or the
	# @a args: message itself (if -string is set to true).&p -from
	# @a args: specifies the sender of the mail.&p -to is interpreted as
	# @a args: a list of recipient addresses.&p -string is boolean value
	# @a args: indicating wether -message is the channel containing it
	# @a args: (false), or the message itself (true). This is optional and
	# @a args: defaults to false.

	::pool::syslog::syslog info $this put

	::pool::array::def           oDef
	::pool::getopt::defOption    oDef command -t ::pool::getopt::nonempty
	::pool::getopt::defOption    oDef from    -t ::pool::getopt::nonempty
	::pool::getopt::defOption    oDef to      -t ::pool::getopt::nonempty
	::pool::getopt::defOption    oDef message -t ::pool::getopt::nonempty
	::pool::getopt::defOption    oDef string  -t ::pool::getopt::boolean
	::pool::getopt::defShortcuts oDef
	::pool::getopt::initValues   oDef       opState
	::pool::getopt::processOpt   oDef $args opState
	unset oDef

	#parray opState

	if {$sock == {}} {
	    # no connection available, open it, then prepare and transfer the
	    # message
	    Open HandleOpened
	} else {
	    Prepare HandlePrepared $opState(-from) $opState(-to)
	}
    }


    method HandleOpened {seq} {
	# @c Called after completion of the open sequencer <a seq> during a
	# @c <m put> transaction. Initiates the preparation transaction if no
	# @c error came back to us.
	#
	# @a seq: Handle of the finishing sequencer.

	set state [$seq state]

	#parray opState

	switch -- $state {
	    done {
		Prepare HandlePrepared $opState(-from) $opState(-to)
	    }
	    default {
		Finish $seq
	    }
	}

	return
    }


    method HandlePrepared {seq} {
	# @c Called after completion of the prepare sequencer <a seq>.
	# @c Initiates the data transfer if no error came back to us
	#
	# @a seq: Handle of the finishing sequencer.

	set state [$seq state]

	switch -- $state {
	    done {
		Data Finish $opState(-message) $opState(-string)
	    }
	    default {
		Finish $seq
	    }
	}

	return
    }
}


# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/smtp/smtp.cls'.
# Date: Thu Sep 14 23:03:30 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> smtpConnection <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::smtpConnection {
    variable  _superclasses    {}
    variable  _scChainForward  smtpConnection
    variable  _scChainBackward smtpConnection
    variable  _classVariables  {}
    variable  _methods         {ClearSocket Close Data Finish HandleOpened HandlePrepared Open Prepare SetSock close constructor destructor errorInfo open put state}

    variable  _variables
    array set _variables  {opState {smtpConnection {isArray 1 initialValue {}}} sock {smtpConnection {isArray 0 initialValue {}}} state {smtpConnection {isArray 0 initialValue {}}} error {smtpConnection {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {helo {smtpConnection {-default {} -type ::pool::getopt::nonempty -action {} -class Helo}} progress {smtpConnection {-default {} -type ::pool::getopt::notype -action {} -class Progress}} retrydelay {smtpConnection {-default 10000 -type ::pool::getopt::integer -action {} -class Retrydelay}} maxtries {smtpConnection {-default 1 -type ::pool::getopt::integer -action {} -class Maxtries}} blocksize {smtpConnection {-default 1024 -type ::pool::getopt::integer -action {} -class Blocksize}} host {smtpConnection {-default localhost -type ::pool::getopt::nonempty -action {} -class Host}} timeout {smtpConnection {-default {} -type ::pool::getopt::notype -action {} -class Timeout}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {ClearSocket . put . state . open . Open . SetSock . errorInfo . constructor . HandlePrepared . destructor . Finish . Data . Close . close . Prepare . HandleOpened .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::smtpConnection::ClearSocket {} {
    ::pool::oo::support::SetupVars smtpConnection
    # @c Closes the connection to the smtp demon described
	# @c by this object.

	catch {::close $sock}
	set    sock ""

	::pool::syslog::syslog info $this channel closed
	return
}



proc ::pool::oo::class::smtpConnection::Close {completionMethod} {
    ::pool::oo::support::SetupVars smtpConnection
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

	smtpCloseSeq ${this}_close  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock

	# ... and start its operation.

	${this}_close event next
	return
}



proc ::pool::oo::class::smtpConnection::Data {completionMethod message {msgIsString 0}} {
    ::pool::oo::support::SetupVars smtpConnection
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

	smtpDataSeq ${this}_data               -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock              -progress   $opt(-progress)    -blocksize  $opt(-blocksize)   -message    $message           -string     $msgIsString

	# ... and start its operation.

	${this}_data event next
	return
}



proc ::pool::oo::class::smtpConnection::Finish {{seq {}}} {
    ::pool::oo::support::SetupVars smtpConnection
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



proc ::pool::oo::class::smtpConnection::HandleOpened {seq} {
    ::pool::oo::support::SetupVars smtpConnection
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



proc ::pool::oo::class::smtpConnection::HandlePrepared {seq} {
    ::pool::oo::support::SetupVars smtpConnection
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



proc ::pool::oo::class::smtpConnection::Open {completionMethod} {
    ::pool::oo::support::SetupVars smtpConnection
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

	smtpOpenSeq ${this}_open  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -maxtries   $opt(-maxtries)    -retrydelay $opt(-retrydelay)  -host       $opt(-host)        -helo       $opt(-helo)

	# ... and start its operation.

	${this}_open event next
	return
}



proc ::pool::oo::class::smtpConnection::Prepare {completionMethod from to} {
    ::pool::oo::support::SetupVars smtpConnection
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

	smtpPrepareSeq ${this}_prep            -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock              -from       $from              -to         $to

	# ... and start its operation.

	${this}_prep event next
	return
}



proc ::pool::oo::class::smtpConnection::SetSock {s} {
    ::pool::oo::support::SetupVars smtpConnection
    # @c Accessor method, used by the <c smtpOpenSeq> sequencer to transfer
	# @c information about the channel representing the connection to the
	# @c smtp demon.
	#
	# @a s: The handle of the channel representing the connection to the
	# @a s: smtp demon.

	set sock $s
	return
}



proc ::pool::oo::class::smtpConnection::close {args} {
    ::pool::oo::support::SetupVars smtpConnection
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



proc ::pool::oo::class::smtpConnection::constructor {} {
    ::pool::oo::support::SetupVars smtpConnection
    # @c Constructor. Just logs the event.

	::pool::syslog::syslog info $this created
	return
}



proc ::pool::oo::class::smtpConnection::destructor {} {
    ::pool::oo::support::SetupVars smtpConnection
    # @c Destructor. Closes an active socket and logs the event.

	ClearSocket

	::pool::syslog::syslog info $this deleted
	return
}



proc ::pool::oo::class::smtpConnection::errorInfo {} {
    ::pool::oo::support::SetupVars smtpConnection
    # @r the error information of the SMTP connection.
	# @r Valid only in case of state = error.

	return $error
}



proc ::pool::oo::class::smtpConnection::open {args} {
    ::pool::oo::support::SetupVars smtpConnection
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



proc ::pool::oo::class::smtpConnection::put {args} {
    ::pool::oo::support::SetupVars smtpConnection
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



proc ::pool::oo::class::smtpConnection::state {} {
    ::pool::oo::support::SetupVars smtpConnection
    # @r the state of the SMTP connection.

	return $state
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::smtpConnection::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods smtpConnection
::pool::oo::support::FixOptions smtpConnection

# Create object instantiation procedure
interp alias {} smtpConnection {} ::pool::oo::support::New smtpConnection

# -------------------------------


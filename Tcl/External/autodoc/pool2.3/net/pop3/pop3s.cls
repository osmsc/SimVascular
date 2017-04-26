# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: pop3s.cls,v 1.2 2000/09/14 20:26:12 aku Exp $
#
# @c Base management of POP3 connections, synchronous operations
# @s Base management of POP3 connections, synchronous operations
# @i POP3, management of POP3 connections, synchronous operations
# @see <xref pop3info>
# -----------------------------

class pop3SynConnection {

    # @o maxtries:   Specifies the maximum allowed number of trials to connect.
    # @o maxtries:   Defaults to 1.
    # @o retrydelay: Specifies the time to wait (in milliseconds) after a
    # @o retrydelay: failure before doing the next try. Defaults to 10 seconds.
    # @o host:       Specifies the host the demon to connect to resides on.
    # @o host:       Defaults to 'localhost'.
    # @o timeout:    defines the number of milliseconds to wait before
    # @o timeout:    aborting a smtp command without having a response.
    # @o progress:   If not empty, a command to evaluate with current
    # @o progress:   connection and number of bytes transfered so far as
    # @o progress:   arguments.
    # @o blocksize:  Companion option to <o progress>, optional. Defines the
    # @o blocksize:  size of the blocks to transfer between invocations of
    # @o blocksize:  <o progress>. Ignored if <o progress> is empty.

    option maxtries         -d 1         -t ::pool::getopt::integer
    option retrydelay       -d 10000     -t ::pool::getopt::integer
    option host             -d localhost -t ::pool::getopt::nonempty
    option timeout          -d ""
    option progress         -d ""
    option blocksize        -d 1024      -t ::pool::getopt::integer

    # @o user:     The name of the user trying to login.
    # @o secret:   The password of the user trying to login.

    # @o use-top-for-retr: A boolean flag. Setting it to TRUE causes the
    # @o use-top-for-retr: sequencer to use the command 'TOP x 0' instead of
    # @o use-top-for-retr: 'RETR x' to retrieve the message. The first pop
    # @o use-top-for-retr: server of my provider didn't recognize RETR, but
    # @o use-top-for-retr: this special command. Maybe some other people have
    # @o use-top-for-retr: to deal with such a weird beast too.

    option user             -d ""        -t ::pool::getopt::nonempty
    option secret           -d ""        -t ::pool::getopt::nonempty
    option use-top-for-retr -d 0         -t ::pool::getopt::boolean

    # low level state

    # @v sock:     The handle of the channel controlled by this object
    # @v state:    The state of the last executed command.
    # @v error:    The error message of the last executed, failed command.
    # @v greeting: The greeting sent by the pop3 server during the
    # @v greeting: initialization of the connection (<m Open>).
    # @v n:        The number of messages in the mailbox we are connected to,
    # @v n:        as given by STAT (see <m SetN>).

    var sock        ""
    var state       ""
    var error       ""
    var greeting    ""
    var n           ""

    # @v backsignal: The variable to set by the callback method to signal
    # @v backsignal: the end of the operation.

    var backsignal  ""


    method pop3SynConnection {} {
	# @c Constructor. Just logs the event.

	::pool::syslog::syslog info $this created
	return
    }


    method ~pop3SynConnection {} {
	# @c Destructor. Closes an active socket and logs the event.

	ClearSocket
	::pool::syslog::syslog info $this deleted
	return
    }


    method state {} {
	# @c Retrieves state of this object.

	return $state
    }


    method errorInfo {} {
	# @c Retrieves error information of this object.
	# @c Valid only in case of state = error.

	return $error
    }


    method ClearSocket {} {
	# @c Closes the connection to the pop3 server described
	# @c by this object.

	catch {close $sock}
	set    sock ""
	return
    }


    method SetSock {s} {
	# @c Accessor method, used by the <c pop3OpenSeq> sequencer to transfer
	# @c information about the channel representing the connection to the
	# @c pop server.
	#
	# @a s: The handle of the channel representing the connection to the
	# @a s: pop server.

	set sock $s
	return
    }


    method SetGreeting {g} {
	# @c Accessor method, used by the <c pop3ApopSeq> / <c pop3UserSeq>
	# @c sequencer to transfer the received greeting into the connection
	# @c manager (this object).
	#
	# @a g: The text of the received greeting.

	set greeting $g
	return
    }


    method SetN {num} {
	# @c Accessor method, used by the <c pop3ApopSeq> / <c pop3UserSeq>
	# @c to transfer the number of found messages into the connection
	# @c manager.
	#
	# @a num: The number of found messages (as given by STAT).

	set n $num
	return
    }


    # ----------------------------------------------------
    # low level sequencers

    method Open {} {
	# @c Opens a connection to the pop3 demon described by this object.

	# create the sequencer ...

	pop3OpenSeq ${this}_open \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       Done	      \
		-maxtries   $opt(-maxtries)   \
		-retrydelay $opt(-retrydelay) \
		-host       $opt(-host)       \

	# ... and start its operation.

	${this}_open event next

	#vwait backsignal -- upvar'd variable not enough, need exact path.

	vwait ::${this}::backsignal
	::pool::syslog::syslog debug "Open: $state $error"

	# return state and error information from the sequencer.
	list $state $error
    }


    method Close {} {
	# @c Close connection to the pop3 demon described by this object.

	# create the sequencer ...

	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	pop3CloseSeq ${this}_close \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       Done \
		-sock       $sock

	# ... and start its operation.

	${this}_close event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
    }


    method Dele {msgId} {
	# @c Delete the specified message.
	#
	# @a msgId:            The numerical index of the message to delete.

	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3DeleteSeq ${this}_dele \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       Done \
		-sock       $sock             \
		-msg        $msgId

	# ... and start its operation.

	${this}_dele event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
    }


    method LoginApop {} {
	# @c Logs into the pop3 server described by this object using given
	# @c username and password. The password is not transfered to the
	# @c server. A hashcode constructed from it and the server greeting
	# @c (the timestamp in it) is used instead.

	# create the sequencer ...

	if {$sock == {}} {
	    error "no connection to pop3 server"
	}

	pop3ApopSeq ${this}_apop \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       Done \
		-sock       $sock             \
		-user       $opt(-user)       \
		-secret     $opt(-secret)     \
		-greeting   $greeting

	# ... and start its operation.

	${this}_apop event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
    }


    method LoginUser {} {
	# @c Logs into the pop3 server described by this object using given
	# @c username and password. The password is send in the clear.

	# create the sequencer ...

	if {$sock == {}} {
	    error "no connection to pop3 server"
	}

	pop3UserSeq ${this}_user \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       Done \
		-sock       $sock             \
		-user       $opt(-user)       \
		-secret     $opt(-secret)

	# ... and start its operation.

	${this}_user event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
    }


    method Top {msgId} {
	# @c Read header information of the specified message.
	#
	# @a msgId:            The numerical index of the message whose
	# @a msgId:            headers are requested.

	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3TopSeq ${this}_top \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       Done \
		-sock       $sock             \
		-msg        $msgId

	# ... and start its operation.

	${this}_top event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
    }


    method Retr {msgId} {
	# @c Retrieve the specified message.
	#
	# @a msgId:            The numerical index of the requested message.

	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3RetrSeq ${this}_retr \
		-timeout    $opt(-timeout)    \
		-conn       $this             \
		-done       Done \
		-sock       $sock             \
		-msg        $msgId

	# ... and start its operation.

	${this}_retr event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
    }



    method Done {seq} {
	# @c This method is called after an operation ends.
	# @a seq: The handle of the internal sequencer which executed the completed operation.

	::pool::syslog::syslog debug "Done $seq with state <[$seq state]>"

	set state [$seq state]
	if {$state != "done"} {
	    set error [$seq errorInfo]
	} else {
	    set error ""
	}
	# set backsignal 1 ; # <-- this is not ok, need exact path to make
	# vwait understand which var to wait for.

	set ::${this}::backsignal 1 ; # -- stop inner event loop
	return
    }
}


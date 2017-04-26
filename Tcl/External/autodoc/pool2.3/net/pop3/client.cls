# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: client.cls,v 1.1 1998/06/01 19:56:37 aku Exp $
#
# @c Pop3 client core built upon the base connection management
# @s Core of a POP3 client
# @i POP3, POP3 client
# @see general <xref pop3info>, or <xref pop3c> for more specific info
# -----------------------------

class pop3Client : pop3Connection {
    # @c Full fledged POP3 client. The only parts not covered in this class
    # @c are message classification and storage. These are delegated to
    # @c external objects, see <o classificator> and <o storage>. A state
    # @c machine is built on top of the low level methods in
    # @c <c pop3Connection>.

    # @o auth: Defines the mode to use during login into the pop3 server,
    # @o auth: either 'apop' or 'user'. The latter uses USER/PASS to send the
    # @o auth: password in the clear, and is therefore less secure than APOP,
    # @o auth: which sends a hashvalue created from the timestamp used by the
    # @o auth: server to greet us and the password itself. On the other hand,
    # @o auth: every server has to support USER/PASS, APOP-support is optional.

    option auth -d apop -t ::pool::pop3::authmode

    # @o storage: The name of the object handling the storing of incoming
    # @o storage: mails. Has to support the interface defined by
    # @o storage: <c popClientStorageBase>, i.e. its class should be derived
    # @o storage: from that class.

    option storage -d "" -t ::pool::getopt::nonempty

    # @o classificator: The name of the object handling the classification of
    # @o classificator: incoming mails. Has to support the interface defined by
    # @o classificator: <c popClientMsgClassificatorBase>, i.e. its class
    # @o classificator: should be derived from that class.

    option classificator -d "" -t ::pool::getopt::nonempty

    # @o on-connect: The script evaluate after a succesful connect.
    # @o on-login:   The script evaluate after a successful login.
    # @o done:       The script evaluate after the connection was closed.

    option on-connect       -d ""
    option on-login         -d ""
    option done             -d ""

    # - internal state form here on -

    # @v cState:    The state of the finite automaton. Could not use 'state'
    # @v cState:    as this is used by the base class to record the state of
    # @v cState:    the last low-level operation.
    # @v after:     The id of the idle-handler used to schedule and execute
    # @v after:     the next task on the <v queue>.
    # @v queue:     A list of tasks to do, operated in a FIFO manner.
    # @v deleted:   A list containing the index numbers of the sucessfully
    # @v deleted:   deleted messages. Used during recovery to enforce the
    # @v deleted:   state of the server at the time of the loss of the
    # @v deleted:   connection.
    # @v retrieved: A list containing the index numbers of the sucessfully
    # #v retrieved: deleted messages. Used during recovery to enforce the
    # @v retrieved: state of the server at the time of the loss of the
    # @v retrieved: connection.
    # @v pending:   The number of messages sent to the classificator we have
    # @v pending:   no decision about (yet).
    # @v skip:      The number of messages to skip during recovery.
    # @v lock:      Activity flag. As long as it is true the system will
    # @v lock:      ignore any attempt to start another session.

    var cState    waiting
    var after     ""
    var queue     {}
    var deleted   {}
    var retrieved {}
    var pending   0
    var skip      0
    var lock      0


    method Init {} {
	# @c (Re)Initializes the state of the finite automaton.

	set cState    waiting
	set after     ""
	set queue     {}
	set deleted   {}
	set retrieved {}
	set pending   0
	set skip      0
	set lock      0
	set cGreeting ""
	set cN        ""
	return
    }


    method Goto {newstate} {
	# @c Jumps the client into the given state.
	# @c Will behave like builtin 'return' in the calling procedure.
	#
	# @a newstate: The state to jump to.
	
	set cState $newstate
	::pool::syslog::syslog notice $this goto $newstate

	return -code return
    }



    method run {} {
	# @c Starts a retrieval cycle of the specified client.

	if {"$cState" != "waiting"} {
	    error "client already executing"
	}

	::pool::syslog::syslog notice $this start

	# reset recovery information, to avoid propagation
	# of irrelevant data

	set deleted   ""
	set retrieved ""

	# read the next line as: Open -> Logon
	# == Execute 'open', then go into the state 'logon'.

	Open Logon
	Goto connect
    }


    method Logon {seq} {
	# @c Callback of 'open connection' operation.
	# @c Initiates logon in case of sucess.
	#
	# @a seq: Handle of the 'open' sequencer created by <m Open>.

	## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	## check results of last step

	set s [$seq state]
	if {"$s" != "done"} {
	    # some kind of error occured during connect.
	    # report, then jump back into passive waiting

	    set state error

	    if {"$s" == "error"} {
		set error [$seq errorInfo]
		::pool::syslog::syslog error \
			$this connecting to server failed ($s $error)
	    } else {
		set error "connecting to server failed: $s"
		::pool::syslog::syslog error $this $error
	    }

	    Goto waiting
	}

	::pool::syslog::syslog debug $this connect done

	if {$opt(-on-connect) != {}} {
	    catch {
		uplevel #0 $opt(-on-connect) $this
	    }
	}

	## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	## prepare for next step

	switch -- $opt(-auth) {
	    upass {
		LoginUser InitScheduler
	    }
	    apop {
		LoginApop InitScheduler
	    }
	    default {error "unknown authentication method $opt(-auth)"}
	}

	Goto logon
    }


    method InitScheduler {seq} {
	# @c Callback of 'login' operation.
	# @c Initializes the scheduler task queue with header retrieval
	# @c operations, then starts the real work.
	#
	# @a seq: Handle of the 'login' sequencer created by <m LoginUser>
	# @a seq: (or <m LoginApop>.

	## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	## check results of last step

	set s [$seq state]
	if {"$s" != "done"} {
	    # some kind of error occured during logon
	    # report, then jump back into passive waiting
	    # don't forget to close the channel, some errors leave it open.

	    set state error

	    if {"$s" == "error"} {
		set error [$seq errorInfo]
		::pool::syslog::syslog error \
			$this login to server failed ($s $error)
	    } else {
		set error "login to server failed: $s"
		::pool::syslog::syslog error $this $error
	    }
	
	    ClearSocket
	    Goto waiting
	}

	::pool::syslog::syslog debug  $this login done
	::pool::syslog::syslog notice $this messages $n

	if {$opt(-on-login) != {}} {
	    catch {
		uplevel #0 $opt(-on-login) $this $n
	    }
	}

	## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	## prepare for next step

	if {($queue == {}) && ($n == 0)} {
	    # no commands pending from last run, nothing new => shutdown system

	    Close Off
	    Goto  active
	}

	# initialize queue of tasks to be done, then start a scheduler
	# during a recovery run the queue is prefilled with delete's and a quit
	# executing that quit will restart again, with a clean state.
	# problems during a recovery run are mostly ignored.

	set  start $skip
	incr start
	
	for {set i $start} {$i <= $n} {incr i} {
	    Task [list top $i]
	}

	if {$n == 0} {
	    # nothing new, but queue contains some commands
	    # (inserted by InitiateRecovery).

	    WakeScheduler
	}

	# scheduler was activated by Task
	Goto active
    }


    method Task {task} {
	# @c Adds a new task to the scheduler queue,
	# @c starts the scheduler, if necessary. Deletions
	# @c are added to the front, to give them priority.
	#
	# @a task: Text describing a task to be done by the client

	::pool::syslog::syslog notice $this newtask $task

	# RETR and DELE have priority over everything else
	switch -glob $task {
	    quit*  -
	    top*    {lappend               queue $task}
	    retr*   -
	    dele*   {::pool::list::unshift queue $task}
	}

	WakeScheduler
	return
    }


    method WakeScheduler {} {
	# @c Starts the scheduler, if not already waiting for execution.
	
	# task in progress ?

	if {$lock} {return}

	# scheduler running ?

	if {$after != {}} {return}

	# prepare scheduler for execution
	set after [after idle $this Schedule]
	return
    }


    method Schedule {} {
	# @c The scheduler. Executed semi-periodically to launch the tasks
	# @c waiting in the internal queue. Automatically injects a
	# @c connection shutdown in case of nothing more waiting to be done.

	set after ""

	if {$queue == {}} {
	    # wait for classificator
	    if {$pending > 0} {return}

	    # queue empty, nothing to wait, automatic quit
	    Task quit
	    return
	}

	# execute next task
	#::pool::syslog::syslog debug queue = <$queue>

	set task [::pool::list::shift queue]

	::pool::syslog::syslog debug $this do $task

	if {"$task" == "quit"} {
	    Close CloseDone
	} else {
	    set cmd [::pool::string::cap [lindex $task 0]]
	    set msg [lindex $task 1]

	    # Dynamic dispatch to appropriate lowlevel sequencer

	    $cmd $msg ${cmd}Done
	}

	# lock scheduler, don't execute waiting tasks as long as this one is
	# running
	set lock 1
	return
    }


    method TopDone {seq} {
	# @c Called after completion of a header retrieval. Initiates
	# @c emergency recovery in case of problems. The received information
	# @c is given to the classificator for determination of further
	# @c action. Awakes the scheduler to start the next job.
	#
	# @a seq: Handle of the top sequencer created by <m Top>

	set lock 0
	set msg  [$seq cget -msg]

	::pool::syslog::syslog debug $this top $msg done ([$seq state])...

	switch -- [$seq state] {
	    done {
		# send received headers to classificator, mark message
		# as pending to avoid a premature shutdown of the scheduler.

		incr  pending
		after idle \
			$opt(-classificator) classify \
			$this $msg [list [$seq GetMessage]]

		WakeScheduler
	    }
	    error {
		# ignore this message, step on to the next task
		# we should probably count this, and act later appropriately !?

		::pool::syslog::syslog error $this top $msg: [$seq errorInfo]
		WakeScheduler
	    }
	    eof     -
	    timeout {
		# ouch, the connection is (or seems to be) down.
		# We have to initiate emergency recovery procedures.
		InitiateRecovery
	    }
	}

	return
    }


    method DeleDone {seq} {
	# @c Called after completion of a message deletion. Initiates
	# @c emergency recovery in case of problems. Awakes the
	# @c scheduler to start the next job.
	#
	# @a seq: Handle of the delete sequencer created by <m Dele>.

	set lock 0
	set msg  [$seq cget -msg]

	switch -- [$seq state] {
	    done {
		::pool::syslog::syslog notice $this done delete $msg

		# message deleted (almost), step to next task
		# (and remember the id for possible recovery)

		WakeScheduler
		lappend deleted $msg
	    }
	    error {
		# ignore this message, step on to the next task
		# we should probably count this, and act later appropriately !?

		::pool::syslog::syslog error \
			$this delete $msg: [$seq errorInfo]

		WakeScheduler
	    }
	    eof     -
	    timeout {
		# ouch, the connection is (or seems to be) down.
		# We have to initiate emergency recovery procedures.
		InitiateRecovery
	    }
	}

	return
    }


    method RetrDone {seq} {
	# @c Called after completion of message retrieval. Initiates
	# @c emergency recovery in case of problems. Awakes the
	# @c scheduler to start the next job. The received information
	# @c is given to the storage facility.
	#
	# @a seq: Handle of the delete sequencer created by <m Retr>.

	set lock 0
	set msg  [$seq cget -msg]

	switch -- [$seq state] {
	    done {
		::pool::syslog::syslog notice $this done retrieve $msg

		# message retrieved, delete it immediately
		# (remember the id for possible recovery)

		Task [list dele $msg]
		lappend retrieved $msg

		# send the gathered message to the storage facility
		after idle $opt(-storage) store [list [$seq GetMessage]]
	    }
	    error {
		# ignore this message, step on to the next task
		# we should probably count this, and act later appropriately !?

		::pool::syslog::syslog error \
			$this retrieve $msg: [$seq errorInfo]
		WakeScheduler
	    }
	    eof     -
	    timeout {
		# ouch, the connection is (or seems to be) down.
		# We have to initiate emergency recovery procedures.
		InitiateRecovery
	    }
	}

	return
    }


    method CloseDone {seq} {
	# @c Callback of standard shutdown. May restart
	# @c the client, to proceed in error recovery.
	#
	# @a seq: Handle of the close sequencer created by <m Close>.

	::pool::syslog::syslog debug $this close done ([$seq state])...
	set lock 0

	# if there are more tasks waiting we have to be at the end of a
	# recover run. clear queue and restart in that case, else do a
	# shutdown.

	ClearSocket

	set jobs   $queue
	set cState waiting
	set queue  ""
	set skip   0

	if {$jobs == {}} {
	    Goto waiting
	}
 
	run
    }


    method Off {seq} {
	# @c Callback of definite shutdown.
	#
	# @a seq: Handle of the close sequencer created by <m Close>.

	set lock 0

	ClearSocket
	Goto waiting
	return
    }


    method InitiateRecovery {} {
	# @c Does everything required to recover from line or server problems.
	# @c Things include: &p Execution of commit run to remove all messages
	# @c which were already deleted and/or retrieved, but not committed by
	# @c server. &p Skipping over messages making trouble multiple times.

	::pool::syslog::syslog debug initiate recovery for $this...

	# current transaction was broken. gather information about
	# retrieved and deleted messages to start another transaction
	# just removing these from the pop3 server. in case of nothing
	# retrieved or deleted it was the first message having trouble.
	# Bump the skip counter one up, then restart to retrieve the rest.
	# Just do a shutdown if nothing waits anymore.

	ClearSocket

	# discard all tasks waiting for execution.
	set queue   ""
	set pending 0

	catch {after cancel $after}

	set processed ""
	if {$deleted   != {}} {eval lappend processed $deleted}
	if {$retrieved != {}} {eval lappend processed $retrieved}

	set processed [::pool::list::uniq $processed]

	::pool::syslog::syslog debug processed messages = $processed

	set deleted   ""
	set retrieved ""

	if {$processed == {}} {
	    incr skip

	    if {$n <= $skip} {
		# nothing to do, bye

		# unlock for future invocations
		set lock 0
		set after ""

		::pool::syslog::syslog \
			debug initiate recovery for $this: impossible, skipped everything
		Init
		Goto waiting
	    }

	    # restart, skip over message with problems
	} else {
	    # reset skip counter, try again from the very start after the
	    # commit run.

	    set skip 0

	    # fill task queue with commands required by commit run
	    foreach msg $processed {
		Task [list dele $msg]
	    }
	    Task quit

	    # scheduler must not operate now, we have to restart first
	    catch {after cancel $after}
	}

	# unlock and restart
	set lock   0
	set after  ""
	set cState waiting
	
	run
	return
    }


    # - interface used by classificator to return its decision into the system

    method msgIgnore {msg} {
	# @c Classificator callback. The specified message shall be neither
	# @c deleted nor retrieved. It will sit in the server awaiting action
	# @c of the user.
	#
	# @a msg: Id of the message to ignore.

	# one message less to wait for
	incr pending -1

	WakeScheduler
	::pool::syslog::syslog notice $this done ignore $msg
	return
    }


    method msgDelete {msg} {
	# @c Classificator callback. The specified message shall be deleted at
	# @c the server, without retrieval.
	#
	# @a msg: Id of the message to delete.

	Task [list dele $msg]

	# one message less to wait for
	incr pending -1
	return
    }


    method msgRetrieve {msg} {
	# @c Classificator callback. The specified message shall be retrieved
	# @c from the server.
	#
	# @a msg: Id of the message to retrieve.

	Task [list retr $msg]

	# one message less to wait for
	incr pending -1
	return
    }


    method ClearSocket {} {
	# @c Closes the connection to the pop3 server described
	# @c by this object.

	pop3Connection_ClearSocket

	if {$opt(-done) != {}} {
	    uplevel #0 $opt(-done) $this
	}
    }
}


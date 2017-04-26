# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/client.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3Client <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3Client {
    variable  _superclasses    pop3Connection
    variable  _scChainForward  pop3Client
    variable  _scChainBackward pop3Client
    variable  _classVariables  {}
    variable  _methods         {ClearSocket CloseDone DeleDone Goto Init InitScheduler InitiateRecovery Logon Off RetrDone Schedule Task TopDone WakeScheduler msgDelete msgIgnore msgRetrieve run}

    variable  _variables
    array set _variables  {cState {pop3Client {isArray 0 initialValue waiting}} lock {pop3Client {isArray 0 initialValue 0}} pending {pop3Client {isArray 0 initialValue 0}} queue {pop3Client {isArray 0 initialValue {}}} retrieved {pop3Client {isArray 0 initialValue {}}} after {pop3Client {isArray 0 initialValue {}}} skip {pop3Client {isArray 0 initialValue 0}} deleted {pop3Client {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {on-connect {pop3Client {-default {} -type ::pool::getopt::notype -action {} -class On-connect}} storage {pop3Client {-default {} -type ::pool::getopt::nonempty -action {} -class Storage}} done {pop3Client {-default {} -type ::pool::getopt::notype -action {} -class Done}} auth {pop3Client {-default apop -type ::pool::pop3::authmode -action {} -class Auth}} on-login {pop3Client {-default {} -type ::pool::getopt::notype -action {} -class On-login}} classificator {pop3Client {-default {} -type ::pool::getopt::nonempty -action {} -class Classificator}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {ClearSocket . DeleDone . TopDone . Goto . msgDelete . RetrDone . InitScheduler . CloseDone . Init . Schedule . InitiateRecovery . WakeScheduler . Task . Off . msgIgnore . run . msgRetrieve . Logon .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3Client::ClearSocket {} {
    ::pool::oo::support::SetupVars pop3Client
    # @c Closes the connection to the pop3 server described
	# @c by this object.

	pop3Connection_ClearSocket

	if {$opt(-done) != {}} {
	    uplevel #0 $opt(-done) $this
	}
}



proc ::pool::oo::class::pop3Client::CloseDone {seq} {
    ::pool::oo::support::SetupVars pop3Client
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



proc ::pool::oo::class::pop3Client::DeleDone {seq} {
    ::pool::oo::support::SetupVars pop3Client
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

		::pool::syslog::syslog error  $this delete $msg: [$seq errorInfo]

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



proc ::pool::oo::class::pop3Client::Goto {newstate} {
    ::pool::oo::support::SetupVars pop3Client
    # @c Jumps the client into the given state.
	# @c Will behave like builtin 'return' in the calling procedure.
	#
	# @a newstate: The state to jump to.
	
	set cState $newstate
	::pool::syslog::syslog notice $this goto $newstate

	return -code return
}



proc ::pool::oo::class::pop3Client::Init {} {
    ::pool::oo::support::SetupVars pop3Client
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



proc ::pool::oo::class::pop3Client::InitScheduler {seq} {
    ::pool::oo::support::SetupVars pop3Client
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
		::pool::syslog::syslog error  $this login to server failed ($s $error)
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



proc ::pool::oo::class::pop3Client::InitiateRecovery {} {
    ::pool::oo::support::SetupVars pop3Client
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

		::pool::syslog::syslog  debug initiate recovery for $this: impossible, skipped everything
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



proc ::pool::oo::class::pop3Client::Logon {seq} {
    ::pool::oo::support::SetupVars pop3Client
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
		::pool::syslog::syslog error  $this connecting to server failed ($s $error)
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



proc ::pool::oo::class::pop3Client::Off {seq} {
    ::pool::oo::support::SetupVars pop3Client
    # @c Callback of definite shutdown.
	#
	# @a seq: Handle of the close sequencer created by <m Close>.

	set lock 0

	ClearSocket
	Goto waiting
	return
}



proc ::pool::oo::class::pop3Client::RetrDone {seq} {
    ::pool::oo::support::SetupVars pop3Client
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

		::pool::syslog::syslog error  $this retrieve $msg: [$seq errorInfo]
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



proc ::pool::oo::class::pop3Client::Schedule {} {
    ::pool::oo::support::SetupVars pop3Client
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



proc ::pool::oo::class::pop3Client::Task {task} {
    ::pool::oo::support::SetupVars pop3Client
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



proc ::pool::oo::class::pop3Client::TopDone {seq} {
    ::pool::oo::support::SetupVars pop3Client
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
		after idle  $opt(-classificator) classify  $this $msg [list [$seq GetMessage]]

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



proc ::pool::oo::class::pop3Client::WakeScheduler {} {
    ::pool::oo::support::SetupVars pop3Client
    # @c Starts the scheduler, if not already waiting for execution.
	
	# task in progress ?

	if {$lock} {return}

	# scheduler running ?

	if {$after != {}} {return}

	# prepare scheduler for execution
	set after [after idle $this Schedule]
	return
}



proc ::pool::oo::class::pop3Client::msgDelete {msg} {
    ::pool::oo::support::SetupVars pop3Client
    # @c Classificator callback. The specified message shall be deleted at
	# @c the server, without retrieval.
	#
	# @a msg: Id of the message to delete.

	Task [list dele $msg]

	# one message less to wait for
	incr pending -1
	return
}



proc ::pool::oo::class::pop3Client::msgIgnore {msg} {
    ::pool::oo::support::SetupVars pop3Client
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



proc ::pool::oo::class::pop3Client::msgRetrieve {msg} {
    ::pool::oo::support::SetupVars pop3Client
    # @c Classificator callback. The specified message shall be retrieved
	# @c from the server.
	#
	# @a msg: Id of the message to retrieve.

	Task [list retr $msg]

	# one message less to wait for
	incr pending -1
	return
}



proc ::pool::oo::class::pop3Client::run {} {
    ::pool::oo::support::SetupVars pop3Client
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3Client::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Connection::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3Client

# Create object instantiation procedure
interp alias {} pop3Client {} ::pool::oo::support::New pop3Client

# -------------------------------


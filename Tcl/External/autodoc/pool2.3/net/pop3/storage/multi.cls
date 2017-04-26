# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: multi.cls,v 1.1 1998/06/01 19:56:44 aku Exp $
#
# @c Storage facility employing other storage systems
# @s Storage facility employing other storage systems
# @i storage facility
# -----------------------------

class multiStorage : popClientStorageBase {
    # @c Storage system usable by the pop client in <c pop3Client>. Refers to
    # @c several external storage systems, as configured by the user, via
    # @c <m add>. Scans through all of them for every incoming mail until a
    # @c success is reported. The scan process is event controlled, more than
    # @c one can be in progress.

    # @o command: The command to evaluate after a scan completed. First
    # @o command: argument is either 'done' or 'error'. In the latter case the
    # @o command: accompanying error message is appended as the 2nd argument.

    option command

    # @v facilities: A list containing the object handles of all storage
    # @v facilities: system to query during a scan.

    var facilities {}

    # @v thread: State information for every active scan.

    var -array thread {}


    method add {o} {
	# @c Adds the storage facility <a o> to this object.
	#
	# @a o: Handle of the storage object to add. Must be derived from
	# @a o: <c popClientStorageBase>.

	lappend facilities $o
	return
    }


    method storeMessage {command message} {
	# @c Stores the given <a message>, tries all facilities known to the
	# @c object.
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	set handle [::pool::serial::new]
	set thread($handle) [list 0 $message $command]

	Store $handle
	return
    }


    method Store {handle} {
	# @c Stores the message in the given scan state (<a handle>) using the
	# @c facility next on the list in the same state.
	#
	# @a handle:  Internal handle of this storage transaction.
	# @a handle:  Used to remember the transaction state.

	set idx [lindex $thread($handle) 0]

	if {$idx > [llength $facilities]} {
	    # all facilities tried out, give up.

	    set command [lindex $thread($handle) 2]
	    unset thread($handle)

	    Done $command 1 {no more facilities to try}
	    return
	} else {
	    after idle $this Execute $handle
	}
    }


    method Execute {handle} {
	# @c Invokes the chosen storage facility for the given scan.
	#
	# @a handle: Internal handle of this storage transaction.
	# @a handle: Used to remember the transaction state.

	set idx     [lindex $thread($handle) 0]
	set message [lindex $thread($handle) 1]
	set obj     [lindex $facilities   $idx]

	set fail [catch {
	    $obj store -command [list $this SubDone $handle] $message
	} errmsg] ; #{}

	if {$fail} {
	    after idle $this SubDone $handle error [list $errmsg]
	}
    }


    method SubDone {handle state {msg {}}} {
	# @c Callback used by the invoked facility to notify
	# @c this object about its success (or failure).
	#
	# @a handle: Internal handle of this storage transaction.
	# @a handle: Used to remember the transaction state.
	# @a state:  Completion state of the invoked facility.
	# @a msg:    Error message in case of failure.

	if {"$state" == "error"} {
	    # access transaction information and try next facility

	    set idx     [lindex $thread($handle) 0]
	    set message [lindex $thread($handle) 1]
	    set obj     [lindex $facilities   $idx]

	    ::pool::syslog::syslog error $this $obj: $msg

	    set thread($handle) [list [incr idx] $message]

	    Store $handle
	} else {
	    # delivery done, release transaction information

	    set command [lindex $thread($handle) 2]
	    unset thread($handle)

	    Done $command 0
	}
    }


    method Done {command fail {msg {}}} {
	# @c Overides base class functionality to allow the notification of
	# @c someone outside about the completion of the scan. The standard
	# @c functionality just notifies the caller.
	#
	# @a command: The script evaluate. Allowed to be empty, nothing is done
	# @a command: in that case. Gets either 'error' or 'done' as first
	# @a command: argument. In case of an 'error' <a msg> is given to as
	# @a command: well.
	# @a fail:    Boolean value. True signal unsucessful completion of the
	# @a fail:    storing process.
	# @a msg:     The error text to add as 2nd argument to <a command>.


	popClientStorageBase_Done $command $fail $msg

	# redirect completion of storage to someone outside too

	if {$opt(-command) != {}} {
	    if {$fail} {
		after idle $opt(-command) error [list $msg]
	    } else {
		after idle $opt(-command) done
	    }
	}
	return
    }
}


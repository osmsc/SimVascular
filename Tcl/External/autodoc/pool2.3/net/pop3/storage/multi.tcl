# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/storage/multi.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> multiStorage <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::multiStorage {
    variable  _superclasses    popClientStorageBase
    variable  _scChainForward  multiStorage
    variable  _scChainBackward multiStorage
    variable  _classVariables  {}
    variable  _methods         {Done Execute Store SubDone add storeMessage}

    variable  _variables
    array set _variables  {thread {multiStorage {isArray 1 initialValue {}}} facilities {multiStorage {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {command {multiStorage {-default {} -type ::pool::getopt::notype -action {} -class Command}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {SubDone . Store . add . Done . storeMessage . Execute .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::multiStorage::Done {command fail {msg {}}} {
    ::pool::oo::support::SetupVars multiStorage
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



proc ::pool::oo::class::multiStorage::Execute {handle} {
    ::pool::oo::support::SetupVars multiStorage
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



proc ::pool::oo::class::multiStorage::Store {handle} {
    ::pool::oo::support::SetupVars multiStorage
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



proc ::pool::oo::class::multiStorage::SubDone {handle state {msg {}}} {
    ::pool::oo::support::SetupVars multiStorage
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



proc ::pool::oo::class::multiStorage::add {o} {
    ::pool::oo::support::SetupVars multiStorage
    # @c Adds the storage facility <a o> to this object.
	#
	# @a o: Handle of the storage object to add. Must be derived from
	# @a o: <c popClientStorageBase>.

	lappend facilities $o
	return
}



proc ::pool::oo::class::multiStorage::storeMessage {command message} {
    ::pool::oo::support::SetupVars multiStorage
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::multiStorage::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::popClientStorageBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences multiStorage

# Create object instantiation procedure
interp alias {} multiStorage {} ::pool::oo::support::New multiStorage

# -------------------------------


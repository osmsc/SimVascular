# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/storage/trig.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> triggerStorage <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::triggerStorage {
    variable  _superclasses    popClientStorageBase
    variable  _scChainForward  triggerStorage
    variable  _scChainBackward triggerStorage
    variable  _classVariables  {}
    variable  _methods         {Reset SubDone Trigger clientDone storeMessage}

    variable  _variables
    array set _variables  {cDone {triggerStorage {isArray 0 initialValue 0}} stored {triggerStorage {isArray 0 initialValue 0}} in {triggerStorage {isArray 0 initialValue 0}}}

    variable  _options
    array set _options  {command {triggerStorage {-default {} -type ::pool::getopt::notype -action {} -class Command}} target {triggerStorage {-default {} -type ::pool::getopt::nonempty -action {} -class Target}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {SubDone . Trigger . clientDone . storeMessage . Reset .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::triggerStorage::Reset {} {
    ::pool::oo::support::SetupVars triggerStorage
    # @c Enforces the initial state of the object.

	set cDone  0
	set in     0
	set stored 0
	return
}



proc ::pool::oo::class::triggerStorage::SubDone {command state {msg {}}} {
    ::pool::oo::support::SetupVars triggerStorage
    # @c Callback for <o target>. Counts the completion of the storage
	# @c process, forwards the state and error information to our caller,
	# @c and acts if the last mail was stored.
	#
	# @a command: The script evaluate. Allowed to be empty, nothing is done
	# @a command: in that case. Gets either 'error' or 'done' as first
	# @a command: argument. In case of an 'error' <a msg> is given to as
	# @a command: well.
	# @a state:   Completion state, either 'done' or 'error'.
	# @a msg:     The error text to add as 2nd argument to <a command>.

	incr stored

	if {"$state" == "error"} {
	    Done $command 1 $msg
	} else {
	    Done $command 0
	}

	Trigger
	return
}



proc ::pool::oo::class::triggerStorage::Trigger {} {
    ::pool::oo::support::SetupVars triggerStorage
    # @c Checks wether the last mails was stored or not. If so,
	# @c <o command> is evaluated, using ourselves as its first and only
	# @c argument.

	if {$cDone && ($in == $stored)} {
	    if {$opt(-command) != {}} {
		uplevel #0 $opt(-command) $this
	    }
	    Reset
	}
	return
}



proc ::pool::oo::class::triggerStorage::clientDone {args} {
    ::pool::oo::support::SetupVars triggerStorage
    # @c Calling this method signals that the pop client completed its
	# @c retrieval session and that no more mails will be coming,
	#
	# @a args: Ignored. Added to allow immediate usage by
	# @a args: <o pop3Client:done>.

	incr cDone
	Trigger
	return
}



proc ::pool::oo::class::triggerStorage::storeMessage {command message} {
    ::pool::oo::support::SetupVars triggerStorage
    # @c Forward the given message to the configured storage facility, and
	# @c counts that too
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	incr in
	$opt(-target) store -command [list $this SubDone $command] $message
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::triggerStorage::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::popClientStorageBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences triggerStorage

# Create object instantiation procedure
interp alias {} triggerStorage {} ::pool::oo::support::New triggerStorage

# -------------------------------


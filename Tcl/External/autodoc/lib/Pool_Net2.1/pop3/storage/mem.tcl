# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/storage/mem.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> memStorage <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::memStorage {
    variable  _superclasses    popClientStorageBase
    variable  _scChainForward  memStorage
    variable  _scChainBackward memStorage
    variable  _classVariables  {}
    variable  _methods         {clear messages storeMessage stored}

    variable  _variables
    array set _variables  {nextId {memStorage {isArray 0 initialValue 1}} mem {memStorage {isArray 1 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {messages . stored . storeMessage . clear .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::memStorage::clear {} {
    ::pool::oo::support::SetupVars memStorage
    # @c Removes all stored messages from memory

	set                  nextId 1
	::pool::array::clear mem
	return
}



proc ::pool::oo::class::memStorage::messages {} {
    ::pool::oo::support::SetupVars memStorage
    # @c Query the memory storage facility for messages stored in it.
	# @r A list containing the messages stored in the facility, and
	# @r their handles, in a format suitable to 'array set'.

	return [array get mem]
}



proc ::pool::oo::class::memStorage::storeMessage {command message} {
    ::pool::oo::support::SetupVars memStorage
    # @c Store the given message into our internal array.
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	set  mem($nextId) $message
	incr nextId

	Done $command 0
	return
}



proc ::pool::oo::class::memStorage::stored {} {
    ::pool::oo::support::SetupVars memStorage
    # @c Query the memory storage facility for messages stored in it.
	# @r The number of messages stored in the facility

	return [expr {$nextId - 1}]
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::memStorage::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::popClientStorageBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences memStorage

# Create object instantiation procedure
interp alias {} memStorage {} ::pool::oo::support::New memStorage

# -------------------------------


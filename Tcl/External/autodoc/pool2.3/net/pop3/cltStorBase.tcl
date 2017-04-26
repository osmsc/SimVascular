# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/cltStorBase.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> popClientStorageBase <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::popClientStorageBase {
    variable  _superclasses    {}
    variable  _scChainForward  popClientStorageBase
    variable  _scChainBackward popClientStorageBase
    variable  _classVariables  {}
    variable  _methods         {Done store storeMessage}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {store . Done . storeMessage .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::popClientStorageBase::Done {command fail {msg {}}} {
    ::pool::oo::support::SetupVars popClientStorageBase
    # @c This method can be used by derived classes to signal the
	# @c completion of the storage. It will execute the defined callback
	# @c with the appropriate arguments.
	#
	# @a command: The script evaluate. Allowed to be empty, nothing is done
	# @a command: in that case. Gets either 'error' or 'done' as first
	# @a command: argument. In case of an 'error' <a msg> is given to as
	# @a command: well.
	# @a fail:    Boolean value. True signal unsucessful completion of the
	# @a fail:    storing process.
	# @a msg:     The error text to add as 2nd argument to <a command>.

	if {$command != {}} {
	    if {$fail} {
		after idle $command error [list $msg]
	    } else {
		after idle $command done
	    }
	}
	return
}



proc ::pool::oo::class::popClientStorageBase::store {args} {
    ::pool::oo::support::SetupVars popClientStorageBase
    # @c An option based interface to <m storeMessage>. The script to
	# @c evaluate after completion of storing is given as argument to the
	# @c option '-command'. The message is the first non-option argument.
	#
	# @a args: A list of option/value-pairs, followed by the message to
	# @a args: store. Only '-command' is recognized.

	::pool::getopt::defOption    odef command
	::pool::getopt::defShortcuts odef

	set message [lindex [::pool::getopt::process odef $args oval] 0]

	# ^ The line above started out without the [lindex 0]. This caused
	# - problems if tcl decided to backslash the message due to unmatched
	# - braces, ... instead of bracing it (see Tcl_ScanCountedElement).
	# - The backslashed list was sent on to the storage system. Bah :-(.
	# - Lindex now retrieves the unslashed element, the original text I
	# - wanted to sent. So, DON'T mix strings and lists, they are really
	# - NOT the same.

	$this storeMessage $oval(-command) $message
	return
}



proc ::pool::oo::class::popClientStorageBase::storeMessage {command message} {
    ::pool::oo::support::SetupVars popClientStorageBase
    # @c Abstract method. Must be overidden by derived classes to
	# @c implement the actual process of storing a message.
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	error "[oinfo class]: abstract method 'store' not overidden"
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::popClientStorageBase::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods popClientStorageBase
::pool::oo::support::FixOptions popClientStorageBase

# Create object instantiation procedure
interp alias {} popClientStorageBase {} ::pool::oo::support::New popClientStorageBase

# -------------------------------


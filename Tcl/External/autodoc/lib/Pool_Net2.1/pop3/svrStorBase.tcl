# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/svrStorBase.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> popServerStorageBase <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::popServerStorageBase {
    variable  _superclasses    {}
    variable  _scChainForward  popServerStorageBase
    variable  _scChainBackward popServerStorageBase
    variable  _classVariables  {}
    variable  _methods         {dele lock size stat transfer unlock}

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
    array set _methodTable  {unlock . stat . transfer . lock . dele . size .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::popServerStorageBase::dele {mbox msgList} {
    ::pool::oo::support::SetupVars popServerStorageBase
    # @c Abstract method, deletes the specified messages from the mailbox.
	#
	# @a mbox:    Handle of the mailbox to modify.
	# @a msgList: List of message ids.

	error "[oinfo class]: abstract method 'delete' not overidden"
}



proc ::pool::oo::class::popServerStorageBase::lock {mbox} {
    ::pool::oo::support::SetupVars popServerStorageBase
    # @c Abstract method, locks the specified mailbox for exclusive access
	# @c by a single connection.
	#
	# @a mbox: Handle of the mailbox to lock.
	# @r 1 if the mailbox was locked sucessfully, 0 else.

	error "[oinfo class]: abstract method 'lock' not overidden"
}



proc ::pool::oo::class::popServerStorageBase::size {mbox msgId} {
    ::pool::oo::support::SetupVars popServerStorageBase
    # @c Abstract method, determines the size of the given mail in the
	# @c specified mailbox, in bytes.
	#
	# @a mbox: Handle of the mailbox to
	# @a msgId: Numerical index of the message to look at.
	# @r size of the message in bytes.

	error "[oinfo class]: abstract method 'size' not overidden"
}



proc ::pool::oo::class::popServerStorageBase::stat {mbox} {
    ::pool::oo::support::SetupVars popServerStorageBase
    # @c Abstract method, determines the number of mails in the specified
	# @c mailbox.
	#
	# @a mbox: Handle of the mailbox to look at.
	# @r The number of messages in the mailbox

	error "[oinfo class]: abstract method 'stat' not overidden"
}



proc ::pool::oo::class::popServerStorageBase::transfer {args} {
    ::pool::oo::support::SetupVars popServerStorageBase
    # @c Abstract method, starts a (partial) transfer of the given
	# @c message. Configured via a list of option/value-pairs, followed
	# @c by the mailbox to look at, the numerical id of the message to
	# @c transfer and the channel to sent the mail to, in this order.
	#
	# @a args: List of option/value-pairs, followed by 3 arguments
	# @a args: (explained in the method description). Recognized options
	# @a args: are '-done' and '-lines'.&p
	# @a args: The value of -done is interpreted as a script to
	# @a args: call after completion of the transfer. Its
	# @a args: specification is required. &p
	# @a args: On the other hand, specification of -lines is
	# @a args: optional. It is interpreted as the number of
	# @a args: lines to transfer, beyond the usual message header.
	# @a args: The complete message is transfered if it is not
	# @a args: specified.

	error "[oinfo class]: abstract method 'transfer' not overidden"
}



proc ::pool::oo::class::popServerStorageBase::unlock {mbox} {
    ::pool::oo::support::SetupVars popServerStorageBase
    # @c Abstract method, revokes the lock on the specified mailbox.
	#
	# @a mbox: Handle of the mailbox to unlock

	error "[oinfo class]: abstract method 'unlock' not overidden"
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::popServerStorageBase::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods popServerStorageBase
::pool::oo::support::FixOptions popServerStorageBase

# Create object instantiation procedure
interp alias {} popServerStorageBase {} ::pool::oo::support::New popServerStorageBase

# -------------------------------


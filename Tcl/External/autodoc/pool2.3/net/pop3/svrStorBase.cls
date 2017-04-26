# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: svrStorBase.cls,v 1.1 1998/06/01 19:56:39 aku Exp $
#
# @c File- and directorybased mailbox management. Currently ussed
# @c by the small scale pop3 server application (<f apps/popsy>).
#
# @s Mailbox management, interface used by a POP3 server (see <c pop3Server>).
# @i Mailbox management, pop3 server
# -----------------------------

class popServerStorageBase {
    # @c This class defines the interface used by instances of <c pop3Server>
    # @c to access the storage subsystem containing all mails retrievable by
    # @c the users of the server.


    method lock {mbox} {
	# @c Abstract method, locks the specified mailbox for exclusive access
	# @c by a single connection.
	#
	# @a mbox: Handle of the mailbox to lock.
	# @r 1 if the mailbox was locked sucessfully, 0 else.

	error "[oinfo class]: abstract method 'lock' not overidden"
    }


    method unlock {mbox} {
	# @c Abstract method, revokes the lock on the specified mailbox.
	#
	# @a mbox: Handle of the mailbox to unlock

	error "[oinfo class]: abstract method 'unlock' not overidden"
    }


    method stat {mbox} {
	# @c Abstract method, determines the number of mails in the specified
	# @c mailbox.
	#
	# @a mbox: Handle of the mailbox to look at.
	# @r The number of messages in the mailbox

	error "[oinfo class]: abstract method 'stat' not overidden"
    }


    method size {mbox msgId} {
	# @c Abstract method, determines the size of the given mail in the
	# @c specified mailbox, in bytes.
	#
	# @a mbox: Handle of the mailbox to
	# @a msgId: Numerical index of the message to look at.
	# @r size of the message in bytes.

	error "[oinfo class]: abstract method 'size' not overidden"
    }


    method transfer {args} {
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


    method dele {mbox msgList} {
	# @c Abstract method, deletes the specified messages from the mailbox.
	#
	# @a mbox:    Handle of the mailbox to modify.
	# @a msgList: List of message ids.

	error "[oinfo class]: abstract method 'delete' not overidden"
    }
}



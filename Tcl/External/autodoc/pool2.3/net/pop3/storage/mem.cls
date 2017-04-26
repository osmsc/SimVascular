# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: mem.cls,v 1.1 1998/06/01 19:56:44 aku Exp $
#
# @c Storage facility, holds incoming mails in memory
# @s Storage facility, holds incoming mails in memory
# @i storage facility
# -----------------------------

class memStorage : popClientStorageBase {
    # @c Storage system usable by the pop client in <c pop3Client>. Incoming
    # @c mails are stored in memory, in the array <v mem>.

    # @v nextId: The next index to use for <v mem>.
    # @v mem:    The array containing the incoming messages.

    var nextId 1
    var -array mem


    method storeMessage {command message} {
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


    method stored {} {
	# @c Query the memory storage facility for messages stored in it.
	# @r The number of messages stored in the facility

	return [expr {$nextId - 1}]
    }


    method messages {} {
	# @c Query the memory storage facility for messages stored in it.
	# @r A list containing the messages stored in the facility, and
	# @r their handles, in a format suitable to 'array set'.

	return [array get mem]
    }


    method clear {} {
	# @c Removes all stored messages from memory

	set                  nextId 1
	::pool::array::clear mem
	return
    }
}


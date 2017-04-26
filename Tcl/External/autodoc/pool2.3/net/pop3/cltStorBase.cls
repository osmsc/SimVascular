# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: cltStorBase.cls,v 1.2 1998/06/04 18:06:45 aku Exp $
#
# @c Interface used by the POP3 client core (<c pop3Client>) to store incoming
# @c messages.
#
# @s Interface used by a POP3 client (see <c pop3Client>) for message storage.
# @i pop3 client
# -----------------------------

class popClientStorageBase {
    # @c This class defines the interface used by instances of <c pop3Client>
    # @c to store retrieved mails locally.

    method store {args} {
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

    method storeMessage {command message} {
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


    method Done {command fail {msg {}}} {
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
}


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: smtp.cls,v 1.1 1998/06/01 19:56:44 aku Exp $
#
# @c Storage facility built upon SMTP delivery
# @s Storage facility built upon SMTP delivery
# @i SMTP, storage facility
# -----------------------------

class smtpStorage : popClientStorageBase {
    # @c Storage system usable by the pop client in <c pop3Client>. Incoming
    # @c mails are send to a smtp demon for local delivery and storage. Uses a
    # @c <c smtpConnection> to do the main work.

    # @o helo: The string to send to the smtp demon after connection and its
    # @o helo: greeting.
    # @o from: The email address of the pseudo sender of all incoming mails
    # @o to:   The address to sent all incoming mails to.

    # -W- In the future the target address might be extracted from the message
    # -W- itself, and then mapped to a local address by an array.

    option helo -d "" -t ::pool::getopt::nonempty
    option from -d "" -t ::pool::getopt::nonempty
    option to   -d "" -t ::pool::getopt::nonempty


    method storeMessage {command message} {
	# @c Store the given message via SMTP and the local mail demon.
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	set conn ${this}Smtp[::pool::serial::new]

	smtpConnection $conn -helo $opt(-helo)

	$conn put \
	    -from	$opt(-from)		\
	    -to		$opt(-to)		\
	    -message	$message		\
	    -string	1			\
	    -command	[list $this IsDone $command]
    }


    method IsDone {command conn} {
	# @c Executed after SMTP storage is finished.
	#
	# @a command: The command to execute after closing the connection
	# @a command: represented by <a conn>.
	# @a conn:    The handle of the <c smtpConnection> object reporting
	# @a conn:    back.

	if {"[$conn state]" == "error"} {
	    Done $command 1 [$conn errorInfo]
	    $conn delete
	    return
	}

	$conn close -command [list $this AllDone $command]
	return
    }


    method AllDone {command conn} {
	# @c Executed after the SMTP connection was completely closed.
	#
	# @a command: The command to execute now that the storing is complete.
	# @a conn:    The handle of the <c smtpConnection> object shutting
	# @a conn:    down.

	if {"[$conn state]" == "error"} {
	    Done $command 1 [$conn errorInfo]
	} else {
	    Done $command 0
	}

	$conn delete
	return
    }
}


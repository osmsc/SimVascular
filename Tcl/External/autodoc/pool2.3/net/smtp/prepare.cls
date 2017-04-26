# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: prepare.cls,v 1.1 1998/06/01 19:56:54 aku Exp $
#
# @c Sequencer for preparation of mail transfer (from / to)
# @s Prepare transfer of mail message (MAIL FROM, RCPT TO)
# @i SMTP, MAIL FROM command, RCPT TO command
# -----------------------------

class smtpPrepareSeq : smtpSequencer {

    # @o from: The email address of the mail sender.
    # @o to:   The list of addresses to send the mail to.

    option from -d "" -c ::pool::getopt::nonempty
    option to   -d "" -c ::pool::getopt::nonempty


    method smtpPrepareSeq {} {
	# @c Constructor.

	next MailFromTry
	return
    }


    method MailFromTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Sends the mail sender address to the demon, then waits
	# @c for its response.

	wait  $opt(-sock) GotMailFromResponse
	Write "MAIL FROM:$opt(-from)"
	return
    }


    method GotMailFromResponse {line} {
	# @c Called after smtp demon responded to the MAIL FROM
	# @c command. In case of sucess the list of intended
	# @c recipients is transfered one by one, via RCPT TO.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	}

	PrepareRecipients
	return
    }


    method PrepareRecipients {} {
	# @c A single recipient is transfered to the demon,
	# @c via RCPT TO.

	set recipient [::pool::list::shift opt(-to)]

	wait  $opt(-sock) GotRcptResponse
	Write "RCPT TO:$recipient"
	return
    }


    method GotRcptResponse {line} {
	# @c Called after the smtp demon responded to the RCPT TO
	# @c command issued last. Completes the transaction or
	# @c sends the next recipient on the list.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	}

	if {$opt(-to) == {}} {
	    event done
	}

	PrepareRecipients
	return
    }
}


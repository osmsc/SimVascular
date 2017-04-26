# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: apop.cls,v 1.1 1998/06/01 19:56:37 aku Exp $
#
# @c Sequencer for login into a pop server via APOP.
# @s Delete message on pop server (APOP)
# @i POP3, APOP command
# -----------------------------

class pop3ApopSeq : pop3Sequencer {
    init {
	# This sequencer relies on my Trf extension to generate and encode the
	# required hashes.

	package require Trf
    }

    # @o user:     The name of the user trying to login.
    # @o secret:   The password of the user trying to login.

    # @o greeting: The text of the greeting which was sent by the server in the
    # @o greeting: initialization phase of the connection.

    option user     -d "" -t ::pool::getopt::nonempty
    option secret   -d "" -t ::pool::getopt::nonempty
    option greeting -d "" -t ::pool::getopt::nonempty


    method pop3ApopSeq {} {
	# @c Constructor.

	next ApopTry
	return
    }


    method ApopTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Extracts the timestamp from the greeting, uses
	# @c this and the password to generate the response to our challenge,
	# @c then writes out the login command to the pop3 server, at last
	# @c waits for its response.

	# extract server timestamp from greeting
	regexp {<(.*)@(.*)>} $opt(-greeting) timestamp

	if {$timestamp == {}}       {
	    error "no timestamp, server unable to handle APOP"
	}

	# generate the hash

	set digIn  "${timestamp}$opt(-secret)"
	set digOut [hex -mode encode $digIn]

	::pool::syslog::syslog debug $this digest input <${digIn}>
	::pool::syslog::syslog debug $this digest outpt <${digOut}>

	# create the sequencer ...

	wait $opt(-sock) GotApopResponse
	Write "APOP $opt(-user) $digOut"
	return
    }


    method GotApopResponse {line} {
	# @c Called after pop3 demon responded to the APOP command. Depending
	# @c on the result of the login the sequencer stops its operation now
	# @c (error), or writes out the command to retrieve the number of
	# @c messages storeed in the mailbox (successful login).
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    wait   $opt(-sock) GotStatResponse
	    Write "STAT"
	}
    }


    method GotStatResponse {line} {
	# @c Called after pop3 demon responded to the STAT command.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    $opt(-conn) SetN [lindex $line 1]
	    event done
	}
    }
}


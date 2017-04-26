# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: user.cls,v 1.1 1998/06/01 19:56:39 aku Exp $
#
# @c Sequencer for login into a pop server via user/pass.
# @s Delete message on pop server (USER)
# @i POP3, USER command
# -----------------------------

class pop3UserSeq : pop3Sequencer {

    # @o user:     The name of the user trying to login.
    # @o secret:   The password of the user trying to login.

    option user     -d "" -t ::pool::getopt::nonempty
    option secret   -d "" -t ::pool::getopt::nonempty


    method pop3UserSeq {} {
	# @c Constructor.

	next UserTry
	return
    }


    method UserTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the login command to the pop3 server, then
	# @c waits for its response.

	# create the sequencer ...

	wait $opt(-sock) GotUserResponse
	Write "USER $opt(-user)"
	return
    }


    method GotUserResponse {line} {
	# @c Called after pop3 demon responded to the USER command. Send the
	# @c password to the server (in clear!), but only if the user was
	# @c accepted by the server.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    wait   $opt(-sock) GotPassResponse
	    Write "PASS $opt(-secret)"
	    # not so secret here in open transmission!
	}
    }


    method GotPassResponse {line} {
	# @c Called after pop3 demon responded to the PASS command. Depending
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


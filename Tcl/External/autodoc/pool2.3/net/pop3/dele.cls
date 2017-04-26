# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: dele.cls,v 1.1 1998/06/01 19:56:38 aku Exp $
#
# @c Sequencer for deletion of a message.
# @s Delete message on pop server (DELE)
# @i POP3, DELE command
# -----------------------------

class pop3DeleteSeq : pop3Sequencer {

    # @o msg: The numerical index of the message to delete at the server.

    option msg -d "" -t ::pool::getopt::nonempty


    method pop3DeleteSeq {} {
	# @c Constructor.

	next DeleteTry
	return
    }


    method DeleteTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the deletion command to the pop3 server,
	# @c then waits for its response.

	wait $opt(-sock) GotDeleResponse
	Write "DELE $opt(-msg)"
	return
    }


    method GotDeleResponse {line} {
	# @c Called after pop3 demon responded to the DELE command.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    event done
	}
    }
}


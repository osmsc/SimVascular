# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: close.cls,v 1.1 1998/06/01 19:56:37 aku Exp $
#
# @c Sequencer for closing down a pop3 connection
# @s Close pop3 connection (QUIT)
# @i POP3, QUIT command
# -----------------------------

class pop3CloseSeq : pop3Sequencer {

    method pop3CloseSeq {} {
	# @c Constructor.

	next CloseTry
	return
    }


    method CloseTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the command to the demon, then waits for
	# @c its response.

	wait $opt(-sock) GotQuitResponse
	Write QUIT
	return
    }


    method GotQuitResponse {line} {
	# @c Called after pop3 demon responded to the QUIT command.
	# @c Whatever state we are in, the channel will be closed.
	#
	# @a line: Text of response

	Log $line

	$opt(-conn) ClearSocket

	if {[IsError $line]} {
	    event error $line
	} else {
	    event done
	}
    }
}


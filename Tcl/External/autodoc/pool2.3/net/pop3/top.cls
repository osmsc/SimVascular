# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: top.cls,v 1.1 1998/06/01 19:56:39 aku Exp $
#
# @c Sequencer for retrieval of message headers.
# @s Delete message on pop server (TOP)
# @i POP3, TOP command
# -----------------------------

class pop3TopSeq : pop3Sequencer {

    # @o msg: The numerical index of the message to delete at the server.

    option msg     -d "" -t ::pool::getopt::nonempty

    # @v message: Used as transient storage for the incoming message.

    var message ""


    method pop3TopSeq {} {
	# @c Constructor.

	next TopTry
	return
    }


    method TopTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the retrieval command to the pop3 server,
	# @c then waits for its response.

	wait $opt(-sock) GotTopResponse
	Write "TOP $opt(-msg) 1"
	return
    }


    method GotTopResponse {line} {
	# @c Called after pop3 demon responded to the TOP command. An error
	# @c aborts the operation, else we start reading the incoming message,
	# @c which followed the server response immediately.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    # the server will dump the header information immediately after
	    # a positive response. setup an event to handle the incoming data.

	    set message ""

	    wait $opt(-sock) GotTopData
	    return
	}
    }


    method GotTopData {line} {
	# @c Called for each line of the incoming mail. Stops the
	# @c sequencer upon detection of the end-of-message marker (single
	# @c dot on a line by itself), or appends the <a line> to its
	# @c internal store.
	#
	# @a line: Text of response
    
	if {"$line" == "."} {
	    # end of message marker received, transaction completed

	    set message [string trimright $message "\t\n "]
	    event done
	} else {
	    # extend storage of received data

	    append message "$line\n"

	    wait $opt(-sock) GotTopData
	    return
	}
    }


    method GetMessage {} {
	# @c Accessor method.
	# @r is the text of the received message.

	return $message
    }
}


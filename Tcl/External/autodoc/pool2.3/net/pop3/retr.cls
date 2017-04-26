# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: retr.cls,v 1.1 1998/06/01 19:56:38 aku Exp $
#
# @c Sequencer for retrieval of messages.
# @s Delete message on pop server (RETR)
# @i POP3, RETR command
# -----------------------------

class pop3RetrSeq : pop3Sequencer {

    # @o msg:     The numerical index of the message to delete at the server.

    # @o use-top: A boolean flag. Setting it to TRUE causes the sequencer to
    # @o use-top: use the command 'TOP x 0' instead of 'RETR x' to retrieve
    # @o use-top: the message. The first pop server of my provider didn't
    # @o use-top: recognize RETR, but this special command. Maybe some other
    # @o use-top: people have to deal with such a weird beast too.

    option msg     -d "" -t ::pool::getopt::nonempty
    option use-top -d 0  -t ::pool::getopt::boolean

    # @v message: Used as transient storage for the incoming message.

    var message ""


    method pop3RetrSeq {} {
	# @c Constructor.

	next RetrTry
	return
    }


    method RetrTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the retrieval command to the pop3 server,
	# @c then waits for its response.

	wait $opt(-sock) GotRetrResponse

	if {$opt(-use-top)} {
	    # the first pop server of my provider didn't accept RETR x.
	    # Had to use 'TOP x 0' instead. Maybe some other people have
	    # to deal with such a weird beast too.

	    Write "TOP $opt(-msg) 0"
	} else {
	    Write "RETR $opt(-msg)"
	}
	return
    }


    method GotRetrResponse {line} {
	# @c Called after pop3 demon responded to the RETR command. An error
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

	    wait $opt(-sock) GotRetrData
	    return
	}
    }


    method GotRetrData {line} {
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

	    wait $opt(-sock) GotRetrData
	    return
	}
    }


    method GetMessage {} {
	# @c Accessor method.
	# @r is the text of the received message.

	return $message
    }
}


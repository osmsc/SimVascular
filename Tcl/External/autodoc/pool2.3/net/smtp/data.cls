# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: data.cls,v 1.1 1998/06/01 19:56:53 aku Exp $
#
# @c Defines the sequencer to execute a SMTP DATA transfer
# @s Transfer message to smtp demon (DATA)
# @i SMTP, Message transfer, DATA command
# -----------------------------

class smtpDataSeq : smtpSequencer {

    # @o progress:  If not empty, a command to evaluate with current connection
    # @o progress:  and number of bytes transfered so far as arguments.

    # @o blocksize: Companion option to <o progress>, optional. Defines the
    # @o blocksize: size of the blocks to transfer between invocations of
    # @o blocksize: <o progress>. Ignored if <o progress> is empty.

    option progress   -d ""
    option blocksize  -d 1024 -c ::pool::getopt::integer

    # @o message: Either the handle of a channel containing the message to
    # @o message: sent, or the message itself. This is determined by the
    # @o message: contents of <o string>.

    # @o string:  A boolean value indicating wether <o message> is the channel
    # @o string:  containing it (false), or the message itself (true). This is
    # @o string:  optional and defaults to false.

    option message -d "" -c ::pool::getopt::nonempty
    option string  -d 0  -c ::pool::getopt::boolean

    # @v closeChannel: If <o message> contains the message itself an internal
    # @v closeChannel: memory channel is used to allow us the placement of the
    # @v closeChannel: transfer into the background and this flag is set to
    # @v closeChannel: true, reminding us that we are responsible for the
    # @v closeChannel: closing of the message channel.

    var closeChannel 0

    # @v nTransfered: Internal counter, keeps track of the total number of
    # @v nTransfered: bytes transfered by a single call to 'fcopy'. Used only
    # @v nTransfered: if <o progress> is set.

    var nTransfered  0


    method smtpDataSeq {} {
	# @c Constructor.

	next DataTry
	return
    }


    method DataTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the command initiating a data transfer to
	# @c the demon, then waits for its response.

	wait $opt(-sock) GotDataResponse
	Write DATA
	return
    }


    method GotDataResponse {line} {
	# @c Called after smtp demon reacted on DATA. A specific
	# @c response code is expected, everything else is
	# @c considered as failure. Initiates the real transfer
	# @c of data in case of success.
	#
	# @a line: Response of demon

	Log $line

	switch -- [lindex $line 0] {
	    354     {
		StartTransfer
	    }
	    default {
		event error $line
	    }
	}
    }


    method StartTransfer {} {
	# @c Starts transfer of data. If <o progress> was specified the
	# @c initiated transfer is cut into individual chunks of <o blocksize>
	# @c bytes each.

	# future: massage message body with transformer procedure!

	# syslog debug [seq_aget $seq -smtp] > transfer message block...

	if {$opt(-progress) == {}} {
	    # No progress indicator, therefore no need to copy
	    # individual chunks.

	    if {$opt(-string)} {
		# Message is a string, write it out (synchronously), then wait
		# for the response.

		puts $opt(-sock) $opt(-message)
		puts $opt(-sock) "."

		wait $opt(-sock) GotTransferResponse 
	    } else {
		# Message is stored in a channel, just copy between it and the
		# connection to the demon. This takes place in the background.

		fcopy $opt(-message) $opt(-sock) \
			-command [list $this DataTransferProgress]
	    }
	} else {
	    # A progress indicator was given to the sequencer. Send data in
	    # chunks (of -blocksize) to get that going.

	    if {$opt(-string)} {
		# Sending a string in chunks and in the background is too
		# complicated. Use memory channel for reduction to the simple
		# case of channels.

		# create a in-memory channel, store the message in it, then
		# play with the option values and our internal state.

		package require Memchan

		set   mc [memchan]
		puts $mc $opt(-message)
		seek $mc 0

		set opt(-message) $mc
		set opt(-string)  0 ; # cause future calls to bypass this code
		set closeChannel  1 ; # force delete of channel after transfer
	    }

	    fcopy $opt(-message) $opt(-sock) \
		    -size    $opt(-blocksize) \
		    -command [list $this DataTransferProgress]
	}

	return
    }


    method DataTransferProgress {n} {
	# @c Callback for transfer. Completes whole transfer or initiates next
	# @c chunk. Executes the progress-handler, if it was defined.
	#
	# @a n: Number of bytes transfered by 'fcopy'.

	incr nTransfered $n

	if {[eof $opt(-message)]} {
	    # end-of-message marker
	    puts $opt(-sock) "."

	    if {$closeChannel} {
		# Transfer involved a string, remove the internal in-memory
		# channel and restore the original state of the sequencer.

		close $opt(-message)
		set    opt(-message) {}
	    }

	    wait $opt(-sock) GotTransferResponse 
	} else {
	    # jump out to progress handler

	    if {$opt(-progress) != {}} {
		set fail [catch {
		    uplevel #0 $opt(-progress) $opt(-conn) $nTransfered
		} errmsg] ;# {}

		if {$fail} {
		    global errorInfo
		    event $seq error "$errmsg $errorInfo"
		}
	    }

	    # continue copying
	    StartTransfer
	}

	return
    }


    method GotTransferResponse {line} {
	# @c After the completion of a transfer a closing response is send by
	# @c the demon. It is catched here and depending on its response code
	# @c the operation terminates with either success or failure.
	#
	# @a line:  Response of demon.

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    event done
	}
    }
}


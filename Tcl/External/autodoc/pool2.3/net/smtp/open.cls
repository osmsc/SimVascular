# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: open.cls,v 1.1 1998/06/01 19:56:54 aku Exp $
#
# @c Implements the sequencer to open a SMTP connection
# @s Open smtp connection (HELO)
# @i SMTP, Open connection, HELO command
# -----------------------------

class smtpOpenSeq : smtpSequencer {

    # @o maxtries:   Specifies the maximum allowed number of trials to connect.
    # @o maxtries:   Defaults to 1.

    # @o retrydelay: Specifies the time to wait (in milliseconds) after a
    # @o retrydelay: failure before doing the next try. Defaults to 10 seconds.

    # @o host:       Specifies the host the demon to connect to resides on.
    # @o host:       Defaults to 'localhost'.

    # @o helo:       Specifies the string to use as argument for the HELO
    # @o helo:       command sent to the demon after its greeting.

    option helo       -d ""
    option maxtries   -d 1
    option retrydelay -d 10000
    option host       -d localhost

    # @v tries: The number of tries which were executed (and failed) so far.

    var tries 0


    method smtpOpenSeq {} {
	# @c Constructor.

	next OpenTry
	return
    }


    method OpenTry {} {
	# @c The first action taken after the construction of the sequencer
	# @c completes. Tries to get a socket refering to a connection to the
	# @c server. In case of failure at most <o maxtries> retries are made
	# @c before giving up.

	incr tries

	set fail [catch {
	    set sock [socket $opt(-host) [::pool::smtp::port]]
	} errmsg] ;# {}

	if {$fail} {
	    if {$tries == $opt(-maxtries)} {
		event error $errmsg
	    }

	    after $opt(-retrydelay) $this event next
	    return
	}

	# We have a connection now, configure it, then wait for
	# initial greeting send by demon we are talking to.

	fconfigure $sock -blocking 0 -buffering line -translation crlf

	$opt(-conn) SetSock $sock
	set opt(-sock)      $sock

	wait $sock GotGreeting
	return
    }


    method GotGreeting {line} {
	# @c Called after the the demon sent a greeting message
	# @c identifying itself. Now we identify ourselves by
	# @c sending HELO with an appropriate argument.
	#
	# @a line: Text of response

	Log   $line
	wait  $opt(-sock) GotHeloResponse
	Write "HELO $opt(-helo)"
	return
    }


    method GotHeloResponse {line} {
	# @c Called after the demon reacted on HELO. Depending
	# @c on the type of response the transaction completes
	# @c with either success or failure.
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


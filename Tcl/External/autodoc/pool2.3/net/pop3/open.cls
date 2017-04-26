# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: open.cls,v 1.3 2000/07/31 19:15:25 aku Exp $
#
# @c Implements the sequencer to open a POP3 connection
# @s Open pop3 connection (HELO)
# @i POP3, Open connection, HELO command
# -----------------------------

class pop3OpenSeq : pop3Sequencer {

    # @o maxtries:   Specifies the maximum allowed number of trials to connect.
    # @o maxtries:   Defaults to 1.

    # @o retrydelay: Specifies the time to wait (in milliseconds) after a
    # @o retrydelay: failure before doing the next try. Defaults to 10 seconds.

    # @o host:       Specifies the host the demon to connect to resides on.
    # @o host:       Defaults to 'localhost'.

    option maxtries   -d 1
    option retrydelay -d 10000
    option host       -d localhost

    # @v tries: The number of tries which were executed (and failed) so far.

    var tries 0


    method pop3OpenSeq {} {
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

	#parray opt
	#::puts "tries=$tries"

	::pool::syslog::syslog debug \
		"Connecting to $opt(-host) on port [::pool::pop3::port] ($tries)"

	set fail [catch {
	    set sock [socket $opt(-host) [::pool::pop3::port]]
	} errmsg] ;# {}

	::pool::syslog::syslog debug "Connecting: $fail $errmsg"

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
	# @c identifying itself. The sent information is stored
	# @c in the pop3 descriptor as it may contain information
	# @c required by APOP.
	#
	# @a line: Text of response

	Log                     $line
	$opt(-conn) SetGreeting $line

	event done
	return
    }
}


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: seq.cls,v 1.1 1998/06/01 19:56:38 aku Exp $
#
# @c Base functionality of all sequencers handling a POP3 command.
# @s POP3 sequencer base
# @i POP3, sequencer base
# -----------------------------

class pop3Sequencer : sequencer {
    # @c Special sequencer containing the common information and functionality
    # @c required by a sequencer handling an POP command


    # @o conn: Handle of the <c pop3Connection> object which created the
    # @o conn: sequencer.

    option conn -d ""

    # @o done: Name of the method to call at <o conn> after completion of the
    # @o done: sequence.

    option done -d ""

    # @o sock: The socket to use to talk with the pop3 demon.

    option sock -d ""


    method OnDone {} {
	# @c Overides base class definition <m sequencer:OnDone> to call the
	# @c completion method in the associated pop3 connection object.

	return [$opt(-conn) $opt(-done) $this]
    }


    method Write {text} {
	# @c Send the specified <a text> to the pop3 demon. Additionally logs
	# @c it using the syslog facility of Pool.
	#
	# @a text: The text to send to the pop3 demon.

	puts                         $opt(-sock)   $text
	::pool::syslog::syslog debug $opt(-conn) > $text
	return
    }


    method Log {text} {
	# @c Logs the specified <a text> using syslog facility of Pool.
	# @a text: The text to log.

	::pool::syslog::syslog debug $opt(-conn) < $text
	return
    }


    method IsError {line} {
	# @c Determines the error state of the POP3 response contained in
	# @c <a line>.
	# @a line: The response to check.
	# @r 1 in case of an error detected, 0 else.

	set response [lindex $line 0]

	if {"$response" == "+OK"} {
	    return 0
	} else {
	    return 1
	}
    }
}


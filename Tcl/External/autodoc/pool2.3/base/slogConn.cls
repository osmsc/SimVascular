# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: slogConn.cls,v 1.2 1999/02/14 19:48:14 aku Exp $
#
# @c Helper to syslog. Allows users to prepend the generated messages with a
# @c prefix of their own choice.
# -----------------------------

class syslogConnection {
    # @c This simple class extends the base 'syslog' system by allowing
    # @c different libraries to prefix messages with a string of their own
    # @c choice.


    # @o prefix: String to add to all messages running through
    # @o prefix: the instance.

    option prefix -d {}

    method log {level args} {
	# @c Forwards incoming data to <p ::pool::syslog::syslog>, additionally
	# @c adds the stored prefix to the message.
	#
	# @a level: relative importance of the message.
	# @a args:  List of texts to log.

	::pool::syslog::syslog $level $opt(-prefix): $args
	return
    }
}


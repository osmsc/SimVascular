# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: remoteLog.cls,v 1.1 1998/06/01 19:55:15 aku Exp $
#
# @c Helper to syslog. Allows users to prepend the generated messages with a
# @c prefix of their own choice.
# -----------------------------

class remoteLog {

    # @o portspec: The specification of the port to send the logged messages
    # @o portspec: to. A list containing two elements, the name of the target
    # @o portspec: host, and the port used there, in this order.

    option portspec -d {} -a TrackPortSpec

    # @v host:   The host-part of <o portspec>
    # @v port:   The port-part of <o portspec>
    # @v socket: The handle of the channel created via <o portspec>.

    var host   ""
    var port   ""
    var socket ""


    method remoteLog {} {
	# @c Constructor, initializes the port specification (as empty)
	# @c <o portspec>.

	TrackPortSpec -portspec {}
	return
    }


    method TrackPortSpec {option oldValue} {
	# @c Configure procedure. Propagates changes to the port specification
	# @c to <v host>, <v port> and <v socket>.
	#
	# @a option:   The changed option.
	# @a oldValue: The old value of the option.

	if {$opt(-portspec) == {}} {
	    catch {close $socket}
	    set port   ""
	    set host   ""
	    set socket ""

	    # switch syslog off
	    ::pool::syslog::def {}
	} else {
	    set host   [lindex $opt(-portspec) 0]
	    set port   [lindex $opt(-portspec) 1]
	    set socket [socket $host $port]
	    
	    fconfigure $socket -buffering line -translation crlf -blocking 0

	    # start logging
	    ::pool::syslog::def [list $this log]
	}

	return
    }


    method log {level text} {
	# @c This method sends the incoming messages down the <v socket>.
	#
	# @a level: Relative importance of the logged message. Should be one
	# @a level: of the strings returned by <p ::pool::syslog::levels>.
	#
	# @a text: The message to log.

	# standard log
	#puts stderr "($port) $level\t$text"
	# puts stderr "$level\t$text"

	if {$port == {}} {return}

	#    puts stderr "--$level\t$text"

	if {[catch {puts $socket "$level $text"} errmsg]} {
	    catch {close $socket}
	    set port   ""
	    set host   ""
	    set socket ""

	    ::pool::syslog::def {}

	    puts stderr "error\tremotelog problem: $errmsg"
	}

	return
    }
}


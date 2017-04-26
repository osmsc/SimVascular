# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: misc.tcl,v 1.2 1998/06/01 19:56:15 aku Exp $
#
# @c Miscancellous procedures
# @s Miscancellous procedures
# @/i 
# -----------------------------

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval misc {
	variable version @base:mFullVersion@
	namespace export *

	# initialize port number generator
	set rdLastPort  [expr [pid] % 32768 + 9999]
    }
}



proc ::pool::misc::rdServer {command} {
    # @c Starts a server socket on a randomly chosen port.
    # @c The general idea of operation was taken from the Comm
    # @c package by <x loverso>.
    # @a command: The command to execute for a new connection
    # @a command: accepted by the server socket.
    # @r The chosen port
    # @i Server on random port

    variable   rdLastPort
    set nport $rdLastPort

    while {1} {
	set cmd [list socket -server $command]

	lappend cmd $nport
	if {![catch $cmd ret]} {
	    break
	}

	# error occured. in case of collision with
	# other user of 'nport' try again with different numbert

	if {![string match "*already in use" $ret]} {
	    error $ret
	}
	set nport [incr rdLastPort]
    }

    return [lindex [fconfigure $ret -sockname] 2]
}


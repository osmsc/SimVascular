# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: port.tcl,v 1.3 2000/07/31 19:15:25 aku Exp $
#
# @c Definition of port to use by pop3 client and server cores.
# @c Might be overidden for testing purposes.
# @s Definition of port to use by pop3 client and server cores.
# @i POP3, port definition for POP3
# -----------------------------

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval pop3 {
	variable version @base:mFullVersion@
	namespace export *
    }
}


proc ::pool::pop3::port {} {
    # @c This command returns the port to be used by clients
    # @c (<f net/pop3/pop3.cls>. Its redefinition allows usage
    # @c of a different port for testing purposes; and is
    # @c simpler than the implementation of a -port option.

    #return pop3
    return 110 ; # avoid /etc/services, might not contain pop3!
}


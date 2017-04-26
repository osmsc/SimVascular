# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: port.tcl,v 1.3 1998/06/02 20:05:37 aku Exp $
#
# @c Definition of port to use by smtp client and server cores.
# @c Might be overidden for testing purposes.
# @s Definition of port to use by smtp client and server cores.
# @i SMTP, port definition for SMTP
# -----------------------------

package require Tcl 8.0
package require Pool_Base

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval smtp {
	variable version @base:mFullVersion@
	namespace export *

    }
}


proc ::pool::smtp::port {} {
    # @c This command returns the port to be used by clients
    # @c (<f net/smtp/smtp.cls>. Its redefinition allows usage
    # @c of a different port for testing purposes; and is
    # @c simpler than the implementation of a -port option.

    return smtp
}


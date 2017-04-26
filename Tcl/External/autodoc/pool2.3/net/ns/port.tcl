# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net
#
# CVS: $Id: port.tcl,v 1.2 1998/06/01 19:56:26 aku Exp $
#
# @c Mini nameserver / registry system, port of demon
# @s Mini nameserver, application registry, port spec
# @i nameserver, registry, application registry
# -----------------------------

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval nameserver {
	variable version @base:mFullVersion@
	namespace export *
    }
}


proc ::pool::nameserver::Port {} {
    # @r The port to use by the mini name server
    return 31853
}


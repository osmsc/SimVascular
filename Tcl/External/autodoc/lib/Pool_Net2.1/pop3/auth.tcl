# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: auth.tcl,v 1.1 1998/06/01 19:56:37 aku Exp $
#
# @c Helper procedures used by <c pop3Server>. A type checker usable by the
# @c option processing subsystem (<f base/getopt.tcl>) is provided. 
#
# @s POP3 type checker procedures
# @i type checker, POP3
# -----------------------------

package require Tcl 8.0

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval pop3 {
	variable version @base:mFullVersion@
	namespace export *
    }
}


proc ::pool::pop3::authmode {o v} {
    # @c This type checker accepts only 'apop' and 'upass' as valid
    # @c authentication modes.
    #
    # @a o: The option whose value is checked.
    # @a v: The value to check.

    # @r A boolean value. True if <a v> contained a legal authentication mode.

    switch -- $v {
	apop  -
	upass {
	    return 1
	}
    }

    return 0
}



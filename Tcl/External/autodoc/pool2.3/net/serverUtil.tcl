# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: serverUtil.tcl,v 1.1 1998/06/01 19:56:16 aku Exp $
#
# @c Framework for construction of line-oriented servers (like smtp,
# @c pop3, ...). See <xref svt_explain> for more information and
# @c <f net/pop3/>, <f net/smtp/> for examples of usage. See <c server> too.
#
# @s Server construction kit, helper procedures.
# @i Server, Framework for servers, Construction of servers
# -----------------------------

package require Tcl 8.0


namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval oo {
	variable version @base:mFullVersion@

	namespace eval class {
	    namespace eval server {
		# - Here goes our special procedure
	    }
	}
    }
}


proc ::pool::oo::class::server::InstallBgError {} {
    # @c Entrypoint for the auto loader. Executing it causes the installation
    # @c of a custom background handler used by <c server>-derived classes to
    # @c get correct error reporting in case of socket problems.
}


proc bgerror {text} {
    # @c Special handler of background error messages.
    # @n Essential to handling certain types of errors
    # @n (during 'fcopy' for instance).
    # @a text: The error message to print and handle.

    global errorInfo

    # our own handler of global error conditions
    # determines affected server and connection in
    # case of socket problems, enforces shutdown.

    if {[regexp {(sock[0-9]*)} $text match sockname]} {

	# iterate over servers
	foreach s [array names ::pool::oo::server::servers] {
	    if {[$s managesSock $sockname]} {
		$s reportError $sockname $text
		return
	    }
	}

	# don't know what to do
    }

    # report generally
    ::pool::syslog::syslog error $text, $errorInfo
}


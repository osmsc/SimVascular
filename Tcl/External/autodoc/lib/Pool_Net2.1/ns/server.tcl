# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: server.tcl,v 1.5 1998/06/02 20:05:34 aku Exp $
#
# @c Serverside of mini nameserver / registry system. It
# @c is built on top of the Comm package by <xref loverso>.
# @s Mini nameserver, application registry, server
# @i nameserver, registry, application registry, name service

package require Tcl 8.0
package require Pool_Base
package require Comm

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval nameserver {
	variable version @base:mFullVersion@

	namespace eval server {
	    namespace export *

	    # registry database, maps application names to network ports
	    ::pool::array::def registry
	}
    }
}

# redefine standard channel to use the specified server port
comm destroy
comm new comm -local 1 -listen 1 -port [::pool::nameserver::Port]


proc ::pool::nameserver::server::register {as} {
    # @c Called by client to register the application with
    # @c id 'comm remoteid' under the name of <a as>.
    # @a as: The name to use for registration
    #
    # @future: -W- Return some hashed key as result of registration, allow
    # @future: -W- deletion only if requestor presents the appropriate token.
    # @future: -W- << this must be defined more precisely >>.
    # @future: -W- Password protected access for monitor and management
    # @future: -W- applications.

    variable registry

    ::pool::syslog::syslog info ns [comm remoteid] nameserver::register $as

    if {[info exists registry($as)]} {
	error "application \"$as\" already present"
    }

    set registry($as) [comm remoteid]
    return
}


proc ::pool::nameserver::server::revoke {who} {
    # @c Called by the client to unregister the application <a who>.
    # @c The system checks that the application executing the
    # @c revocation is the same as the registrator.
    # @a who: Name to remove from the database.

    # @d The application 'nsmon' is permitted to remove other applications
    # @d than itself. Use this application only in a trusted environment!

    variable registry

    if {[comm remoteid] != $registry($who)} {
	# check for monitor, this one is allowed to remove other
	# applications than itself. *No big protection*, just a
	# check against the name 'nsmon', so use only in a trusted
	# environment.

	if {
	    ![info exists registry(nsmon)] ||
	    ([comm remoteid] != $registry(nsmon))
	} {
	    error "you are not \"$who\""
	}
    }

    ::pool::syslog::syslog info ns [comm remoteid] nameserver::revoke $who

    unset registry($who)
    return
}


proc ::pool::nameserver::server::lookup {pattern} {
    # @c Called by the client to search for applications
    # @c matching the <a pattern>.
    # @a pattern: The glob style pattern to use while
    # @a pattern: searching the registration database.

    variable registry

    ::pool::syslog::syslog info ns [comm remoteid] nameserver::lookup $pattern

    return [array get registry $pattern]
}


proc ::pool::nameserver::server::init {} {
    # @c Initializes the serverside facilities of the name
    # @c service. Does actually nothing, serves as entry
    # @c point for the autoloader only.

    ::pool::syslog::syslog info ns nameserver::init [::pool::date::nowTime]
    return
}


# -----------------------------
# missing things:
#
# -W- trap and recover from signals.
# -W- save / restore database to recover from crashs
# -W- ping registered applications, enable the removal
# -W- of entries associated to died applications
# -W- allow for forced removal of entries by some sort
# -W- of superuser. add crypt tech to do more rigorous
# -W- checking during revokation.
#
# -W- ? allow multiple registrations of the same name,
# -W-   automatically add distinguishing serial number (#n),
# -W-   see tk send and its registry
#
# -W- allow more than server instance, primary vs. secondaries,
# -W- automatic switch over in case of primary crashes.
# -W- debugging hooks into the facility (watch its operation online).
# -W- -> use syslog to do this ?!
# -----------------------------


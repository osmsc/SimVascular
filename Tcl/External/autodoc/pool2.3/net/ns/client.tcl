# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net
#
# CVS: $Id: client.tcl,v 1.5 1998/06/02 20:05:34 aku Exp $
#
# @c Clientside of mini nameserver / registry system. It
# @c is built on top of the Comm package by <xref loverso>.
# @s Mini nameserver, application registry, client
# @i nameserver, registry, application registry
# -----------------------------

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
	namespace export *

	# remember the name used to register at the name server
	set appname ""

	# get port the server listens on for requests.
	set port [::pool::nameserver::Port]

	# add cleanup hook
	::pool::atexit::add ::pool::nameserver::Clean
    }
}


proc ::pool::nameserver::register {as} {
    # @c Registers the running application at the name
    # @c server under the name of <a as>. The name is
    # @c remembered internally, for use by <p ::pool::nameserver::revoke>.
    #
    # @a as: Name to use for registration.

    variable appname
    variable port

    if {$appname != {}} {
	error "$as: already registered"
    }

    set  appname $as

    set fail [catch {
	comm send $port ::pool::nameserver::server::register [list $as]
    } msg] ;#{}

    if {$fail} {
	if {[string match "*refused*" $msg]} {
	    error "no name server present at port $port"
	} else {
	    global errorInfo
	    error "$msg $errorInfo"
	}
    }

    return
}


proc ::pool::nameserver::revoke {} {
    # @c Removes the application from the name server.

    variable appname
    variable port

    if {$appname == {}} {
	error "application not registered"
    }

    set fail [catch {
	comm send $port ::pool::nameserver::server::revoke [list $appname]
    } msg] ;#{}

    if {$fail} {
	if {[string match "*refused*" $msg]} {
	    error "no name server present at port $port"
	} else {
	    global errorInfo
	    error "$msg $errorInfo"
	}
    }

    set appname ""
    return
}


proc ::pool::nameserver::revokeOther {name} {
    # @c Removes the application from the name server.
    #
    # @a name: The name of the application to remove from the nameserver.

    variable port

    if {$name == {}} {
	error "application missing"
    }

    set fail [catch {
	comm send $port ::pool::nameserver::server::revoke [list $name]
    } msg] ;#{}

    if {$fail} {
	if {[string match "*refused*" $msg]} {
	    error "no name server present at port $port"
	} else {
	    global errorInfo
	    error "$msg $errorInfo"
	}
    }

    return
}


proc ::pool::nameserver::lookup {{pattern *}} {
    # @c Queries the name server for registered
    # @c applications matching the <a pattern>.
    # @a pattern: glob-style pattern to use during search.
    # @r A list usable by 'array set'. Application names
    # @r are mapped to ids usable by 'comm'.

    variable port

    set fail [catch {
	comm send $port ::pool::nameserver::server::lookup [list $pattern]
    } msg] ;#{}

    if {$fail} {
	if {[string match "*refused*" $msg]} {
	    error "no name server present at port $port"
	} else {
	    global errorInfo
	    error "$msg $errorInfo"
	}
    } else {
	return $msg
    }
}


proc ::pool::nameserver::Clean {} {
    # @c This procedure is hooked into 'exit' to perform automatic revokation
    # @c upon exit. See <p ::pool::atexit::add> too. It is not foolproof, as
    # @c signals are not trapped.

    variable appname

    if {$appname == {}} {
	return
    }

    catch {revoke}
    return
}


# -----------------------------
# missing things:
#
# => see 'server.tcl'.
# -----------------------------


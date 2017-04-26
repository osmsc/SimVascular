# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -- utilities -- 

proc adef {name} {
    upvar $name array
    catch {unset array}
    set   array(_) {}
    unset array(_)
    return
}


proc foreachWin {w args} {
    catch {eval $w $args}

    foreach w [winfo children $w] {
	eval foreachWin $w $args
    }

    return
}



proc logName {} {
    # @c Determines the name of actual user. Several methods are
    # @c tried before giving up.
    # @r The user (account) running the calling application.
    # @i account search, user id, logname

    global env tcl_platform

    switch --  $tcl_platform(platform) {
	unix {
	    set logname ""

	    catch {set logname $env(LOGNAME)}
	    if {{} != $logname} {return $logname}

	    catch {set logname $env(USER)}
	    if {{} != $logname} {return $logname}

	    catch {set logname [exec logname]}
	    if {{} != $logname} {return $logname}

	    catch {set logname [exec whoami]}
	    if {{} != $logname} {return $logname}
	}
	win {
	    package require registry
	    return [registry values HKEY_LOCAL_MACHINE\\Network\\Logon\\username]
	}
	default {
	    error "don't know how to get username for this system ($tcl_platform(platform))"
	}
    }

    error "can't find name of actual user"
}


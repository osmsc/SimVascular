# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS:	$Id: misc.tcl,v 1.7 2000/07/31 19:15:15 aku Exp $
#
# @c Miscancellous procedures
# @s Miscancellous procedures
# --------------------

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval misc {
	variable version @base:mFullVersion@
	namespace export *
    }
}



proc ::pool::misc::currentAddress {} {
    # @r The email address of the user calling the procedure.
    # @d Assumes a usual setup with login name equivalent to email name.

    return [logName]@[info hostname]
}


proc ::pool::misc::currentUser {} {
    # @r Shortcut to get at the real name of the user calling the procedure.

    return [realName [logName]]
}



proc ::pool::misc::realName {account} {
    # @c Determines the realworld name of user <a account>,
    # @c as stored in /etc/passwd.
    # @a account: The name of the account to seach the real name for.
    # @r The real name associated to the <a account>.

    # @i account search, user id, logname

    global tcl_platform

    if {[string compare unix $tcl_platform(platform)] != 0} {
	# @note This procedure is specific to unix and derivations.

	return "Unknown"
    }

    set tmp [open /etc/passwd r]

    while {! [eof $tmp]} {
	set line [split [gets $tmp] :]
	if {"$account" == "[lindex $line 0]"} {
	    return [lindex $line 4]
	}
    }

    return "Unknown"
}



proc ::pool::misc::logName {} {
    # @c Determines the name of actual user. Several methods are
    # @c tried before giving up.
    # @r The user (account) running the calling application.
    # @i account search, user id, logname

    global env tcl_platform

    set logname ""

    catch {set logname $env(LOGNAME)}
    if {{} != $logname} {return $logname}

    catch {set logname $env(USER)}
    if {{} != $logname} {return $logname}

    catch {set logname [exec logname]}
    if {{} != $logname} {return $logname}

    catch {set logname [exec whoami]}
    if {{} != $logname} {return $logname}

    error "can't find name of actual user (set LOGNAME, USER or USERNAME)"
}



proc ::pool::misc::setDifference {a b} {
    # @c Computes the difference A-B of the sets <a a> and <a b>.
    # @c Duplicate elements are removed from the result.
    # @c The arguments must contain lists.
    #
    # @r The difference A-B of the given sets.
    #
    # @a a: List containing the base set.
    # @a b: List containing the set to subtract from the first.

    return [::pool::list::uniq [::pool::list::filter $a $b]]
}



proc ::pool::misc::setIntersection {a b} {
    # @c Computes the intersection of the sets <a a> and <a b>.
    # @c Duplicate elements are removed from the result.
    # @c The arguments must contain lists.
    #
    # @r The intersection of the given sets.
    #
    # @a a: List containing the first set to intersect.
    # @a b: List containing the second set to intersect.

    set a [::pool::list::uniq $a]
    set b [::pool::list::uniq $b]

    # The length of the first argument to 'match' is the speed limiting factor,
    # not the pattern, so choose the shorter one for that.

    if {[llength $a] < [llength $b]} {
	return [::pool::list::uniq [::pool::list::match $a $b]]
    } else {
	return [::pool::list::uniq [::pool::list::match $b $a]]
    }
}



proc ::pool::misc::setUnion {a b} {
    # @c Computes the union of the sets <a a> and <a b>.
    # @c Duplicate elements are removed from the result.
    # @c The arguments must contain lists.
    #
    # @r The union of the given sets.
    #
    # @a a: List containing the first set to unify.
    # @a b: List containing the second set to unify.

    return [::pool::list::uniq [concat $a $b]]
}


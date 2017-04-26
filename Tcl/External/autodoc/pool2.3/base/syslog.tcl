# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: syslog.tcl,v 1.1 1998/06/01 19:55:16 aku Exp $
#
# @c General logging facility to avoid having lower libraries
# @c to know the actual log mechanism employed by a client application.
# @s syslog-like logging facility.
# @i logging, syslog, message reporting, error reporting, message levels

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval syslog {
	variable version @base:mFullVersion@
	namespace export *

	# List containing the names of the log-levels available to the user

	variable logLevels {
	    emergency alert critical error warning notice info debug
	}

	# A map from the unique prefixes of all levels to the longform

	variable pfxMap
	foreach level $logLevels {
	    set pfxMap($level) $level
	}
	::pool::string::fillPrefixes pfxMap

	# internal state of the subsystem
	# A map associating log-levels to the commands to execute.

	variable cmd
	foreach level $logLevels {
	    set cmd($level) {}
	}

	# associate log-levels and colors, for usage by user interfaces

	variable color
	array set color {
	    emergency red
	    alert     red
	    critical  red
	    error     red
	    warning   yellow
	    notice    seagreen
	    info      {}
	    debug     lightsteelblue
	}

	# associate log-levels to numerical values, for easy comparison
	# of importance

	variable levelNumber
	array set levelNumber {
	    emergency 7
	    alert     6
	    critical  5
	    error     4
	    warning   3
	    notice    2
	    info      1 
	    debug     0
	}

	# remove temporary
	unset level
    }
}



proc ::pool::syslog::2color {level} {
    # @r The color associated to the given <a level>
    # @a level: The level to convert into a color.

    variable color
    variable pfxMap

    set level $pfxMap($level)
    return    $color($level)
}



proc ::pool::syslog::levelCmp {lvA lvB} {
    # @r One of -1, 0, or 1. 0 if <a lvA> and <a lvB> are equal, -1
    # @r if <a lvA> is less important than <a lvB> and 1 else.
    # @a lvA: The first level to compare.
    # @a lvB: The second level to compare.

    variable pfxMap
    variable levelNumber

    set lvA  $pfxMap($lvA)
    set lvB  $pfxMap($lvB)

    set lvA  $levelNumber($lvA)
    set lvB  $levelNumber($lvB)

    if {$lvA < $lvB} {
	return -1
    } elseif {$lvA > $lvB} {
	return 1
    } else {
	return 0
    }
}



proc ::pool::syslog::def {putsCmd} {
    # @c Defines a command which will be executed for every message given to
    # @c the system.
    #
    # @a putsCmd: The script evaluated by <p ::pool::syslog::syslog> to log the
    # @a putsCmd: incoming messages. Will be called with 2 arguments: The level
    # @a putsCmd: and the text.

    variable cmd
    variable logLevels

    foreach level $logLevels {
	set cmd($level) $putsCmd
    }

    return
}



proc ::pool::syslog::defLevel {level putsCmd} {
    # @c Defines a command which will be executed for every message given to
    # @c the system and having the specified level.
    #
    # @a putsCmd: The script evaluated by <p ::pool::syslog::syslog> to log the
    # @a putsCmd: incoming messages. Will be called with 2 arguments: The level
    # @a putsCmd: and the text.
    #
    # @a level:   The level triggering the execution of <a putsCmd>.

    variable pfxMap
    variable cmd

    if {![info exists pfxMap($level)]} {
	error "::pool::syslog::defLevel: unknown message level \"$level\""
    }

    set level $pfxMap($level)

    set cmd($level) $putsCmd
    return
}



proc ::pool::syslog::Log2Stderr {level text} {
    # @c Standard log procedure, writes incoming message to stderr.
    #
    # @a level: Log level of message given.
    # @a text:  Message to log

    variable   pfxMap
    set level $pfxMap($level)

    puts  stderr "$level\t$text"
    flush stderr
    return
}



proc ::pool::syslog::setStderr {} {
    # @c Convenience procedure. Installs the standard log procedure
    # @c (<p ::pool::syslog::Log2Stderr>) for all levels.

    def ::pool::syslog::Log2Stderr
    return
}



proc ::pool::syslog::levels {} {
    # @r Returns a list containing the names of all log-levels known to the
    # @r system. The shortcuts are not returned.

    variable logLevels
    return  $logLevels
}



proc ::pool::syslog::syslog {level args} {
    # @c Entrypoint to the logger facility, to be used by libraries. The actual
    # @c log is done by a command defined via <p ::pool::syslog::def> or
    # @c <p ::pool::syslog::defLevel>.

    # @a level: Relative importance of the logged message. Should be one of the
    # @a level: strings returned by <p ::pool::syslog::levels>.
    #
    # @a args: list containing the texts to log.

    variable cmd
    variable pfxMap

    if {0} {
	if {"$level" == "error"} {
	    # catch errors early
	    ::puts [::pool::dump::callstack "logged error"]
	}
    }


    if {![info exists pfxMap($level)]} {
	error "::pool::syslog::syslog: unknown message level \"$level\""
    }

    set level $pfxMap($level)

    if {$cmd($level) == {}} {
	# no vector for level, skip 
	return
    }

    # Remove list artefacts from message, then jump through the vector.
    # Catch errors. Future: log such as errors. Far future: report errors
    # there to stderr, as a last resort.

    regsub -all {[\}\{]} $args {} args
    catch {
	uplevel #0 $cmd($level) [list $level] [list $args]
    }

    return
}



proc ::pool::syslog::logLevel {o v} {
    # @c Type checker procedure for 'getopt'. Accepts all levels known to this
    # @c module.
    #
    # @a o: The name of the option to check.
    # @a v: The value to check.

    # @r A boolean value. True if and only if <a v> is a level defined here.

    variable pfxMap
    return [info exists pfxMap($v)]
}



# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: atexit.tcl,v 1.6 1998/06/01 19:55:14 aku Exp $
#
# @c Specify scripts to evaluate just before terminating
# @c the application.  This provides a hook into exit processing.
# @s Hooking into exit
# @i atexit, exit hook, script termination


package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval atexit {
	variable version @base:mFullVersion@
	namespace export *

	# internal state of the subsystem. A list of scripts
	# to evaluate upon exit.

	variable atexitScripts {}
    }
}


proc ::pool::atexit::add {script} {
    # @c Remember the <a script> for evaluation upon exit.
    # @a script: code to evaluate upon exit.

    variable atexitScripts
    lappend  atexitScripts $script
    return
}


proc ::pool::atexit::do {} {
    # @c Execute all remembered scripts.

    variable atexitScripts

    foreach script $atexitScripts {
	uplevel #0 $script
    }
    return
}


# save builtin under different name (inside our namespace)
# then provide our implementation

rename exit ::pool::atexit::exit


proc exit {args} {
    # @c The new exit procedure: executes the scripts given via
    # @c <p ::pool::atexit::add>, then terminates the application.
    # @c The saved builtin 'exit' is used to accomplish this.
    # @a args:	Arguments propagated to the builtin.
    # @r as of the builtin

    ::pool::atexit::do
    uplevel ::pool::atexit::exit $args
}


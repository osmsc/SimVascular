# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -- Running tests -- 


proc tsRun {setupScript} {

    ifSetState run disabled

    interp create _t

    # -W- load definitions and required package into the interpreter.

    ifSplashText "Initializing interpreter"

    _t eval $setupScript

    ifSplashText "Reading test suite definitions"

    catch {_t eval source defs}

    # Remove all unwanted procedures

    foreach p {
	test print_verbose dotests
	splashDialog splashText
	splashRemove splashWait
    } {
	catch {_t eval rename $p {{}}}
    }

    _t eval {proc test {args} {uplevel #0 testExec $args}}
    _t alias testExec     testExecute
    _t alias splashDialog splashDialog
    _t alias splashText   splashText
    _t alias splashWait   splashWait
    _t alias splashRemove splashRemove

    foreach file [lsort [glob *.test]] {
	_t eval source $file
    }

    interp delete _t

    ifSetState run normal
    return
}


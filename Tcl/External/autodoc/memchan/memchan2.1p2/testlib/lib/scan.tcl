# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -- Test suite scan -- 

# Scan procedures

proc tsScan {setupScript} {

    interp create _t

    # -W- load definitions and required package into the interpreter.

    ifSplashText "Initializing interpreter"

    catch {_t eval $setupScript}

    ifSplashText "Reading test suite definitions"

    catch {_t eval source defs}

    # Remove all unwanted procedures

    foreach p {test print_verbose dotests splashDialog splashText} {
	catch {_t eval rename $p {{}}}
    }

    _t eval {proc test {args} {eval testDef $args}}
    _t alias testDef      testDef
    _t alias splashDialog splashDialog
    _t alias splashText   splashText

    foreach file [lsort [glob *.test]] {

	ifSplashText "Scanning file $file"

	_t eval source $file
    }

    interp delete _t
    return
}

proc testX {args} {}

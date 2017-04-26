# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -W- package accessor utilities -- 
# ---
# -W- They should go into a separate package,
# -W- for later distribution together with the
# -W- tcl core, like 'http' and 'opt'.


global _pkgTestSetupScript
set    _pkgTestSetupScript ***

proc pkgTestSetup {} {
    global tcl_platform _pkgTestSetupScript

    if {[string compare $_pkgTestSetupScript ***]} {
	return $_pkgTestSetupScript
    }

    # pwd = test dir
    # .. = top dir, setup script in platform dir, or top dir

    set sfile [file join .. $tcl_platform(platform) test.setup]

    if {[file exists $sfile]} {
	set _pkgTestSetupScript [read [set fh [open $sfile r]]]	
	close $fh
	return $_pkgTestSetupScript
    }

    set sfile [file join .. test.setup]

    if {[file exists $sfile]} {
	set _pkgTestSetupScript [read [set fh [open $sfile r]]]	
	close $fh
	return $_pkgTestSetupScript
    }

    error "unable to find script for global initialization of the test suite."
}


proc pkgMaintainer {} {
    # -W- Try to access the package description.
    return a.kupries@westend.com
    #return aku
    #return {}
}


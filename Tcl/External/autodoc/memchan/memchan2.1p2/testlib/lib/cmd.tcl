# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -- Commands -- 


proc cmdSetAllTo {use} {
    global testUse tests testNo

    foreach t $tests {
	if {[info exists testNo($t)]} {
	    set testUse($t) $use
	} else {
	    set testUse($t) 0
	}
    }

    return
}


proc cmdSet {use indices} {
    global testUse tests testNo

    foreach i $indices {
	set t $testNo(n,$i)
	set testUse($t) $use
    }

    return

}


proc cmdMailReport {} {
    eval global [info global test*] tcl_platform

    # Generate and show a report to be sent to the maintainer of the extension.

    set to [pkgMaintainer]

    if {$to == {}} {
	splashDialog {
	    My apologies, but I cannot generate the report
	    as I don't know to whom I should send it to.
	} Ok
	return
    }

    # Header information.
    # pwd          = test dir.
    # file dirname = top dir.
    # file tail    = extenson name + version

    set sep "==TG[clock seconds]X[clock clicks]FOO"

    set    mail ""
    append mail "From: [logName]@[info hostname]\n"
    append mail "MIME-Version: 1.0\n"
    append mail "To: $to\n"
    append mail "Cc: [logName]\n"
    append mail "X-TCL-TEST: test report, [file tail [file dirname [pwd]]], $tcl_platform(os)\n"
    append mail "Subject: Test report for [file tail [file dirname [pwd]]] on $tcl_platform(os)\n"
    append mail "Content-type: multipart/mixed;\n boundary=\"$sep\"\n"
    append mail "\n"

    append mail "This is a multi-part message in MIME format.\n"

    mimeStart
    append mail "Bugreport\n"
    append mail "Extension [file tail [file dirname [pwd]]]\n"
    append mail "Platform\n"
    append mail "\tOS        $tcl_platform(os) $tcl_platform(osVersion)\n"
    append mail "\tPlatform  $tcl_platform(platform)\n"
    append mail "\tMachine   $tcl_platform(machine)\n"
    append mail "\tByteOrder $tcl_platform(byteOrder)\n"

    # -W- I want more:
    # -W- Which cc ? Which libc ? `uname -a`
    # -W- Hm, unix/config*, unix/Makefile

    append mail "\n"

    # Listing of all tests and their status

    mimeStart
    append mail "Overview about all tests\n"
    append mail "\n"

    foreach t $tests {
	switch -- $testState($t) {
	    {}          {append mail "Never executed  | "}
	    skipped     {append mail "Skipped         | "}
	    ok          {append mail "* Ok *          | "}
	    failed      {append mail "****** FAILED * | "}
	    error       {append mail "******* ERROR * | "}
	    error-setup {append mail "* ERROR/SETUP * | "}
	    default     {append mail "U ($testState($t)) | "}
	}
	append mail "$t, $testDesc($t)\n"
    }

    # Detailed information about the failed tests.

    foreach t $tests {
	switch -- $testState($t) {
	    {}          -
	    skipped     -
	    ok          {# ignore the skipped and successful tests}
	    failed      -
	    error       -
	    error-setup {
		mimeStart
		testText $t xClearMail xAddMail xDoneMail
	    }
	    default     {# ignore tests with an unknown state}
	}
    }

    # Signature

    mimeStart
    append mail "--\n"
    append mail "Sincerely,\n\tthe Tester @ [clock format [clock seconds]]\n"

    mimeEnd

    ifMail $mail
    return
}


proc mimeStart {} {
    upvar mail mail sep sep

    append mail "--$sep\n"
    append mail "Content-Type: text/plain; charset=us-ascii\n"
    append mail "Content-Transfer-Encoding: 7bit\n"
    append mail "\n"
    return
}


proc mimeEnd {} {
    upvar mail mail sep sep
    append mail "$sep\n"
}


proc xClearMail {} {
    # ignore this call
    return
}


proc xDoneMail {} {
    # ignore this call
    return
}


proc xAddMail {text {tag {}}} {
    upvar 2 mail mail

    # ignore tag information. (maybe later (text/enriched))
    append mail $text
    return
}


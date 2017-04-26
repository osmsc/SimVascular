# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# == Mini database for the management of tests. ==
# == Is able to manage the tests of one suite, but not more ==
# == Change that if namespaces / OO is acceptable.

# Storage, list of defined tests.


catch {unset tests}
global tests
set    tests {}

# Storage, global arrays for the various parts of a test.

adef testDesc		; # Short description of the test
adef testRequires	; # Names of other tests whose execution is a
#                       ; # pre-requisite to a test.
adef testConstraints	; # Constraints to satisfy. Unsatisfied constraints
#                       ; # cause the system to skip the ... tests.
adef testScript		; # Script containing the test
adef testSetup		; # Script to setup prerequisites for the test
adef testCleanup	; # Script to cleanup the prerequisites after the test.
adef testExpect		; # Expected result of a test. Described by a 2-element
adef testNo             ; # Serial number of the test, index in listbox.
#                       ; # list. The first element defines the match
#                       ; # mechanism, the 2nd the pattern to match against.
#                       ; # Available mechanisms are 'exact', 'glob' and
#                       ; # 'regexp'

# Storage, volatile information about a test

adef testEnable		; # 0/1, used to enable/disable individual tests.
adef testState		; # String containing information about the last
#                       ; # execution of the test. Possible values are:
#                       ; # ok, failed, error, setup-error, skipped
adef testRes		; # Result from the last execution of the test.
adef testWin            ; # Widget associated to the test. Colored according to
#                       ; # the state.


# Accessor procedures.

proc testDef {name description args} {
    # Called during the scan of the testsuite, adds the specified test to
    # the internal datastructures.

    eval global [info global test*]

    if {[info exists testScript($name)]} {
	error $name $description: already defined.
    }


    if {[set len [llength $args]] == 1} {
	# new style definition (with requirements, cleanup and setup scriptcs).

	error $name, $description: cannot handle new style test definition yet

    } elseif {$len == 2} {
	# old style definition, no constraints
	# args = script result

	set testDesc($name)        $description
	set testRequires($name)    {}
	set testConstraints($name) {}
	set testScript($name)      [lindex $args 0]
	set testSetup($name)       {}
	set testCleanup($name)     {}
	set testExpect($name)      [list exact [lindex $args 1]]

	set testEnable($name)      1
	set testState($name)       {}
	set testRes($name)         {}
	set testWin($name)         {}

    } elseif {$len == 3} {
	# old style definition with constrains
	# args = constraints script result

	set testDesc($name)        $description
	set testRequires($name)    {}
	set testConstraints($name) [lindex $args 0]
	set testScript($name)      [lindex $args 1]
	set testSetup($name)       {}
	set testCleanup($name)     {}
	set testExpect($name)      [list exact [lindex $args 2]]

	set testEnable($name)      1
	set testState($name)       {}
	set testRes($name)         {}
	set testWin($name)         {}

    } else {
	error unknown test definition $name $description
    }

    lappend tests $name
    return
}



proc testColor {t} {
    # Converts the state of the specified test into a color.
    # Currently the conversion is hardcoded, that may change
    # in the future

    global testState

    switch -- $testState($t) {
	failed      {return red}
	error       {return yellow}
	setup-error {return blue}
	skipped     {return white}
	ok          -
	{}          {return lightsteelblue}
    }

    error "Unknown state of test $t: $testState($t)"
}



proc testDone {t state result} {

    # Writes the results of a run of the specified test
    # into the volatile arrays

    global testState testRes testWin

    set testState($t) $state
    set testRes($t)   $result

    if {[info exists testWin($t)] && ($testWin($t) != {})} {
	# Propagate the change to the user interface too.

	uiTestSetState $t $testWin($t) [testColor $t]
    }

    return
}



proc testStateText {state} {
    switch -- $state {
	{}          {return "Was never executed"}
	ok          {return "Sucessfully executed"}
	failed      {return "Failed"}
	error       {return "Uncatched error"}
	setup-error {return "Error during setup"}
	skipped     {return "Skipped"}
    }

    error "unknown state $state"
}



proc testStateTag {state} {
    switch -- $state {
	{}      {return strong}
	default {return $state}
    }

    error "unknown state $state"
}



proc testText {t clear add end} {
    # Generate a string from the test specification and place
    # it into the specified 'text'-Widget. Several tags are used
    # to mark parts of the information.

    eval global [info global test*]

    set desc        $testDesc($t)
    set requires    $testRequires($t)
    set constraints $testConstraints($t)
    set setup       $testSetup($t)
    set do          $testScript($t)
    set cleanup     $testCleanup($t)
    set result      $testRes($t)
    set expect      $testExpect($t)
    set state       $testState($t)

    set sep ----------
    set sep $sep$sep$sep

    # Create a string about the test from the available information.

    $clear

    $add "$t ($desc)" title
    $add "\n"
    $add [testStateText $state] [testStateTag $state]
    $add "\n"
    $add "$sep\n"

    if {$requires != {}} {
	$add "Requires:"     key
	$add "    $requires" value
	$add "\n"
    }

    if {$constraints != {}} {
	$add "Constraints:"  key
	$add " $constraints" value
	$add "\n"
    }

    if {$setup != {}} {
	$add "Setup:" key
	$add "\n"

	if {![string compare $state error-setup]} {
	    $add $setup $state
	} else {
	    $add $setup
	}

	$add "\n"
	$add "$sep\n"
    }

    $add "Script:" key
    $add "\n"

    if {![string compare $state error-setup]} {
	$add $do
    } else {
	$add $do $state
    }

    $add "\n"
    $add "$sep\n"

    if {$cleanup != {}} {
	$add "Cleanup:" key
	$add "\n"
	$add $cleanup
	$add "\n"
	$add "$sep\n"
    }

    foreach {etype evalue} $expect {break}

    $add "Expected ($etype):" key
    $add "\n"
    $add $evalue value
    $add "\n"
    $add "$sep\n"

    if {![string compare $state err]} {
	$add "Error:" failed
    } else {
	$add "Result:" key
    }

    $add "\n"
    $add $result value
    $add "\n"

    $end
    return
}



proc testExecute {t args} {
    eval global [info global test*]

    # All the other arguments are irrelevant, we know them already,
    # they are stored in the various data structures

    if {!$testUse($t)} {
	# Skip test by command from the user
	return
    }

    ifSee -highlight $t

    # Check constraints, if we have some
    
    if {![testConstraintsOk $testConstraints($t)]} {
	testDone $t skipped {}
	ifSee $t
	return
    }

    # Perform the test (setup, do, cleanup)

    if {$testSetup($t) != {}} {
	set fail [catch {_t eval $testSetup($t)} result]
	if {$fail} {
	    testDone $t setup-error $result
	    ifSee $t
	    return
	}
    }

    set fail [catch {_t eval $testScript($t)} result]
    
    if {$testCleanup($t) != {}} {
	catch {_t eval $testCleanup($t)} dummy
    }

    if {$fail} {
	testDone $t error $result
	ifSee $t
	return
    }

    # Compare the results

    foreach {etype evalue} $testExpect($t) {break}

    switch -- $etype {
	exact {
	    set ok [expr {[string compare $result $evalue] == 0}]
	}
	glob {
	    set ok [string match $evalue $result]
	}
	regexp {
	    set ok [regexp -- $evalue $result]
	}
    }

    if {!$ok} {
	testDone $t failed $result
    } else {
	testDone $t ok $result
    }

    ifSee $t
    return
}



proc testConstraintsOk {constraints} {
    # Taken from tcl 8.0.4 'defs'

    global testConfig

    set doTest 0
    if {[string match {*[$\[]*} $constraints] != 0} {
	# full expression, e.g. {$foo > [info tclversion]}

	catch {set doTest [uplevel #0 expr [list $constraints]]} msg
    } elseif {[regexp {[^.a-zA-Z0-9 ]+} $constraints] != 0} {
	# something like {a || b} should be turned into 
	# $testConfig(a) || $testConfig(b).
	
	regsub -all {[.a-zA-Z0-9]+} $constraints {$testConfig(&)} c
	catch {set doTest [eval expr $c]}
    } else {
	# just simple constraints such as {unixOnly fonts}.

	set doTest 1
	foreach constraint $constraints {
	    if {![info exists testConfig($constraint)]
	    || !$testConfig($constraint)} {
		set doTest 0
		break
	    }
	}
    }

    return $doTest
}



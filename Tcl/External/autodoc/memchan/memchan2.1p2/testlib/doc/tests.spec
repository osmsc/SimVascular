
Specification of internal and external interfaces for new-style testsuites
allowing the use of a graphical frontend to the test system.
==========================================================================

Files and directories
---------------------

*	The testsuite resides in the directory 'tests', an immediate
	subdirectory of the extension/package directory. It is a
	sibling to all platform specific directories.

*	Files having the extension '.test' contain the tests to execute.

*	The file 'defs' is optional. If existing, it has to contain the
	definitions of additional procedures required by the tests.

*	The file 'setup' is optional. If existing, it has to commands
	whose evaluation will do any global setup required by the tests.
	The commands in this file have access to the definitions from 'defs'.


Overview about operation
------------------------

*	The test system starts and initializes itself. The definition
	of the generally known procedures is part of this.

*	After that it searches for the optional files and reads them
	if they are present, first 'defs', then 'setup'.

*	The next step is the detection of all files making up the test
	suite (.test) and a pre-scan (source) of their contents to get
	the names and descriptions of the defined tests. The files are
	scanned (and later evaluated) in alphabetical order. It is the
	responsibility of the test suite maintainer to order the tests
	in the files in such a way that a test A requiring test B is
	executed after that one.

	During the above the graphical interface is already up and
	provides feeback about the progress of the scan.

*	The user interface is now ready for inputs from the user.
	One possible operation is to start the tests.

*	If that happens the test files are re-evaluated, this time
	with the full-fledged definitions for the test-procedures.

	The results of the executed tests are shown in a log window
	and saved in an array, for later peruse by the user interface.


Interfaces
----------

*	It is the responsibility of the 'make' system to load the
	library / package to test into the interpreter running the
	'test' system. This is so because that process is platform
	dependent.

	Problem: Developers might like to keep the tester open while
	working on a library and errors. This means that the library /
	package must be reloaded for proper testing. I currently
	have no solution to this.


'defs'
~~~~~~

*	'defs' is the first loaded file specific to the test suite. It
	has to define all helper procedures the tests will need. All
	of the definitions will go into the namespace '::defs'.

	The test system will not touch this namespace anymore
	afterward. This means that the new procedures are allowed to
	maintain their prviate state inside of it.

	Functionality provided by the 'test' system: None.

'setup'
~~~~~~~

*	'setup' is the 2nd file specific to the test suite loaded into
	the system. It is his responsibility to do any global
	initialization required for the tests in the suite. Part of
	that is the definition and initialization of all constraints
	used by it (the test suite).

	Functionality provided by the 'test' system:

		constraintDef <name> <value>
		All definitions from 'defs'.

*	'setup' may define the procedure 'gCleanup'. If that is done
	the system will call this procedure after the execution of all
	tests and expects it to perform any required global cleaning up.


.test files
~~~~~~~~~~~

*	These files contain the tests to execute.

	Functionality provided by the 'test' system:

		'test'			Main test definition procedure
		splash <args>		User interaction
		splash_remove		User interaction
		splash_and_wait <args>	User interaction
		bell			User interaction
		All definitions from 'defs'.

*	Constraints are used automatically and are not available to
	the test code itself.


Futures
=======

<>	Add edit and management facilities to the 'test' system, make it a
	full grown center for testing management.

<>	IMMEDIATE:	Write application for conversion of old-style suites
			to the new style.

		Alternative: Provide emulation modes.

<>	Allow testers to send a report via email.
	Need more information about the system for this
	(tcl_platform, maybe more).




old style
	test	<name> <description> <script> <result>

new style
	test	<name> <description> ?<constraints>? <script> <result>

gui style
	test <name> <description> {
		?constraints	<constraints>?
		?requires	<testnames>?
		?setup		<script>?
		do		<script>
		result		<args>		(general match mechanism)
		?cleanup	<script>?
	}








-	safety: wholly separate or sub-interpreter, namespaces ?

-	sourcing test files with different implementation of the test
	and interaction commands to gather information => get a list
	of possible tests. auto-remove/disable platform specific tests.

-	allow individual execution of tests (checkboxes)
	(might have to take dependencies into account too, see above)

-	conversion of old-style test-suites to new style, or define
	new test command in backward compatible way.

-	different levels of verbosity
	=> passed/failed vs. failed in detail vs. all in detail

-	use passed/failed information to deactivate the passed tests,
	good for iteration of testsuite while working on bugs and
	leaving the test gui open.

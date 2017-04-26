# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: oo.tcl,v 1.7 1999/02/20 18:06:39 aku Exp $
#
# @c This OO system is rooted in <xref Sam> work (SNTL, tkinspect)
# @c and was modified and enhanced by myself. The version here is
# @c a complete rewrite, taking advantage of the namespace features
# @c in tcl 8.x. No code of Sams work remained, all bugs found will
# @c be mine.

# -W- add support for read only options (set at creation time, then never again)
# -W- add support for mandatory options (must be set at creation time)
# -W- add support for redefinition of options or their parts.

package require Tcl 8.0


# Shortcut to the class definition command.
interp alias {} class {} ::pool::oo::support::class


namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval oo {
	variable version @base:mFullVersion@

	namespace eval class {
	    # This one will later contain the namespaces representing class
	    # definitions!
	}

	namespace eval support {
	    # Class compiler and object runtime library sit here.

	    # state information of class compiler
	    variable currentClass       ""
	    variable classCode          ""
	    variable superclasses       ""
	    variable initializationCode ""

	    variable instanceVariables;	::pool::array::def instanceVariables
	    variable classVariables;	::pool::array::def classVariables
	    variable options;		::pool::array::def options
	    variable optionAliases;	::pool::array::def optionAliases
	    variable methods;		::pool::array::def methods

	    # runtime support procedures, used by instance namespaces
	    namespace export            \
		    AfterCons delete cget config configure \
		    chainToSuper chainToDerived oinfo chain

	    # persistent compiler information (option processing of options)
	    variable optionSetup
	    ::pool::getopt::defOption optionSetup class
	    ::pool::getopt::defOption optionSetup action
	    ::pool::getopt::defOption optionSetup default
	    ::pool::getopt::defOption optionSetup type \
		    -t ::pool::getopt::nonempty -d ::pool::getopt::notype

	    ::pool::getopt::defShortcuts optionSetup
	    
	    # scripts to execute after the construction of an object.
	    variable afterCons ""
	}
    }
}



# ----------------------------------------------------------------
# class compiler, specification commands
# ----------------------------------------------------------------



proc ::pool::oo::support::class {name args} {
    # @c Main entrypoint of the OO system. Compiles the given class definition
    # @c into tcl code and interprets it afterward, thus installing the class
    # @c in the running interpreter. The 'gen_cls' application redefines this
    # @c procedure into a pure compiler and dumps its result into a file. This
    # @c precompilation should save time on startup.
    #
    # @a name: The name of the class to define.
    # @a args: The definition of the class. The last argument is always
    # @a args: interpreted as script containing member-, option- and method-
    # @a args: definitions. Before this a list of superclasses can be
    # @a args: specified. This list must start with a colon (:).

    eval [Compile $name $args]
    return
}



proc ::pool::oo::support::var {args} {
    # @c Declare a member variable of the current class. This procedure is
    # @c immediately accessible to the class specification, without the
    # @c namespace prefix.
    #
    # @a args: The variable specification. May start with '-array' to signal
    # @a args: that we are talking about an array. This is followed by the
    # @a args: name of the variable. At last an initial value can be given.
    # @a args: In case of an array this value has to be in a form understood
    # @a args: by 'array set'.

    # @n Methods of the class get immediate access to the defined member
    # @n variables (via upvar). In case of a class having options the array
    # @n variable 'opt' will be specified automatically by the system. It will
    # @n always contain the values associated to them.

    # args = -array NAME [{name value...}]
    #      |        NAME [value]

    variable instanceVariables
    variable currentClass

    # interpret arguments, ...

    set isArray 0

    if {"[lindex $args 0]" == "-array"} {
	::pool::list::shift args
	set isArray 1
    }

    set varName [::pool::list::shift args]
    set varInit [::pool::list::shift args]

    # ... then add the definition to the compiler state

    set instanceVariables($varName) \
	    [list $currentClass [list isArray $isArray initialValue $varInit]]
    return
}



proc ::pool::oo::support::classvar {args} {
    # @c Declare a class variable of the current class. This procedure is
    # @c immediately accessible to the class specification, without the
    # @c namespace prefix.
    #
    # @a args: The variable specification. May start with '-array' to signal
    # @a args: that we are talking about an array. This is followed by the
    # @a args: name of the variable. At last an initial value can be given.
    # @a args: In case of an array this value has to be in a form understood
    # @a args: by 'array set'.

    # @n Class variables and their values are stored as part of the namespace
    # @n describing the class. To avoid clashes with the internal variables
    # @n required by the runtime system the latter will start with an
    # @n underscore ('_') and userdefined variables are disallowed to do so.
    # @n &p
    # @n Methods of the class get immediate access to the defined class
    # @n variables (via upvar).

    # args = -array NAME {name value...}
    #      |        NAME value

    variable classVariables

    # interpret arguments, ...

    set isArray 0

    if {"[lindex $args 0]" == "-array"} {
	::pool::list::shift args
	set isArray 1
    }

    set varName [::pool::list::shift args]
    set varInit [::pool::list::shift args]

    # ... reject reserved words

    if {[string match _* $varName]} {
	error "variable identifiers starting with an underscore are reserved."
    }

    # ... then add an accepted definition to the compiler state

    set classVariables($varName) \
	    [list isArray $isArray initialValue $varInit]
    return
}



proc ::pool::oo::support::method {name arguments body} {
    # @c Declares a method of the current class. This procedure is immediately
    # @c accessible to the class specification, without the namespace prefix.
    # @c It has the same arguments as the builtin 'proc'.
    #
    # @a name:      The name of the new method.
    # @a arguments: List of formal arguments
    # @a body:      The script to execute upon calling the method.

    variable methods
    variable currentClass

    # Rename constructor/destructor methods, let the interface stay
    # compatible for old class definitions.

    #puts "compile method $name"

    if {![string compare $name $currentClass]} {
	set name constructor
    } elseif  {![string compare $name ~$currentClass]} {
	set name destructor
    }

    set      methods($name) [list $arguments $body]
    return
}


proc ::pool::oo::support::constructor {body} {
    # @c Declares the constructor of the current class.
    # @a body: The body of the constructor procedure.

    method constructor {} $body
}


proc ::pool::oo::support::destructor {body} {
    # @c Declares the destructor of the current class.
    # @a body: The body of the destructor procedure.

    method destructor {} $body
}


proc ::pool::oo::support::init {code} {
    # @c Declares global initialization code which will be copied verbatim
    # @c into the generated script. This procedure is immediately accessible
    # @c to the class specification, without the namespace prefix.
    #
    # @a code: The tcl code to copy into the translation.

    variable initializationCode
    set      initializationCode [string trim $code]
    return
}



proc ::pool::oo::support::option {name args} {
    # @c Declares an option of the current class. This procedure is immediately
    # @c accessible to the class specification, without the namespace prefix.
    #
    # @a name: The name of the new option, without starting '-'.

    # @a args: The description of the option, in the form of
    # @a args: <option,value>-pairs. Known parameters are -class, -action,
    # @a args: -default and -type.&p

    # @a args: '-class' defaults to the name of the option, with the first
    # @a args: character capitalized. The value is used as class specification
    # @a args: during access to the resource database via 'option get'.&p

    # @a args: '-action' is optional. If specified it is interpreted as the
    # @a args: name of the method to call after the option was changed via the
    # @a args: standard method 'configure'.&p

    # @a args: '-default' is optional, it defines the default value to use if
    # @a args: the option value was not specified during construction.&p

    # @a args: '-type' defaults to <p ::pool::getopt::notype>, it is
    # @a args: interpreted as the name of a procedure checking the legality
    # @a args: of a value given to the option. Please note, I said
    # @a args: 'procedure', *not* 'method'!

    variable optionSetup
    variable options
    variable currentClass

    # Initialize the target array, then process the argument list.

    ::pool::getopt::initValues optionSetup       optval
    ::pool::getopt::processOpt optionSetup $args optval

    # Force the correct default value for an undefined class name, as
    # specified in the argument description (see -class).

    if {$optval(-class) == {}} {
	set optval(-class) [::pool::string::cap $name]
    }

    # Store defining class as part of option definition, to get multiple
    # inheritance of classes having options right (will cause a redefinition
    # error otherwise)

    set options($name) [list $currentClass [array get optval]]
    return
}



proc ::pool::oo::support::alias {alias option} {
    # @c Declares an alias of an option of the current class. This procedure
    # @c is immediately accessible to the class specification, without the
    # @c namespace prefix.
    #
    # @a alias:  The name of the new alias, without starting '-'.
    # @a option: The name of the referenced option, without starting '-'.

    # Just remember the definition, the check will be done later, after all
    # options are known (see <p ::pool::oo::support::Check>).

    variable optionAliases
    set      optionAliases($alias) $option
    return
}



# ----------------------------------------------------------------
# internal compiler procedures
# ----------------------------------------------------------------



proc ::pool::oo::support::ResetCompiler {} {
    # @c Clears out the internal state of the compiler

    variable currentClass
    variable classCode
    variable superclasses
    variable initializationCode
    variable instanceVariables
    variable classVariables
    variable options
    variable optionAliases
    variable methods

    set currentClass       ""
    set classCode          ""
    set superclasses       ""
    set initializationCode ""

    ::pool::array::clear instanceVariables
    ::pool::array::clear classVariables
    ::pool::array::clear options
    ::pool::array::clear optionAliases
    ::pool::array::clear methods
    return
}



proc ::pool::oo::support::Compile {name args} {
    # @c The class compiler. Transforms the class definition into a tcl script.
    #
    # @a name: The name of the class to define.
    # @a args: The definition of the class. The last argument is always
    # @a args: interpreted as script containing member-, option- and method-
    # @a args: definitions. Before this a list of superclasses can be
    # @a args: specified. This list must start with a colon (:).
    #
    # @r A tcl script whose evaluation will install the class in the system.

    variable superclasses
    variable currentClass

    # args = : superclass... {spec}
    #      | {spec}

    ResetCompiler
    set currentClass $name

    set specification [::pool::list::pop args]

    if {"[lindex $args 0]" == ":"} {
	::pool::list::shift args
	set superclasses $args
    } else {
	set superclasses {}
    }

    # Parse specification...
    # ...and write the resulting tcl code.

    eval $specification
    Check
    Dump

    # Get and return compilation result, clean up the temporary space.

    variable    classCode
    set result $classCode

    ResetCompiler

    return  $result
}



proc ::pool::oo::support::Check {} {
    # @c Checks the specification just read in.

    variable optionAliases
    variable options
    variable currentClass
    variable instanceVariables

    # all defined aliases have to refer to defined options

    foreach oa [array names optionAliases] {
	set o $optionAliases($oa)
	if {! [::info exists options($o)]} {
	    error "$currentClass: alias $oa referencing unknown option $o"
	}
    }

    # The user must not define a member variable 'opt' if we have options.

    if {([array size options] > 0)
    &&  ([::info exists instanceVariables(opt)])} {
	error "cannot redefine system variable 'opt' as requested by the user"
    }

    return
}



proc ::pool::oo::support::Dump {} {
    # @c Write the read specification into a string.

    DumpHeader
    DumpInit
    DumpNamespaceDefinition
    DumpMethods
    DumpAutoload
    DumpRuntimeIntegration
    return
}



proc ::pool::oo::support::DumpHeader {} {
    # @c Write an explanatory header into the string containing the translated
    # @c class.

    variable currentClass

    Puts "# -*- tcl -*-"
    Puts "# Automatically generated from file '[::info script]'."
    Puts "# Date: [::pool::date::nowTime]"
    Puts "# -------------------------------"
    Puts "# ** Do NOT edit manually **"
    Puts "#"
    Puts "# ** Provided class       **     >> $currentClass <<"
    Puts "# -------------------------------"
    Puts ""
    Puts "package require Pool_Base" ;# -- for now -W-
    Puts ""
    Puts "# -------------------------------"
    return
}



proc ::pool::oo::support::DumpInit {} {
    # @c Write the specified global initialization code into the result
    # @c string, without changes.

    variable initializationCode

    if {$initializationCode != {}} {
	Puts "# Global initialization code"
	Puts "$initializationCode"
	Puts ""
    }

    return
}



proc ::pool::oo::support::DumpAutoload {} {
    # @c Write the information enabling this class to get access to its
    # @c superclasses by autoloading, and making it available for its own
    # @c autoloading too.

    variable currentClass
    variable superclasses

    # Create our own entrypoint for autoloader

    Puts "# Entrypoint for autoloader"
    Puts "proc ::pool::oo::class::${currentClass}::loadClass {} {}"
    Puts ""

    # force all superclasses into the memory, by calling their autoloader
    # entrypoints

    if {$superclasses != {}} {
	Puts "# Request information about all superclasses"
	foreach sc $superclasses {
	    Puts "::pool::oo::class::${sc}::loadClass"
	}
	Puts ""
    }

    return
}



proc ::pool::oo::support::DumpNamespaceDefinition {} {
    # @c Write the definition of the namespace describing the read class.

    variable currentClass
    variable superclasses
    variable instanceVariables
    variable classVariables
    variable options
    variable optionAliases
    variable methods

    # Namespace describing the class
    set classSpace [list ::pool::oo::class::$currentClass]

    set methodList [lsort [array names methods]]
    set cvList     [lsort [array names classVariables]]

    array set methodArray [array get methods]
    foreach key [array names methodArray] {
	set methodArray($key) .
    }

    # Start writing ...
    # The created namespace contains several variables used exclusively by
    # the runtime system. Their >documentation< is available, but of no
    # interest to people writing classes, at least if they don't want to do
    # something special.

    Puts "# Namespace describing the class"
    Puts "namespace eval $classSpace \{"
    Puts "    variable  _superclasses    [list $superclasses]"
    Puts "    variable  _scChainForward  [list $currentClass]"
    Puts "    variable  _scChainBackward [list $currentClass]"
    Puts "    variable  _classVariables  [list $cvList]"
    Puts "    variable  _methods         [list $methodList]"
    Puts ""

    PutsArray _variables     [array get instanceVariables]
    PutsArray _options       [array get options]
    PutsArray _optionAliases [array get optionAliases]
    PutsArray _methodTable   [array get methodArray]

    # Write command instantiating the class variables. A naming convention
    # (see ::pool::oo::support::classvar) enforced by the compiler avoids
    # nameclashes.

    if {[array size classVariables] > 0} {
	Puts "    # class variables"
	foreach cv [lsort [array names classVariables]] {
	    array set cvDef $classVariables($cv)

	    if {$cvDef(isArray)} {
		Puts "    variable  [list $cv]"
		Puts "    array set [list $cv] [list $cvDef(initialValue)]"
	    } else {
		Puts "    variable  [list $cv] [list $cvDef(initialValue)]"
	    }

	    unset cvDef
	}
	Puts ""
    }

    # Export all methods, for usage by derived classes and instances

    Puts "    # Export every method"
    Puts "    namespace export -clear *"
    Puts "\}"
    Puts ""
    Puts "# -------------------------------"
    return
}



proc ::pool::oo::support::DumpMethods {} {
    # @c Writes the declared methods into the translation. Modifies them to
    # @c call the runtime support to get access to instance and class
    # @c variables.

    variable currentClass
    variable methods
    variable options

    # Namespace describing the class
    set classSpace [list ::pool::oo::class::$currentClass]

    Puts ""
    Puts ""

    # Write the methods
    foreach m [lsort [array names methods]] {
	set arguments [lindex $methods($m) 0]
	set body      [lindex $methods($m) 1]

	set    newBody "\n    ::pool::oo::support::SetupVars"
	append newBody " [list $currentClass]\n"
	append newBody "    [string trim $body]\n"

	Puts "proc [list ${classSpace}::$m] {$arguments} {$newBody}"
	Puts ""
	Puts ""
	Puts ""
    }

    Puts "# -------------------------------"
    return
}



proc ::pool::oo::support::DumpRuntimeIntegration {} {
    # @c Write out the commands linking a sourced class to its superclasses,
    # @c allowing creation of instances, etc.

    variable currentClass
    variable superclasses
    variable options
    variable optionAliases

    # Postprocessing, setup information coming from the superclasses
    # => variables, options, methods, constructor/destructor sequencing

    if {$superclasses != {}} {
	Puts "# Integrate superclasses into definition"
	Puts "::pool::oo::support::FixReferences $currentClass"
	Puts ""
    } else { ;# elseif {[array size options] > 0} {}
	Puts "# Import standard methods, fix option processor definition (shortcuts)"
	Puts "::pool::oo::support::FixMethods $currentClass"
	Puts "::pool::oo::support::FixOptions $currentClass"
	Puts ""
    }

    # Create object instantiation procedure (actually an alias)

    set target "::pool::oo::support::New [list $currentClass]"

    Puts "# Create object instantiation procedure"
    Puts "interp alias {} [list $currentClass] {} $target"
    Puts ""
    Puts "# -------------------------------"
    return
}



proc ::pool::oo::support::Puts {args} {
    # @c The procedure used by all dump-procedures to write something into the
    # @c translation. Has the same interface as the builtin 'puts', but writes
    # @c into an internal string.
    #
    # @a args: Specification of the things to write, see the description of
    # @a args: the builtin 'puts' for more.

    variable classCode

    if {"[lindex $args 0]" == "-nonewline"} {
	append classCode [lindex $args 1]
    } else {
	append classCode "[lindex $args 0]\n"
    }

    return
}



proc ::pool::oo::support::PutsArray {varName data} {
    # @c Convenience procedure to write the contents of an array (even an
    # @c empty one) into the translation. Built upon
    # @c <p ::pool::oo::support::Puts>.
    #
    # @a varName: The name of the variable to create
    # @a data:    The contents of the array to write, usable for 'array set'.

    Puts "    variable  $varName"

    if {$data == {}} {
	Puts "    array set $varName {_ _}"
	Puts "    unset     ${varName}(_)"
    } else {
	Puts "    array set $varName  [list $data]"
    }

    Puts ""
    return
}



# ----------------------------------------------------------------
# runtime support
# ----------------------------------------------------------------



proc ::pool::oo::support::FixReferences {class} {
    # @c This procedure is called after setting up the namespace of a class and
    # @c the loading of all superclasses. It imports superclass definitions
    # @c (instance variables, options, option aliases) into the new class, thus
    # @c completing its installation. Additional operations:&p Determine order
    # @c of constructor/destructor sequences. This information will be used by
    # @c the chaining methods too (see <p ::pool::oo::support::chainToDerived>
    # @c and <p ::pool::oo::support::chainToSuper>).&p Import superclass
    # @c methods into the class, add the class names as prefix if necessary.&p
    # @c Convert the completed option information into a definition array
    # @c usable by the <f base/getopt.tcl> subsystem.
    #
    # @a class: The name of the class to complete.

    ImportVariables      $class
    ImportOptions        $class
    ImportOptionAliases  $class
    BuildSuperclassChain $class
    FixMethods           $class
    FixOptions           $class
    return
}




proc ::pool::oo::support::ImportVariables {class} {
    # @c Part of <p ::pool::oo::support::FixReferences>. Imports all instance
    # @c variables defined by all immediate superclasses into the given class.
    # @c Reports collisions as errors.
    #
    # @a class: The name of the class to complete.

    # Determine the namespace containing the class and its superclasses

    set classSpace   ::pool::oo::class::${class}
    set superclasses [set ${classSpace}::_superclasses]

    # Make the variable definitions available to us.

    upvar #0 ${classSpace}::_variables vars

    foreach sc $superclasses {
	# Make the variable definitions available to us, now for the current
	# superclass

	upvar #0 ::pool::oo::class::${sc}::_variables svars

	# Copy all definitions, but check for collisions before that.

	foreach v [array names svars] {
	    if {[::info exists vars($v)]} {
		if {[string compare \
			[lindex $vars($v) 0] [lindex $svars($v) 0]] == 0} {
		    # multiple inheritance of same variable
		    continue
		}
		error "$class: redefinition of superclass variable ${sc}::$v"
	    }
	    set vars($v) $svars($v)
	}
    }

    return
}



proc ::pool::oo::support::ImportOptions {class} {
    # @c Part of <p ::pool::oo::support::FixReferences>. Imports all options
    # @c defined by all immediate superclasses into the given class. Reports
    # @c collisions as errors.
    #
    # @a class: The name of the class to complete.

    # Determine the namespace containing the class and its superclasses

    set classSpace   ::pool::oo::class::${class}
    set superclasses [set ${classSpace}::_superclasses]

    # Make the option definitions available to us.

    upvar #0 ${classSpace}::_options opts

    foreach sc $superclasses {
	# Make the option definitions available to us, now for the current
	# superclass

	upvar #0 ::pool::oo::class::${sc}::_options sopts

	# Copy all definitions, but check for collisions before that.

	foreach o [array names sopts] {
	    if {[::info exists opts($o)]} {
		if {[string compare \
			[lindex $opts($o) 0] [lindex $sopts($o) 0]] == 0} {
		    # multiple inheritance of same option!
		    continue
		}

		error "$class: redefinition of option ${sc}::$o inherited from [lindex $sopts($o) 0]"
	    }
	    set opts($o) $sopts($o)
	}
    }

    return
}



proc ::pool::oo::support::ImportOptionAliases {class} {
    # @c Part of <p ::pool::oo::support::FixReferences>. Imports all option
    # @c aliases defined by all immediate superclasses into the given class.
    # @c Reports collisions as errors.
    #
    # @a class: The name of the class to complete.

    # Determine the namespace containing the class and its superclasses

    set classSpace   ::pool::oo::class::${class}
    set superclasses [set ${classSpace}::_superclasses]

    # Make the alias definitions available to us.

    upvar #0 ${classSpace}::_optionAliases optal

    foreach sc $superclasses {
	# Make the alias definitions available to us, now for the current
	# superclass

	upvar #0 ::pool::oo::class::${sc}::_optionAliases soptal

	# Copy all definitions, but check for collisions before that.

	foreach oa [array names soptal] {
	    if {[::info exists optal($oa)]} {
		error "$class: redefinition of superclass alias ${sc}::$oa"
	    }
	    set optal($oa) $soptal($oa)
	}
    }

    return
}



proc ::pool::oo::support::BuildSuperclassChain {class} {
    # @c Part of <p ::pool::oo::support::FixReferences>. Computes the order
    # @c used for calling the  constructors of the given class. This
    # @c information will be used by the chaining methods too.
    #
    # @a class: The name of the class to complete.

    set classSpace   ::pool::oo::class::${class}
    set superclasses [set ${classSpace}::_superclasses]
    set chain        ""

    # 1) if X is defined as 'class X : Y Z' the system will use the the
    #    following order to call the constructors:
    #
    #    * constructors of Y   \ Here we have recursion.
    #    * constructors of Z   / We order can be computed incrementally though!
    #    * constructor  of X
    #
    # 2) If a class W is inherited by X by multiple paths the constructor of W
    #    will be called only once. The system will choose the left most entry
    #    in the list of constructors to do that.

    # Take the superclass sequences in the specified order and combine them.
    # Remove duplicates after that to fulfill (2). At last add our own
    # constructor to the list and store the result in the class namespace.
    # Destructors are called in the reverse order.

    foreach sc $superclasses {
	eval lappend chain \
		[set ::pool::oo::class::${sc}::_scChainForward] [list $sc]
    }

    set     chain [::pool::list::uniq $chain]
    lappend chain $class

    set ${classSpace}::_scChainForward  $chain
    set ${classSpace}::_scChainBackward [::pool::list::reverse $chain]
    return
}



proc ::pool::oo::support::FixMethods {class} {
    # @c Part of <p ::pool::oo::support::FixReferences>. Imports all methods in
    # @c all superclasses (immediate and! indirect) into this class. Methods
    # @c already known to this class are imported nevertheless, but prefixed
    # @c with the name of the defining class.
    #
    # @a class: The name of the class to complete.

    set classSpace ::pool::oo::class::${class}

    # Make the method definitions available to us. The table is required as it
    # maps method names to a flag indicating wether the method is defined in
    # the class or imported from above. Only the first must be handled here.
    # The second set was imported already, due to our walking of the *complete*
    # chain!
    #
    # methodTable(m) = '.' => m is defined in the class.
    # methodTable(m) = sc  => m was imported from superclass sc.

    upvar #0 ${classSpace}::_methods     methods
    upvar #0 ${classSpace}::_methodTable methodTable

    # We have to check all superclasses, not only the immediate ones.

    set superclasses [set ${classSpace}::_scChainBackward]
    ::pool::list::shift superclasses

    foreach sc $superclasses {
	# Make the method definitions available to us, now the current
	# superclass.

	upvar #0 ::pool::oo::class::${sc}::_methods     smethods
	upvar #0 ::pool::oo::class::${sc}::_methodTable smethodTable

	regsub -all {::} $sc {@} scr ; # :: -> @ for prefixed form of superclassname

	# *Remark* If we have to import superclass methods with the name of
	# that superclass prefixed to avoid collisions with overiding definitions
	# we substitute the namespace separator :: against @ or we will get problems
	# to access this new command.

	foreach m $smethods {
	    if {"$smethodTable($m)" != "."} {
		# Skip over imported method, they were already handled
		continue
	    }

	    if {![::info exists methodTable($m)]} {
		# The method we are looking at is not defined in this class. We
		# import it under its own name *and* the prefixed form! The
		# latter makes implementation of the chaining methods easier as
		# it supresses special cases.

		namespace inscope $classSpace \
			namespace import ::pool::oo::class::${sc}::$m
		namespace inscope $classSpace ::rename $m ${scr}_${m}

		lappend methods     ${scr}_$m
		set     methodTable(${scr}_$m) $sc

		namespace inscope $classSpace \
			namespace import ::pool::oo::class::${sc}::$m

		lappend methods     $m
		set     methodTable($m) $sc
	    } else {
		# The method we are looking at is defined in this class. We
		# import it in their prefixed form. We have to be careful not
		# to destroy the original definition during this. The problem
		# is that a command can be imported into a namespace only under
		# its own name, not a different one. Renaming a command after
		# its import is possible though.

		namespace inscope $classSpace ::rename $m save@${m}
		namespace inscope $classSpace \
			namespace import ::pool::oo::class::${sc}::$m
		namespace inscope $classSpace ::rename $m ${scr}_${m}
		namespace inscope $classSpace ::rename save@${m} $m

		lappend methods     ${scr}_$m
		set     methodTable(${scr}_$m) $sc
	    }
	}
    }

    # Import the standard methods into the class namespace to have them
    # immediately available, with an object prefix ($this)

    namespace inscope $classSpace namespace import ::pool::oo::support::delete
    namespace inscope $classSpace namespace import ::pool::oo::support::chainToSuper
    namespace inscope $classSpace namespace import ::pool::oo::support::chainToDerived
    namespace inscope $classSpace namespace import ::pool::oo::support::chain
    namespace inscope $classSpace namespace import ::pool::oo::support::AfterCons
    namespace inscope $classSpace namespace import ::pool::oo::support::oinfo

    if {[array size ${classSpace}::_options] > 0} {
	namespace inscope $classSpace namespace import ::pool::oo::support::cget
	namespace inscope $classSpace namespace import ::pool::oo::support::configure
	namespace inscope $classSpace namespace import ::pool::oo::support::config
    }

    return
}



proc ::pool::oo::support::FixOptions {class} {
    # @c Part of <p ::pool::oo::support::FixReferences>. Assumes that the
    # @c option and alias definitions are complete. Converts them into an array
    # @c usable by the 'getopt' subsystem. Information used during construction
    # @c and 'configure' is stored in an easier accessible way too.
    #
    # @a class: The name of the class to complete.

    set classSpace ::pool::oo::class::${class}

    # Compute derived information for options
    # 1) shuffle information for easier access of its parts.
    # 2) definition array for ::pool::getopt::processOpt

    upvar #0 ${classSpace}::_options       opts
    upvar #0 ${classSpace}::_optionAliases optAliases

    if {[array size opts] > 0} {

	namespace inscope $classSpace variable _optInfo
	namespace inscope $classSpace variable _optDef

	upvar #0 ${classSpace}::_optInfo  oInfo
	upvar #0 ${classSpace}::_optDef   oDef

	foreach o [array names opts] {
	    array set oDef [lindex $opts($o) 1]
	    set oInfo($o,default) $oDef(-default)
	    set oInfo($o,class)   $oDef(-class)
	    set oInfo($o,action)  $oDef(-action)

	    ::pool::getopt::defOption oDef $o -t $oDef(-type) -d $oDef(-default)
	}

	foreach oa [array names optAliases] {
	    ::pool::getopt::defAlias oDef $oa $optAliases($oa)
	}

	# The oo system automatically provides all classes having options with
	# a name completion feature by defining all unique shorter option names
	# as aliases for their complete options.
	#
	# f.e. -dir automatically gets the aliases -di and -d (if not in
	# conflict with other options).

	::pool::getopt::defShortcuts oDef
    }

    return
}



proc ::pool::oo::support::SetupVars {class} {
    # @c This procedure is called by *all* methods of class as their first
    # @c command to get immediate access to the instance and class variables of
    # @c the class.
    #
    # @a class: The name of the class the method was defined by. Only its
    # @a class: instance and class variables are made accessible to the method.
    # @a class: Because of this a superclass method has no immediate access to
    # @a class: the instance variables of its derived classes.

    set oSpace     [GetObject -2]
    set classSpace ::pool::oo::class::$class

    # The 'uplevel upvar' combination should be explained.
    #
    # Executing 'upvar #0 ${classSpace}::$cv $cv' would make the variable
    # available, but to this procedure, 'SetupVars', and not the calling
    # method, the desired effect. Prepending the command with uplevel causes
    # its execution in the calling method, thus importing the variable into
    # its context. $classSpace, $cv, etc. don't appear as variables, but are
    # already expanded by us at that time.

    # class variables.

    foreach cv [set ${classSpace}::_classVariables] {
	uplevel upvar #0 ${classSpace}::$cv $cv
    }

    # instance variables

    foreach v [array names ${classSpace}::_variables] {
	uplevel upvar #0 ${oSpace}::$v $v
    }


    # The special instance array containing the current option values.

    if {[array size ${classSpace}::_options] > 0} {
	uplevel upvar #0 ${oSpace}::opt opt
    }

    # And now let the special variable 'this' refer to the calling object.

    uplevel set this [string trimleft $oSpace :]
    return
}

proc ::pool::oo::support::chain {method args} {
    # @c Standard method of all objects. Calls the nearest definition of
    # @c <a method> in one of the superclasses of the object. The search
    # @c follows the same order used to call destructors (the class, then
    # @c the superclasses).
    #
    # @a method: The name of the method to call.
    # @a args:   The arguments to give to the method in the calls.

    set oSpace     [GetObject -1]
    set class      [set ${oSpace}::_className]
    set classSpace ::pool::oo::class::$class

    #puts "chain: oSpace = $oSpace"
    #puts "chain: class  = $class"
    #puts "chain: cSpace = $classSpace"

    # Different behaviour if this a chain to the same method currently in
    # chaining or a different one.

    upvar #0 ${oSpace}::_chains _chains

    upvar #0 ${classSpace}::_methodTable mt
    set chain [set ${classSpace}::_scChainBackward]

    set skipto $class
    set unsetSkip 1
    if {[info exists _chains($method)]} {
	set skipto $_chains($method)
	set unsetSkip 0
    }

    #puts "chain: skipto = $skipto"

    # Skip the method in this level and everything we have already
    # used during chaining, walk through the sc chain
    # to the superclasses and call the first method found.

    while {1} {
	set c [::pool::list::shift chain]
	if {("$c" == "$skipto") || ([llength $chain] == 0)} {
	    break
	}
    }

    #puts "chain: chain = $chain"

    if {$mt($method) != "."} {
	# The called method was imported, pop off all classes in the chain
	# until the named one is reached (and removed too). Only the chain
	# after that is of relevance.

	while {1} {
	    set c [::pool::list::shift chain]
	    if {("$c" == "$mt($method)") || ([llength $chain] == 0)} {
		break
	    }
	}
    }

    #puts "chain: chain = $chain"

    if {[llength $chain] == 0} {
	# Ignore calls with nothing to chain to.
	return
    }

    # Prepare call to the next level up in the chain.

    set c [lindex $chain 0]
    regsub -all {::} $c {@} cr

    #puts "chain: call $c / $method => ${cr}_$method"

    if {[::info exists mt(${cr}_$method)]} {

	set _chains($method) $c
	set fail [catch {eval ${oSpace}::${cr}_$method $args} res]

	if {$unsetSkip} {
	    unset _chains($method)
	} else {
	    set _chains($method) $skipto
	}

	switch -- $fail {
	    0 {}
	    1 {
		global errorInfo errorCode
		return  -code      error \
			-errorinfo $errorInfo \
			-errorcode $errorCode $res}
	    2 {
		return -code return $res
	    }
	    3 {
		return {}
	    }
	    4 {}
	    default {
		return -code $fail
	    }
	}
    }

    return
}


proc ::pool::oo::support::GetObject {n} {
    # @c Determines the name of the object calling a particular method.
    # @c 'namespace current' is of no help here as all methods are imported
    # @c into the object namespace. They execute in their defining namespace,
    # @c and not the object. Because of this we are forced to look at the call
    # @c stack ('info level') and the method names used there.
    #
    # @a n: The relative stack level to start with (must be negative). Usually
    # @a n: -1 (for the standard methods), -1 in special cases (SetupVars).


    # 'info level $n' gives us the complete string used to call the method. It
    # is a list whose first element contains the method name (and the calling
    # namespace!), followed by the method arguments (which we are not
    # interested in).
    #
    # After the removal of leading colons and splitting the method name at
    # these we get a list containing the calling namespace and the real method
    # name, the latter is irrelevant to us. Sorry, but that is not all, life
    # is made a bit more complicated by a special case: Inside a method of an
    # object we are allowed to call other methods using only their name,
    # without a leading namespace. This is easy to detect, our list will just
    # contain one element. In that case we have to walk up the stack until we
    # find a method with a namespace before its name. That is then the object
    # we searched for.

    while {1} {
	set methodName \
		[split [string trimleft [lindex [::info level $n] 0] :] :]

	if {[llength $methodName] < 2} {
	    incr n -1
	    continue
	}

	#puts "GetObject $n $methodName"

	# Feb 14, 1999 / ak / Fixed problem with objects in namespaces.
	#
	# Not the first element is the object space, but everything in
	# the list except the last two elements (which are method name
	# and namespace/method separator).
	
	return [join ::[lreplace [lreplace $methodName end end] end end] :]
    }

    # We will not come here.
}



proc ::pool::oo::support::New {class object args} {
    # @c Runtime support for creating instances of a class. The system will
    # @c create an alias x for each class x resolving into 'New x'.
    #
    # @a class:  The name of the class the instance shall be created for.
    # @a class:  Automatically supplied to the procedure by the instance
    # @a class:  constructor alias.
    # @a object: The name of the new object.
    # @a args:   Initial object configuration, as <option,value>-pairs.
    #
    # @r The name of the object, = <a object>.

    variable afterCons

    set oSpace ::${object}
    set classSpace ::pool::oo::class::${class}

    # Create the namespace representing the object, then add and initialize all
    # instance variables.

    namespace eval $oSpace [list variable _className $class] ; # backref to class of object.
    namespace eval $oSpace [list variable _chains]           ; # state of 'support::chain'
    namespace eval $oSpace [list set      _chains(_) .]      ; # s.a.
    namespace eval $oSpace [list unset    _chains(_)]        ; # s.a.

    upvar #0 ${classSpace}::_variables vars

    foreach v [array names vars] {
	array set vDef [lindex $vars($v) 1]

	if {$vDef(isArray)} {
	    namespace inscope $oSpace variable  $v

	    if { $vDef(initialValue) == {}} {
		namespace inscope $oSpace array set $v [list _ _]
		namespace inscope $oSpace unset ${v}(_)
	    } else {
		namespace inscope $oSpace array set $v $vDef(initialValue)
	    }
	} else {
	    namespace inscope $oSpace variable $v $vDef(initialValue)
	}
    }

    # Import methods (user and standard ones)

    #puts oSpace=$oSpace/importing.command

    namespace inscope $oSpace namespace import ::pool::oo::class::${class}::*

    # already imported, via the class itself !!
    #namespace inscope $oSpace namespace import ::pool::oo::support::delete
    #namespace inscope $oSpace namespace import ::pool::oo::support::chainToSuper
    #namespace inscope $oSpace namespace import ::pool::oo::support::chainToDerived
    #namespace inscope $oSpace namespace import ::pool::oo::support::AfterCons

    # Handle options, if we have some (standard methods, 'opt' instance
    # variable and its initialization).

    upvar #0 ${classSpace}::_options opt
    upvar #0 ${classSpace}::_optDef  oDef
    upvar #0 ${classSpace}::_optInfo oInfo

    if {[array size opt] > 0} {
	# already imported, via the class itself !!
	#namespace inscope $oSpace namespace import ::pool::oo::support::cget
	#namespace inscope $oSpace namespace import ::pool::oo::support::configure
	#namespace inscope $oSpace namespace import ::pool::oo::support::config

	namespace inscope $oSpace variable opt
	SetupOptions      $oSpace object oDef oInfo [array names opt] $args
    } elseif {[string compare $args ""] != 0} {
	# The user tried to configure an object without options!
	error "$object: cannot configure object without options"
    }

    # Now walk the chain of superclasses and call all the defined constructors.
    # Execute the collected 'afterCons' scripts, if there are any.
    # See method '::pool::oo::support::AfterCons' too.

    upvar #0 ${classSpace}::_methodTable mTable
    set afterConsSave $afterCons
    set afterCons     {}

    #puts "chain/forward=[set ${classSpace}::_scChainForward]"

    foreach c [set ${classSpace}::_scChainForward] {
	if {![string compare $class $c]} {
	    if {
		[::info exists mTable(constructor)] &&
		("." == "$mTable(constructor)")
	    } {
		#puts "calling ${oSpace}::constructor"
		${oSpace}::constructor
	    }
	} else {
	    regsub -all {::} $c {@} cr
	    if {[::info exists mTable(${cr}_constructor)]} {
		#puts "calling ${oSpace}::${cr}_constructor"
		${oSpace}::${cr}_constructor
	    }
	}
    }

    foreach script $afterCons {
	eval $script
    }

    set afterCons $afterConsSave


    # create a dispatcher procedure for access via subcommand style
    proc ::${object} {m args} "uplevel 1 ${object}::\$m \$args"

    # At last return the name of the newly constructed object.

    return $object
}



proc ::pool::oo::support::SetupOptions {
    oSpace object optDef optInfo legalopts arglist
} {
    # @c Called during object construction to initialize the options of the new
    # @c object. Does it in three steps: The initial configuration is processed
    # @c first, then the resource database queried for the missing parts (only
    # @c if Tk present), then the defaults given in the class specification for
    # @c anything yet missing.
    #
    # @a oSpace:    The namespace representing the new object.
    # @a object:    The name of the new object.
    # @a optDef:    The name of the array containing the option definitions
    # @a optDef:    usable by the 'getopt'-system.
    # @a optInfo:   The name of the array containing information to use during
    # @a optInfo:   access to the resource database.
    # @a legalopts: A list containing the names of all options defined fro the
    # @a legalopts: class.
    # @a arglist:   A list of <option,value>-pairs. Contains the initial
    # @a arglist:   configuration given by the object creator.

    upvar $optDef  oDef
    upvar $optInfo oInfo
    upvar #0 ${oSpace}::opt opt

    # Step i, process the initial configuration.

    ::pool::getopt::processOpt oDef $arglist opt

    if {[string match *Tk* [::info loaded]]} {
	# Step ii, query the resource database, but only if Tk is active.
	# Illegal values are ignored, and the system will fall back to the
	# hardwired defaults to maintain usability.
	#
	# -W- log illegal values in resource via 'syslog'-system ?

	foreach o $legalopts {
	    if {! [::info exists opt(-$o)]} {
		if {![catch {
		    set value [::option get $object $o $oInfo($o,class)]
		}]} {
		    if {($value != {}) && [$oInfo($o,type) $o $value]} {
			set opt(-$o) $value
		    }
		}
	    }
	}
    }

    # Step iii, fill in in the hardwired defaults for anything yet missing.

    foreach o $legalopts {
	if {! [::info exists opt(-$o)]} {
	    set opt(-$o) $oInfo($o,default)
	}
    }

    return
}



proc ::pool::oo::support::AfterCons {script} {
    # @c Special procedure. Allows constructors the registration of code which
    # @c will be executed after completion of object initialization. This
    # @c allows f.e. the redefinition of a value in an instance variable by a
    # @c derived class and yet have the superclass react to the changed value.
    # @c The megawidget base class (<c widget>) uses this feature.
    #
    # @a script: The tcl code to execute after object initialization.

    variable afterCons
    lappend  afterCons $script
    return
}



# ----------------------------------------------------------------
# runtime support, standard methods
# ----------------------------------------------------------------


proc ::pool::oo::support::delete {} {
    # @c Standard method of all objects. Destroys the object invoking it.

    set oSpace     [GetObject -1]
    set class      [set ${oSpace}::_className]
    set classSpace ::pool::oo::class::$class

    # The internal instance variable '_className' is used as flag too. The
    # empty string signals that the object is already in the process of
    # destruction. This cuts off a possible recursive invokation.

    if {$class == {}} {
	# already in destruction
	return
    }

    set ${oSpace}::_className {}

    # Walk the chain of superclasses in reverse order and call all the defined
    # destructors.

    upvar #0 ${classSpace}::_methodTable mTable

    foreach c [set ${classSpace}::_scChainBackward] {
	if {![string compare $class $c]} {
	    if {
		[::info exists mTable(destructor)] &&
		("." == "$mTable(destructor)")
	    } {
		#puts "calling ${oSpace}::destructor"
		${oSpace}::destructor
	    }
	} else {
	    regsub -all {::} $c {@} cr
	    if {[::info exists mTable(${cr}_destructor)]} {
		#puts "calling ${oSpace}::${cr}_destructor"
		${oSpace}::${cr}_destructor
	    }
	}
    }

    # At last destroy the namespace containing the instance
    # Don't forget the dispatcher command

    namespace delete $oSpace
    catch {rename $oSpace {}}
    return
}



proc ::pool::oo::support::cget {option} {
    # @c Standard method of all objects. Retrieves the current value of the
    # @c specified <a option>.
    #
    # @a option: The name of the option to retrieve.
    #
    # @r The current value of the option.

    if {![string match -* $option]} {
	error "unknown option: $option"
    }

    set option [string trimleft $option -]

    set oSpace [GetObject -1]
    set class  [set ${oSpace}::_className]
    set classSpace ::pool::oo::class::$class

    upvar #0 ${classSpace}::_options       optionTable
    upvar #0 ${classSpace}::_optionAliases aliasTable

    # Map an alias to its option before acessing the 'opt' array containing
    # the per-instance option values.

    if {[::info exists aliasTable($option)]} {
	set option $aliasTable($option)
    }

    if {! [::info exists optionTable($option)]} {
	error "unknown option: -$option"
    }

    upvar #0 ${oSpace}::opt optValue

    return $optValue(-$option)
}



proc ::pool::oo::support::config {args} {
    # @c A shorthand for <p ::pool::oo::support::config>.
    # @a args: See <p ::pool::oo::support::config>.

    return [eval configure $args]
}



proc ::pool::oo::support::configure {args} {
    # @c Standard method of all objects. Used to retrieve and manipulate the
    # @c values of the options associated to the object. Three forms of calling
    # @c this method are allowed.&p Without arguments the system will retrieve
    # @c the values of *all* options and return them in a list suitable for
    # @c 'array set', with the option names as keys.&p A single argument will
    # @c be interpreted as the name of an option and its value will be
    # @c retrieved. In this mode the functionality is equal to
    # @c <p ::pool::oo::support::cget>.&p The last mode is invoked by calling
    # @c the method with an even number of argument, these will be interpreted
    # @c as pairs of options and their values. The system will reconfigure the
    # @c object according to the really changed options and their associated
    # @c action methos, but only if all specified values are legal.
    #
    # @a args: See desscription.
    # @r See description.

    set oSpace [GetObject -1]

    #puts "oSpace=$oSpace"

    set class  [set ${oSpace}::_className]
    set classSpace ::pool::oo::class::$class

    if {$args == {}} {
	# Retrieve data of *all* options known to this object
	# Aliases are ignored!

	upvar #0 ${classSpace}::_options optionTable
	upvar #0 ${oSpace}::opt          optValue

	set result ""
	foreach o [array names optionTable] {
	    array set oDef [lindex $optionTable($o) 1]
	    lappend result [list -$o $o $oDef(-class) $oDef(-default) $optValue(-$o)]
	}

	return $result
    }

    if {[llength $args] == 1} {
	# Retrieve data of specified option
	# ('cget' will resolve a possible alias)

	return [${oSpace}::cget [lindex $args 0]]
    }

    # User specified options and corresponding values.
    # Parse them, then check and use them, at last, let
    # the instance react to the changes.
    # The parser stage will resolve any aliases too.

    upvar #0 ${classSpace}::_options optionTable
    upvar #0 ${classSpace}::_optDef  optDef
    upvar #0 ${oSpace}::opt          optValue

    array set optvalues [array get optValue]
    ::pool::getopt::processOpt optDef $args optvalues

    # Remove all options and their values which were specified
    # yet did not change. Save the old values of changed options
    # in a separate location, for usage by the action later.

    ::pool::array::def oldvalues

    foreach o [array names optvalues] {
	if {"$optvalues($o)" != "$optValue($o)"} {
	    set oldvalues($o) $optValue($o)
	    set optValue($o)  $optvalues($o)
	}
	unset optvalues($o)
    }

    # Execute all actions associated to the changed options.
    # No order can be assumed (array!).

    foreach o [array names oldvalues] {
	array set oDef [lindex $optionTable([string trimleft $o -]) 1]
	if {$oDef(-action) != {}} {
	    ${oSpace}::$oDef(-action) $o $oldvalues($o)
	}
	unset oDef
    }

    return
}



proc ::pool::oo::support::chainToSuper {method args} {
    # @c Standard method of all objects. Calls not only the specified
    # @c <a method>, but all its definitions in superclasses as well. Follows
    # @c the same order used to call destructors (the class, then the
    # @c superclasses).
    #
    # @a method: The name of the method to call.
    # @a args:   The arguments to give to the method in all calls.

    set oSpace     [GetObject -1]
    set class      [set ${oSpace}::_className]
    set classSpace ::pool::oo::class::$class

    upvar #0 ${classSpace}::_methodTable mt
    set chain [set ${classSpace}::_scChainBackward]

    # Call the method in this level first, then walk through the sc chain
    # to the superclasses and call their methods too.

    eval ${oSpace}::$method $args
    ::pool::list::shift chain

    if {$mt($method) != "."} {
	# The called method was imported, pop off all classes in the chain
	# until the named one is reached (and removed too). Only the chain
	# after that is of relevance.

	while {1} {
	    set c [::pool::list::shift chain]
	    if {("$c" == "$mt($method)") || ([llength $chain] == 0)} {
		break
	    }
	}
    }

    foreach c $chain {
	regsub -all {::} $c {@} cr
	if {[::info exists mt(${cr}_$method)]} {
	    eval ${oSpace}::${cr}_$method $args
	}
    }

    return
}



proc ::pool::oo::support::chainToDerived {method args} {
    # @c Standard method of all objects. Calls not only the specified
    # @c <a method>, but all its definitions in superclasses as well. Follows
    # @c the same order used to call constructors (the superclasses, then the
    # @c class).
    #
    # @a method: The name of the method to call.
    # @a args:   The arguments to give to the method in all calls.

    set oSpace     [GetObject -1]
    set class      [set ${oSpace}::_className]
    set classSpace ::pool::oo::class::$class

    upvar #0 ${classSpace}::_methodTable mt
    set chain [set ${classSpace}::_scChainForward]

    # Call method in this level at last, walk through the sc chain
    # from the superclasses and call their methods beforehand.

    ::pool::list::pop chain

    if {$mt($method) != "."} {
	# The called method was imported, pop off all classes in the chain
	# until the named one is reached (and removed too). Only the chain
	# after that is of relevance.

	while {1} {
	    set c [::pool::list::pop chain]
	    if {("$c" == "$mt($method)") || ([llength $chain] == 0)} {
		break
	    }
	}
    }

    foreach c $chain {
	regsub -all {::} $c {@} cr
	if {[::info exists mt(${cr}_$method)]} {
	    eval ${oSpace}::${cr}_$method $args
	}
    }

    eval ${oSpace}::$method $args
    return
}



proc ::pool::oo::support::oinfo {what args} {
    # @c Standard method of all objects. Allows retrieval of various meta
    # @c information about the object and its class.
    #
    # @a what: The name of the subcommand to execute. Specifies the
    # @a what: information requested by the user.
    # @a args: Information dependent additional selector data.
    #
    # @r a string containing the requested information.

    set oSpace [GetObject -1]
    set class  [set ${oSpace}::_className]
    set cSpace ::pool::oo::class::${class}

    switch -- $what {
	class {
	    return $class
	}

	superclasses {
	    return [set ${cSpace}::_superclasses]
	}

	methods {
	    return [set ${cSpace}::_methods]
	}

	variables {
	    return [lsort [array names ${cSpace}::_variables]]
	}

	variable {
	    set varname [lindex $args 0]
	    upvar ${cSpace}::_variables vtable
	    return $vtable($varname)
	}

	options {
	    return [lsort [array names ${cSpace}::_options]]
	}

	option {
	    set optname [lindex $args 0]
	    upvar ${cSpace}::_options otable
	    return $otable($optname)
	}

	default {}
    }

    error "$oSpace oinfo: unknown subcommand '$what'"
}


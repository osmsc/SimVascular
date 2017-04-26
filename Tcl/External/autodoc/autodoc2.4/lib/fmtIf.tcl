# -*- tcl -*-
# Automatically generated from file 'fmtIf.cls'.
# Date: Thu Sep 07 18:20:48 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> formatterInterface <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::formatterInterface {
    variable  _superclasses    {}
    variable  _scChainForward  formatterInterface
    variable  _scChainBackward formatterInterface
    variable  _classVariables  {}
    variable  _methods         {Fmt TrackFormatter constructor}

    variable  _variables
    array set _variables  {fmt {formatterInterface {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {formatter {formatterInterface {-default {} -type ::pool::getopt::notype -action TrackFormatter -class Formatter}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackFormatter . constructor . Fmt .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::formatterInterface::Fmt {args} {
    ::pool::oo::support::SetupVars formatterInterface
    # @c Method for accessing the formatter functionality. Added because I
	# @c like '$fmt do_something ...' better than '$fmt do_something ...'.
	#
	# @a args: The arguments given to the formatter.

	return [uplevel [list $fmt $args]]
}



proc ::pool::oo::class::formatterInterface::TrackFormatter {o oldValue} {
    ::pool::oo::support::SetupVars formatterInterface
    # @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o formatter>. Propagates the new value to
	# @c the internal shadow.
	#
	# @a o: The name of the changed option, here always [strong -formatter].
	# @a oldValue: The value of the option before the change. Ignored here.

	set fmt $opt(-formatter)
	return
}



proc ::pool::oo::class::formatterInterface::constructor {} {
    ::pool::oo::support::SetupVars formatterInterface
    # @c Constructor, initializes the option and its shadow.

	${this}::TrackFormatter -formatter {}
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::formatterInterface::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods formatterInterface
::pool::oo::support::FixOptions formatterInterface

# Create object instantiation procedure
interp alias {} formatterInterface {} ::pool::oo::support::New formatterInterface

# -------------------------------


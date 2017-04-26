# -*- tcl -*-
# Automatically generated from file 'distInterface.cls'.
# Date: Thu Sep 07 18:20:48 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> distInterface <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::distInterface {
    variable  _superclasses    {}
    variable  _scChainForward  distInterface
    variable  _scChainBackward distInterface
    variable  _classVariables  {}
    variable  _methods         {Dist TrackDist constructor}

    variable  _variables
    array set _variables  {dist {distInterface {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {dist {distInterface {-default {} -type ::pool::getopt::notype -action TrackDist -class Dist}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {Dist . TrackDist . constructor .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::distInterface::Dist {args} {
    ::pool::oo::support::SetupVars distInterface
    # @c Method for accessing the functionality of the distribution object.
	# @c Added because I like '$dist do_something ...' better than
	# @c '$dist do_something ...' or '$opt(-dist) do_something'.
	#
	# @a args: The arguments given to the distribution object

	return [uplevel [list $dist $args]]
}



proc ::pool::oo::class::distInterface::TrackDist {o oldValue} {
    ::pool::oo::support::SetupVars distInterface
    # @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o dist>. Propagates the new value to
	# @c the internal shadow.
	#
	# @a o: The name of the changed option, here always [strong -dist].
	# @a oldValue: The value of the option before the change. Ignored here.

	set dist $opt(-dist)
	return
}



proc ::pool::oo::class::distInterface::constructor {} {
    ::pool::oo::support::SetupVars distInterface
    # @c Constructor, initializes the option and its shadow.

	${this}::TrackDist -dist {}
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::distInterface::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods distInterface
::pool::oo::support::FixOptions distInterface

# Create object instantiation procedure
interp alias {} distInterface {} ::pool::oo::support::New distInterface

# -------------------------------


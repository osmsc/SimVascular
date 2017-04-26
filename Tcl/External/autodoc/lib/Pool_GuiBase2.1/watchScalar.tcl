# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/watchScalar.cls'.
# Date: Thu Sep 14 23:03:58 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> watchScalar <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::watchScalar {
    variable  _superclasses    watchManager
    variable  _scChainForward  watchScalar
    variable  _scChainBackward watchScalar
    variable  _classVariables  {}
    variable  _methods         {createSubwidgets updateDisplay}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . updateDisplay .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::watchScalar::createSubwidgets {} {
    ::pool::oo::support::SetupVars watchScalar
    # @c Called after object construction. Generates the internal widgets
	# @c and their layout.

	# On the left a label showing the name of the tracked variable.
	# On the right its value.
	# Between them a label to show the assignment operator

	label $this.name  -textvariable "${this}::opt(-variable)"
	label $this.sep   -text         ":="
	label $this.value -text         $value

	pack $this.name  -side left  -fill both -expand 0 -ipady 1m
	pack $this.sep   -side left  -fill both -expand 0 -ipady 1m
	pack $this.value -side right -fill both -expand 1 -ipady 1m
	return
}



proc ::pool::oo::class::watchScalar::updateDisplay {} {
    ::pool::oo::support::SetupVars watchScalar
    # @c Method required by the superclass <c watchManager> to propagate
	# @c changes to the value into the display.

	$this.value configure -text $value

	#update idletasks
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::watchScalar::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::watchManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences watchScalar

# Create object instantiation procedure
interp alias {} watchScalar {} ::pool::oo::support::New watchScalar

# -------------------------------


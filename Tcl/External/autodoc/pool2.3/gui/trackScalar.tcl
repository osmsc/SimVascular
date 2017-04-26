# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/trackScalar.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> trackScalar <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::trackScalar {
    variable  _superclasses    watchManager
    variable  _scChainForward  trackScalar
    variable  _scChainBackward trackScalar
    variable  _classVariables  {}
    variable  _methods         {ResetDisplay TrackVariable createSubwidgets updateDisplay}

    variable  _variables
    array set _variables  {line {trackScalar {isArray 0 initialValue 1}}}

    variable  _options
    array set _options  {numbercolor {trackScalar {-default black -type ::pool::getopt::notype -action {} -class Numbercolor}} varvaluecolor {trackScalar {-default blue -type ::pool::getopt::notype -action {} -class Varvaluecolor}} varnamecolor {trackScalar {-default red -type ::pool::getopt::notype -action {} -class Varnamecolor}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . updateDisplay . ResetDisplay . TrackVariable .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::trackScalar::ResetDisplay {} {
    ::pool::oo::support::SetupVars trackScalar
    # @c Clears the display, then writes the current contents of the
	# @c asssociated variable into it. Used to refressh the display
	# @c after changes to the option <o variable>.

	set line 1

	$this.t configure -state normal
	$this.t delete 1.0 end
	$this.t insert end "$opt(-variable)\n" varname
	$this.t configure -state disabled

	updateDisplay
	return
}



proc ::pool::oo::class::trackScalar::TrackVariable {o oldValue} {
    ::pool::oo::support::SetupVars trackScalar
    # @c Overide superclass definition to allow us the insertion of our
	# @c own code into the action following the change of the variable
	# @c the widget is connected to.
	#
	# @a o:        The name of the changed option.
	# @a oldValue: The value of the option before the change.

	watchManager_TrackVariable $o $oldValue
	ResetDisplay
	return
}



proc ::pool::oo::class::trackScalar::createSubwidgets {} {
    ::pool::oo::support::SetupVars trackScalar
    # @c Called after object construction. Generates the internal widgets
	# @c and their layout.

	# This widget not only traces the variable contents, but changes to
	# '-variable' too. The latter cause a reset of the display.

	scrollbar    $this.s
	text         $this.t ;# -width $opt(-width) -height $opt(-height)
	::pool::ui::multiScroll $this.s vertical $this.t

	pack $this.s -side left -expand 0 -fill both
	pack $this.t -side left -expand 1 -fill both

	$this.t tag configure varname  -foreground $opt(-varnamecolor)
	$this.t tag configure varvalue -foreground $opt(-varvaluecolor)
	$this.t tag configure number   -foreground $opt(-numbercolor)
	$this.t configure -state disabled

	ResetDisplay
	return
}



proc ::pool::oo::class::trackScalar::updateDisplay {} {
    ::pool::oo::support::SetupVars trackScalar
    # @c Method required by the superclass <c watchManager> to propagate
	# @c changes to the value into the display.

	$this.t configure -state normal
	$this.t insert end "[format %5d $line] " number
	$this.t insert end "$value\n"            varvalue
	$this.t configure -state disabled

	incr line

	#update idletasks
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::trackScalar::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::watchManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences trackScalar

# Create object instantiation procedure
interp alias {} trackScalar {} ::pool::oo::support::New trackScalar

# -------------------------------


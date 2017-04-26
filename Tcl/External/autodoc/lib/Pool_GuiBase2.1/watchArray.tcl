# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/watchArray.cls'.
# Date: Thu Sep 14 23:03:58 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> watchArray <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::watchArray {
    variable  _superclasses    watchAManager
    variable  _scChainForward  watchArray
    variable  _scChainBackward watchArray
    variable  _classVariables  {}
    variable  _methods         {BuildDisplay Map2Lines clearDisplay createSubwidgets initDisplay updateDisplay}

    variable  _variables
    array set _variables  {keys {watchArray {isArray 1 initialValue {}}} sortedKeys {watchArray {isArray 0 initialValue {}}} maxKey {watchArray {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {varvaluecolor {watchArray {-default blue -type ::pool::getopt::notype -action {} -class Varvaluecolor}} varnamecolor {watchArray {-default red -type ::pool::getopt::notype -action {} -class Varnamecolor}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . clearDisplay . updateDisplay . initDisplay . BuildDisplay . Map2Lines .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::watchArray::BuildDisplay {} {
    ::pool::oo::support::SetupVars watchArray
    # @c Clear the display and recreate it from the ground.

	upvar #0 $opt(-variable) v

	$this.t configure -state normal
	$this.t delete 1.0 end

	$this.t insert end "$opt(-variable) = \{\n"

	foreach k $sortedKeys {
	    set offset [expr {$maxKey - [string length $k]}]

	    $this.t insert end " ${k}[::pool::string::blank $offset] " varname
	    $this.t insert end "$v($k)\n"                              varvalue
	}

	$this.t insert end "\}"

	$this.t configure -state disabled
	return
}



proc ::pool::oo::class::watchArray::Map2Lines {} {
    ::pool::oo::support::SetupVars watchArray
    # @c Build a map associating the keys of the array we are connected to
	# @c to lines in our text widget.

	upvar #0 $opt(-variable) v

	::pool::array::clear keys

	set line 2
	foreach key $sortedKeys {
	    set  keys($key) $line
	    incr line
	}

	return
}



proc ::pool::oo::class::watchArray::clearDisplay {} {
    ::pool::oo::support::SetupVars watchArray
    # @c Method required by the superclass <c watchManager> initialize the
	# @c display after changes to -variable (but not the contents of the
	# @c associated variable!)

	$this.t configure -state normal
	$this.t delete 1.0 end
	$this.t configure -state disabled

	return
}



proc ::pool::oo::class::watchArray::createSubwidgets {} {
    ::pool::oo::support::SetupVars watchArray
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
	$this.t configure -state disabled

	return
}



proc ::pool::oo::class::watchArray::initDisplay {} {
    ::pool::oo::support::SetupVars watchArray
    # @c Method required by the superclass <c watchManager> initialize the
	# @c display after changes to -variable (but not the contents of the
	# @c associated variable!)

	upvar #0 $opt(-variable) v

	set sortedKeys [lsort [array names v]]
	set maxKey     [::pool::list::lengthOfLongestEntry $sortedKeys]

	Map2Lines
	BuildDisplay

	#update idletasks
	return
}



proc ::pool::oo::class::watchArray::updateDisplay {} {
    ::pool::oo::support::SetupVars watchArray
    # @c Method required by the superclass <c watchManager> to propagate
	# @c changes to the value into the display.

	switch -- $operation {
	    w {
		if {[::info exists keys($item)]} {
		    # Change of existing entry. Set insertion cursor into the
		    # corresponding line, behind the key information and then
		    # write over the existing data.

		    upvar #0 $opt(-variable) v

		    set line $keys($item)
		    set pos  [expr {2+$maxKey}]

		    $this.t configure -state normal
		    $this.t mark set insert $line.$pos
		    $this.t delete   insert $line.end
		    $this.t insert   insert "$v($item)" varvalue
		    $this.t configure -state disabled

		} else {
		    # The array got a new entry, rebuild the whole structure
		    initDisplay
		}
	    }
	    u {
		# An entry was removed from the array, rebuild the whole
		# structure
		initDisplay
	    }
	}

	#update idletasks
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::watchArray::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::watchAManager::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences watchArray

# Create object instantiation procedure
interp alias {} watchArray {} ::pool::oo::support::New watchArray

# -------------------------------


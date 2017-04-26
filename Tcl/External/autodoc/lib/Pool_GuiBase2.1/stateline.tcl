# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/stateline.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> stateline <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::stateline {
    variable  _superclasses    widget
    variable  _scChainForward  stateline
    variable  _scChainBackward stateline
    variable  _classVariables  {}
    variable  _methods         {createSubwidgets setText}

    variable  _variables
    array set _variables  {messages {stateline {isArray 1 initialValue {}}} handles {stateline {isArray 0 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {createSubwidgets . setText .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::stateline::createSubwidgets {} {
    ::pool::oo::support::SetupVars stateline
    # @c Creates and packs the widget required by the stateline.

	label $this._text -border 2 -relief sunken -text {} -anchor w
	pack  $this._text -expand 1 -fill both -side top -ipadx 2m -ipady 1m

	addSubwidget text $this._text
	return
}



proc ::pool::oo::class::stateline::setText {handle text} {
    ::pool::oo::support::SetupVars stateline
    # @c Accessor method to place a message in the stateline.
	#
	# @a handle: The symbolic name associated to the message. Can be used
	# @a handle: between messages from several different sources.
	# @a text:   The text to show in the stateline.

	# Remove the handle from the stack, whereever it is, ...

	::pool::list::delete handles $handle

	if {$text != {}} {
	    # ... then add it to the top (for a nonempty message)
	    # and display the now current message.

	    set messages($handle) $text
	    ::pool::list::unshift handles $handle
	    $this._text configure -text $text

	} else {
	    # ... The message of this handle is cleared. Don't add it back,
	    # but display the message of the handle now at the top of the
	    # list. Clear the display, if there is none.

	    unset messages($handle)
	    if {$handles != {}} {
		$this._text configure -text $messages([lindex $handles 0])
	    } else {
		$this._text configure -text ""
	    }
	}

	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::stateline::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences stateline

# Create object instantiation procedure
interp alias {} stateline {} ::pool::oo::support::New stateline

# -------------------------------


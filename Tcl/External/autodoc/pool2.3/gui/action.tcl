# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/gui/action.cls'.
# Date: Thu Sep 14 23:03:57 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> actionrow <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::actionrow {
    variable  _superclasses    widget
    variable  _scChainForward  actionrow
    variable  _scChainBackward actionrow
    variable  _classVariables  {}
    variable  _methods         {Repack add change createSubwidgets cvtOrientation doForSub}

    variable  _variables
    array set _variables  {names {actionrow {isArray 1 initialValue {}}} n {actionrow {isArray 0 initialValue 0}}}

    variable  _options
    array set _options  {orientation {actionrow {-default horizontal -type ::pool::getopt::notype -action Repack -class Orientation}} escape {actionrow {-default -1 -type ::pool::getopt::notype -action {} -class Escape}} default {actionrow {-default -1 -type ::pool::getopt::notype -action {} -class Default}} padx {actionrow {-default 0 -type ::pool::getopt::notype -action Repack -class Padx}} pady {actionrow {-default 0 -type ::pool::getopt::notype -action Repack -class Pady}} fill {actionrow {-default none -type ::pool::getopt::notype -action Repack -class Fill}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {doForSub . createSubwidgets . cvtOrientation . add . Repack . change .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::actionrow::Repack {} {
    ::pool::oo::support::SetupVars actionrow
    # @c Called after changes to the value of some options.
	# @c Executes a relayout of the widget.

	doForSub "pack forget %b"
	doForSub [list pack %b  -side   [cvtOrientation $opt(-orientation)]  -in     $this         -expand 1             -padx   $opt(-padx)   -pady   $opt(-pady)   -fill   $opt(-fill)]
	return
}



proc ::pool::oo::class::actionrow::add {name text command} {
    ::pool::oo::support::SetupVars actionrow
    # @c Adds a new button to the row, labels it with
	# @c <a text> and performs the necessary setup so
	# @c that <a command> is executed in case of its
	# @c invocation.
	# @a text: text to use as label of the new button
	# @a command: script to execute in case of an
	# @a command: invocation of the new button.
	# @a name: Symbolic name of the new button.

	set  place $n
	incr n
	set  names($name) $place

	set b    $opt(-background)
	set f    $opt(-foreground)
	set h    $opt(-highlightthickness)
	set side [cvtOrientation $opt(-orientation)]

	if {$place == $opt(-default)} {
	    frame  $this.default        -bg $b -highlightthickness $h -relief sunken -bd 2
	    button $this.b$place -fg $f -bg $b -highlightthickness $h

	    pack $this.default		 -in     $this	 -side   $side	 -expand 1		 -padx   $opt(-padx)	 -pady   $opt(-pady)	 -fill   $opt(-fill)

	    pack $this.b$place		 -in $this.default	 -padx 2m		 -pady 2m

	    # fast invocation of default
	    bind [winfo toplevel $this] <Return> "$this.b$place invoke"
	} else {
	    button $this.b$place -fg $f -bg $b -highlightthickness $h

	    pack $this.b$place		 -in     $this	 -side   $side	 -expand 1		 -padx   $opt(-padx)	 -pady   $opt(-pady)	 -fill   $opt(-fill)
	}

	if {$place == $opt(-escape)} {
	    # allow fast cancel
	    bind [winfo toplevel $this] <Key-Escape> "$this.b$place invoke"
	}

	addSubwidget $name $this.b$place

	$this.b$place configure -text $text -command $command
}



proc ::pool::oo::class::actionrow::change {name newtext} {
    ::pool::oo::support::SetupVars actionrow
    # @c Changes the text associated to the button
	# @c with the symbolic <a name> to <a newtext>.
	# @a newtext: text to place into the button.
	# @a name: Symbolic name of the button to change.

	set place $names($name)

	$this.b$place configure -text $newtext
	return
}



proc ::pool::oo::class::actionrow::createSubwidgets {} {
    ::pool::oo::support::SetupVars actionrow
    # @c Generates subordinate widgets and their layout.
	# @c Here only the master frame requires configuration.
	# @c The buttons will be added later via <m add>.
	# @n Called automatically by the object framework.

	frameWidget configure  -bg                 $opt(-background)          -highlightthickness $opt(-highlightthickness)  -bd                 $opt(-border)              -relief             $opt(-relief)
	return
}



proc ::pool::oo::class::actionrow::cvtOrientation {o} {
    ::pool::oo::support::SetupVars actionrow
    # @c converts row orientation <a o> into
	# @c a value acceptable to 'pack -side'.
	# @a o: orientation to convert.

	switch -- $o {
	    horizontal {return left}
	    vertical   {return top}
	    backward   {return right}
	    upward     {return bottom}
	    default    {"error illegal orientation $o"}
	}
}



proc ::pool::oo::class::actionrow::doForSub {cmd} {
    ::pool::oo::support::SetupVars actionrow
    # @c Executes the <a cmd> for all buttons which are part of the widget.
	# @a cmd: Script to be executed. Occurences of %b will be
	# @a cmd: substituted with the path of the current button.

	for {set i 0} {$i < $n} {incr i} {
	    if {$i == $opt(-default)} {
		set w $this.default
	    } else {
		set w $this.b$i
	    }
	    regsub -- {%b} $cmd $w cmdE
	    eval $cmdE
	}
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::actionrow::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::widget::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences actionrow

# Create object instantiation procedure
interp alias {} actionrow {} ::pool::oo::support::New actionrow

# -------------------------------


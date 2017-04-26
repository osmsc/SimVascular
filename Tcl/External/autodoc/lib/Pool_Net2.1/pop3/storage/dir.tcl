# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/storage/dir.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> dirStorage <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::dirStorage {
    variable  _superclasses    popClientStorageBase
    variable  _scChainForward  dirStorage
    variable  _scChainBackward dirStorage
    variable  _classVariables  {}
    variable  _methods         {TrackDir constructor storeMessage}

    variable  _variables
    array set _variables  {nextId {dirStorage {isArray 0 initialValue 1}}}

    variable  _options
    array set _options  {dir {dirStorage {-default {} -type ::pool::getopt::nonempty -action TrackDir -class Dir}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackDir . constructor . storeMessage .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::dirStorage::TrackDir {option oldValue} {
    ::pool::oo::support::SetupVars dirStorage
    # @c Configure the target directory of this storage facility.
	# @a option:   The name of the option to track.
	# @a oldValue: The old value of the option.

	set base $opt(-dir)

	if {$base == {}} {
	    error "no directory specified"
	}

	# sanity checks
	if {! [file exists      $base]} {
	    error "[oinfo class]: '$base' does not exist"
	}
	if {! [file isdirectory $base]} {
	    error "[oinfo class]: '$base' not a directory"
	}
	if {! [file readable    $base]} {
	    error "[oinfo class]: '$base' not readable"
	}
	if {! [file writable    $base]} {
	    error "[oinfo class]: '$base' not writable"
	}

	# gather highest numbered filename and use it to initialize the
	# filename generator

	set here [pwd]
	cd $base
	set flist [glob -nocomplain \[0-9\]*]
	cd $here

	if {$flist == {}} {
	    set nextId 1
	} else {
	    set fl ""
	    foreach f $flist {if {[regexp -- {^[0-9]*$} $f]} {lappend fl $f}}
	    set  nextId [lindex [lsort -integer -decreasing $fl] 0]
	    incr nextId
	}

	return
}



proc ::pool::oo::class::dirStorage::constructor {} {
    ::pool::oo::support::SetupVars dirStorage
    # @c Constructor, initializes <v nextId> too.

	if {$opt(-dir) != ""} {
	    TrackDir -dir {}
	}
	return
}



proc ::pool::oo::class::dirStorage::storeMessage {command message} {
    ::pool::oo::support::SetupVars dirStorage
    # @c Store the given message into the configured directory.
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	set fail [catch {
	    set           file [file join $opt(-dir) $nextId]
	    set              f [open $file w]
	    puts -nonewline $f $message
	    close           $f
	    incr       nextId
	} errmsg] ; #{}

	Done $command $fail $errmsg
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::dirStorage::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::popClientStorageBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences dirStorage

# Create object instantiation procedure
interp alias {} dirStorage {} ::pool::oo::support::New dirStorage

# -------------------------------


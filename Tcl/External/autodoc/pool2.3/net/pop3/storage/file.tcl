# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/storage/file.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> fileStorage <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::fileStorage {
    variable  _superclasses    popClientStorageBase
    variable  _scChainForward  fileStorage
    variable  _scChainBackward fileStorage
    variable  _classVariables  {}
    variable  _methods         {TrackFile constructor storeMessage}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {file {fileStorage {-default {} -type ::pool::getopt::nonempty -action TrackFile -class File}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackFile . constructor . storeMessage .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::fileStorage::TrackFile {option oldValue} {
    ::pool::oo::support::SetupVars fileStorage
    # @c Configure the target file of this storage facility.
	# @a option:   The name of the option to track.
	# @a oldValue: The old value of the option.

	set base $opt(-file)

	if {$base == {}} {
	    error "no file specified"
	}

	# sanity checks
	if {! [file exists      $base]} {
	    error "[oinfo class]: '$base' does not exist"
	}
	if {[file isdirectory $base]} {
	    error "[oinfo class]: '$base' not a file"
	}
	if {! [file readable    $base]} {
	    error "[oinfo class]: '$base' not readable"
	}
	if {! [file writable    $base]} {
	    error "[oinfo class]: '$base' not writable"
	}
	return
}



proc ::pool::oo::class::fileStorage::constructor {} {
    ::pool::oo::support::SetupVars fileStorage
    # @c Constructor.

	if {$opt(-file) != ""} {
	    TrackFile -file {}
	}
	return
}



proc ::pool::oo::class::fileStorage::storeMessage {command message} {
    ::pool::oo::support::SetupVars fileStorage
    # @c Appends the given message into the configured file.
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	set fail [catch {
	    set              f [open $opt(-file) a]
	    puts            $f "From [::pool::date::nowTime]"
	    puts -nonewline $f $message
	    close           $f
	} errmsg] ; #{}

	Done $command $fail $errmsg
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::fileStorage::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::popClientStorageBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences fileStorage

# Create object instantiation procedure
interp alias {} fileStorage {} ::pool::oo::support::New fileStorage

# -------------------------------


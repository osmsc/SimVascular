# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: dir.cls,v 1.1 1998/06/01 19:56:44 aku Exp $
#
# @c Storage facility, delivers incoming mails into a directory.
# @s Storage facility, delivers incoming mails into a directory.
# @i storage facility
# -----------------------------

class dirStorage : popClientStorageBase {
    # @c Storage system usable by the pop client in <c pop3Client>. Incoming
    # @c mails are stored as files into a predefined directory, see option
    # @c <o dir>.

    # @o dir: The name of the directory to place incoming mails into.

    option dir -d "" -t ::pool::getopt::nonempty -a TrackDir

    # @v nextId: Internal state, the name of the next file to use for storing
    # @v nextId: an incoming message. Initialized during construction and
    # @v nextId: after every change of the target directory, see <m TrackDir>.

    var nextId 1

    method dirStorage {} {
	# @c Constructor, initializes <v nextId> too.

	if {$opt(-dir) != ""} {
	    TrackDir -dir {}
	}
	return
    }


    method TrackDir {option oldValue} {
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


    method storeMessage {command message} {
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
}


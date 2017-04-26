# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: file.cls,v 1.1 1998/06/01 19:56:44 aku Exp $
#
# @c Storage facility, appends incoming mails to a file
# @s Storage facility, appends incoming mails to a file
# @i storage facility
# -----------------------------

class fileStorage : popClientStorageBase {
    # @c Storage system usable by the pop client in <c pop3Client>. Incoming
    # @c mails are stored into a predefined file, see option <o file>.

    # @o file: The name of the file to append incoming mails to.

    option file -d "" -t ::pool::getopt::nonempty -a TrackFile


    method fileStorage {} {
	# @c Constructor.

	if {$opt(-file) != ""} {
	    TrackFile -file {}
	}
	return
    }


    method TrackFile {option oldValue} {
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


    method storeMessage {command message} {
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
}


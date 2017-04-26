# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: mbox.cls,v 1.1 1998/06/01 19:56:38 aku Exp $
#
# @c File- and directorybased mailbox management. Currently ussed
# @c by the small scale pop3 server application (<f apps/popsy>).
#
# @s Mailbox management based on files and directories
# @i Mailbox management, pop3 server
# -----------------------------

class mbox : popServerStorageBase {
    # @c A file and directory based implementation of the
    # @c <c popServerStorageBase>-interface. Each mailbox is implemented as a
    # @c directory below <o dir>, and every mail is stored in a single file.

    # @o dir: The path to the base directory containing mailboxes and mails.

    option dir -d "" -t ::pool::getopt::nonempty

    # @v locked: Every locked mailbox has entry in this array, its name is
    # @v locked: used as index.

    # @v state:  Every locked mailbox has entry in this array, its name is
    # @v state:  used as index. The associated value is a list of the files in
    # @v state:  the mailbox (= list of stored mails).

    # @v transfer: This array contains the state for every running transfer.
    # @v transfer: This state is currently only the callback script to execute
    # @v transfer: after its completion.

    var -array locked   {}
    var -array state    {}
    var -array transfer {}


    method mbox {} {
	# @c Constructor. Does some more checks on the given base directory.

	# sanity checks
	set base $opt(-dir)

	if {$base == {}} {
	    error "directory not specified"
	}
	if {! [file exists      $base]} {
	    error "constructor: '$base' does not exist"
	}
	if {! [file isdirectory $base]} {
	    error "constructor: '$base' not a directory"
	}
	if {! [file readable    $base]} {
	    error "constructor: '$base' not readable"
	}
	if {! [file writable    $base]} {
	    error "constructor: '$base' not writable"
	}
	return
    }


    method add {mbox} {
	# @c Create a mailbox with handle <a mbox>. The handle is used as the
	# @c name of the directory to contain the mails too.
	#
	# @a mbox: Reference to the mailbox to be operated on.

	set mbox   [file join $opt(-dir) $mbox]
	file mkdir $mbox
	return
    }


    method remove {mbox} {
	# @c Remove mailbox with handle <a mbox>. This will destroy all mails
	# @c contained in it too.
	#
	# @a mbox: Reference to the mailbox to be operated on.

	set mbox           [file join $opt(-dir) $mbox]
	file delete -force $mbox
	return
    }



    method move {old new} {
	# @c Change the handle of mailbox <a old> to <a new>.
	#
	# @a old: Reference to the mailbox to be operated on.
	# @a new: New reference to the mailbox

	set old [file join $opt(-dir) $old]
	set new [file join $opt(-dir) $new]

	file rename -force $old $new
	return
    }


    method exists {mbox} {
	# @c Determines existence of mailbox <a mbox>.
	# @a mbox: Reference to the mailbox to check for.
	# @r 1 if the mailbox exists, 0 else.

	set mbox [file join $opt(-dir) $mbox]
	return   [file exists $mbox]
    }


    method Check {mbox} {
	# @c Internal procedure. Used to map a mailbox handle
	# @c to the directory containing the messages.
	# @a mbox: Reference to the mailbox to be operated on.
	# @r Path of directory holding the message files of the
	# @r specified mailbox.

	set mbox [file join $opt(-dir) $mbox]

	if {! [file exists      $mbox]} {
	    error "Check: '$mbox' does not exist"
	}
	if {! [file isdirectory $mbox]} {
	    error "Check: '$mbox' not a directory"
	}
	if {! [file readable    $mbox]} {
	    error "Check: '$mbox' not readable"
	}
	if {! [file writable    $mbox]} {
	    error "Check: '$mbox' not writable"
	}
	
	return $mbox
    }


    method locked {mbox} {
	# @c Checks wether the specified mailbox is locked or not.
	# @a mbox: Reference to the mailbox to check.
	# @r 1 if the mailbox is locked, 0 else.

	set mbox [file join $opt(-dir) $mbox]
	return [::info exists locked($mbox)]
    }


    # -- interface to the pop server --


    method lock {mbox} {
	# @c Locks the given mailbox, additionally stores a list of the
	# @c available files in the manager state. All files (= messages)
	# @c added to the mailbox after this operation will be ignored
	# @c during the session.
	#
	# @a mbox: Reference to the mailbox to be locked.
	# @r 1 if mailbox was locked sucessfully, 0 else.

	# locked already ?
	if {[locked $mbox]} {
	    return 0
	}

	set dir [Check $mbox]

	# get list of message files residing in mailbox directory
	set state($dir)  [glob -nocomplain [file join $dir *]]
	set locked($dir) 1
	return 1
    }


    method unlock {mbox} {
	# @c A locked mailbox is unlocked, thereby made available
	# @c to other sessions.
	#
	# @a mbox: Reference to the mailbox to be locked.

	set dir [Check $mbox]
	unset  state($dir)
	unset  locked($dir)
	return
    }


    method stat {mbox} {
	# @c Determines the number of messages picked up by <m lock>.
	# @c Will fail if the mailbox was not locked.
	#
	# @a mbox: Reference to the mailbox queried.
	# @r The number of messages in the mailbox

	if {![locked $mbox]} {
	    error "mailbox $mbox not locked"
	}

	set dir [Check $mbox]
	return  [llength $state($dir)]
    }


    method size {mbox msgId} {
	# @c Determines the size of the specified message, in bytes.
	#
	# @a mbox: Reference to the mailbox to be operated on.
	# @a msgId: Numerical index of the message to look at.
	# @r size of the message in bytes.

	set dir [Check $mbox]
	return [file size [lindex $state($dir) [incr msgId -1]]]
    }


    method dele {mbox msgList} {
	# @c Deletes the specified messages from the mailbox. This should
	# @c be followed by a <m unlock> as the state is not updated
	# @c accordingly.
	#
	# @a mbox: Reference to the mailbox to be operated on.
	# @a msgList: List of message ids.

	set dir [Check $mbox]

	# @d The code assumes that the id's in the list were already
	# @d checked against the maximal number of messages.

	foreach msgId $msgList {
	    file delete [lindex $state($dir) [incr msgId -1]]
	}

	# the mailbox state is unusable now.
	return
    }


    method transfer {args} {
	# @c Starts a (partial) transfer of the given message. Configured via
	# @c a list of option/value-pairs, followed by the mailbox to look at,
	# @c the numerical id of the message to transfer and the channel to
	# @c sent the mail to, in this order.
	#
	# @a args: List of option/value-pairs, followed by 3 arguments
	# @a args: (explained in the method description). Recognized options
	# @a args: are '-done' and '-lines'.&p
	# @a args: The value of -done is interpreted as a script to
	# @a args: call after completion of the transfer. Its
	# @a args: specification is required. &p
	# @a args: On the other hand, specification of -lines is
	# @a args: optional. It is interpreted as the number of
	# @a args: lines to transfer, beyond the usual message header.
	# @a args: The complete message is transfered if it is not
	# @a args: specified.

	::pool::array::def           oDef
	::pool::getopt::defOption    oDef done  -t ::pool::getopt::nonempty
	::pool::getopt::defOption    oDef lines
	::pool::getopt::defShortcuts oDef

	set args [::pool::getopt::process oDef $args oVal]
	unset oDef

	set mbox  [::pool::list::shift args]
	set msgId [::pool::list::shift args]
	set chan  [::pool::list::shift args]

	if {$oVal(-done) == {}} {
	    error "no callback specified"
	}

	incr msgId -1
	set dir [Check $mbox]
	set out [open [lindex $state($dir) $msgId] r]

	if {$oVal(-lines) != {}} {
	    # partial transfer, send only the first $oVal(-lines) lines after
	    # the header. An in-memory channel is used to construct the partial
	    # message.

	    package require Memchan

	    set msg [read $out]
	    close         $out

	    #puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	    #puts "[::pool::mail::header $msg]"
	    #puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	    #puts "[::pool::mail::body $msg]"
	    #puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	    #puts "[join [lrange [split [::pool::mail::body $msg] \n] 1 \
	    #		    # [incr oVal(-lines) -1]] \n]"
	    #puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

	    set   out [memchan]
	    puts $out [::pool::mail::header $msg]
	    puts $out ""
	    puts $out [join [lrange [split [::pool::mail::body $msg] \n] 0 \
		    [incr oVal(-lines) -1]] \n]
	    seek $out 0

	    unset msg
	}

	set transId [::pool::serial::new]

	set transfer($transId) $oVal(-done)
	unset oVal

	fcopy $out $chan \
		-command [list $this TransferDone $mbox $out $chan $transId]
	return
    }


    method TransferDone {mbox outchan chan transId n} {
	# @c Internal procedure. Called by 'fcopy' after completion of the
	# @c transfer. Executes the '-done' script specified at the call
	# @c to <m transfer>.
	#
	# @a mbox:    Reference to the mailbox to be operated on. Ignored.
	# @a outchan: The channel contained the data written.
	# @a chan:    The channel to write the data into.
	# @a transId: The id of the transfer
	# @a n:       Number of bytes sent, courtesy by 'fcopy'. Ignored here.

	# @future 'n' might be usable for server statistics.

	# write end-of-message marker
	puts  $chan "."
	close $outchan

	set done $transfer($transId)
	unset     transfer($transId)

	uplevel #0 $done
	return
    }
}


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: trig.cls,v 1.2 1998/06/02 16:56:20 aku Exp $
#
# @c Storage facility, forwards incoming data to another facility, triggers
# @c external command after delivery of the last mail.
# @s Storage facility, forwards incoming data to another facility
# @i storage facility
# -----------------------------

class triggerStorage : popClientStorageBase {
    # @c Storage system usable by the pop client in <c pop3Client>. Incoming
    # @c mails are forward to a predefined storage facility, see <o target>.
    # @c This class offers the functionality to detect the completion of
    # @c storing the last mail which came in via <c pop3Client> and act upon
    # @c that, via <o command>. This is currently used in my pop client
    # @c (<f apps/popeye>) to trigger a flist operation in my mailreader,
    # @c which is <x ExMH>, created by <x Welch>, also written in <d Tcl>.
    # @c This operation scans all known mail folders for new mail which is
    # @c then displayed. Without that <x ExMH> would have to poll every so
    # @c often to be up to date.

    # @o target: The handle of the storage facility to forward incoming mails
    # @o target: to.

    # @o command: The command to evaluate after the storing of the last
    # @o command: incoming mail completed. Called with ourselves as first and
    # @o command: only argument.

    option target -t ::pool::getopt::nonempty
    option command

    # - internal state -

    # @v in:     The number mails which came in so far.
    # @v stored: The number of mails which were stored using <o target>.
    # @v cDone:  Set by <m clientDone>, signals that there will be no more
    # @v cDone:  mails coming in.

    var in     0
    var stored 0
    var cDone  0


    method storeMessage {command message} {
	# @c Forward the given message to the configured storage facility, and
	# @c counts that too
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	incr in
	$opt(-target) store -command [list $this SubDone $command] $message
	return
    }


    method SubDone {command state {msg {}}} {
	# @c Callback for <o target>. Counts the completion of the storage
	# @c process, forwards the state and error information to our caller,
	# @c and acts if the last mail was stored.
	#
	# @a command: The script evaluate. Allowed to be empty, nothing is done
	# @a command: in that case. Gets either 'error' or 'done' as first
	# @a command: argument. In case of an 'error' <a msg> is given to as
	# @a command: well.
	# @a state:   Completion state, either 'done' or 'error'.
	# @a msg:     The error text to add as 2nd argument to <a command>.

	incr stored

	if {"$state" == "error"} {
	    Done $command 1 $msg
	} else {
	    Done $command 0
	}

	Trigger
	return
    }


    method clientDone {args} {
	# @c Calling this method signals that the pop client completed its
	# @c retrieval session and that no more mails will be coming,
	#
	# @a args: Ignored. Added to allow immediate usage by
	# @a args: <o pop3Client:done>.

	incr cDone
	Trigger
	return
    }


    method Trigger {} {
	# @c Checks wether the last mails was stored or not. If so,
	# @c <o command> is evaluated, using ourselves as its first and only
	# @c argument.

	if {$cDone && ($in == $stored)} {
	    if {$opt(-command) != {}} {
		uplevel #0 $opt(-command) $this
	    }
	    Reset
	}
	return
    }


    method Reset {} {
	# @c Enforces the initial state of the object.

	set cDone  0
	set in     0
	set stored 0
	return
    }
}


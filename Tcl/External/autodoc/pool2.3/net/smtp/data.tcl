# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/smtp/data.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> smtpDataSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::smtpDataSeq {
    variable  _superclasses    smtpSequencer
    variable  _scChainForward  smtpDataSeq
    variable  _scChainBackward smtpDataSeq
    variable  _classVariables  {}
    variable  _methods         {DataTransferProgress DataTry GotDataResponse GotTransferResponse StartTransfer constructor}

    variable  _variables
    array set _variables  {nTransfered {smtpDataSeq {isArray 0 initialValue 0}} closeChannel {smtpDataSeq {isArray 0 initialValue 0}}}

    variable  _options
    array set _options  {message {smtpDataSeq {-default {} -type ::pool::getopt::notype -action {} -class ::pool::getopt::nonempty}} progress {smtpDataSeq {-default {} -type ::pool::getopt::notype -action {} -class Progress}} blocksize {smtpDataSeq {-default 1024 -type ::pool::getopt::notype -action {} -class ::pool::getopt::integer}} string {smtpDataSeq {-default 0 -type ::pool::getopt::notype -action {} -class ::pool::getopt::boolean}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {DataTransferProgress . DataTry . constructor . GotTransferResponse . StartTransfer . GotDataResponse .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::smtpDataSeq::DataTransferProgress {n} {
    ::pool::oo::support::SetupVars smtpDataSeq
    # @c Callback for transfer. Completes whole transfer or initiates next
	# @c chunk. Executes the progress-handler, if it was defined.
	#
	# @a n: Number of bytes transfered by 'fcopy'.

	incr nTransfered $n

	if {[eof $opt(-message)]} {
	    # end-of-message marker
	    puts $opt(-sock) "."

	    if {$closeChannel} {
		# Transfer involved a string, remove the internal in-memory
		# channel and restore the original state of the sequencer.

		close $opt(-message)
		set    opt(-message) {}
	    }

	    wait $opt(-sock) GotTransferResponse 
	} else {
	    # jump out to progress handler

	    if {$opt(-progress) != {}} {
		set fail [catch {
		    uplevel #0 $opt(-progress) $opt(-conn) $nTransfered
		} errmsg] ;# {}

		if {$fail} {
		    global errorInfo
		    event $seq error "$errmsg $errorInfo"
		}
	    }

	    # continue copying
	    StartTransfer
	}

	return
}



proc ::pool::oo::class::smtpDataSeq::DataTry {} {
    ::pool::oo::support::SetupVars smtpDataSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the command initiating a data transfer to
	# @c the demon, then waits for its response.

	wait $opt(-sock) GotDataResponse
	Write DATA
	return
}



proc ::pool::oo::class::smtpDataSeq::GotDataResponse {line} {
    ::pool::oo::support::SetupVars smtpDataSeq
    # @c Called after smtp demon reacted on DATA. A specific
	# @c response code is expected, everything else is
	# @c considered as failure. Initiates the real transfer
	# @c of data in case of success.
	#
	# @a line: Response of demon

	Log $line

	switch -- [lindex $line 0] {
	    354     {
		StartTransfer
	    }
	    default {
		event error $line
	    }
	}
}



proc ::pool::oo::class::smtpDataSeq::GotTransferResponse {line} {
    ::pool::oo::support::SetupVars smtpDataSeq
    # @c After the completion of a transfer a closing response is send by
	# @c the demon. It is catched here and depending on its response code
	# @c the operation terminates with either success or failure.
	#
	# @a line:  Response of demon.

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    event done
	}
}



proc ::pool::oo::class::smtpDataSeq::StartTransfer {} {
    ::pool::oo::support::SetupVars smtpDataSeq
    # @c Starts transfer of data. If <o progress> was specified the
	# @c initiated transfer is cut into individual chunks of <o blocksize>
	# @c bytes each.

	# future: massage message body with transformer procedure!

	# syslog debug [seq_aget $seq -smtp] > transfer message block...

	if {$opt(-progress) == {}} {
	    # No progress indicator, therefore no need to copy
	    # individual chunks.

	    if {$opt(-string)} {
		# Message is a string, write it out (synchronously), then wait
		# for the response.

		puts $opt(-sock) $opt(-message)
		puts $opt(-sock) "."

		wait $opt(-sock) GotTransferResponse 
	    } else {
		# Message is stored in a channel, just copy between it and the
		# connection to the demon. This takes place in the background.

		fcopy $opt(-message) $opt(-sock)  -command [list $this DataTransferProgress]
	    }
	} else {
	    # A progress indicator was given to the sequencer. Send data in
	    # chunks (of -blocksize) to get that going.

	    if {$opt(-string)} {
		# Sending a string in chunks and in the background is too
		# complicated. Use memory channel for reduction to the simple
		# case of channels.

		# create a in-memory channel, store the message in it, then
		# play with the option values and our internal state.

		package require Memchan

		set   mc [memchan]
		puts $mc $opt(-message)
		seek $mc 0

		set opt(-message) $mc
		set opt(-string)  0 ; # cause future calls to bypass this code
		set closeChannel  1 ; # force delete of channel after transfer
	    }

	    fcopy $opt(-message) $opt(-sock)  -size    $opt(-blocksize)  -command [list $this DataTransferProgress]
	}

	return
}



proc ::pool::oo::class::smtpDataSeq::constructor {} {
    ::pool::oo::support::SetupVars smtpDataSeq
    # @c Constructor.

	next DataTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::smtpDataSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::smtpSequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences smtpDataSeq

# Create object instantiation procedure
interp alias {} smtpDataSeq {} ::pool::oo::support::New smtpDataSeq

# -------------------------------


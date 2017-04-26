# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/retr.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3RetrSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3RetrSeq {
    variable  _superclasses    pop3Sequencer
    variable  _scChainForward  pop3RetrSeq
    variable  _scChainBackward pop3RetrSeq
    variable  _classVariables  {}
    variable  _methods         {GetMessage GotRetrData GotRetrResponse RetrTry constructor}

    variable  _variables
    array set _variables  {message {pop3RetrSeq {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {use-top {pop3RetrSeq {-default 0 -type ::pool::getopt::boolean -action {} -class Use-top}} msg {pop3RetrSeq {-default {} -type ::pool::getopt::nonempty -action {} -class Msg}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {RetrTry . GotRetrData . GetMessage . constructor . GotRetrResponse .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3RetrSeq::GetMessage {} {
    ::pool::oo::support::SetupVars pop3RetrSeq
    # @c Accessor method.
	# @r is the text of the received message.

	return $message
}



proc ::pool::oo::class::pop3RetrSeq::GotRetrData {line} {
    ::pool::oo::support::SetupVars pop3RetrSeq
    # @c Called for each line of the incoming mail. Stops the
	# @c sequencer upon detection of the end-of-message marker (single
	# @c dot on a line by itself), or appends the <a line> to its
	# @c internal store.
	#
	# @a line: Text of response
    
	if {"$line" == "."} {
	    # end of message marker received, transaction completed

	    set message [string trimright $message "\t\n "]
	    event done
	} else {
	    # extend storage of received data

	    append message "$line\n"

	    wait $opt(-sock) GotRetrData
	    return
	}
}



proc ::pool::oo::class::pop3RetrSeq::GotRetrResponse {line} {
    ::pool::oo::support::SetupVars pop3RetrSeq
    # @c Called after pop3 demon responded to the RETR command. An error
	# @c aborts the operation, else we start reading the incoming message,
	# @c which followed the server response immediately.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	} else {
	    # the server will dump the header information immediately after
	    # a positive response. setup an event to handle the incoming data.

	    set message ""

	    wait $opt(-sock) GotRetrData
	    return
	}
}



proc ::pool::oo::class::pop3RetrSeq::RetrTry {} {
    ::pool::oo::support::SetupVars pop3RetrSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the retrieval command to the pop3 server,
	# @c then waits for its response.

	wait $opt(-sock) GotRetrResponse

	if {$opt(-use-top)} {
	    # the first pop server of my provider didn't accept RETR x.
	    # Had to use 'TOP x 0' instead. Maybe some other people have
	    # to deal with such a weird beast too.

	    Write "TOP $opt(-msg) 0"
	} else {
	    Write "RETR $opt(-msg)"
	}
	return
}



proc ::pool::oo::class::pop3RetrSeq::constructor {} {
    ::pool::oo::support::SetupVars pop3RetrSeq
    # @c Constructor.

	next RetrTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3RetrSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3RetrSeq

# Create object instantiation procedure
interp alias {} pop3RetrSeq {} ::pool::oo::support::New pop3RetrSeq

# -------------------------------


# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/top.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3TopSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3TopSeq {
    variable  _superclasses    pop3Sequencer
    variable  _scChainForward  pop3TopSeq
    variable  _scChainBackward pop3TopSeq
    variable  _classVariables  {}
    variable  _methods         {GetMessage GotTopData GotTopResponse TopTry constructor}

    variable  _variables
    array set _variables  {message {pop3TopSeq {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {msg {pop3TopSeq {-default {} -type ::pool::getopt::nonempty -action {} -class Msg}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {GotTopResponse . GetMessage . constructor . TopTry . GotTopData .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3TopSeq::GetMessage {} {
    ::pool::oo::support::SetupVars pop3TopSeq
    # @c Accessor method.
	# @r is the text of the received message.

	return $message
}



proc ::pool::oo::class::pop3TopSeq::GotTopData {line} {
    ::pool::oo::support::SetupVars pop3TopSeq
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

	    wait $opt(-sock) GotTopData
	    return
	}
}



proc ::pool::oo::class::pop3TopSeq::GotTopResponse {line} {
    ::pool::oo::support::SetupVars pop3TopSeq
    # @c Called after pop3 demon responded to the TOP command. An error
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

	    wait $opt(-sock) GotTopData
	    return
	}
}



proc ::pool::oo::class::pop3TopSeq::TopTry {} {
    ::pool::oo::support::SetupVars pop3TopSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Writes out the retrieval command to the pop3 server,
	# @c then waits for its response.

	wait $opt(-sock) GotTopResponse
	Write "TOP $opt(-msg) 1"
	return
}



proc ::pool::oo::class::pop3TopSeq::constructor {} {
    ::pool::oo::support::SetupVars pop3TopSeq
    # @c Constructor.

	next TopTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3TopSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::pop3Sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3TopSeq

# Create object instantiation procedure
interp alias {} pop3TopSeq {} ::pool::oo::support::New pop3TopSeq

# -------------------------------


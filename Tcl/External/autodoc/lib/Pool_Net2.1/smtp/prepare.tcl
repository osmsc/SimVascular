# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/smtp/prepare.cls'.
# Date: Thu Sep 14 23:03:30 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> smtpPrepareSeq <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::smtpPrepareSeq {
    variable  _superclasses    smtpSequencer
    variable  _scChainForward  smtpPrepareSeq
    variable  _scChainBackward smtpPrepareSeq
    variable  _classVariables  {}
    variable  _methods         {GotMailFromResponse GotRcptResponse MailFromTry PrepareRecipients constructor}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {from {smtpPrepareSeq {-default {} -type ::pool::getopt::notype -action {} -class ::pool::getopt::nonempty}} to {smtpPrepareSeq {-default {} -type ::pool::getopt::notype -action {} -class ::pool::getopt::nonempty}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {GotMailFromResponse . PrepareRecipients . constructor . MailFromTry . GotRcptResponse .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::smtpPrepareSeq::GotMailFromResponse {line} {
    ::pool::oo::support::SetupVars smtpPrepareSeq
    # @c Called after smtp demon responded to the MAIL FROM
	# @c command. In case of sucess the list of intended
	# @c recipients is transfered one by one, via RCPT TO.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	}

	PrepareRecipients
	return
}



proc ::pool::oo::class::smtpPrepareSeq::GotRcptResponse {line} {
    ::pool::oo::support::SetupVars smtpPrepareSeq
    # @c Called after the smtp demon responded to the RCPT TO
	# @c command issued last. Completes the transaction or
	# @c sends the next recipient on the list.
	#
	# @a line: Text of response

	Log $line

	if {[IsError $line]} {
	    event error $line
	}

	if {$opt(-to) == {}} {
	    event done
	}

	PrepareRecipients
	return
}



proc ::pool::oo::class::smtpPrepareSeq::MailFromTry {} {
    ::pool::oo::support::SetupVars smtpPrepareSeq
    # @c The first action taken after the construction of the sequencer
	# @c completes. Sends the mail sender address to the demon, then waits
	# @c for its response.

	wait  $opt(-sock) GotMailFromResponse
	Write "MAIL FROM:$opt(-from)"
	return
}



proc ::pool::oo::class::smtpPrepareSeq::PrepareRecipients {} {
    ::pool::oo::support::SetupVars smtpPrepareSeq
    # @c A single recipient is transfered to the demon,
	# @c via RCPT TO.

	set recipient [::pool::list::shift opt(-to)]

	wait  $opt(-sock) GotRcptResponse
	Write "RCPT TO:$recipient"
	return
}



proc ::pool::oo::class::smtpPrepareSeq::constructor {} {
    ::pool::oo::support::SetupVars smtpPrepareSeq
    # @c Constructor.

	next MailFromTry
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::smtpPrepareSeq::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::smtpSequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences smtpPrepareSeq

# Create object instantiation procedure
interp alias {} smtpPrepareSeq {} ::pool::oo::support::New smtpPrepareSeq

# -------------------------------


# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/storage/smtp.cls'.
# Date: Thu Sep 14 23:03:29 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> smtpStorage <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::smtpStorage {
    variable  _superclasses    popClientStorageBase
    variable  _scChainForward  smtpStorage
    variable  _scChainBackward smtpStorage
    variable  _classVariables  {}
    variable  _methods         {AllDone IsDone storeMessage}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {from {smtpStorage {-default {} -type ::pool::getopt::nonempty -action {} -class From}} helo {smtpStorage {-default {} -type ::pool::getopt::nonempty -action {} -class Helo}} to {smtpStorage {-default {} -type ::pool::getopt::nonempty -action {} -class To}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {IsDone . storeMessage . AllDone .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::smtpStorage::AllDone {command conn} {
    ::pool::oo::support::SetupVars smtpStorage
    # @c Executed after the SMTP connection was completely closed.
	#
	# @a command: The command to execute now that the storing is complete.
	# @a conn:    The handle of the <c smtpConnection> object shutting
	# @a conn:    down.

	if {"[$conn state]" == "error"} {
	    Done $command 1 [$conn errorInfo]
	} else {
	    Done $command 0
	}

	$conn delete
	return
}



proc ::pool::oo::class::smtpStorage::IsDone {command conn} {
    ::pool::oo::support::SetupVars smtpStorage
    # @c Executed after SMTP storage is finished.
	#
	# @a command: The command to execute after closing the connection
	# @a command: represented by <a conn>.
	# @a conn:    The handle of the <c smtpConnection> object reporting
	# @a conn:    back.

	if {"[$conn state]" == "error"} {
	    Done $command 1 [$conn errorInfo]
	    $conn delete
	    return
	}

	$conn close -command [list $this AllDone $command]
	return
}



proc ::pool::oo::class::smtpStorage::storeMessage {command message} {
    ::pool::oo::support::SetupVars smtpStorage
    # @c Store the given message via SMTP and the local mail demon.
	#
	# @a command: The script evaluate after completion of the process (use
	# @a command: <m Done> to accomplish this). Allowed to be empty,
	# @a command: nothing is done in that case. Gets either 'error' or
	# @a command: 'done' as first argument.
	# @a message: The text of the message to store.

	set conn ${this}Smtp[::pool::serial::new]

	smtpConnection $conn -helo $opt(-helo)

	$conn put  -from	$opt(-from)		 -to		$opt(-to)		 -message	$message		 -string	1			 -command	[list $this IsDone $command]
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::smtpStorage::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::popClientStorageBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences smtpStorage

# Create object instantiation procedure
interp alias {} smtpStorage {} ::pool::oo::support::New smtpStorage

# -------------------------------


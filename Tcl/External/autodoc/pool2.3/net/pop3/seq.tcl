# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/seq.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3Sequencer <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3Sequencer {
    variable  _superclasses    sequencer
    variable  _scChainForward  pop3Sequencer
    variable  _scChainBackward pop3Sequencer
    variable  _classVariables  {}
    variable  _methods         {IsError Log OnDone Write}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {sock {pop3Sequencer {-default {} -type ::pool::getopt::notype -action {} -class Sock}} done {pop3Sequencer {-default {} -type ::pool::getopt::notype -action {} -class Done}} conn {pop3Sequencer {-default {} -type ::pool::getopt::notype -action {} -class Conn}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {Log . IsError . OnDone . Write .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3Sequencer::IsError {line} {
    ::pool::oo::support::SetupVars pop3Sequencer
    # @c Determines the error state of the POP3 response contained in
	# @c <a line>.
	# @a line: The response to check.
	# @r 1 in case of an error detected, 0 else.

	set response [lindex $line 0]

	if {"$response" == "+OK"} {
	    return 0
	} else {
	    return 1
	}
}



proc ::pool::oo::class::pop3Sequencer::Log {text} {
    ::pool::oo::support::SetupVars pop3Sequencer
    # @c Logs the specified <a text> using syslog facility of Pool.
	# @a text: The text to log.

	::pool::syslog::syslog debug $opt(-conn) < $text
	return
}



proc ::pool::oo::class::pop3Sequencer::OnDone {} {
    ::pool::oo::support::SetupVars pop3Sequencer
    # @c Overides base class definition <m sequencer:OnDone> to call the
	# @c completion method in the associated pop3 connection object.

	return [$opt(-conn) $opt(-done) $this]
}



proc ::pool::oo::class::pop3Sequencer::Write {text} {
    ::pool::oo::support::SetupVars pop3Sequencer
    # @c Send the specified <a text> to the pop3 demon. Additionally logs
	# @c it using the syslog facility of Pool.
	#
	# @a text: The text to send to the pop3 demon.

	puts                         $opt(-sock)   $text
	::pool::syslog::syslog debug $opt(-conn) > $text
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3Sequencer::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3Sequencer

# Create object instantiation procedure
interp alias {} pop3Sequencer {} ::pool::oo::support::New pop3Sequencer

# -------------------------------


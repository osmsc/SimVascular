# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/smtp/seq.cls'.
# Date: Thu Sep 14 23:03:30 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> smtpSequencer <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::smtpSequencer {
    variable  _superclasses    sequencer
    variable  _scChainForward  smtpSequencer
    variable  _scChainBackward smtpSequencer
    variable  _classVariables  {}
    variable  _methods         {IsError Log OnDone Write}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {sock {smtpSequencer {-default {} -type ::pool::getopt::notype -action {} -class Sock}} done {smtpSequencer {-default {} -type ::pool::getopt::notype -action {} -class Done}} conn {smtpSequencer {-default {} -type ::pool::getopt::notype -action {} -class Conn}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {Log . IsError . OnDone . Write .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::smtpSequencer::IsError {line} {
    ::pool::oo::support::SetupVars smtpSequencer
    # @c Determines the error state of the SMTP response contained in
	# @c <a line>.
	# @a line: The response to check.
	# @r 1 in case of an error detected, 0 else.

	set response [lindex $line 0]

	if {(200 <= $response) && ($response < 300)} {
	    return 0
	} else {
	    return 1
	}
}



proc ::pool::oo::class::smtpSequencer::Log {text} {
    ::pool::oo::support::SetupVars smtpSequencer
    # @c Logs the specified <a text> using syslog facility of Pool.
	# @a text: The text to log.

	::pool::syslog::syslog debug $opt(-conn) < $text
	return
}



proc ::pool::oo::class::smtpSequencer::OnDone {} {
    ::pool::oo::support::SetupVars smtpSequencer
    # @c Overides base class definition <m sequencer:OnDone> to call the
	# @c completion method in the associated smtp connection object.

	return [$opt(-conn) $opt(-done) $this]
}



proc ::pool::oo::class::smtpSequencer::Write {text} {
    ::pool::oo::support::SetupVars smtpSequencer
    # @c Send the specified <a text> to the smtp demon. Additionally logs
	# @c it using the syslog facility of Pool.

	# @a text: The text to send to the smtp demon.

	puts                         $opt(-sock)   $text
	::pool::syslog::syslog debug $opt(-conn) > $text
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::smtpSequencer::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::sequencer::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences smtpSequencer

# Create object instantiation procedure
interp alias {} smtpSequencer {} ::pool::oo::support::New smtpSequencer

# -------------------------------


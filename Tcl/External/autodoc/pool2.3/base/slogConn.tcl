# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/base/slogConn.cls'.
# Date: Thu Sep 14 23:03:44 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> syslogConnection <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::syslogConnection {
    variable  _superclasses    {}
    variable  _scChainForward  syslogConnection
    variable  _scChainBackward syslogConnection
    variable  _classVariables  {}
    variable  _methods         log

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options  {prefix {syslogConnection {-default {} -type ::pool::getopt::notype -action {} -class Prefix}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {log .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::syslogConnection::log {level args} {
    ::pool::oo::support::SetupVars syslogConnection
    # @c Forwards incoming data to <p ::pool::syslog::syslog>, additionally
	# @c adds the stored prefix to the message.
	#
	# @a level: relative importance of the message.
	# @a args:  List of texts to log.

	::pool::syslog::syslog $level $opt(-prefix): $args
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::syslogConnection::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods syslogConnection
::pool::oo::support::FixOptions syslogConnection

# Create object instantiation procedure
interp alias {} syslogConnection {} ::pool::oo::support::New syslogConnection

# -------------------------------


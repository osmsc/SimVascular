# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/base/remoteLog.cls'.
# Date: Thu Sep 14 23:03:44 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> remoteLog <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::remoteLog {
    variable  _superclasses    {}
    variable  _scChainForward  remoteLog
    variable  _scChainBackward remoteLog
    variable  _classVariables  {}
    variable  _methods         {TrackPortSpec constructor log}

    variable  _variables
    array set _variables  {socket {remoteLog {isArray 0 initialValue {}}} port {remoteLog {isArray 0 initialValue {}}} host {remoteLog {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {portspec {remoteLog {-default {} -type ::pool::getopt::notype -action TrackPortSpec -class Portspec}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {TrackPortSpec . constructor . log .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::remoteLog::TrackPortSpec {option oldValue} {
    ::pool::oo::support::SetupVars remoteLog
    # @c Configure procedure. Propagates changes to the port specification
	# @c to <v host>, <v port> and <v socket>.
	#
	# @a option:   The changed option.
	# @a oldValue: The old value of the option.

	if {$opt(-portspec) == {}} {
	    catch {close $socket}
	    set port   ""
	    set host   ""
	    set socket ""

	    # switch syslog off
	    ::pool::syslog::def {}
	} else {
	    set host   [lindex $opt(-portspec) 0]
	    set port   [lindex $opt(-portspec) 1]
	    set socket [socket $host $port]
	    
	    fconfigure $socket -buffering line -translation crlf -blocking 0

	    # start logging
	    ::pool::syslog::def [list $this log]
	}

	return
}



proc ::pool::oo::class::remoteLog::constructor {} {
    ::pool::oo::support::SetupVars remoteLog
    # @c Constructor, initializes the port specification (as empty)
	# @c <o portspec>.

	TrackPortSpec -portspec {}
	return
}



proc ::pool::oo::class::remoteLog::log {level text} {
    ::pool::oo::support::SetupVars remoteLog
    # @c This method sends the incoming messages down the <v socket>.
	#
	# @a level: Relative importance of the logged message. Should be one
	# @a level: of the strings returned by <p ::pool::syslog::levels>.
	#
	# @a text: The message to log.

	# standard log
	#puts stderr "($port) $level\t$text"
	# puts stderr "$level\t$text"

	if {$port == {}} {return}

	#    puts stderr "--$level\t$text"

	if {[catch {puts $socket "$level $text"} errmsg]} {
	    catch {close $socket}
	    set port   ""
	    set host   ""
	    set socket ""

	    ::pool::syslog::def {}

	    puts stderr "error\tremotelog problem: $errmsg"
	}

	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::remoteLog::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods remoteLog
::pool::oo::support::FixOptions remoteLog

# Create object instantiation procedure
interp alias {} remoteLog {} ::pool::oo::support::New remoteLog

# -------------------------------


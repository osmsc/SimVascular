# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/pop3.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3Connection <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3Connection {
    variable  _superclasses    {}
    variable  _scChainForward  pop3Connection
    variable  _scChainBackward pop3Connection
    variable  _classVariables  {}
    variable  _methods         {ClearSocket Close Dele LoginApop LoginUser Open Retr SetGreeting SetN SetSock Top constructor destructor errorInfo state}

    variable  _variables
    array set _variables  {sock {pop3Connection {isArray 0 initialValue {}}} greeting {pop3Connection {isArray 0 initialValue {}}} state {pop3Connection {isArray 0 initialValue {}}} n {pop3Connection {isArray 0 initialValue {}}} error {pop3Connection {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {progress {pop3Connection {-default {} -type ::pool::getopt::notype -action {} -class Progress}} retrydelay {pop3Connection {-default 10000 -type ::pool::getopt::integer -action {} -class Retrydelay}} maxtries {pop3Connection {-default 1 -type ::pool::getopt::integer -action {} -class Maxtries}} secret {pop3Connection {-default {} -type ::pool::getopt::nonempty -action {} -class Secret}} blocksize {pop3Connection {-default 1024 -type ::pool::getopt::integer -action {} -class Blocksize}} host {pop3Connection {-default localhost -type ::pool::getopt::nonempty -action {} -class Host}} use-top-for-retr {pop3Connection {-default 0 -type ::pool::getopt::boolean -action {} -class Use-top-for-retr}} user {pop3Connection {-default {} -type ::pool::getopt::nonempty -action {} -class User}} timeout {pop3Connection {-default {} -type ::pool::getopt::notype -action {} -class Timeout}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {ClearSocket . state . Open . SetN . SetSock . errorInfo . constructor . destructor . LoginUser . LoginApop . SetGreeting . Dele . Top . Retr . Close .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3Connection::ClearSocket {} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Closes the connection to the pop3 server described
	# @c by this object.

	catch {close $sock}
	set    sock ""
	return
}



proc ::pool::oo::class::pop3Connection::Close {completionMethod} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Close connection to the pop3 demon described by this object.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	# create the sequencer ...

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	pop3CloseSeq ${this}_close  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock

	# ... and start its operation.

	${this}_close event next
	return
}



proc ::pool::oo::class::pop3Connection::Dele {msgId completionMethod} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Delete the specified message.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.
	# @a msgId:            The numerical index of the message to delete.

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3DeleteSeq ${this}_dele  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock              -msg        $msgId

	# ... and start its operation.

	${this}_dele event next
	return
}



proc ::pool::oo::class::pop3Connection::LoginApop {completionMethod} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Logs into the pop3 server described by this object using given
	# @c username and password. The password is not transfered to the
	# @c server. A hashcode constructed from it and the server greeting
	# @c (the timestamp in it) is used instead.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	# create the sequencer ...

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 server"
	}

	pop3ApopSeq ${this}_apop  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock              -user       $opt(-user)        -secret     $opt(-secret)      -greeting   $greeting

	# ... and start its operation.

	${this}_apop event next
	return
}



proc ::pool::oo::class::pop3Connection::LoginUser {completionMethod} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Logs into the pop3 server described by this object using given
	# @c username and password. The password is send in the clear.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	# create the sequencer ...

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 server"
	}

	pop3UserSeq ${this}_user  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock              -user       $opt(-user)        -secret     $opt(-secret)

	# ... and start its operation.

	${this}_user event next
	return
}



proc ::pool::oo::class::pop3Connection::Open {completionMethod} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Opens a connection to the pop3 demon described by this object.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	if {$completionMethod == {}} {
	    error "no command specified"
	}

	# create the sequencer ...

	pop3OpenSeq ${this}_open  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -maxtries   $opt(-maxtries)    -retrydelay $opt(-retrydelay)  -host       $opt(-host)        
	# ... and start its operation.

	${this}_open event next
	return
}



proc ::pool::oo::class::pop3Connection::Retr {msgId completionMethod} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Retrieve the specified message.
	#
	# @a msgId:            The numerical index of the requested message.
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3RetrSeq ${this}_retr  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock              -msg        $msgId

	# ... and start its operation.

	${this}_retr event next
	return
}



proc ::pool::oo::class::pop3Connection::SetGreeting {g} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Accessor method, used by the <c pop3ApopSeq> / <c pop3UserSeq>
	# @c sequencer to transfer the received greeting into the connection
	# @c manager (this object).
	#
	# @a g: The text of the received greeting.

	set greeting $g
	return
}



proc ::pool::oo::class::pop3Connection::SetN {num} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Accessor method, used by the <c pop3ApopSeq> / <c pop3UserSeq>
	# @c to transfer the number of found messages into the connection
	# @c manager.
	#
	# @a num: The number of found messages (as given by STAT).

	set n $num
	return
}



proc ::pool::oo::class::pop3Connection::SetSock {s} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Accessor method, used by the <c pop3OpenSeq> sequencer to transfer
	# @c information about the channel representing the connection to the
	# @c pop server.
	#
	# @a s: The handle of the channel representing the connection to the
	# @a s: pop server.

	set sock $s
	return
}



proc ::pool::oo::class::pop3Connection::Top {msgId completionMethod} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Read header information of the specified message.
	#
	# @a completionMethod: The method to call after completion of the
	# @a completionMethod: low-level sequencer.
	# @a msgId:            The numerical index of the message whose
	# @m msgId:            headers are requested.

	if {$completionMethod == {}} {
	    error "no command specified"
	}
	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3TopSeq ${this}_top  -timeout    $opt(-timeout)     -conn       $this              -done       $completionMethod  -sock       $sock              -msg        $msgId

	# ... and start its operation.

	${this}_top event next
	return
}



proc ::pool::oo::class::pop3Connection::constructor {} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Constructor. Just logs the event.

	::pool::syslog::syslog info $this created
	return
}



proc ::pool::oo::class::pop3Connection::destructor {} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Destructor. Closes an active socket and logs the event.

	ClearSocket
	::pool::syslog::syslog info $this deleted
	return
}



proc ::pool::oo::class::pop3Connection::errorInfo {} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Retrieves error information of this object.
	# @c Valid only in case of state = error.

	return $error
}



proc ::pool::oo::class::pop3Connection::state {} {
    ::pool::oo::support::SetupVars pop3Connection
    # @c Retrieves state of this object.

	return $state
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3Connection::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods pop3Connection
::pool::oo::support::FixOptions pop3Connection

# Create object instantiation procedure
interp alias {} pop3Connection {} ::pool::oo::support::New pop3Connection

# -------------------------------


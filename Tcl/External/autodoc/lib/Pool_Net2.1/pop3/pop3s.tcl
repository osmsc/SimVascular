# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/pop3s.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3SynConnection <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3SynConnection {
    variable  _superclasses    {}
    variable  _scChainForward  pop3SynConnection
    variable  _scChainBackward pop3SynConnection
    variable  _classVariables  {}
    variable  _methods         {ClearSocket Close Dele Done LoginApop LoginUser Open Retr SetGreeting SetN SetSock Top constructor destructor errorInfo state}

    variable  _variables
    array set _variables  {sock {pop3SynConnection {isArray 0 initialValue {}}} greeting {pop3SynConnection {isArray 0 initialValue {}}} state {pop3SynConnection {isArray 0 initialValue {}}} n {pop3SynConnection {isArray 0 initialValue {}}} error {pop3SynConnection {isArray 0 initialValue {}}} backsignal {pop3SynConnection {isArray 0 initialValue {}}}}

    variable  _options
    array set _options  {progress {pop3SynConnection {-default {} -type ::pool::getopt::notype -action {} -class Progress}} retrydelay {pop3SynConnection {-default 10000 -type ::pool::getopt::integer -action {} -class Retrydelay}} maxtries {pop3SynConnection {-default 1 -type ::pool::getopt::integer -action {} -class Maxtries}} secret {pop3SynConnection {-default {} -type ::pool::getopt::nonempty -action {} -class Secret}} blocksize {pop3SynConnection {-default 1024 -type ::pool::getopt::integer -action {} -class Blocksize}} host {pop3SynConnection {-default localhost -type ::pool::getopt::nonempty -action {} -class Host}} use-top-for-retr {pop3SynConnection {-default 0 -type ::pool::getopt::boolean -action {} -class Use-top-for-retr}} user {pop3SynConnection {-default {} -type ::pool::getopt::nonempty -action {} -class User}} timeout {pop3SynConnection {-default {} -type ::pool::getopt::notype -action {} -class Timeout}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {ClearSocket . state . Open . SetN . SetSock . Done . errorInfo . constructor . destructor . LoginUser . LoginApop . SetGreeting . Dele . Top . Retr . Close .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3SynConnection::ClearSocket {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Closes the connection to the pop3 server described
	# @c by this object.

	catch {close $sock}
	set    sock ""
	return
}



proc ::pool::oo::class::pop3SynConnection::Close {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Close connection to the pop3 demon described by this object.

	# create the sequencer ...

	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	pop3CloseSeq ${this}_close  -timeout    $opt(-timeout)     -conn       $this              -done       Done  -sock       $sock

	# ... and start its operation.

	${this}_close event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
}



proc ::pool::oo::class::pop3SynConnection::Dele {msgId} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Delete the specified message.
	#
	# @a msgId:            The numerical index of the message to delete.

	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3DeleteSeq ${this}_dele  -timeout    $opt(-timeout)     -conn       $this              -done       Done  -sock       $sock              -msg        $msgId

	# ... and start its operation.

	${this}_dele event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
}



proc ::pool::oo::class::pop3SynConnection::Done {seq} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c This method is called after an operation ends.
	# @a seq: The handle of the internal sequencer which executed the completed operation.

	::pool::syslog::syslog debug "Done $seq with state <[$seq state]>"

	set state [$seq state]
	if {$state != "done"} {
	    set error [$seq errorInfo]
	} else {
	    set error ""
	}
	# set backsignal 1 ; # <-- this is not ok, need exact path to make
	# vwait understand which var to wait for.

	set ::${this}::backsignal 1 ; # -- stop inner event loop
	return
}



proc ::pool::oo::class::pop3SynConnection::LoginApop {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Logs into the pop3 server described by this object using given
	# @c username and password. The password is not transfered to the
	# @c server. A hashcode constructed from it and the server greeting
	# @c (the timestamp in it) is used instead.

	# create the sequencer ...

	if {$sock == {}} {
	    error "no connection to pop3 server"
	}

	pop3ApopSeq ${this}_apop  -timeout    $opt(-timeout)     -conn       $this              -done       Done  -sock       $sock              -user       $opt(-user)        -secret     $opt(-secret)      -greeting   $greeting

	# ... and start its operation.

	${this}_apop event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
}



proc ::pool::oo::class::pop3SynConnection::LoginUser {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Logs into the pop3 server described by this object using given
	# @c username and password. The password is send in the clear.

	# create the sequencer ...

	if {$sock == {}} {
	    error "no connection to pop3 server"
	}

	pop3UserSeq ${this}_user  -timeout    $opt(-timeout)     -conn       $this              -done       Done  -sock       $sock              -user       $opt(-user)        -secret     $opt(-secret)

	# ... and start its operation.

	${this}_user event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
}



proc ::pool::oo::class::pop3SynConnection::Open {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Opens a connection to the pop3 demon described by this object.

	# create the sequencer ...

	pop3OpenSeq ${this}_open  -timeout    $opt(-timeout)     -conn       $this              -done       Done	       -maxtries   $opt(-maxtries)    -retrydelay $opt(-retrydelay)  -host       $opt(-host)        
	# ... and start its operation.

	${this}_open event next

	#vwait backsignal -- upvar'd variable not enough, need exact path.

	vwait ::${this}::backsignal
	::pool::syslog::syslog debug "Open: $state $error"

	# return state and error information from the sequencer.
	list $state $error
}



proc ::pool::oo::class::pop3SynConnection::Retr {msgId} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Retrieve the specified message.
	#
	# @a msgId:            The numerical index of the requested message.

	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3RetrSeq ${this}_retr  -timeout    $opt(-timeout)     -conn       $this              -done       Done  -sock       $sock              -msg        $msgId

	# ... and start its operation.

	${this}_retr event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
}



proc ::pool::oo::class::pop3SynConnection::SetGreeting {g} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Accessor method, used by the <c pop3ApopSeq> / <c pop3UserSeq>
	# @c sequencer to transfer the received greeting into the connection
	# @c manager (this object).
	#
	# @a g: The text of the received greeting.

	set greeting $g
	return
}



proc ::pool::oo::class::pop3SynConnection::SetN {num} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Accessor method, used by the <c pop3ApopSeq> / <c pop3UserSeq>
	# @c to transfer the number of found messages into the connection
	# @c manager.
	#
	# @a num: The number of found messages (as given by STAT).

	set n $num
	return
}



proc ::pool::oo::class::pop3SynConnection::SetSock {s} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Accessor method, used by the <c pop3OpenSeq> sequencer to transfer
	# @c information about the channel representing the connection to the
	# @c pop server.
	#
	# @a s: The handle of the channel representing the connection to the
	# @a s: pop server.

	set sock $s
	return
}



proc ::pool::oo::class::pop3SynConnection::Top {msgId} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Read header information of the specified message.
	#
	# @a msgId:            The numerical index of the message whose
	# @a msgId:            headers are requested.

	if {$msgId == {}} {
	    error "no message specified"
	}
	if {$sock == {}} {
	    error "no connection to pop3 demon"
	}

	# create the sequencer ...

	pop3TopSeq ${this}_top  -timeout    $opt(-timeout)     -conn       $this              -done       Done  -sock       $sock              -msg        $msgId

	# ... and start its operation.

	${this}_top event next

	vwait ::${this}::backsignal
	# return state and error information from the sequencer.
	list $state $error
}



proc ::pool::oo::class::pop3SynConnection::constructor {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Constructor. Just logs the event.

	::pool::syslog::syslog info $this created
	return
}



proc ::pool::oo::class::pop3SynConnection::destructor {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Destructor. Closes an active socket and logs the event.

	ClearSocket
	::pool::syslog::syslog info $this deleted
	return
}



proc ::pool::oo::class::pop3SynConnection::errorInfo {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Retrieves error information of this object.
	# @c Valid only in case of state = error.

	return $error
}



proc ::pool::oo::class::pop3SynConnection::state {} {
    ::pool::oo::support::SetupVars pop3SynConnection
    # @c Retrieves state of this object.

	return $state
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3SynConnection::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods pop3SynConnection
::pool::oo::support::FixOptions pop3SynConnection

# Create object instantiation procedure
interp alias {} pop3SynConnection {} ::pool::oo::support::New pop3SynConnection

# -------------------------------


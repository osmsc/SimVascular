# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/server.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> server <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::server {
    variable  _superclasses    {}
    variable  _scChainForward  server
    variable  _scChainBackward server
    variable  _classVariables  servers
    variable  _methods         {Attach CloseConnection Detach DoCloseConnection GreetPeer HandleCommand HandleNewConnection HandleUnknownCmd InitializeNewConnection Log Respond2Client SetCmdMap constructor destructor managesSock reportError start}

    variable  _variables
    array set _variables  {connMap {server {isArray 1 initialValue {}}} port {server {isArray 0 initialValue {}}} sockMap {server {isArray 1 initialValue {}}} cmdMap {server {isArray 1 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {HandleUnknownCmd . DoCloseConnection . Detach . GreetPeer . InitializeNewConnection . managesSock . Attach . CloseConnection . constructor . SetCmdMap . HandleNewConnection . destructor . Log . HandleCommand . Respond2Client . reportError . start .}

    # class variables
    variable  servers
    array set servers {}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::server::Attach {connId} {
    ::pool::oo::support::SetupVars server
    # @c Reenables listening for commands for the given connection.
	# @c See <m Detach> too.

	# @a connId: Connection identifier referencing into <v connMap>.

	set sock  $connMap($connId)
	fileevent $sock readable [list $this HandleCommand $connId $sock]
	return
}



proc ::pool::oo::class::server::CloseConnection {} {
    ::pool::oo::support::SetupVars server
    # @c Abstract method. Called by <m DoCloseConnection> to execute
	# @c class specific code. Should do any class specific cleanup for
	# @c the connection in destruction.

	#error "abstract method 'newConnection' not overidden"
}



proc ::pool::oo::class::server::Detach {connId} {
    ::pool::oo::support::SetupVars server
    # @c After this call the given connection does not listen for
	# @c commands anymore. This is useful to allow temporary operation
	# @c of 'fcopy' et. al. The complementary command is <m Attach>.

	# @a connId: Connection identifier referencing into <v connMap>.

	fileevent $connMap($connId) readable {}
	return
}



proc ::pool::oo::class::server::DoCloseConnection {connId} {
    ::pool::oo::support::SetupVars server
    # @c Closes the connection described by <a connId>. Must be associated
	# @c to this server. Closes the associated channel, then cleans and
	# @c destroys the connection descriptor. Uses the abstract method
	# @c <m CloseConnection> to execute class specific code.

	# @a connId: Connection identifier referencing into <v connMap>.

	::pool::syslog::syslog debug $this $connId closing connection

	set sock $connMap($connId)

	close $sock

	unset sockMap($sock)
	unset connMap($connId)

	catch {$this CloseConnection $connId} errmsg

	::pool::syslog::syslog notice this $connId closed
	return
}



proc ::pool::oo::class::server::GreetPeer {connId} {
    ::pool::oo::support::SetupVars server
    # @c Abstract method. Called by <m HandleNewConnection> to execute
	# @c class specific code. Should sent a greeting message to the new
	# @c client.

	# @a connId: Connection identifier referencing into <v connMap>.

	#error "abstract method 'GreetPeer' not overidden"
}



proc ::pool::oo::class::server::HandleCommand {connId sock} {
    ::pool::oo::support::SetupVars server
    # @c Called by the event system after arrival of a new command for
	# @c connection <a connId>.

	# @a connId: Connection identifier referencing into <v connMap>.
	# @a sock:   Direct access to the channel representing the connection.
	
	# client closed connection, bye bye
	if {[eof $sock]} {
	    DoCloseConnection $connId
	    return
	}

	# line was incomplete, wait for more
	if {[gets $sock line] < 0} {
	    return
	}

	::pool::syslog::syslog info $this $connId < $line

	set fail [catch {
	    set cmd [string tolower [lindex $line 0]]

	    if {![::info exists cmdMap($cmd)]} {
		# unknown, use unknown handler

		$this HandleUnknownCmd $connId $cmd $line
	    } else {
		$this $cmdMap($cmd)    $connId $cmd $line
	    }
	} errmsg] ;#{}


	if {$fail} {
	    # Had an error during handling of 'cmd'.
	    # Handled by closing the connection.
	    # (the framework does not know how to relay the internal
	    # error to the client)

	    ::pool::syslog::syslog error $this $connId $cmd: $errmsg
	    DoCloseConnection $connId
	}

	return
}



proc ::pool::oo::class::server::HandleNewConnection {sock rHost rPort} {
    ::pool::oo::support::SetupVars server
    # @c A new connection to the server was opened. The connection
	# @c descriptor is generated and initialized. A greeting will be sent
	# @c upon sucessful completion of this task. In case of a failure the
	# @c connection is closed immediately, without any response. Uses the
	# @c abstract methods <m InitializeNewConnection> and <m GreetPeer> to
	# @c execute class specific setup code and the greeting of the new
	# @c client.

	# @a sock:  The channel handle of the new connection.
	# @a rHost: The host the client resides on.
	# @a rPort: The port used by the client.

	# @n This is the part of the code you have to change if you want to
	# @n implement a host based access scheme.

	set id c#[::pool::serial::new]

	set sockMap($sock) [list $rHost $rPort $id]
	set connMap($id)   $sock

	if {[catch {$this InitializeNewConnection $id} errmsg]} {
	    close $sock

	    ::pool::syslog::syslog error $this init $errmsg
	    unset sockMap($sock)
	    unset connMap($id)
	    return
	}

	fconfigure $sock -buffering line -translation crlf -blocking 0

	if {[catch {$this GreetPeer $id} errmsg]} {
	    close $sock

	    ::pool::syslog::syslog error $this greeting $errmsg
	    unset sockMap($sock)
	    unset connMap($id)
	    return
	}

	fileevent $sock readable [list $this HandleCommand $id $sock]
	return
}



proc ::pool::oo::class::server::HandleUnknownCmd {connId cmd line} {
    ::pool::oo::support::SetupVars server
    # @c Standard way of handling an unknown command sent by the client to
	# @c us. The 'error' is catched in <m HandleCommand>, reported via
	# @v syslog and causes a shutdown of the specified connection.

	# @a connId: Connection identifier referencing into <v connMap>.
	# @a cmd:    The name of the command not understood by the server.
	# @a line:   The complete line sent by the client.

	error "unknown command '$cmd'"
}



proc ::pool::oo::class::server::InitializeNewConnection {connId} {
    ::pool::oo::support::SetupVars server
    # @c Abstract method. Called by <m HandleNewConnection> to execute
	# @c class specific code. Should do any class specific initializations
	# @c for the new connection.

	# @a connId: Connection identifier referencing into <v connMap>.

	#error "abstract method 'newConnection' not overidden"
}



proc ::pool::oo::class::server::Log {level args} {
    ::pool::oo::support::SetupVars server
    # @c Convenience method, wraps around the syslog interface,
	# @c automatically adds the server handle to the written text.
	# @c See <p ::pool::syslog::syslog> too.
	#
	# @a level: Relative importance of the logged message. Should be one of
	# @a level: the strings returned by <p ::pool::syslog::levels>.
	# @a args:  List containing the texts to log.

	::pool::syslog::syslog $level $this $args
	return
}



proc ::pool::oo::class::server::Respond2Client {conn ok text} {
    ::pool::oo::support::SetupVars server
    # @c Internal procedure. Writes a response <a text> to the
	# @c client represented by <a conn>. To the caller it is
	# @c equivalent to the builtin 'return'.
	#	
	# @a conn: Descriptor of connection to write to.
	# @a ok:   Primary response, specific to the server subclass
	# @a text: Additional text following the primary response.

	set sock $connMap($conn)

	Log  info $conn > $ok $text
	puts $sock       "$ok $text"

	return
}



proc ::pool::oo::class::server::SetCmdMap {map} {
    ::pool::oo::support::SetupVars server
    # @c Used by derived classes to establish the mapping from command
	# @c names to their handler methods.
	#
	# @a map: The mapping in 'array set/get' format.

	# We can't simply use array get/set as command names are forced into
	# lowercase.

	foreach {cmd method} $map {
	    set cmdMap([string tolower $cmd]) $method
	}
	return
}



proc ::pool::oo::class::server::constructor {} {
    ::pool::oo::support::SetupVars server
    # @c Constructor. Installs the custom background error handler upon
	# @c the first call, see <f net/serverUtil.tcl>. Always registers the
	# @c new server in the map (<cv servers>) used by the error handler.

	::pool::oo::class::server::InstallBgError

	set servers($this) 1
}



proc ::pool::oo::class::server::destructor {} {
    ::pool::oo::support::SetupVars server
    # @c Destructor. This closes all currently open connections too.

	foreach c [array names connMap] {
	    DoCloseConnection $c
	}

	unset servers($this)
	return
}



proc ::pool::oo::class::server::managesSock {sock} {
    ::pool::oo::support::SetupVars server
    # @c Used by the custom background handler in <f net/serverUtil.tcl> to
	# @c check wether a socket is handled by the queried server or not.
	# @r a boolean value. 1 indicates that the socket is handled here.
	#
	# @a sock: The handle of the socket to look for.

	return [::info exists sockMap($sock)]
}



proc ::pool::oo::class::server::reportError {sock errmsg} {
    ::pool::oo::support::SetupVars server
    # @c Reports an error in the underlying server,
	# @c closes the affected connection.

	# @a sock:   Handle of the channel representing the connection.
	# @a errmsg: The message to print out.

	set connId $sockMap($sock)

	::pool::syslog::syslog error $this $connId $errmsg
	DoCloseConnection $connId
	return
}



proc ::pool::oo::class::server::start {} {
    ::pool::oo::support::SetupVars server
    # @c A server is dormant until this method is called.

	if {$port == {}} {error "no port to listen on"}

	socket -server [list $this HandleNewConnection] $port

	::pool::syslog::syslog debug $this starting...
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::server::loadClass {} {}

# Import standard methods, fix option processor definition (shortcuts)
::pool::oo::support::FixMethods server
::pool::oo::support::FixOptions server

# Create object instantiation procedure
interp alias {} server {} ::pool::oo::support::New server

# -------------------------------


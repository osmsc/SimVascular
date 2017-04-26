# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/pop3/server.cls'.
# Date: Thu Sep 14 23:03:28 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> pop3Server <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::pop3Server {
    variable  _superclasses    server
    variable  _scChainForward  pop3Server
    variable  _scChainBackward pop3Server
    variable  _classVariables  {serverFullname serverName serverVersion}
    variable  _methods         {CheckLogin CloseConnection GreetPeer H_apop H_dele H_list H_noop H_pass H_quit H_reset H_retr H_stat H_top H_user HandleUnknownCmd InitializeNewConnection TransferDone constructor}

    variable  _variables
    array set _variables  {connInfo {pop3Server {isArray 1 initialValue {}}}}

    variable  _options
    array set _options  {storage {pop3Server {-default {} -type ::pool::getopt::notype -action {} -class Storage}} userdb {pop3Server {-default {} -type ::pool::getopt::notype -action {} -class Userdb}}}

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {HandleUnknownCmd . H_dele . H_reset . TransferDone . H_stat . GreetPeer . H_retr . InitializeNewConnection . H_pass . H_user . CloseConnection . constructor . H_apop . H_top . H_quit . H_noop . H_list . CheckLogin .}

    # class variables
    variable  serverFullname {Popsy 0.1}
    variable  serverName Popsy
    variable  serverVersion 0.1

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::pop3Server::CheckLogin {conn clientid serverid storage} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Internal procedure. General code used by USER/PASS and
	# @c APOP login mechanisms to verify the given user-id.
	# @c Locks the mailbox in case of a match.
	#
	# @a conn:     Descriptor of connection to write to.
	# @a clientid: Authentication code transmitted by client
	# @a serverid: Authentication code calculated here.
	# @a storage:  Handle of mailbox requested by client.

	array set state $connInfo($conn)

	if {$storage == {}} {
	    # The user given by the client has no storage, therefore it does
	    # not exist. React as if wrong password was given.

	    set state(state) auth
	    set state(logon) ""

	    Log notice $conn state auth, no maildrop
	    Respond2Client $conn -ERR "authentication failed, sorry"

	} elseif {[string compare $clientid $serverid] != 0} {
	    # password/digest given by client dos not match

	    set state(state) auth
	    set state(logon) ""

	    Log notice $conn state auth, secret does not match
	    Respond2Client $conn -ERR "authentication failed, sorry"

	} elseif {! [$opt(-storage) lock $storage]} {
	    # maildrop is locked already (by someone else).

	    set state(state) auth
	    set state(logon) ""

	    Log notice $conn state auth, maildrop already locked
	    Respond2Client $conn -ERR  "could not aquire lock for maildrop $state(name)"
	} else {
	    # everything went fine. allow to proceed in session.

	    set state(storage) $storage
	    set state(state)   trans
	    set state(logon)   ""
	    set state(msg)     [$opt(-storage) stat $state(storage)]
	
	    Log notice $conn login $state(name) $storage $state(msg)
	    Log notice $conn state trans

	    Respond2Client $conn +OK "congratulations"
	}

	set connInfo($conn) [array get state]
	return
}



proc ::pool::oo::class::pop3Server::CloseConnection {conn} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Called by the general server to cleanup the pop3 specific part of
	# @c a new connection. Overides the baseclass definition
	# @c (<m server:CloseConnection>).
	#
	# @a conn: Descriptor of connection to write to.

	array set state $connInfo($conn)

	if {$state(storage) == {}} {
	    return
	}

	# remove possible lock set in storage facility.
	if {[catch {$opt(-storage) unlock $state(storage)} errormessage]} {
	    Log error $conn storage problem: $errormessage

	    # -W- future ? kill all connections, execute clean up of storage
	    # -W-          facility.
	}

	set state(storage) {}

	set connInfo($conn) [array get state]
	return
}



proc ::pool::oo::class::pop3Server::GreetPeer {conn} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Called after the initialization of a new connection. Writes the
	# @c greeting to the new client. Overides the baseclass definition
	# @c (<m server:GreetPeer>).
	#
	# @a conn: Descriptor of connection to write to.

	array set state $connInfo($conn)

	Respond2Client $conn +OK  "[::info hostname] $serverFullname ready $state(id)"
	return
}



proc ::pool::oo::class::pop3Server::H_apop {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle APOP command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(logon)" == "user"} {
	    Respond2Client $conn -ERR "login mechanism USER/PASS was chosen"
	    return
	} elseif {"$state(state)" == "trans"} {
	    Respond2Client $conn -ERR "client already authenticated"
	    return
	}

	# The first two arguments to the command are user name and its
	# response to the challenge set by the server.

	set state(name)  [lindex $line 1]
	set state(logon) apop

	set digest  [lindex $line 2]
	set info    [$opt(-userdb) lookup $state(name)]
	set pwd     [lindex $info 0]
	set storage [lindex $info 1]

	Log debug $conn info = <$info>

	if {$storage == {}} {
	    # user does not exist, skip over digest computation
	    set connInfo($conn) [array get state]

	    CheckLogin $conn "" "" $storage
	    return
	}

	# Do the same algorithm as the client to generate a digest, then
	# compare our data with information sent by the client. As we are
	# using tcl 8.x there is need to use channels, an immediate
	# computation is possible.

	package require Trf

	set ourDigest [hex -mode encode [md5 "$state(id)$pwd"]]

	Log debug $conn digest input <$state(id)$pwd>
	Log debug $conn digest outpt <$ourDigest>
	Log debug $conn digest given <$digest>

	set connInfo($conn) [array get state]

	CheckLogin $conn $digest $ourDigest $storage
	return
}



proc ::pool::oo::class::pop3Server::H_dele {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle DELE command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	    return
	}

	set msgid [lindex $line 1]

	if {
	    ($msgid > $state(msg)) ||
	    ([lsearch $msgid $state(deleted)] >= 0)
	} {
	    Respond2Client $conn -ERR "no such message"
	} else {
	    lappend state(deleted) $msgid
	    Respond2Client $conn +OK "message $msgid deleted"
	}

	set connInfo($conn) [array get state]
	return
}



proc ::pool::oo::class::pop3Server::H_list {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle LIST command. Generates scan listing
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "fail"} {
	    Respond2Client $conn -ERR "login failed, no actions possible"
	    return
	} else if {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	    return
	}

	set msgid [lindex $line 1]

	if {$msgid == {}} {
	    # full listing
	    Respond2Client $conn +OK $state(n) messages

	    set n $state(n)

	    for {set i 0} {$i < $n} {incr n} {
		Respond2Client $conn $i  [$opt(-storage) size $state(storage) $i]
	    }

	    puts $connMap($conn) "."

	} else {
	    # listing for specified message

	    if {
		($msgid > $state(msg)) ||
		([lsearch $msgid $state(deleted)] >= 0)
	    }  {
		Respond2Client $conn -ERR "no such message"
		return
	    }

	    Respond2Client $conn +OK  "$msgid [$opt(-storage) size $state(storage) $msgid]"
	    return
	}
}



proc ::pool::oo::class::pop3Server::H_noop {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle NOOP command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "fail"} {
	    Respond2Client $conn -ERR "login failed, no actions possible"
	} elseif {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	} else {
	    Respond2Client $conn +OK ""
	}

	return
}



proc ::pool::oo::class::pop3Server::H_pass {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle PASS command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(logon)" == "apop"} {
	    Respond2Client $conn -ERR "login mechanism APOP was chosen"
	} elseif {"$state(state)" == "trans"} {
	    Respond2Client $conn -ERR "client already authenticated"
	} else {
	    # The password is given as the first argument of the command

	    set pwd  [lindex $line 1]
	    set info [$opt(-userdb) lookup $state(name)]

	    CheckLogin $conn $pwd [lindex $info 0] [lindex $info 1]
	}
	return
}



proc ::pool::oo::class::pop3Server::H_quit {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle QUIT command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	set state(state) update

	if {$state(deleted) != {}} {
	    $opt(-storage) dele $state(storage) $state(deleted)
	}

	after idle $this CloseConnection $conn

	Respond2Client $conn +OK  "[::info hostname] $serverFullname shutting down"

	set connInfo($conn) [array get state]
	return
}



proc ::pool::oo::class::pop3Server::H_reset {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle RSET command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "fail"} {
	    Respond2Client $conn -ERR "login failed, no actions possible"
	} elseif {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	} else {
	    set state(deleted) ""

	    Respond2Client $conn +OK "$state(msg) messages waiting"
	}

	set connInfo($conn) [array get state]
	return
}



proc ::pool::oo::class::pop3Server::H_retr {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle RETR command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	    return
	}

	set msgid [lindex $line 1]

	if {
	    ($msgid > $state(msg)) ||
	    ([lsearch $msgid $state(deleted)] >= 0)
	} {
	    Respond2Client $conn -ERR "no such message"
	} else {
	    Respond2Client $conn +OK  "[$opt(-storage) size $state(storage) $msgid] octets"

	    # Disable readable events for command channel This allows the
	    # transfer system of the storage mechanism to use 'fcopy'.

	    Detach    $conn
	    Log debug $conn transfering data

	    $opt(-storage) transfer  -done [list $this TransferDone $conn]  $state(storage) $msgid $connMap($conn)
	    # response already sent.
	}

	return
}



proc ::pool::oo::class::pop3Server::H_stat {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle STAT command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	} else {
	    Respond2Client $conn +OK  "$state(msg) messages waiting for retrieval"
	}

	return
}



proc ::pool::oo::class::pop3Server::H_top {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle RETR command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	    return
	}

	set msgid  [lindex $line 1]
	set nlines [lindex $line 2]

	if {
	    ($msgid > $state(msg)) ||
	    ([lsearch $msgid $state(deleted)] >= 0)
	} {
	    Respond2Client $conn -ERR "no such message"
	} elseif {$nlines == {}} {
	    Respond2Client $conn -ERR "missing argument: #lines to read"
	} elseif {$nlines == 0} {
	    # reroute special case
	    H_retr $conn $cmd $line
	} else {
	    Respond2Client $conn +OK  "[$opt(-storage) size $state(storage) $msgid] octets"
	
	    # Disable readable events for command channel This allows the
	    # transfer system of the storage mechanism to use 'fcopy'.

	    Detach    $conn
	    Log debug $conn transfering data

	    $opt(-storage) transfer  -lines $nlines   -done  [list $this TransferDone $conn]  $state(storage) $msgid $connMap($conn)
	    # response already sent.
	}

	return
}



proc ::pool::oo::class::pop3Server::H_user {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handle USER command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(logon)" == "apop"} {
	    Respond2Client $conn -ERR "login mechanism APOP was chosen"
	} elseif {"$state(state)" == "trans"} {
	    Respond2Client $conn -ERR "client already authenticated"
	} else {
	    # The user name is the first argument to the command

	    set state(name)  [lindex $line 1]
	    set state(logon) user

	    Respond2Client $conn +OK "please send PASS command"
	}

	set connInfo($conn) [array get state]	
	return
}



proc ::pool::oo::class::pop3Server::HandleUnknownCmd {conn cmd line} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Handler for commands not known to the server. Overides the
	# @c baseclass definition (<m server:HandleUnknownCmd>). Simply writes
	# @c an error response to the client.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The complete line sent by the client behind <a conn>.
	
	Respond2Client $conn -ERR "unknown command '$cmd'"
	return
}



proc ::pool::oo::class::pop3Server::InitializeNewConnection {conn} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Called by the base class to initialize the pop3 specific part of a
	# @c new connection. Overides the baseclass definition
	# @c (<m server:InitializeNewConnection>).
	#
	# @a conn: Descriptor of connection to write to.

	::pool::array::def state

	set sock     $connMap($conn)
	set connData $sockMap($sock)

	set rHost [lindex $connData 0]
	set rPort [lindex $connData 1]

	# id = unique handle of this connection, base of hashcode used in APOP.
	set state(id)  "<[clock clicks][::pool::serial::new][pid]@[::info hostname]>"
	set state(state)      "auth"
	set state(name)       ""
	set state(logon)      ""
	set state(storage)    ""
	set state(deleted)    ""
	set state(msg)        ""
	set state(remotehost) $rHost
	set state(remoteport) $rPort

	set connInfo($conn) [array get state]

	Log notice $conn opened $rHost $rPort $state(id)
	Log notice $conn state auth, waiting for logon
	return
}



proc ::pool::oo::class::pop3Server::TransferDone {conn} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Internal procedure. Called by the storage system after completion
	# @c of the transfer requested by the server. Reenables listening for
	# @c commands.
	#
	# @a conn: Descriptor of connection to write to.

	Attach    $conn
	Log debug $conn transfer complete, listening again
	return
}



proc ::pool::oo::class::pop3Server::constructor {} {
    ::pool::oo::support::SetupVars pop3Server
    # @c Constructor. Creates the core of a pop3 server. It handles all
	# @c interactions with a client, but relies on external code for
	# @c authentication and mail storage. Built on top of <c server>.

	# Trick: no builtin port definition, uses an external procedure to
	# provide the actual value. Allows redefinition of the used port for
	# testing purposes.

	set port [::pool::pop3::port]

	SetCmdMap {
	    USER H_user
	    PASS H_pass
	    APOP H_apop
	    STAT H_stat
	    DELE H_dele
	    RETR H_retr
	    TOP  H_top
	    QUIT H_quit
	    NOOP H_noop
	    RSET H_reset
	    LIST H_list
	}
	# -- UIDL -- not implemented --

	Log debug $this...
	return
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::pop3Server::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::server::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences pop3Server

# Create object instantiation procedure
interp alias {} pop3Server {} ::pool::oo::support::New pop3Server

# -------------------------------


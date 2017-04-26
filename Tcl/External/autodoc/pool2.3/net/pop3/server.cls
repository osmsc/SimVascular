# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: server.cls,v 1.1 1998/06/01 19:56:38 aku Exp $
#
# @c Core of a POP3 server (Popsy). All general operation is handled by the
# @c code in the baseclass <c server>. 
#
# @s POP3 server core (Popsy)
# @i POP3, mail server core, Popsy
#
# @see general <xref pop3info>, or <xref pop3s> for more specific info
# -----------------------------


class pop3Server : server {
    # @c A full fledged pop3 server, based upon the <c server> framework. The
    # @c only missing parts are a storage system handling mailboxes and mails
    # @c and a database of user accounts. These are delegated to external
    # @c objects, see option <o userdb> and <o storage>. See <xref pop3s> for
    # @c more. &p The UIDL command is not supported.

    classvar serverName     "Popsy"
    classvar serverVersion  "0.1"
    classvar serverFullname "Popsy 0.1"

    # @o userdb: Handle of the object giving us access to the database of users
    # @o userdb: and their associated passwords. Must be derived from class
    # @o userdb: <c userdbBase>.

    option userdb  -d  ""

    # @o storage: Handle of the object giving us access to the facility storing
    # @o storage: the mails known to the whole system. Must be derived from
    # @o storage: class <c popServerStorageBase>.

    option storage -d ""

    # @v connInfo: Maps connection handles to the state information required by
    # @v connInfo: the server. The data is stored in 'array set' format, for
    # @v connInfo: easy retrieval and update. Any method requiring access to
    # @v connInfo: the data of a specific connection will read and store
    # @v connInfo: 'connInfo(<conn>)' from/into the local array 'state'.

    var -array connInfo



    method pop3Server {} {
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


    method CheckLogin {conn clientid serverid storage} {
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
	    Respond2Client $conn -ERR \
		    "could not aquire lock for maildrop $state(name)"
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


    # - overidden abstract methods -


    method HandleUnknownCmd {conn cmd line} {
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


    method GreetPeer {conn} {
	# @c Called after the initialization of a new connection. Writes the
	# @c greeting to the new client. Overides the baseclass definition
	# @c (<m server:GreetPeer>).
	#
	# @a conn: Descriptor of connection to write to.

	array set state $connInfo($conn)

	Respond2Client $conn +OK \
		"[::info hostname] $serverFullname ready $state(id)"
	return
    }


    method InitializeNewConnection {conn} {
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
	set state(id) \
		"<[clock clicks][::pool::serial::new][pid]@[::info hostname]>"
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


    method CloseConnection {conn} {
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


    # - pop3 specific methods, work horses -

    method H_user {conn cmd line} {
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


    method H_pass {conn cmd line} {
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


    method H_apop {conn cmd line} {
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


    method H_stat {conn cmd line} {
	# @c Handle STAT command.
	#
	# @a conn: Descriptor of connection to write to.
	# @a cmd:  The sent command
	# @a line: The sent line, with <a cmd> as first word.

	array set state $connInfo($conn)

	if {"$state(state)" == "auth"} {
	    Respond2Client $conn -ERR "client not authenticated"
	} else {
	    Respond2Client $conn +OK \
		    "$state(msg) messages waiting for retrieval"
	}

	return
    }


    method H_dele {conn cmd line} {
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


    method H_retr {conn cmd line} {
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
	    Respond2Client $conn +OK \
		    "[$opt(-storage) size $state(storage) $msgid] octets"

	    # Disable readable events for command channel This allows the
	    # transfer system of the storage mechanism to use 'fcopy'.

	    Detach    $conn
	    Log debug $conn transfering data

	    $opt(-storage) transfer \
		    -done [list $this TransferDone $conn] \
		    $state(storage) $msgid $connMap($conn)
	    # response already sent.
	}

	return
    }


    method H_top  {conn cmd line} {
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
	    Respond2Client $conn +OK \
		    "[$opt(-storage) size $state(storage) $msgid] octets"
	
	    # Disable readable events for command channel This allows the
	    # transfer system of the storage mechanism to use 'fcopy'.

	    Detach    $conn
	    Log debug $conn transfering data

	    $opt(-storage) transfer \
		    -lines $nlines  \
		    -done  [list $this TransferDone $conn] \
		    $state(storage) $msgid $connMap($conn)
	    # response already sent.
	}

	return
    }


    method H_quit {conn cmd line} {
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

	Respond2Client $conn +OK \
		"[::info hostname] $serverFullname shutting down"

	set connInfo($conn) [array get state]
	return
    }


    method H_noop {conn cmd line} {
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


    method H_reset {conn cmd line} {
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


    method H_list {conn cmd line} {
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
		Respond2Client $conn $i \
			[$opt(-storage) size $state(storage) $i]
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

	    Respond2Client $conn +OK \
		    "$msgid [$opt(-storage) size $state(storage) $msgid]"
	    return
	}
    }


    method TransferDone {conn} {
	# @c Internal procedure. Called by the storage system after completion
	# @c of the transfer requested by the server. Reenables listening for
	# @c commands.
	#
	# @a conn: Descriptor of connection to write to.

	Attach    $conn
	Log debug $conn transfer complete, listening again
	return
    }
}


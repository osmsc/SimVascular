#
# $Id: comm.tcl,v 4.20 1998/05/30 20:37:51 loverso Exp $
# %%_OSF_FREE_COPYRIGHT_%%
# Copyright (C) 1995-1998 The Open Group.   All Rights Reserved.
# (Please see the file "comm.LICENSE" that accompanied this source,
#  or http://www.opengroup.org/www/dist_client/caubweb/COPYRIGHT.free.html)
#

#	comm works just like Tk's send, except that it uses sockets.
#	These commands work just like "send" and "winfo interps":
#
#		comm send ?-async? <id> <cmd> ?<arg> ...?
#		comm interps
#
#	See the manual page comm.n for further details on this package.
#

package provide Comm 3.7

###############################################################################
#
# See documentation for public methods of "comm"
#

proc comm {cmd args} {
    global comm
    set chan comm

    set method [array names comm $cmd*,method]	;# min unique
    if {[llength $method] == 1} {
	return [eval $comm($method)]
    } else {
	foreach c [array names comm *,method] {
		lappend cmds [lindex [split $c ,] 0]
	}
        error "bad subcommand \"$cmd\": should be [join [lsort $cmds] ", "]"
    }
}

###############################################################################
#
# Use this to replace "send" and "winfo interps"
#

proc comm_send {} {
    proc send {args} {
	eval comm send $args
    }
    rename winfo tk_winfo
    proc winfo {cmd args} {
	if ![string match in* $cmd] {return [eval [list tk_winfo $cmd] $args]}
	return [comm interps]
    }
    proc comm_send {} {}
}

###############################################################################
#
# Private and internal methods
#
# Do not call or alter any procs or variables from here down
#

if ![info exists comm(chans)] {
    array set comm {
	debug 0 chans {} localhost 127.0.0.1
	connecting,hook 1
	connected,hook 1
	incoming,hook 1
	eval,hook 1
	reply,hook 1
	lost,hook 1
	offerVers {3 2}
	acceptVers {3 2}
	defVers 2
    }
    set comm(lastport) [expr [pid] % 32768 + 9999]
    # fast check for acceptable versions
    foreach comm(_x) $comm(acceptVers) {
	set comm($comm(_x),vers) 1
    }
    catch {unset comm(_x)}
}

#
# Class variables:
#	lastport		saves last default listening port allocated 
#	debug			enable debug output
#	chans			list of allocated channels
#	$meth,method		body of method
#
# Channel instance variables:
# comm()
#	$ch,port		listening port (our id)
#	$ch,socket		listening socket
#	$ch,local		boolean to indicate if port is local
#	$ch,serial		next serial number for commands
#
#	$ch,hook,$hook		script for hook $hook
#
#	$ch,peers,$id		open connections to peers; ch,id=>fid
#	$ch,fids,$fid		reverse mapping for peers; ch,fid=>id
#	$ch,vers,$id		negotiated protocol version for id
#	$ch,pending,$id		list of outstanding send serial numbers for id
#
#	$ch,buf,$fid		buffer to collect incoming data		
#	$ch,result,$serial	result value set here to wake up sender
#	$ch,return,$serial	return codes to go along with result
#

proc commDebug arg {global comm; if $comm(debug) {uplevel 1 $arg}}

###############################################################################
#
# Create the methods on comm
# Perhaps this shouldn't store them as procs?
#
set comm(method,method) {
    if {[llength $args] == 1} {
	if [info exists comm([lindex $args 0],method)] {
	    return $comm([lindex $args 0],method)
	} else {
	    error "No such method"
	}
    }
    eval set [list comm([lindex $args 0],method)] [lrange $args 1 end]
}

if 0 {
	# Propogate result, code, and errorCode.  Can't just eval
	# otherwise TCL_BREAK gets turrned into TCL_ERROR.
	global errorInfo errorCode
	set code [catch [concat commSend $args] res]
	return -code $code -errorinfo $errorInfo -errorcode $errorCode $res
}
comm method connect	{ eval commConnect $args }
comm method self	{ set comm($chan,port) }
comm method channels	{ set comm(chans) }
comm method new		{ eval commNew $args }
comm method configure	{ eval commConfigure 0 $args }
comm method shutdown	{ eval commShutdown $args }
comm method abort	{ eval commAbort $args }
comm method destroy	{ eval commDestroy $args }
comm method hook	{ eval commHook $args }
comm method ids {
    set res $comm($chan,port)
    foreach {i id} [array get comm $chan,fids,*] {lappend res $id}
    set res
}
comm method interps [comm method ids]
comm method remoteid {
    if [info exists comm($chan,remoteid)] {
	set comm($chan,remoteid)
    } else {
	error "No remote commands processed yet"
    }
}
comm method debug {
    set comm(debug) [switch $args on - 1 {subst 1} default {subst 0}]
}
comm method init	{ error "This method is no longer supported" }

###############################################################################
#
# See the Tk send(n) or comm(n) man page for details on the arguments
#
# Usage: send ?-async? id cmd ?arg arg ...?
#
comm method send {
    set cmd send
    set i 0
    if [string match -async [lindex $args $i]] {
	set cmd async
	incr i
    }
    set id [lindex $args $i]
    incr i
    set args [lrange $args $i end]
    if ![info complete $args] {
	return -code error "Incomplete command"
    }
    if [string match "" $args] {
	return -code error "wrong # args: should be \"send ?-async? id arg ?arg ...?\""
    }

    if [catch {commConnect $id} fid] {
	return -code error "Connect to remote failed: $fid"
    }

    set ser [incr comm($chan,serial)]
    # This is unneeded - wraps from 2147483647 to -2147483648
    ### if {$comm($chan,serial) == 0x7fffffff} {set comm($chan,serial) 0}

    commDebug {puts stderr "send <[list [list $cmd $ser $args]]>"}

    # The double list assures that the command is a single list when read.
    puts $fid [list [list $cmd $ser $args]]
    flush $fid

    # wait for reply if so requested
    if [string match send $cmd] {
	upvar 0 comm($chan,pending,$id) pending	;# shorter variable name

	lappend pending $ser
	set comm($chan,return,$ser) ""		;# we're waiting
	vwait comm($chan,result,$ser)

	# if connection was lost, pending is gone
	if [info exists pending] {
	    set pos [lsearch -exact $pending $ser]
	    set pending [lreplace $pending $pos $pos]
	}

	commDebug {puts stderr "result <$comm($chan,return,$ser);$comm($chan,result,$ser)>"}
	after idle unset comm($chan,result,$ser)

	array set return $comm($chan,return,$ser)
	unset comm($chan,return,$ser)
	switch -- $return(-code) {
	    "" - 0 {return $comm($chan,result,$ser)}
	    1 {
		return -code $return(-code) \
			-errorinfo $return(-errorinfo) \
			-errorcode $return(-errorcode) \
			$comm($chan,result,$ser)
	    }
	    default {return -code $return(-code) $comm($chan,result,$ser)}
	}
    }
}

###############################################################################
#
# Create a new comm channel/instance
#
proc commNew {ch args} {
    global comm

    if {[lsearch -exact $comm(chans) $ch] >= 0} {
	error "Already existing channel: $ch"
    }
    if {([llength $args] % 2) != 0} {
	error "Must have an even number of config arguments"
    }
    if [string match comm $ch] {
	# allow comm to be recreated after destroy
    } elseif {![string compare $ch [info proc $ch]]} {
	error "Already existing command: $ch"
    } else {
	regsub "set chan \[^\n\]*\n" [info body comm] "set chan $ch\n" nbody
	proc $ch {cmd args} $nbody
    }
    lappend comm(chans) $ch
    set chan $ch
    set comm($chan,serial) 0
    set comm($chan,chan) $chan
    set comm($chan,port) 0
    set comm($chan,listen) 0
    set comm($chan,socket) ""
    set comm($chan,local) 1
    if {[llength $args] > 0} {
	eval commConfigure 1 $args
    }
    # XXX need to destroy chan if config failed
}

#
# Destroy the comm instance.
#
proc commDestroy {} {
    upvar chan chan
    global comm
    catch {close $comm($chan,socket)}
    commAbort
    catch {unset comm($chan,port)}
    catch {unset comm($chan,local)}
    catch {unset comm($chan,socket)}
    unset comm($chan,serial)
    set pos [lsearch -exact $comm(chans) $chan]
    set comm(chans) [lreplace $comm(chans) $pos $pos]
    if [string compare comm $chan] {
	rename $chan {}
    }
}

###############################################################################
#
#
#

proc commConfVars {v t} {
    global comm
    set comm($v,var) $t
    set comm(vars) {}
    foreach c [array names comm *,var] {
	lappend comm(vars) [lindex [split $c ,] 0]
    }
}
commConfVars port p
commConfVars local b
commConfVars listen b
commConfVars socket ro
commConfVars chan ro
commConfVars serial ro

proc commConfigure {{force 0} args} {
    upvar chan chan
    global comm

    # query
    switch [llength $args] {
	0 {
	    foreach v $comm(vars) {lappend res -$v $comm($chan,$v)}
	    return $res
	}
	1 {
	    set arg [lindex $args 0]
	    set var [string range $arg 1 end]
	    if {[string match -* $arg] && [info exists comm($var,var)]} {
		return $comm($chan,$var)
	    } else {
		error "Unknown configuration option: $arg"
	    }
	}
    }

    # set
    set opt 0
    foreach arg $args {
	incr opt
	if [info exists skip] {unset skip; continue}
	set var [string range $arg 1 end]
	if {![string match -* $arg] || ![info exists comm($var,var)]} {
	    error "Unknown configuration option: $arg"
	}
	set optval [lindex $args $opt]
	switch $comm($var,var) {
	    b { set $var [commBool $optval]; set skip 1 }
	    v { set $var $optval; set skip 1 }
	    p { if {[string compare $optval ""] && ![regexp {[0-9]+} $optval]} {
		    error "Non-port to configuration option: -$var"
		}
		set $var $optval
		set skip 1
	    }
	    i { if {![regexp {[0-9]+} $optval]} {
		    error "Non-integer to configuration option: -$var"
		}
		set $var $optval
		set skip 1
	    }
	    ro { error "Readonly configuration option: -$var" }
	}
    }
    if [info exists skip] {
	error "Missing value for option: $arg"
    }

    foreach var {port listen local} {
	if {[info exists $var] && [set $var] != $comm($chan,$var)} {
	    incr force
	    set comm($chan,$var) [set $var]
	}
    }

    # do not re-init socket
    if !$force return

    # User is recycling object, possibly to change from local to !local
    if [info exists comm($chan,socket)] {
	commAbort
	catch {close $comm($chan,socket)}
	unset comm($chan,socket)
    }

    set comm($chan,socket) ""
    if !$comm($chan,listen) {
	set comm($chan,port) 0
	return
    }

    if {[info exists port] && [string match "" $comm($chan,port)]} {
	set nport [incr comm(lastport)]
    } else {
	set userport 1
	set nport $comm($chan,port)
    } 
    while 1 {
	set cmd [list socket -server [list commIncoming $chan]]
	if $comm($chan,local) {
	    lappend cmd -myaddr $comm(localhost)
	}
	lappend cmd $nport
	if ![catch $cmd ret] {
	    break
	}
	if {[info exists userport] || ![string match "*already in use" $ret]} {
	    # don't erradicate the class
	    if ![string match comm $chan] {
		rename $chan {}
	    }
	    error $ret
	}
	set nport [incr comm(lastport)]
    }
    set comm($chan,socket) $ret

    # If port was 0, system allocated it for us
    set comm($chan,port) [lindex [fconfigure $ret -sockname] 2]

    return
}

#
# Process a boolean value
#
proc commBool b {
    switch -glob $b 0 - {[fF]*} - {[oO][fF]*} {return 0}
    return 1
}

###############################################################################
#
# Called to connect to a remote interp
#
proc commConnect {id} {
    upvar chan chan
    global comm

    commDebug {puts stderr "commConnect $id"}

    # process connecting hook now
    if [info exists comm($chan,hook,connecting)] {
    	eval $comm($chan,hook,connecting)
    }

    if [info exists comm($chan,peers,$id)] {
	return $comm($chan,peers,$id)
    }
    if {[lindex $id 0] == 0} {
	error "Remote comm is anonymous; cannot connect"
    }

    if {[llength $id] > 1} {
	set host [lindex $id 1]
    } else {
	set host $comm(localhost)
    }
    set port [lindex $id 0]
    set fid [socket $host $port]

    # process connected hook now
    if [info exists comm($chan,hook,connected)] {
    	if [catch $comm($chan,hook,connected) err] {
	    global errorInfo
	    set ei $errorInfo
	    close $fid
	    error $err $ei
	}
    }

    # commit new connection
    commNewConn $id $fid

    # send offered protocols versions and id to identify ourselves to remote
    puts $fid [list $comm(offerVers) $comm($chan,port)]
    set comm($chan,vers,$id) $comm(defVers)		;# default proto vers
    flush $fid
    return $fid
}

#
# Called for an incoming new connection
#
proc commIncoming {chan fid addr remport} {
    global comm

    commDebug {puts stderr "commIncoming $chan $fid $addr $remport"}

    # process incoming hook now
    if [info exists comm($chan,hook,incoming)] {
    	if [catch $comm($chan,hook,incoming) err] {
	    global errorInfo
	    set ei $errorInfo
	    close $fid
	    error $err $ei
	}
    }

    # a list of offered proto versions is the first word of first line
    # remote id is the second word of first line
    # rest of first line is ignored
    set protoline [gets $fid]
    set offeredvers [lindex $protoline 0]
    set remid [lindex $protoline 1]

    # use the first supported version in the offered list
    foreach v $offeredvers {
	if [info exists comm($v,vers)] {
	    set vers $v
	    break
	}
    }
    if ![info exists vers] {
	close $fid
	error "Unknown offered protocols \"$protoline\" from $addr/$remport"
    }

    # If the remote host addr isn't our local host addr,
    # then add it to the remote id.
    if [string compare [lindex [fconfigure $fid -sockname] 0] $addr] {
	set id [list $remid $addr]
    } else {
	set id $remid
    }

    # Detect race condition of two comms connecting to each other
    # simultaneously.  It is OK when we are talking to ourselves.
    if {[info exists comm($chan,peers,$id)] && $id != $comm($chan,port)} {
	puts stderr "commIncoming race condition: $id"
	puts stderr "peers=$comm($chan,peers,$id) port=$comm($chan,port)"
	# To avoid the race, we really want to terminate one connection.
	# However, both sides are commited to using it.  commConnect
	# needs to be sychronous and detect the close.
	# close $fid
	# return $comm($chan,peers,$id)
    }

    # Make a protocol response.  Avoid any temptation to use {$vers > 2} - this
    # forces forwards compatibility issues on protocol versions that haven't
    # been invented yet.  DON'T DO IT!  Instead, test for each supported
    # version explicitly.  I.e., {$vers >2 && $vers < 5} is OK.
    switch $vers {
	3 {				
	    # Respond with the selected version number
	    puts $fid [list [list vers $vers]]
	    flush $fid
	}
    }

    # commit new connection
    commNewConn $id $fid
    set comm($chan,vers,$id) $vers

}

#
# Common new connection processing
#
proc commNewConn {id fid} {
    upvar chan chan
    global comm

    commDebug {puts stderr "commNewConn $id $fid"}

    # There can be a race condition two where comms connect to each other
    # simultaneously.  This code favors our outgoing connection.
    if [info exists comm($chan,peers,$id)] {
	# abort this connection, use the existing one
	# close $fid
	# return -code return $comm($chan,peers,$id)
    } else {
	set comm($chan,pending,$id) {}
    	set comm($chan,peers,$id) $fid
    }
    set comm($chan,fids,$fid) $id
    fconfigure $fid -trans binary -blocking 0
    fileevent $fid readable [list commCollect $chan $fid]
}

###############################################################################
#
#
# Close down a peer connection.
#
proc commShutdown {id} {
    upvar chan chan
    global comm

    if [info exists comm($chan,peers,$id)] {
	commLostConn $comm($chan,peers,$id) "Connection shutdown by request"
    }
}

#
# Close down all peer connections
#
proc commAbort {} {
    upvar chan chan
    global comm

    foreach pid [array names comm $chan,peers,*] {
	commLostConn $comm($pid) "Connection aborted by request"
    }
}

# Called to tidy up a lost connection, including aborting ongoing sends
# Each send should clean themselves up in pending/result.
#
proc commLostConn {fid {reason "target application died or connection lost"}} {
    upvar chan chan
    global comm

    commDebug {puts stderr "commLostConn $fid $reason"}

    catch {close $fid}

    set id $comm($chan,fids,$fid)

    foreach s $comm($chan,pending,$id) {
	set comm($chan,return,$s) {-code error}
	set comm($chan,result,$s) $reason
    }
    unset comm($chan,pending,$id)
    unset comm($chan,fids,$fid)
    catch {unset comm($chan,peers,$id)}		;# race condition
    catch {unset comm($chan,buf,$fid)}

    # process lost hook now
    catch {catch $comm($chan,hook,lost)}

    return $reason
}

###############################################################################
#
# Hook support
#

proc commHook {hook {script +}} {
    upvar chan chan
    global comm
    if ![info exists comm($hook,hook)] {
	error "Unknown hook invoked"
    }
    if !$comm($hook,hook) {
	error "Unimplemented hook invoked"
    }
    if [string match + $script] {
	if [catch {set comm($chan,hook,$hook)} ret] {
	    return ""
	}
	return $ret
    }
    if [string match +* $script] {
	append comm($chan,hook,$hook) \n [string range $script 1 end]
    } else {
	set comm($chan,hook,$hook) $script
    }
}

###############################################################################
#
# Called from the fileevent to read from fid and append to the buffer.
# This continues until we get a whole command, which we then invoke.
#
proc commCollect {chan fid} {
    global comm
    upvar #0 comm($chan,buf,$fid) data

    # Tcl8 may return an error on read after a close
    if {[catch {read $fid} nbuf] || [eof $fid]} { 
	fileevent $fid readable {}		;# be safe
	commLostConn $fid
	return
    }
    append data $nbuf

    commDebug {puts stderr "collect <$data>"}

    # If data contains at least one complete command, we will
    # be able to take off the first element, which is a list holding
    # the command.  This is true even if data isn't a well-formed
    # list overall, with unmatched open braces.  This works because
    # each command in the protocol ends with a newline, thus allowing
    # lindex and lreplace to work.
    #
    # This isn't true with Tcl8.0, which will return an error until
    # the whole buffer is a valid list.  This is probably OK, although
    # it could potentially cause a deadlock.
    while {![catch {set cmd [lindex $data 0]}]} {
	commDebug {puts stderr "cmd <$data>"}
	if [string match "" $cmd] break
	if [info complete $cmd] {
	    set data [lreplace $data 0 0]
	    after idle [list commExec $chan $fid $comm($chan,fids,$fid) $cmd]
	}
    }
}

#
# Recv and execute a remote command, returning the result and/or error
#
# buffer should contain:
#	send # {cmd}		execute cmd and send reply with serial #
#	async # {cmd}		execute cmd but send no reply
#	reply # {cmd}		execute cmd as reply to serial #
#
# Unknown commands are silently discarded
#
proc commExec {chan fid remoteid buf} {
    global comm

    # these variables are documented in the hook interface
    set cmd [lindex $buf 0]
    set ser [lindex $buf 1]
    set buf [lrange $buf 2 end]
    set buffer [lindex $buf 0]

    # Save remoteid for "comm remoteid".  This will only be valid
    # if retrieved before any additional events occur # on this channel.   
    # N.B. we could have already lost the connection to remote, making
    # this id be purely informational!
    set comm($chan,remoteid) [set id $remoteid]

    commDebug {puts stderr "exec <$cmd,$ser,$buf>"}

    switch -- $cmd {
	send - async {}
	reply {
	    if {![info exists comm($chan,return,$ser)]} {
	        commDebug {puts stderr "No one waiting for serial \"$ser\""}
		return
	    }

	    # Decompose reply command to assure it only uses "return"
	    # with no side effects.

	    array set return {-code "" -errorinfo "" -errorcode ""}
	    set ret [lindex $buffer end]
	    set len [llength $buffer]
	    incr len -2
	    foreach {sw val} [lrange $buffer 1 $len] {
		if ![info exists return($sw)] continue
		set return($sw) $val
	    }

	    if [info exists comm($chan,hook,reply)] {
		catch $comm($chan,hook,reply)
	    }

	    # this wakes up the sender
	    set comm($chan,result,$ser) $ret
	    set comm($chan,return,$ser) [array get return]
	    return
	}
	vers {
	    set comm($chan,vers,$id) $ser
	    return
	}
	default {
	    commDebug {puts stderr "unknown command; discard \"$cmd\""}
	    return
	}
    }

    # process eval hook now
    if [info exists comm($chan,hook,eval)] {
    	set err [catch $comm($chan,hook,eval) ret]
	commDebug {puts stderr "eval hook res <$err,$ret>"}
	switch $err {
	    1 {				;# error
		set done 1
	    }
	    2 - 3 {			;# return / break
		set err 0
		set done 1
	    }
	}
    }

    # exec command
    if ![info exists done] {
	# Sadly, the uplevel needs to be in the catch to access the local
	# variables buffer and ret.  These cannot simply be global because
	# commExec is reentrant (i.e., they could be linked to an allocated
	# serial number).
	set err [catch [concat uplevel #0 $buffer] ret]
    }

    commDebug {puts stderr "res <$err,$ret>"}

    # The double list assures that the command is a single list when read.
    if [string match send $cmd] {
	# The catch here is just in case we lose the target.  Consider:
	#	comm send $other comm send [comm self] exit
	catch {
	    set return return
	    # send error or result
	    switch $err {
		0 {}
		1 {
		    global errorInfo errorCode
		    lappend return -code $err \
			    -errorinfo $errorInfo \
			    -errorcode $errorCode
		}
		default { lappend return -code $err}
	    }
	    lappend return $ret
	    puts $fid [list [list reply $ser $return]]
	    flush $fid
	}
    }
}

###############################################################################
#
# Finish creating "comm" using the default port for this interp.
#
if ![info exists comm(comm,port)] {
    if [string match macintosh $tcl_platform(platform)] {
	comm new comm -port 0 -local 0 -listen 1
	set comm(localhost) [lindex [fconfigure $comm(comm,socket) -sockname] 0]
	comm config -local 1
    } else {
	comm new comm -port 0 -local 1 -listen 1
    }
}

#eof

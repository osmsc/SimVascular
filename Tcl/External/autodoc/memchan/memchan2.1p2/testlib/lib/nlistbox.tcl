# -*- tcl -*- (C) 1999 A. Kupries
# -----------------------------------------------------------------------------
# Ok, I'm doing my own fancy listbox too :-(
# Pure Tcl, no namespaces (sorry, want to support older version of Tcl too)
#
# nListbox = 'new listbox'
# -----------------------------------------------------------------------------

# -- nlistbox
# Create and configure a new listbox.

proc nlistbox {w args} {
    # Import the array holding the state of all nlistbox widgets.

    global nlistbox_state

    # We use a 'text' widget to simulate the listbox. Create it,
    # then save the original widget command for later, internal usage.

    text   $w -wrap none -cursor {} -insertwidth 0
    rename $w nlistbox$w

    # The alias was sspace conserving, but I don't know whether it
    # is possible to wrap an additional procedure around it. So I
    # create some bloat here, by duplicating the body of the dispatcher.
    #
    # interp alias {} $w {} nlistbox:dispatch $w

    regsub @w [info body nlistbox:_dispatch] $w body
    proc $w {sub args} $body

    # Initialize the state of the new widget (browsing, no selection,
    # no mark, empty (n=0), no tags to reuse, initial counter for
    # window and tag creation).

    set nlistbox_state($w,selectmode)	browse
    set nlistbox_state($w,curselection)	{}
    set nlistbox_state($w,mark)		{}
    set nlistbox_state($w,nexttag)	0
    set nlistbox_state($w,freetags)	{}
    set nlistbox_state($w,n)		0

    # Define the standard tags for display of anchor and active item,
    # and the selected items. The color should come from an option, and
    # not coded into the widget.

    nlistbox$w tag configure anchor   -underline {}
    nlistbox$w tag configure active   -underline 1
    nlistbox$w tag configure selected -background lightblue

    # Do the initial configuration, set the bindings for selection
    # handling and such.

    nlistbox:_configure  $w 0 $args
    nlistbox:setBindings $w
    return $w
}


# -- dispatch
# Internal procedure. Copied and customized for every new nlistbox.
# Dispatches to the handler of the specified subcommand.

proc nlistbox:_dispatch {w sub args} {
    global nlistbox_dispatch

    # An array is used to hold the names of the handler procedures.
    # Two advantages over calling 'nlistbox:$sub', i.e. constructing
    # the name on the fly:
    #
    # 1) Speed. Construction of the name on the fly causes the bytecode
    #    system to lookup the command procedure every time the dispatcher
    #    is executed. The array solution allows the interpreter to convert
    #    the strings in the array into 'command'-objects, these do not
    #    need to do any additional lookup, they point directly to the
    #    proc-definition.
    #
    # 2) The array makes it easy to define convenient 'short' method names,
    #    like the ones which are used for everything else in tcl.
    #    (See below)

    $nlistbox_dispatch($sub) @w $args
}


# --	Dispatcher array. Contents are transformed from
#	string objects into command-object on demand. And
#	stay that way, thus speeding lookup.

global    nlistbox_dispatch
array set nlistbox_dispatch {
    activate		nlistbox:activate
    activat 		nlistbox:activate
    activa  		nlistbox:activate
    activ   		nlistbox:activate
    acti    		nlistbox:activate
    act     		nlistbox:activate
    ac      		nlistbox:activate
    a       		nlistbox:activate
    bbox		nlistbox:bbox
    bbo 		nlistbox:bbox
    bb  		nlistbox:bbox
    b   		nlistbox:bbox
    cget		nlistbox:cget
    cge 		nlistbox:cget
    cg  		nlistbox:cget
    configure		nlistbox:configure
    configur 		nlistbox:configure
    configu  		nlistbox:configure
    config   		nlistbox:configure
    confi    		nlistbox:configure
    conf     		nlistbox:configure
    con      		nlistbox:configure
    co       		nlistbox:configure
    curselection	nlistbox:curselection
    curselectio 	nlistbox:curselection
    curselecti  	nlistbox:curselection
    curselect   	nlistbox:curselection
    curselec    	nlistbox:curselection
    cursele     	nlistbox:curselection
    cursel      	nlistbox:curselection
    curse       	nlistbox:curselection
    curs        	nlistbox:curselection
    cur         	nlistbox:curselection
    cu          	nlistbox:curselection
    delete		nlistbox:delete
    delet 		nlistbox:delete
    dele  		nlistbox:delete
    del   		nlistbox:delete
    de    		nlistbox:delete
    d     		nlistbox:delete
    get			nlistbox:get
    ge			nlistbox:get
    g			nlistbox:get
    index		nlistbox:index
    indexconfigure	nlistbox:indexconfigure
    indexconfigur	nlistbox:indexconfigure
    indexconfigu	nlistbox:indexconfigure
    indexconfig 	nlistbox:indexconfigure
    indexconfi  	nlistbox:indexconfigure
    indexconf   	nlistbox:indexconfigure
    indexcon    	nlistbox:indexconfigure
    indexco     	nlistbox:indexconfigure
    indexcget		nlistbox:indexcget
    indexcge		nlistbox:indexcget
    indexcg		nlistbox:indexcget
    insert		nlistbox:insert
    inser		nlistbox:insert
    inse		nlistbox:insert
    ins 		nlistbox:insert
    nearest		nlistbox:nearest
    neares		nlistbox:nearest
    neare		nlistbox:nearest
    near		nlistbox:nearest
    nea 		nlistbox:nearest
    ne  		nlistbox:nearest
    n   		nlistbox:nearest
    scan		nlistbox:scan
    sca 		nlistbox:scan
    sc  		nlistbox:scan
    see			nlistbox:see
    selection		nlistbox:selection
    selectio		nlistbox:selection
    selecti		nlistbox:selection
    select		nlistbox:selection
    selec		nlistbox:selection
    sele		nlistbox:selection
    sel 		nlistbox:selection
    size		nlistbox:size
    siz 		nlistbox:size
    si  		nlistbox:size
    xview		nlistbox:xview
    xvie		nlistbox:xview
    xvi 		nlistbox:xview
    xv  		nlistbox:xview
    x   		nlistbox:xview
    yview		nlistbox:yview
    yvie		nlistbox:yview
    yvi 		nlistbox:yview
    yv  		nlistbox:yview
    y   		nlistbox:yview
    scan:mark		nlistbox:scan:mark
    scan:mar		nlistbox:scan:mark
    scan:ma		nlistbox:scan:mark
    scan:m		nlistbox:scan:mark
    scan:dragto		nlistbox:scan:dragto
    scan:dragt		nlistbox:scan:dragto
    scan:drag		nlistbox:scan:dragto
    scan:dra		nlistbox:scan:dragto
    scan:dr		nlistbox:scan:dragto
    scan:d		nlistbox:scan:dragto
    selection:anchor	nlistbox:selection:anchor
    selection:ancho	nlistbox:selection:anchor
    selection:anch	nlistbox:selection:anchor
    selection:anc	nlistbox:selection:anchor
    selection:an	nlistbox:selection:anchor
    selection:a 	nlistbox:selection:anchor
    selection:clear	nlistbox:selection:clear
    selection:clea	nlistbox:selection:clear
    selection:cle	nlistbox:selection:clear
    selection:cl	nlistbox:selection:clear
    selection:c 	nlistbox:selection:clear
    selection:includes	nlistbox:selection:includes
    selection:include	nlistbox:selection:includes
    selection:includ	nlistbox:selection:includes
    selection:inclu	nlistbox:selection:includes
    selection:incl	nlistbox:selection:includes
    selection:inc	nlistbox:selection:includes
    selection:in	nlistbox:selection:includes
    selection:i 	nlistbox:selection:includes
    selection:set	nlistbox:selection:set
    selection:se	nlistbox:selection:set
    selection:s 	nlistbox:selection:set
}


# --	Global state array. Contains the state for each nlistbox
#	State of $w in entries "$w,*"

global    nlistbox_state
array set nlistbox_state {}


# --	Ok, start the implementation of the various
#	subcommands

# --	activate an entry

proc nlistbox:activate {w arglist} {
    # arglist = length of 1, index of entry to activate

    set line [nlistbox:_lineOfIndex $w [lindex $arglist 0] 0]

    catch {nlistbox$w tag remove active active.first active.last+1c}
    nlistbox$w tag add    active $line.0 $line.end+1c

    #puts "activate line $line"

    return
}


# --	determine the bounding box for an entry.

proc nlistbox:bbox {w arglist} {
    # args = length of 1, index of entry to look at

    set line [nlistbox:_lineOfIndex $w [lindex $arglist 0] 0]

    lrange [nlistbox$w dlineinfo $line.0] 0 3
}

# --	Get the value of an option

proc nlistbox:cget {w arglist} {
    global nlistbox_state

    set option [lindex $arglist 0]

    nlistbox:_illegalOpt $option

    if {![string compare -selectmode $option]} {
	return $nlistbox_state($w,selectmode)
    } else {
	return [nlistbox$w cget $option]
    }
}

# --	Configure options.

proc nlistbox:configure {w arglist} {
    nlistbox:_configure $w 1 $arglist
}


proc nlistbox:_configure {w zero arglist} {
    global nlistbox_state

    # Special handling of -selectmode, everything else is simply
    # forwarded to the internal text widget.

    if {[llength $arglist] == 0} {
	if {!$zero} {
	    # Ignore this call. Came from widget constructor, without
	    # configuration options.
	    return
	}

	# Build list describing all options, remove all options
	# special to the text widget, give the user the illusion of a listbox.

	set list ""

	foreach e [nlistbox$w configure] {
	    if {![catch {nlistbox:_illegalOpt [lindex $e 0]}]} {
		lappend list $e
	    }
	}

	lappend list \
		[list -selectmode selectMode SelectMode \
		browse $nlistbox_state($w,selectmode)]

	return [lsort $list]
    }

    if {[llength $arglist] == 1} {
	# Forward to retrieval
	return [nlistbox:cget $w $arglist]
    }

    foreach {opt val} $arglist {
	nlistbox:_illegalOpt $opt

	if {![string compare -selectmode $opt]} {
	    set nlistbox_state($w,selectmode) $val
	} else {
	    nlistbox$w configure $opt $val
	}
    }

    return 
}

# --	Determine current selection

proc nlistbox:curselection {w arglist} {
    global nlistbox_state
    return $nlistbox_state($w,curselection)
}

# --	Delete entries from the list.

proc nlistbox:delete {w arglist} {
    global nlistbox_state

    # Determine range to eliminate

    if {$nlistbox_state($w,n) <= 0} {
	# nothing to delete
	return
    }

    foreach {first last fline lline} [nlistbox:_getRange $w $arglist] {break}

    nlistbox:selection:_clear $w $first $last $fline $lline
    nlistbox$w delete $fline.0 $lline.end+1c


    for {set i $fline} {$i <= $lline} {incr i} {
	catch {
	    lappend nlistbox_state($w,freetags) $nlistbox_state($w,line$i)
	    unset nlistbox_state($w,line$i)
	}
	
	if {[info exists nlistbox_state($w,line$i,w)]} {
	    catch {destroy $nlistbox_state($w,line$i,w)}
	}

	catch {unset nlistbox_state($w,line$i,w)}
	catch {unset nlistbox_state($w,line$i,image)}
	catch {unset nlistbox_state($w,line$i,win)}
	catch {unset nlistbox_state($w,line$i,data)}

	incr nlistbox_state($w,n) -1
    }

    return
}

# --	Get entries from the list.

proc nlistbox:get {w arglist} {
    # Determine range to get

    foreach {first last fline lline} [nlistbox:_getRange $w $arglist] {break}

    set res {}

    for {set i $fline} {$i <= $lline} {incr i} {
	lappend res [nlistbox$w get $i.0 $i.end]
    }

    return $res
}

# --	Convert indices into number of entry

proc nlistbox:index {w arglist} {
    set entry [expr {[nlistbox:_lineOfIndex $w [lindex $arglist 0] 1] - 1}]

    #puts "entry = $entry"

    return $entry
}

# --	Insert new entries.

proc nlistbox:insert {w arglist} {
    global nlistbox_state

    set line    [nlistbox:_lineOfIndex $w [lindex $arglist 0] 1]
    set arglist [lrange $arglist 1 end]

    foreach l $arglist {
	if {[string match *\n* $l]} {
	    error "newline illegal for listbox entries"
	}

	nlistbox$w insert $line.0 "[string trimright $l]\n"
	incr nlistbox_state($w,n)
	incr line
    }

    incr line -1

    set res {}
    set n [llength $arglist]

    foreach i $nlistbox_state($w,curselection) {
	if {$i < $line} {
	    lappend res $i
	} else {
	    lappend res [expr {$i + $n}]
	}
    }

    set nlistbox_state($w,curselection) $res
    return
}


proc nlistbox:nearest {w arglist} {
    global nlistbox_state
    set y [lindex $arglist 0]

    nlistbox:_lineOfIndex $w ${y}.0 0
}

# --	Handle scanning

proc nlistbox:scan {w arglist} {
    global nlistbox_dispatch

    set sub		[lindex $arglist 0]
    set arglist	[lrange $arglist 1 end]

    $nlistbox_dispatch(scan:$sub) $w $arglist
}

# --	Enforce visibility of an entry

proc nlistbox:see {w arglist} {
    set line    [nlistbox:_lineOfIndex $w [lindex $arglist 0] 1]

    nlistbox$w see $line.0
}

# --	Handle selection operations

proc nlistbox:selection {w arglist} {
    global nlistbox_dispatch

    set sub	[lindex $arglist 0]
    set arglist	[lrange $arglist 1 end]

    #puts "selection/$sub: $w $arglist"

    $nlistbox_dispatch(selection:$sub) $w $arglist
}

# --	Get number of entries in listbox

proc nlistbox:size {w arglist} {
    #expr {[lindex [split [nlistbox$w index end] .] 0] - 2}

    global nlistbox_state
    return $nlistbox_state($w,n)
}

# --	Handle horizontal scrolling

proc nlistbox:xview {w arglist} {
    if {[llength $arglist] == 1} {
	# special case
	set line [nlistbox:_lineOfIndex $w [lindex $arglist 0] 1]

	nlistbox$w see $line.0
    } else {
	# forward to text widget
	eval nlistbox$w xview $arglist
    }
}

# --	Handle vertical scrolling

proc nlistbox:yview {w arglist} {
    if {[llength $arglist] == 1} {
	# special case
	set line    [nlistbox:_lineOfIndex $w [lindex $arglist 0] 1]

	nlistbox$w see $line.0
    } else {
	# forward to text widget
	eval nlistbox$w yview $arglist
    }
}

# --	Set mark

proc nlistbox:scan:mark {w arglist} {
    global nlistbox_state

    foreach {x y} $arglist {break}

    set nlistbox_state($w,mark) [list $x $y [lindex [nlistbox$w xview] 0] [lindex [nlistbox$w yview] 0]]
    return
}

# -- 	Drag from mark

proc nlistbox:scan:dragto {w arglist} {
    global nlistbox_state

    foreach {x y} $arglist {break}
    foreach {ox oy oxv oyv} $nlistbox_state($w,mark) {break}

    nlistbox$w xview moveto	[expr {$oxv + 0.1*($x - $ox)}]
    nlistbox$w yview moveto	[expr {$oyv + 0.1*($y - $oy)}]
    return
}

# --	Set an anchor for area of selection

proc nlistbox:selection:anchor {w arglist} {
    global nlistbox_state

    if {$nlistbox_state($w,n) < 1} {
	# empty list, no anchor possible.
	return
    }

    set line [nlistbox:_lineOfIndex $w [lindex $arglist 0] 0]

    catch {nlistbox$w tag remove anchor anchor.first anchor.last+1c}
    nlistbox$w tag add    anchor $line.0 $line.end+1c
    return
}

# --	Clear selection from area

proc nlistbox:selection:clear {w arglist} {
    # Determine range to clear

    global nlistbox_state

    if {$nlistbox_state($w,n) < 1} {
	# empty list, no selection to clear
	return
    }

    foreach {first last fline lline} [nlistbox:_getRange $w $arglist] {break}

    nlistbox:selection:_clear $w $first $last $fline $lline
}

# --	Check selection

proc nlistbox:selection:includes {w arglist} {
    global nlistbox_state

    if {$nlistbox_state($w,n) < 1} {
	# empty list, nothing selected
	return 0
    }

    set entry [expr {[nlistbox:_lineOfIndex $w [lindex $arglist 0] 0]-1}]
    set pos   [lsearch $nlistbox_state($w,curselection) $entry]

    expr {($pos < 0) ? 0 : 1}
}

proc nlistbox:selection:set {w arglist} {
    global nlistbox_state

    if {$nlistbox_state($w,n) < 1} {
	# empty list, nothing to select
	return
    }

    # Determine range to select

    foreach {first last fline lline} [nlistbox:_getRange $w $arglist] {break}

    nlistbox$w tag add selected $fline.0 $lline.end+1c

    incr fline -1
    incr lline -1

    for {set i $fline} {$i <= $lline} {incr i} {
	lappend nlistbox_state($w,curselection) $i
    }

    nlistbox:_cleanSel $w

    event generate $w <<ListboxSelect>>
    return
}


# -- New functionality

proc nlistbox:indexconfigure {w arglist} {
    # Special handling of some options, everything is simply
    # forwarded to the internal text widget and the tag for that line

    global nlistbox_state

    if {$nlistbox_state($w,n) < 1} {
	# empty list, no index to configure
	error "index out of range"
    }

    set index	[lindex $arglist 0]
    set arglist	[lrange $arglist 1 end]
    set line	[nlistbox:_lineOfIndex $w $index 0]

    if {[llength $arglist] == 0} {
	# Build list describing all options

	set tag	[nlistbox:_tagOf $w $line]

	set list ""

	foreach e [nlistbox$w tag configure $tag] {
	    if {![catch {nlistbox:_illegalEntryOpt [lindex $e 0]}]} {
		lappend list $e
	    }
	}

	#lappend list [list -option optName optClass default value]
	lappend list  [list -text text Text \
		{} [nlistbox$w get $line.0 $line.end]]
	lappend list  [list -image image Image \
		{} [nlistbox:_indexcget $w $line -image]]
	lappend list  [list -window window Window \
		{} [nlistbox:_indexcget $w $line -window]]
	lappend list  [list -data string String \
		{} [nlistbox:_indexcget $w $line -data]]

	return [lsort $list]
    }

    if {[llength $arglist] == 1} {
	# Forward to retrieval
	return [nlistbox:_indexcget $w $line $arglist]
    }

    foreach {opt val} $arglist {
	nlistbox:_illegalEntryOpt $opt

	switch -- $opt {
	    -data {
		# Remember association
		set nlistbox_state($w,line$line,data) $val
	    }
	    -text {
		if {[string match *\n* $val]} {
		    error "newline illegal for listbox entries"
		}

		set tag [nlistbox:_tagOf $w $line]

		if {
		    ![info exists nlistbox_state($w,line$line,image)] ||
		    $nlistbox_state($w,line$line,image) == {}
		} {
		    nlistbox$w delete $line.0 $line.end
		} else {
		    nlistbox$w delete $line.1 $line.end
		}

		nlistbox$w insert $line.end $val $tag
	    }
	    -image {
		set img [nlistbox:_imageOf $w $line]

		set nlistbox_state($w,line$line,image) $val
		
		$img configure -image $val
	    }
	    -window {
		set iw [nlistbox:_windowOf $w $line]

		if {$val == {}} {
		    pack forget $nlistbox_state($w,line$line,w)
		} else {
		    pack  $val -side left -expand 0 -fill both -in $w.$iw
		    raise $val
		    set nlistbox_state($w,line$line,w) $val
		}
	    }
	    default {
		set tag [nlistbox:_tagOf $w $line]
		nlistbox$w tag configure $tag $opt $val
	    }
	}
    }

    return 
}

# --	Retrieve options specific to an entry

proc nlistbox:indexcget {w arglist} {
    global nlistbox_state

    if {$nlistbox_state($w,n) < 1} {
	# empty list, no index to configure
	error "index out of range"
    }

    set index	[lindex $arglist 0]
    set arglist	[lrange $arglist 1 end]
    set line	[nlistbox:_lineOfIndex $w $index 0]

    nlistbox:_indexcget $w $line $arglist
}


# --	Internal helpers
#

# --	Determine option value for a listbox entry.

proc nlistbox:_indexcget {w line arglist} {
    global nlistbox_state

    set option [lindex $arglist 0]

    nlistbox:_illegalEntryOpt $option

    switch -- $option {
	-data {
	    if {![info exists nlistbox_state($w,line$line,data)]} {
		return {}
	    } else {
		return $nlistbox_state($w,line$line,data)
	    }
	}
	-text {
	    return [nlistbox$w get $line.0 $line.end]
	}
	-image {
	    if {![info exists nlistbox_state($w,line$line,image)]} {
		return {}
	    } else {
		return $nlistbox_state($w,line$line,image)
	    }
	}
	default {
	    set tag	[nlistbox:_tagOf $w $line]
	    return [nlistbox$w tag cget $tag $option]
	}
    }
}

# --	Determine line of entry from an index.

proc nlistbox:_lineOfIndex {w index adjust} {
    global nlistbox_state

    # adjust = 0/1, relevant only for index 'end'
    #	   adjust = 1 => refer to element *after* the last

    if {[string compare $index end]} {
	set adjust 0
    }

    if {![string compare $index anchor]} {
	set index anchor.first
    }

    if {![string compare $index active]} {
	set index active.first
    }

    if {[regexp {^-?[0-9]+$} $index]} {
	incr index
	set  index "$index.0"
    }

    if {[catch {set line [lindex [split [nlistbox$w index $index] .] 0]}]} {
	return 0
    }

    #puts "$index -> line = $line /off ($adjust)"

    if {$line < 1} {
	set line 1
    } elseif {$line > $nlistbox_state($w,n)} {
	set  line $nlistbox_state($w,n)
    }

    incr line $adjust

    #puts "$index -> line = $line"

    return $line
}

# --	Determine range of entries

proc nlistbox:_getRange {w arglist} {
    # Determine range

    set first [lindex $arglist 0];
    set fline [nlistbox:_lineOfIndex $w $first 0]
    set last  [lindex $arglist 1]

    if {$last == {}} {
	set last $first
	set lline $fline
    } else {
	set lline [nlistbox:_lineOfIndex $w $last 0]
    }

    list $first $last $fline $lline
}

# --	Remove entries from the selection.

proc nlistbox:selection:_clear {w first last fline lline} {
    global nlistbox_state

    nlistbox$w tag remove selected $fline.0 $lline.end+1c

    incr fline -1
    incr lline -1

    set res {}
    foreach i $nlistbox_state($w,curselection) {
	if {($i < $fline) || ($i > $lline)} {
	    lappend res $i
	}
    }

    set nlistbox_state($w,curselection) $res

    event generate $w <<ListboxSelect>>
    return
}

# --	Cleanup selection list after adding new entries.

proc nlistbox:_cleanSel {w} {
    global nlistbox_state

    set res {}
    foreach i $nlistbox_state($w,curselection) {
	if {![info exists cache($i)]} {
	    lappend res $i
	    set cache($i) .
	}
    }

    set nlistbox_state($w,curselection) [lsort $res]
    return
}


proc nlistbox:_initTag {w t} {
    foreach o {
	-background	-bgstipple	-borderwidth
	-fgstipple	-font		-foreground
	-justify	-lmargin1	-lmargin2
	-offset		-overstrike	-relief
	-rmargin	-spacing1	-spacing2
	-spacing3	-tabs
	-underline	-wrap
    } {
	nlistbox$w tag configure $t $o {}
    }

    nlistbox$w tag lower $t
    return
}


proc nlistbox:_tagOf {w line} {
    global nlistbox_state

    if {[info exists nlistbox_state($w,line$line)]} {
	return $nlistbox_state($w,line$line)
    }

    if {[llength $nlistbox_state($w,freetags)] > 0} {
	set t [lindex $nlistbox_state($w,freetags) 0]
	set nlistbox_state($w,freetags) [lrange $nlistbox_state($w,freetags) 1 end]
    } else {
	set t _t$nlistbox_state($w,nexttag)
	incr nlistbox_state($w,nexttag)
    }

    set nlistbox_state($w,line$line) $t

    nlistbox:_initTag $w $t

    nlistbox$w tag add $t $line.0 $line.end+1c
    return $t
}


proc nlistbox:_windowOf {w line} {
    global nlistbox_state

    if {[info exists nlistbox_state($w,line$line,win)]} {
	return $nlistbox_state($w,line$line,win)
    }

    set win _w$nlistbox_state($w,nexttag)
    incr nlistbox_state($w,nexttag)

    frame $w.$win
    pack propagate $w.$win 1

    nlistbox$w window create $line.0 -window $w.$win

    set nlistbox_state($w,line$line,win) $win

    if {[info exists nlistbox_state($w,line$line)]} {
	nlistbox$w tag add $nlistbox_state($w,line$line) $line.0
    }

    return $win
}


proc nlistbox:_imageOf {w line} {
    global nlistbox_state

    set iw $w.[nlistbox:_windowOf $w $line]

    if {[winfo exists $iw.img]} {
	return $iw.img
    }

    label $iw.img
    pack  $iw.img -side right -expand 0 -fill both

    return $iw.img
}


proc nlistbox:_illegalEntryOpt {o} {
    if {[lsearch {-tabs -wrap -state -spacing2} $o] >= 0} {
	error "illegal option $o"
    }
}


proc nlistbox:_illegalOpt {o} {
    if {[lsearch {-insertbackground -insertborderwidth -insertofftime -insertontime -insertwidth -padx -pady -spacing1 -spacing2 -spacing3 -state -tabs -wrap} $o] >= 0} {
	error "illegal option $o"
    }
}


# --	Construct default bindings for the new listbox.
#

proc nlistbox:setBindings {w} {
    # Tausche die Class-Bindings von "Text" gegen "nListbox" aus.
    # Behalte die Positionierung bei.

    set tags {}

    foreach t [bindtags $w] {
	if {![string compare $t Text]} {
	    lappend tags nListBox
	} else {
	    lappend tags $t
	}
    }

    bindtags $w $tags

    bind $w <Destroy> {
	foreach k [array names nlistbox_state %W,*] {
	    unset nlistbox_state($k)
	}
    }

    return
}


#--------------------------------------------------------------------------
# tkPriv elements (from core tk!) used in this file:
#
# afterId -		Token returned by "after" for autoscanning.
# listboxPrev -		The last element to be selected or deselected
#			during a selection operation.
# listboxSelection -	All of the items that were selected before the
#			current selection operation (such as a mouse
#			drag) started;  used to cancel an operation.
# x, y
#--------------------------------------------------------------------------

#-------------------------------------------------------------------------
# The code below creates the default class bindings for listboxes.
#-------------------------------------------------------------------------


# Note: the check for existence of %W below is because this binding
# is sometimes invoked after a window has been deleted (e.g. because
# there is a double-click binding on the widget that deletes it).  Users
# can put "break"s in their bindings to avoid the error, but this check
# makes that unnecessary.

bind nListBox <1> {
    if [winfo exists %W] {
	nlistbox:bind:BeginSelect %W [%W index @%x,%y]
    }
}

# Ignore double clicks so that users can define their own behaviors.
# Among other things, this prevents errors if the user deletes the
# listbox on a double click.

bind nListBox <Double-1> {
    # Empty script
}

bind nListBox <B1-Motion> {
    set tkPriv(x) %x
    set tkPriv(y) %y
    nlistbox:bind:Motion %W [%W index @%x,%y]
}
bind nListBox <ButtonRelease-1> {
    tkCancelRepeat
    %W activate @%x,%y
}
bind nListBox <Shift-1> {
    nlistbox:bind:BeginExtend %W [%W index @%x,%y]
}
bind nListBox <Control-1> {
    nlistbox:bind:BeginToggle %W [%W index @%x,%y]
}
bind nListBox <B1-Leave> {
    set tkPriv(x) %x
    set tkPriv(y) %y
    nlistbox:bind:AutoScan %W
}
bind nListBox <B1-Enter> {
    tkCancelRepeat
}

bind nListBox <Up> {
    nlistbox:bind:UpDown %W -1
}
bind nListBox <Shift-Up> {
    nlistbox:bind:ExtendUpDown %W -1
}
bind nListBox <Down> {
    nlistbox:bind:UpDown %W 1
}
bind nListBox <Shift-Down> {
    nlistbox:bind:ExtendUpDown %W 1
}
bind nListBox <Left> {
    %W xview scroll -1 units
}
bind nListBox <Control-Left> {
    %W xview scroll -1 pages
}
bind nListBox <Right> {
    %W xview scroll 1 units
}
bind nListBox <Control-Right> {
    %W xview scroll 1 pages
}
bind nListBox <Prior> {
    %W yview scroll -1 pages
    %W activate @0,0
}
bind nListBox <Next> {
    %W yview scroll 1 pages
    %W activate @0,0
}
bind nListBox <Control-Prior> {
    %W xview scroll -1 pages
}
bind nListBox <Control-Next> {
    %W xview scroll 1 pages
}
bind nListBox <Home> {
    %W xview moveto 0
}
bind nListBox <End> {
    %W xview moveto 1
}
bind nListBox <Control-Home> {
    %W activate 0
    %W see 0
    %W selection clear 0 end
    %W selection set 0
}
bind nListBox <Shift-Control-Home> {
    nlistbox:bind:DataExtend %W 0
}
bind nListBox <Control-End> {
    %W activate end
    %W see end
    %W selection clear 0 end
    %W selection set end
}
bind nListBox <Shift-Control-End> {
    nlistbox:bind:DataExtend %W [%W index end]
}
bind nListBox <<Copy>> {
    if {[selection own -displayof %W] == "%W"} {
	clipboard clear -displayof %W
	clipboard append -displayof %W [selection get -displayof %W]
    }
}
bind nListBox <space> {
    nlistbox:bind:BeginSelect %W [%W index active]
}
bind nListBox <Select> {
    nlistbox:bind:BeginSelect %W [%W index active]
}
bind nListBox <Control-Shift-space> {
    nlistbox:bind:BeginExtend %W [%W index active]
}
bind nListBox <Shift-Select> {
    nlistbox:bind:BeginExtend %W [%W index active]
}
bind nListBox <Escape> {
    nlistbox:bind:Cancel %W
}
bind nListBox <Control-slash> {
    nlistbox:bind:SelectAll %W
}
bind nListBox <Control-backslash> {
    if {[%W cget -selectmode] != "browse"} {
	%W selection clear 0 end
    }
}

# Additional Tk bindings that aren't part of the Motif look and feel:

bind nListBox <2> {
    %W scan mark %x %y
}
bind nListBox <B2-Motion> {
    %W scan dragto %x %y
}

# nlistbox:bind:BeginSelect --
#
# This procedure is typically invoked on button-1 presses.  It begins
# the process of making a selection in the listbox.  Its exact behavior
# depends on the selection mode currently in effect for the listbox;
# see the Motif documentation for details.
#
# Arguments:
# w -		The listbox widget.
# el -		The element for the selection operation (typically the
#		one under the pointer).  Must be in numerical form.

proc nlistbox:bind:BeginSelect {w el} {
    global tkPriv
    if {[$w cget -selectmode]  == "multiple"} {
	if [$w selection includes $el] {
	    $w selection clear $el
	} else {
	    $w selection set $el
	}
    } else {
	$w selection clear 0 end
	$w selection set $el
	$w selection anchor $el
	set tkPriv(listboxSelection) {}
	set tkPriv(listboxPrev) $el
    }
}

# nlistbox:bind:Motion --
#
# This procedure is called to process mouse motion events while
# button 1 is down.  It may move or extend the selection, depending
# on the listbox's selection mode.
#
# Arguments:
# w -		The listbox widget.
# el -		The element under the pointer (must be a number).

proc nlistbox:bind:Motion {w el} {
    global tkPriv
    if {$el == $tkPriv(listboxPrev)} {
	return
    }
    set anchor [$w index anchor]
    switch [$w cget -selectmode] {
	browse {
	    $w selection clear 0 end
	    $w selection set $el
	    set tkPriv(listboxPrev) $el
	}
	extended {
	    set i $tkPriv(listboxPrev)
	    if [$w selection includes anchor] {
		$w selection clear $i $el
		$w selection set anchor $el
	    } else {
		$w selection clear $i $el
		$w selection clear anchor $el
	    }
	    while {($i < $el) && ($i < $anchor)} {
		if {[lsearch $tkPriv(listboxSelection) $i] >= 0} {
		    $w selection set $i
		}
		incr i
	    }
	    while {($i > $el) && ($i > $anchor)} {
		if {[lsearch $tkPriv(listboxSelection) $i] >= 0} {
		    $w selection set $i
		}
		incr i -1
	    }
	    set tkPriv(listboxPrev) $el
	}
    }
}

# nlistbox:bind:BeginExtend --
#
# This procedure is typically invoked on shift-button-1 presses.  It
# begins the process of extending a selection in the listbox.  Its
# exact behavior depends on the selection mode currently in effect
# for the listbox;  see the Motif documentation for details.
#
# Arguments:
# w -		The listbox widget.
# el -		The element for the selection operation (typically the
#		one under the pointer).  Must be in numerical form.

proc nlistbox:bind:BeginExtend {w el} {
    if {[$w cget -selectmode] == "extended"} {
	if {[$w selection includes anchor]} {
	    nlistbox:bind:Motion $w $el
	} else {
	    # No selection yet; simulate the begin-select operation.

	    nlistbox:bind:BeginSelect $w $el
	}
    }
}

# nlistbox:bind:BeginToggle --
#
# This procedure is typically invoked on control-button-1 presses.  It
# begins the process of toggling a selection in the listbox.  Its
# exact behavior depends on the selection mode currently in effect
# for the listbox;  see the Motif documentation for details.
#
# Arguments:
# w -		The listbox widget.
# el -		The element for the selection operation (typically the
#		one under the pointer).  Must be in numerical form.

proc nlistbox:bind:BeginToggle {w el} {
    global tkPriv
    if {[$w cget -selectmode] == "extended"} {
	set tkPriv(listboxSelection) [$w curselection]
	set tkPriv(listboxPrev) $el
	$w selection anchor $el
	if [$w selection includes $el] {
	    $w selection clear $el
	} else {
	    $w selection set $el
	}
    }
}

# nlistbox:bind:AutoScan --
# This procedure is invoked when the mouse leaves an entry window
# with button 1 down.  It scrolls the window up, down, left, or
# right, depending on where the mouse left the window, and reschedules
# itself as an "after" command so that the window continues to scroll until
# the mouse moves back into the window or the mouse button is released.
#
# Arguments:
# w -		The entry window.

proc nlistbox:bind:AutoScan {w} {
    global tkPriv
    if {![winfo exists $w]} return
    set x $tkPriv(x)
    set y $tkPriv(y)
    if {$y >= [winfo height $w]} {
	$w yview scroll 1 units
    } elseif {$y < 0} {
	$w yview scroll -1 units
    } elseif {$x >= [winfo width $w]} {
	$w xview scroll 2 units
    } elseif {$x < 0} {
	$w xview scroll -2 units
    } else {
	return
    }
    nlistbox:bind:Motion $w [$w index @$x,$y]
    set tkPriv(afterId) [after 50 nlistbox:bind:AutoScan $w]
}

# nlistbox:bind:UpDown --
#
# Moves the location cursor (active element) up or down by one element,
# and changes the selection if we're in browse or extended selection
# mode.
#
# Arguments:
# w -		The listbox widget.
# amount -	+1 to move down one item, -1 to move back one item.

proc nlistbox:bind:UpDown {w amount} {
    global tkPriv
    $w activate [expr [$w index active] + $amount]
    $w see active
    switch [$w cget -selectmode] {
	browse {
	    $w selection clear 0 end
	    $w selection set active
	}
	extended {
	    $w selection clear 0 end
	    $w selection set active
	    $w selection anchor active
	    set tkPriv(listboxPrev) [$w index active]
	    set tkPriv(listboxSelection) {}
	}
    }
}

# nlistbox:bind:ExtendUpDown --
#
# Does nothing unless we're in extended selection mode;  in this
# case it moves the location cursor (active element) up or down by
# one element, and extends the selection to that point.
#
# Arguments:
# w -		The listbox widget.
# amount -	+1 to move down one item, -1 to move back one item.

proc nlistbox:bind:ExtendUpDown {w amount} {
    if {[$w cget -selectmode] != "extended"} {
	return
    }
    $w activate [expr [$w index active] + $amount]
    $w see active
    nlistbox:bind:Motion $w [$w index active]
}

# nlistbox:bind:DataExtend
#
# This procedure is called for key-presses such as Shift-KEndData.
# If the selection mode isn't multiple or extend then it does nothing.
# Otherwise it moves the active element to el and, if we're in
# extended mode, extends the selection to that point.
#
# Arguments:
# w -		The listbox widget.
# el -		An integer element number.

proc nlistbox:bind:DataExtend {w el} {
    set mode [$w cget -selectmode]
    if {$mode == "extended"} {
	$w activate $el
	$w see $el
        if [$w selection includes anchor] {
	    nlistbox:bind:Motion $w $el
	}
    } elseif {$mode == "multiple"} {
	$w activate $el
	$w see $el
    }
}

# nlistbox:bind:Cancel
#
# This procedure is invoked to cancel an extended selection in
# progress.  If there is an extended selection in progress, it
# restores all of the items between the active one and the anchor
# to their previous selection state.
#
# Arguments:
# w -		The listbox widget.

proc nlistbox:bind:Cancel w {
    global tkPriv
    if {[$w cget -selectmode] != "extended"} {
	return
    }
    set first [$w index anchor]
    set last $tkPriv(listboxPrev)
    if {$first > $last} {
	set tmp $first
	set first $last
	set last $tmp
    }
    $w selection clear $first $last
    while {$first <= $last} {
	if {[lsearch $tkPriv(listboxSelection) $first] >= 0} {
	    $w selection set $first
	}
	incr first
    }
}

# nlistbox:bind:SelectAll
#
# This procedure is invoked to handle the "select all" operation.
# For single and browse mode, it just selects the active element.
# Otherwise it selects everything in the widget.
#
# Arguments:
# w -		The listbox widget.

proc nlistbox:bind:SelectAll w {
    set mode [$w cget -selectmode]
    if {($mode == "single") || ($mode == "browse")} {
	$w selection clear 0 end
	$w selection set active
    } else {
	$w selection set 0 end
    }
}



# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -- Tester interface -- 


proc ifSplashText {text} {

    if {[winfo exists .splash.text]} {
	.splash.fbtext delete 0 end
	.splash.fbtext insert 0 $text
	update
    }

    return
}


proc ifSee {args} {
    global testNo

    if {![string compare [lindex $args 0] -highlight]} {
	set test [lindex $args 1]
	set hilit 1
    } else {
	set test [lindex $args 0]
	set hilit 0
    }

    set i $testNo($test)

    .lb see  $i
    testText $test ifClearText ifAddText ifDoneText

    if {$hilit} {
	.lb indexconfigure $i -background violet
    } else {
	.lb indexconfigure $i -background [testColor $test]
    }

    update
    return
}


proc ifBuild {} {
    global tests

    # generate the main interface.
    # left side:  action buttons.
    # right side: list of found tests, protocol window.

    wm title . Tester

    label     .where -text [pwd] -relief sunken -bd 2 -anchor w
    frame     .action -relief raised -bd 1
    scrollbar .sv -orient vertical -command {.lb yview} -relief raised -bd 1
    nlistbox  .lb -width 30 -yscrollcommand {.sv set}   -relief raised -bd 1 \
	    -selectmode extended
    scrollbar .sb -orient vertical -command {.t yview} -relief raised -bd 1
    text      .t -width 60 -height 30 -bd 2 -relief sunken -font fixed \
	    -yscrollcommand {.sb set}

    pack .where  -side top   -expand 0 -fill both -ipadx 2m -ipady 1m
    pack .action -side left  -expand 0 -fill both
    pack .sv     -side left  -expand 0 -fill both
    pack .lb     -side left  -expand 1 -fill both
    pack .sb     -side left  -expand 0 -fill both
    pack .t      -side right -expand 1 -fill both

    ifCreateActions
    ifFillListbox .*

    # Tags as used by 'testText'.
    .t tag configure title       -background green
    .t tag configure key         -background gray
    .t tag configure value       -background lightblue
    .t tag configure strong      -background coral
    .t tag configure ok
    .t tag configure failed      -background red
    .t tag configure error       -background yellow
    .t tag configure error-setup -background blue

    .t configure -state disabled

    # interface nearly complete, do coloring, center on screen,
    # then show it.

    foreachWin . configure -bg lightsteelblue
    update idletasks

    set wrWidth  [winfo reqwidth     .]
    set wrHeight [winfo reqheight    .]
    set sWidth   [winfo screenwidth  .]
    set sHeight  [winfo screenheight .]

    set x [expr {$sWidth/2  - $wrWidth/2  - [winfo vrootx .]}]
    set y [expr {$sHeight/2 - $wrHeight/2 - [winfo vrooty .]}]

    wm geometry  . ${wrWidth}x${wrHeight}+$x+$y
    wm deiconify .
    update
    return
}



proc ifSetState {btn state} {
    .action.$btn configure -state $state
    return
}



proc ifCreateActions {} {
    # Define actions

    foreach {b txt cmd} {
	run   Run              {tsRun [pkgTestSetup]}
	sets  {Set selected}   {cmdSet 1 [.lb curselection]}
	usets {Unset selected} {cmdSet 0 [.lb curselection]}
	seta  {Set all}        {cmdSetAllTo 1}
	useta {Unset all}      {cmdSetAllTo 0}
	sha   {Show all}       {ifFillListbox .*}
	shf   {Show failed}    {ifFillListbox failed|error|error-setup}
	mail  {Mail report}    cmdMailReport
	exit  Exit             exit
    } {
	button .action.$b -text $txt -command $cmd -anchor w
	pack   .action.$b -side top -expand 0 -fill both -pady 1m -padx 1m
    }

    return
}


proc ifFillListbox {what} {
    eval global [info global test*]

    catch {unset testNo}

    .lb delete 0 end

    set i 0
    set length 30

    foreach t $tests {
	if {![regexp $what $testState($t)]} {
	    continue
	}

	checkbutton .lb.cb$i \
		-variable testUse($t) \
		-text {} \
		-highlightthickness 0 \
		-bg lightsteelblue

	#set testUse($t) 1
	set title "$t $testDesc($t)"

	.lb insert end $title
	.lb indexconfigure $i -window .lb.cb$i -background [testColor $t]

	set testNo($t)   $i
	set testNo(n,$i) $t
	incr i

	if {[set l [string length $title]] > $length} {
	    set length $l
	}
    }

    .lb conf -width $length
    bind .lb <<ListboxSelect>> ifShowSelection

    cmdSetAllTo 1

    # complete.  
    return
}


proc ifShowSelection {} {
    global testNo

    set idx [lindex [.lb curselection] 0]

    if {$idx == {}} {
	return
    }

    testText $testNo(n,$idx) ifClearText ifAddText ifDoneText
    return
}


proc ifClearText {} {
    .t configure -state normal
    .t delete 1.0 end
    return
}


proc ifAddText {text {tag {}}} {
    if {$tag != {}} {
	.t insert end $text $tag
    } else {
	.t insert end $text
    }
    return
}


proc ifDoneText {} {
    .t configure -state disabled
    return
}


proc ifMail {text} {

    if {![winfo exists .mail]} {
	toplevel    .mail
	wm withdraw .mail
	wm title    .mail {Mail report}

	text      .mail.t -width 80 -height 40 -relief sunken -bd 1 \
		-yscrollcommand {.mail.v set} \
		-xscrollcommand {.mail.h set}
	scrollbar .mail.v -orient v -command {.mail.t yview} -relief raised -bd 1
	scrollbar .mail.h -orient h -command {.mail.t xview} -relief raised -bd 1

	frame     .mail.btn        -relief raised -bd 1
	button    .mail.btn.ok     -text Ok     -command ifMailSend
	button    .mail.btn.cancel -text Cancel -command {destroy .mail}

	foreachWin .mail configure -bg lightsteelblue

	pack .mail.btn -side bottom -ipadx 2m -ipady 2m -expand 0 -fill both
	pack .mail.h   -side bottom -expand 0 -fill both
	pack .mail.v   -side left   -expand 0 -fill both
	pack .mail.t   -side top    -expand 1 -fill both

	pack .mail.btn.ok     -padx 2m -expand 1 -fill none -side left
	pack .mail.btn.cancel -padx 2m -expand 1 -fill none -side left
    }

    .mail.t delete 1.0 end
    .mail.t insert     end $text

    wm deiconify .mail
    return
}


proc ifMailSend {} {
    set mail [.mail.t get 1.0 end]

    # Talk to the local SMTP Server.
    # Use the information from the mail to identify sender and recipient.

    regexp   "To: *(\[^\n\]*)\n" $mail dummy to
    regexp "From: *(\[^\n\]*)\n" $mail dummy from

    set s [socket localhost smtp]
    fconfigure $s -buffering line

    # - future: More checking of server responses ?

    gets  $s
    puts  $s "MAIL FROM: $from"
    gets  $s
    puts  $s "RCPT TO: $to"
    gets  $s
    puts  $s "DATA"
    gets  $s
    puts  $s [string trimright $mail \n]
    puts  $s .
    gets  $s

    close $s

    splashText "Mail sent to $to"
    after 2000 {splashRemove ; after 400 destroy .mail}
    return
}

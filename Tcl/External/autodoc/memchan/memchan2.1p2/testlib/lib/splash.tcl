# This file contains generic support code for test suites built along the
# lines of the Tcl test suite and the suites of various extensions.
#
# Copyright (c) 1999 Andreas Kupries, <akupries@westend.com>
#
# -- Splash management -- 

proc splashRemove {} {
    # Remove and destroy an open splash screen.

    if {[winfo exists .splash]} {
	destroy .splash
	update
    }

    return
}


proc splashIntro {} {
    splashText  \
	    "Welcome to Tester v0.1, \
	    an application for running \
	    a test suite interactively"
    return
}


proc splashScan {} {
    # Assume existence of .splash, and format of splashIntro

    entry .splash.fbtext -relief sunken -bd 2
    .splash.fbtext delete 0 end

    pack  .splash.fbtext -side top -expand 0 -fill both \
	    -ipadx 2m -ipady 1m -before .splash.text
    update
    return
}



proc splashCenter {} {
    update idletasks

    set sWidth   [winfo screenwidth  .splash]
    set sHeight  [winfo screenheight .splash]
    set wrWidth  [winfo reqwidth     .splash]
    set wrHeight [winfo reqheight    .splash]
    set p        [winfo parent       .splash]

    set x        [expr {$sWidth/2  - $wrWidth/2  - [winfo vrootx $p]}]
    set y        [expr {$sHeight/2 - $wrHeight/2 - [winfo vrooty $p]}]

    wm geometry  .splash +$x+$y
    wm deiconify .splash
    return
}



proc splashText {text} {
    splashRemove

    regsub -all "\n" $text { } text
    regsub -all "\t" $text { } text
    regsub -all " +" $text { } text

    set image [splashTclLogo]

    toplevel    .splash -bg lightsteelblue
    wm withdraw .splash
    wm title    .splash Tester

    label       .splash.logo -image $image
    message     .splash.text -text  $text \
	    -width 10c -anchor c -relief raised -bd 1

    pack  .splash.logo -side left -expand 0 -fill both
    pack  .splash.text -side top  -expand 1 -fill both -ipadx 1c -ipady 1c

    foreachWin .splash configure -bg lightsteelblue
    splashCenter
    update
    return
}


proc splashWait {args} {
    global _splashBtn

    if {[winfo exists .splash.btn]} {
	eval destroy [winfo children .splash.btn]
    } else {
	frame .splash.btn -relief raised -bd 1
	pack  .splash.btn -side bottom -expand 0 -fill both -ipady 2m -ipadx 2m \
		-before .splash.logo
    }

    set i 0
    foreach btn $args {
	button .splash.btn.b$i -text $btn -command "set _splashBtn $i"
	pack   .splash.btn.b$i -side left -expand 1 -fill none -padx 2m -pady 1m
	incr i
    }

    foreachWin .splash.btn configure -bg lightsteelblue
    update

    vwait   _splashBtn
    destroy .splash.btn

    return $_splashBtn
}


proc splashDialog {text args} {
    splashText $text
    set btn [eval splashWait $args]
    splashRemove
    return $btn
}


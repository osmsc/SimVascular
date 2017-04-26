# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: cgi.tcl,v 1.7 1998/06/07 14:27:46 aku Exp $
#
# @c Helper procedures to facilitate multipage generation of HTML
# @c Redirection of output into a string is possible too. Is built
# @c on top of the <xref cgilib> by <xref libes>.
#
# @s HTML generation commands,
#
# @i HTML generation, multipage HTML, string HTML, cgi
# @see <xref cgitools>
# -------------------------------------------------------

package require Tcl 8.0
package require cgi

# force cgi commands into the interpreter
#catch {cgi_error_occured}
cgi_uid_check -off

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval cgi {
	variable version @base:mFullVersion@
	namespace export *

	# internal state
	# - handle of channel to write the HTML code into.
	# - string to write the HTML code into.
	# - hash table containing the stack of older buffers
	# - integer counter of stack depth

	variable           pageFile   ""
	variable           pageString ""
	variable           stringStack
	::pool::array::def stringStack
	variable           stackDepth 0
    }
}

# ---------------------------------------------------------


proc ::pool::cgi::putsFile {args} {
    # @c This is a replacement procedure for 'cgi_puts' as
    # @c contained in <xref cgilib> (by <xref libes>).
    # @c This version allows generation of more than one page.
    #
    # @a args: as accepted/required by the builtin 'puts'.

    variable pageFile

    if {"-nonewline" == "[lindex $args 0]"} {
	::puts -nonewline $pageFile [lindex $args 1]
    } else {
	::puts $pageFile [lindex $args 0]
    }
    return
}



proc ::pool::cgi::putsString {args} {
    # @c This is a replacement procedure for 'cgi_puts' as
    # @c contained in <xref cgilib> (by <xref libes>).
    # @c This version writes the HTML code into a string
    # @c which then can be retriieved later.
    #
    # @a args: as accepted/required by the builtin 'puts'.

    variable pageString

    if {"-nonewline" == "[lindex $args 0]"} {
	append pageString "[lindex $args 1]"
    } else {
	append pageString "[lindex $args 0]\n"
    }
    return
}


# --------------------------------------------------------
# higher management functionality
#
# i.   stack of string buffers


proc ::pool::cgi::openString {} {
    # @c Activates redirection of HTML output into a
    # @c stringbuffer. A stack of such buffers is
    # @c managed to allow for multiple redirections.

    variable stackDepth
    variable stringStack
    variable pageString

    if {$stackDepth == 0} {
	# Swap out the previously active output procedure
	# and install the string handler instead

	rename ::pool::cgi::Puts       ::pool::cgi::puts.old
	rename ::pool::cgi::putsString ::pool::cgi::Puts
    }

    # Save the current buffer on the stack and start with
    # a fresh one

    set  stringStack($stackDepth) $pageString
    incr stackDepth 1

    set pageString ""
    return
}


proc ::pool::cgi::closeString {} {
    # @c Returns the HTML code stored in the currently active
    # @c string buffer. Pops off one level of redirection
    # @c afterward.
    #
    # @r The HTML code stored in the currently active stringbuffer.

    variable stackDepth
    variable stringStack
    variable pageString

    set data $pageString

    incr stackDepth -1

    set pageString $stringStack($stackDepth)
    set stringStack($stackDepth) ""

    if {$stackDepth == 0} {
	# There are no strings active anymore, so swap in the old
	# output procedure.

	rename ::pool::cgi::Puts     ::pool::cgi::putsString
	rename ::pool::cgi::puts.old ::pool::cgi::Puts
    }

    return $data
}


proc ::pool::cgi::getString {script} {
    # @c Wrapper to <p ::pool::cgi::openString>
    # @c and <p ::pool::cgi::closeString>.
    # @c Ensures correct nesting of these procedures.
    #
    # @a script: Tcl code to evaluate, should contain cgi commands
    # @a script: producing HTML code. Nested 'getString' calls are
    # @a script: possible.
    #
    # @r The HTML code produced by <a script>.

    openString
    uplevel $script
    return [closeString]
}



# --------------------------------------------------------
# higher management functionality
#
# ii.   multi-page generation


proc ::pool::cgi::openPage {file} {
    # @c Opens the <a file> for writing and sets up everything
    # @c required to redirect generated HTML code into it.
    # @a file: Name of the file to write into.

    variable pageFile

    if {$pageFile != {}} {
	closePage
    }

    set pageFile [open $file w]

    rename ::pool::cgi::Puts     ::pool::cgi::puts.bak
    rename ::pool::cgi::putsFile ::pool::cgi::Puts
    return
}



proc ::pool::cgi::closePage {} {
    # @c Closes the current output file and switches back to
    # @c the normal mode of HTML generation.

    variable pageFile
    variable stackDepth

    if {$stackDepth > 0}  {
	error "wrong nesting ::pool::cgi::open/closeString"
    }
    if {$pageFile == {}} {
	return
    }

    close $pageFile
    set    pageFile ""

    rename ::pool::cgi::Puts     ::pool::cgi::putsFile
    rename ::pool::cgi::puts.bak ::pool::cgi::Puts
    return
}


# Now insert this package into the cgi library
#
# Save original write procedure inside our namespace, then create a
# forwarding procedure calling the procedure in the namespace. An alias
# is not possible as this would point to the procedure it was aliased
# to even after a rename. This feature we do *not* want, as we will
# switch the output procedure by renaming various internal procedures.

rename cgi_puts ::pool::cgi::Puts
proc cgi_puts {args} {
    return [uplevel ::pool::cgi::Puts $args]
}


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: file.tcl,v 1.5 2000/09/14 16:09:24 aku Exp $
#
# @c Useful file commands like link resolution, directory traversal, ...
# @s file commands
# ------------------------------------------------------

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval file {
	variable version @base:mFullVersion@
	namespace export *
    }
}



proc ::pool::file::subdirs {dir} {
    # @c	Find all subdirectories of <a dir>.  Softlinks
    # @c	pointing to directories are part of the result too.
    #
    # @a dir:	The directory to search in.
    # @r	List containing all found subdirectories
    #
    # @i subdirectory list, directory hierarchy

    set dirlist ""
    catch {
	set dirlist [glob -nocomplain [file join $dir *]/]
    }

    if {{} == $dirlist} {
	return ""
    }

    regsub -all {/ } $dirlist { } dirlist
    regsub      {/$} $dirlist {}  dirlist
    return $dirlist
}


proc ::pool::file::followLink {path} {
    # @c Follows <a path> to its destination. Recursion is
    # @c used to step through all intermediate softlinks.
    # @c <a path> is returned unchanged if it is a regular
    # @c file or directory.

    # @n Only the last component of <a path> is followed,
    # @n any softlinks higher in the path are not handled.

    # @a path:	The path to follow.
    # @r	Final destination of <a path>.
    # @i	softlink resolution, path stats

    if {![string match [file type $path] link]} {
	return $path
    }

    set path [file join $path [file readlink $path]]

    if {[string match [file type $path] link]} {
	return [followLink $path]
    }

    return $path
}


proc ::pool::file::resolveLinks {path} {
    # @author Maurice Diamantini <diam@ensta.fr>

    # @n I rewrote Maurice code to use the procedures I
    # @n already had in this file.

    # @c Follows <a path> to its destination. Recursion is
    # @c used to step through all intermediate softlinks.
    # @c <a path> is returned unchanged if it is a regular
    # @c file or directory. In contrast to <p ::pool::file::followLink>
    # @c all softlinks in the path are resolved.

    # @a path:	The path to follow.
    # @r	Nearly canonical name of <a path>. Nearly,
    # @r        as it may contain '.' and '..'.
    # @i	softlink resolution, path stats

    set path [followLink $path]
    set dir  [file dirname $path]

    # The 'x' has a sense behind it, but I don't remember which.
    if {"x$dir" == "x$path"} {
	return $path
    } else {
	return [file join [resolveLinks $dir] [file tail $path]]
    }
}



proc ::pool::file::realname {path} {
    # @author Maurice Diamantini <diam@ensta.fr>
    # @n I rewrote Maurice code to use the procedures I
    # @n already had in this file.

    # @c Generates the canonical name of <a path> via resolution
    # @c of all softlinks and elimination of relative directions.

    # @a path:	The path to follow.
    # @r	Canonical name of <a path>.
    # @i	softlink resolution, path stats

    return [normalizePath [resolveLinks $path]]
}



proc ::pool::file::descendDirs {var path script} {
    # @c	Executes <a script> for all directories found in the
    # @c	directory hierarchy beginning at <a path>. The
    # @c	<a script> has immediate access to the variable
    # @c	<a var>, which will be set to the current directory
    # @c	before each execution. The working directory, as delivered
    # @c	by `pwd`, will be set to the current directory too.
    # @c	The command takes great care to avoid looping
    # @c	(which might be caused by circular links)

    # @a var:	 Variable used to transfer the current path into the
    # @a var:    <a script>.
    # @a path:	 Start of the directory hierarchy to follow.
    # @a script: Tcl code executed upon each iteration.

    # @i descend directories, directory hierarchy, directory scan

    global errorInfo errorCode tcl_platform

    if {![file isdirectory $path]} {
	error "$path does not refer to a directory"
    }

    # table of visited inodes, to prevent looping
    ::pool::array::def inodes

    set pathlist  $path
    upvar $var loopvar

    set not_unix [string compare unix $tcl_platform(platform)]

    while {[llength $pathlist] > 0} {
	# loop until list of directories is exhausted

	set p [::pool::list::shift pathlist]

	# get path info, ignore non-stat'able directores
	if {[catch {file stat $p stat}]} {
	    continue
	}

	# From Sébastien Barré <sbarre@claranet.fr>
	#
	# Sadly, there is not inode informations in Windows :(
	# Therefore, 'stat' will return the same information for every
	# file, thus preventing any recursion to occurs ! Let's add a
	# test to prevent inode to be used on Windows platforms (it's
	# not that bad anyway, as there is no way to set up symlinks
	# or circular loops in Windows).

	if {!$not_unix} {
	    # ignore (dev,inode)-pairs visited earlier
	    set key "$stat(dev),$stat(ino)"

	    if {[info exists inodes($key)]} {
		continue
	    }
	    set inodes($key) 1
	}

	# ------------------------------------------------
	# execute script for path

	set here [pwd]
	catch {
	    cd          $p
	    set loopvar $p

	    set res [catch {uplevel $script} msg]
	    # handling of script result is defered behind catch
	    # and restoration of current directory
	}
	cd $here

	# possible results
	# 0 - ok,       nothing
	# 1 - error,    reflect up
	# 2 - return,   reflect up
	# 3 - break,    this loop!
	# 4 - continue, nothing
	# any other: user defined, reflect up.

	switch -- $res {
	    0 {}
	    1 {
		return  -code      error \
			-errorinfo $errorInfo \
			-errorcode $errorCode $msg}

	    2 {
		return -code return $msg
	    }
	    3 {
		return {}
	    }
	    4 {}
	    default {
		return -code $res
	    }
	}

	# ------------------------------------------------
	# tack subdirectories of 'p' to the start of the list,
	# this implements the depth first traversal.

	set pathlist [concat [subdirs $p] $pathlist]
    }
}



proc ::pool::file::descendFiles {var path script} {
    # @c Executes <a script> for all files found in the directory
    # @c hierarchy beginning at <a path>. The <a script>
    # @c has immediate access to the variable <a var>, which will
    # @c be set to the current file before each execution. The working
    # @c directory, as delivered by `pwd`, will be set to the current
    # @c directory too.
    # @c Implemented in terms of <proc ::pool::file::descendDirs>

    # @a var:	 Variable used to transfer the current path into the <a script>
    # @a path:	 Start of the directory hierarchy to follow.
    # @a script: Tcl code executed upon each iteration.

    # @i descend directories, directory hierarchy, directory scan, file scan

    global errorInfo errorCode

    # import variable into current scope, make it accessible to
    # '::pool::file::descendDirs'
    upvar $var loopvar

    descendDirs dir $path {
	# loop through files in current directory

	set flist ""
	catch {set flist [glob -nocomplain *]}

	foreach f $flist {
	    set loopvar [file join $dir $f]

	    set res [catch {uplevel $script} msg]

	    # possible results
	    # 0 - ok,       nothing
	    # 1 - error,    reflect up
	    # 2 - return,   reflect up
	    # 3 - break,    this whole loop!
	    # 4 - continue, nothing
	    # any other: user defined, reflect up.

	    switch -- $res {
		0 {}
		1 {
		    error "$msg\n$errorInfo"
		}
		2 {
		    return -code return $msg
		}
		3 {
		    return {}
		}
		4 {}
		default {
		    return -code $res
		}
	    }
	}
    }
}



proc ::pool::file::normalizePath {path} {
    # @c A <a path> containing '.' and/or '..' will be normalized,
    # @c i.e. these components will be removed and the preceding
    # @c path is modified accordingly. Empty path elements are
    # @c handled like '.' To prevent mishandling of leading '..'s
    # @c the current working directory will be prepended if
    # @c <a path> is relative.

    # @d This code does *not* account for (soft)links. See
    # @d <p ::pool::file::followLink> and <p ::pool::file::resolveLinks>
    # @d for that.
    # @a path: The path to normalize.
    # @r The normalized path.

    if {0 == [string compare relative [file pathtype $path]]} {
	set path [file join [pwd] $path]
    }

    set path [file split $path]

    set res {}
    foreach e $path {
	if {0 == [string compare .. $e]} {
	    ::pool::list::pop res
	} elseif {(0 != [string compare . $e]) && ($e != {})} {
	    lappend res $e
	}
    }

    return [eval file join $res]
}



proc ::pool::file::normalizeUnixPath {path} {
    # @c Same as <p ::pool::file::normalizePath>, but unconditionally uses
    # @c '/' as path separator.

    # @n This is not platform independent, but quite nice for
    # @n handling of internet urls. Because of this the working
    # @n directory is NOT tacked on to the front of the <a path>.

    # @d The code used here will mishandle leading ..'s

    # @a path: The path to normalize.
    # @r The normalized path.

    set path [split $path /]

    set res {}
    foreach e $path {
	if {0 == [string compare .. $e]} {
	    ::pool::list::pop res
	} elseif {(0 != [string compare . $e]) && ($e != {})} {
	    lappend res $e
	}
    }

    return [join $res /]
}



proc ::pool::file::here {} {
    # @c Determines the location of the script file currently active.
    # @r The path to the directory containing the active script
    # @i script location

    return [normalizePath [file join [pwd] [file dirname [info script]]]]
}





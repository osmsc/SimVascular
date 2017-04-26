# Tcl package index file, version 1.0
#if {[info tclversion] < 8.0} return

proc mc_ifneeded dir {
    rename mc_ifneeded {}
    regsub {\.} [info tclversion] {} version
    package ifneeded Memchan 2.1 "load [list [file join $dir @MEMCHAN_LIBFILE@$version.dll]] Memchan"
}

mc_ifneeded $dir


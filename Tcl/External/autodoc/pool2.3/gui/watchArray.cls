# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# 1998 -- Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: watchArray.cls,v 1.1 1998/06/01 19:56:00 aku Exp $
#
# @c Generation and maintenance of a variable watcher display.
# @s Watch the contents of an array variable.
# @i watch array variable, array variable watching, animated feedback, feedback
# -------------------------------------------

class watchArray : watchAManager {

    # @c Instances of this class are coupled to an array variable, then display
    # @c its current contents, tracking any changes made to it.


    # @v keys: Shadow array mapping the keys in the tracked array to the line
    # @v keys: in the text widget displaying key and value.

    var -array keys {}

    # @v maxKey: Length of longest key, to correct vertical alignment of keys
    # @v maxKey: and values.

    var maxKey

    # @v sortedKeys: The list of keys used in the array referenced by
    # @v sortedKeys: <o variable>, sorted in ascending order, to get stability
    # @v sortedKeys: into the display and no changing of lines due to internals
    # @v sortedKeys: of the hash table.

    var sortedKeys

    # @o varnamecolor:  The name of the color to use for the variable name.
    # @o varvaluecolor: The name of the color to use for the variable contents.

    option varnamecolor  -d red
    option varvaluecolor -d blue


    method createSubwidgets {} {
	# @c Called after object construction. Generates the internal widgets
	# @c and their layout.

	# This widget not only traces the variable contents, but changes to
	# '-variable' too. The latter cause a reset of the display.

	scrollbar    $this.s
	text         $this.t ;# -width $opt(-width) -height $opt(-height)
	::pool::ui::multiScroll $this.s vertical $this.t

	pack $this.s -side left -expand 0 -fill both
	pack $this.t -side left -expand 1 -fill both

	$this.t tag configure varname  -foreground $opt(-varnamecolor)
	$this.t tag configure varvalue -foreground $opt(-varvaluecolor)
	$this.t configure -state disabled

	return
    }



    method clearDisplay {} {
	# @c Method required by the superclass <c watchManager> initialize the
	# @c display after changes to -variable (but not the contents of the
	# @c associated variable!)

	$this.t configure -state normal
	$this.t delete 1.0 end
	$this.t configure -state disabled

	return
    }



    method initDisplay {} {
	# @c Method required by the superclass <c watchManager> initialize the
	# @c display after changes to -variable (but not the contents of the
	# @c associated variable!)

	upvar #0 $opt(-variable) v

	set sortedKeys [lsort [array names v]]
	set maxKey     [::pool::list::lengthOfLongestEntry $sortedKeys]

	Map2Lines
	BuildDisplay

	#update idletasks
	return
    }



    method updateDisplay {} {
	# @c Method required by the superclass <c watchManager> to propagate
	# @c changes to the value into the display.

	switch -- $operation {
	    w {
		if {[::info exists keys($item)]} {
		    # Change of existing entry. Set insertion cursor into the
		    # corresponding line, behind the key information and then
		    # write over the existing data.

		    upvar #0 $opt(-variable) v

		    set line $keys($item)
		    set pos  [expr {2+$maxKey}]

		    $this.t configure -state normal
		    $this.t mark set insert $line.$pos
		    $this.t delete   insert $line.end
		    $this.t insert   insert "$v($item)" varvalue
		    $this.t configure -state disabled

		} else {
		    # The array got a new entry, rebuild the whole structure
		    initDisplay
		}
	    }
	    u {
		# An entry was removed from the array, rebuild the whole
		# structure
		initDisplay
	    }
	}

	#update idletasks
	return
    }



    method Map2Lines {} {
	# @c Build a map associating the keys of the array we are connected to
	# @c to lines in our text widget.

	upvar #0 $opt(-variable) v

	::pool::array::clear keys

	set line 2
	foreach key $sortedKeys {
	    set  keys($key) $line
	    incr line
	}

	return
    }


    method BuildDisplay {} {
	# @c Clear the display and recreate it from the ground.

	upvar #0 $opt(-variable) v

	$this.t configure -state normal
	$this.t delete 1.0 end

	$this.t insert end "$opt(-variable) = \{\n"

	foreach k $sortedKeys {
	    set offset [expr {$maxKey - [string length $k]}]

	    $this.t insert end " ${k}[::pool::string::blank $offset] " varname
	    $this.t insert end "$v($k)\n"                              varvalue
	}

	$this.t insert end "\}"

	$this.t configure -state disabled
	return
    }
}


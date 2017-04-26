# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_GuiBase @gui:mFullVersion@
#
# CVS: $Id: stateline.cls,v 1.2 1998/09/30 19:05:02 aku Exp $
#
# @c Stateline widget. Is able to handle more than one source of messages.
# @s stateline widgets
# @i stateline
# -------------------------------------------

class stateline : widget {
    # @c Instances of this class display a line containing a textual message.
    # @c The shown message  can be changed at runtime. Setting the empty string
    # @c as message is possible and clears the shown line. There is a little
    # @c more than that to it. Messages are always associated with a symbolic
    # @c name (= handle) and if different handles are used the widget will
    # @c display the message associated to the handle used in the last set
    # @c statement. Clearing the message of a particular handle will cause the
    # @c system to display the message of the second last handle, and so on.
    # @c The display will be cleared only if all messages of all handles are
    # @c cleared by the user. Setting a message for a known handle overwrites
    # @c the message associated to it.

    # @v messages: Maps form handles to their strings. The string associated to
    # @v messages: the leftmost handle in <v handles> is actually displayed.
    # @v messages: Associating an empty string to that handle causes its removal
    # @v messages: from map and stack, and the text of the handle below it is
    # @v messages: displayed.

    # @v handles: A list of the handles whose texts are known to the widget.
    # @v handles: Managed as a stack, the leftmost position (index 0) is its
    # @v handles: top.

    var -array messages
    var        handles {}

    # This class needs no special constructor.

    method createSubwidgets {} {
	# @c Creates and packs the widget required by the stateline.

	label $this._text -border 2 -relief sunken -text {} -anchor w
	pack  $this._text -expand 1 -fill both -side top -ipadx 2m -ipady 1m

	addSubwidget text $this._text
	return
    }


    method setText {handle text} {
	# @c Accessor method to place a message in the stateline.
	#
	# @a handle: The symbolic name associated to the message. Can be used
	# @a handle: between messages from several different sources.
	# @a text:   The text to show in the stateline.

	# Remove the handle from the stack, whereever it is, ...

	::pool::list::delete handles $handle

	if {$text != {}} {
	    # ... then add it to the top (for a nonempty message)
	    # and display the now current message.

	    set messages($handle) $text
	    ::pool::list::unshift handles $handle
	    $this._text configure -text $text

	} else {
	    # ... The message of this handle is cleared. Don't add it back,
	    # but display the message of the handle now at the top of the
	    # list. Clear the display, if there is none.

	    unset messages($handle)
	    if {$handles != {}} {
		$this._text configure -text $messages([lindex $handles 0])
	    } else {
		$this._text configure -text ""
	    }
	}

	return
    }
}


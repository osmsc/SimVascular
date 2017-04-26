# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: fmtIf.cls,v 1.1 1998/05/26 20:34:27 aku Exp $
#
# @c Internal interface to the formatter object
# @s Internal interface to formatter
# @i formatter interface, internal interface to formatter
# ----------------------------------------------------------------------


class formatterInterface {
    # @c All classes wishing to use the application specified formatter object
    # @c have to derive from this class to get the necessary functionality for
    # @c accessing it.

    # @o formatter: Reference to the used formatter. Automatically transfered
    # @o formatter: into an internal variable for hopefully faster access (one
    # @o formatter: hash lookup, not two).

    # ---------------------------------------------------

    option formatter -d {} -a TrackFormatter

    # @v fmt: Internal shadow of option <o formatter>.

    var fmt


    method formatterInterface {} {
	# @c Constructor, initializes the option and its shadow.

	${this}::TrackFormatter -formatter {}
	return
    }


    method TrackFormatter {o oldValue} {
	# @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o formatter>. Propagates the new value to
	# @c the internal shadow.
	#
	# @a o: The name of the changed option, here always [strong -formatter].
	# @a oldValue: The value of the option before the change. Ignored here.

	set fmt $opt(-formatter)
	return
    }


    method Fmt {args} {
	# @c Method for accessing the formatter functionality. Added because I
	# @c like '$fmt do_something ...' better than '$fmt do_something ...'.
	#
	# @a args: The arguments given to the formatter.

	return [uplevel [list $fmt $args]]
    }
}


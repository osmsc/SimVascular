# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: distInterface.cls,v 1.1 1998/05/26 20:34:26 aku Exp $
#
# @c Internal interface to the global distribution object
# @s Internal interface to distribution
# @i distribution interface, internal interface to distribution
# ----------------------------------------------------------------------


class distInterface {
    # @c All classes wishing to use the global distribution object have to
    # @c derive from this class to get the necessary functionality for
    # @c accessing it.

    # @o dist: Reference to the global <c distribution> object managing the
    # @o dist: documentation tree. Automatically transfered into an internal
    # @o dist: variable for hopefully faster access (one hash lookup, not two).

    option dist -d {} -a TrackDist

    # @v dist: Internal shadow of option <o dist>.

    var dist


    method distInterface {} {
	# @c Constructor, initializes the option and its shadow.

	${this}::TrackDist -dist {}
	return
    }



    method TrackDist {o oldValue} {
	# @c Internal method. Called by the generic option tracking mechanism
	# @c for any change made to <o dist>. Propagates the new value to
	# @c the internal shadow.
	#
	# @a o: The name of the changed option, here always [strong -dist].
	# @a oldValue: The value of the option before the change. Ignored here.

	set dist $opt(-dist)
	return
    }



    method Dist {args} {
	# @c Method for accessing the functionality of the distribution object.
	# @c Added because I like '$dist do_something ...' better than
	# @c '$dist do_something ...' or '$opt(-dist) do_something'.
	#
	# @a args: The arguments given to the distribution object

	return [uplevel [list $dist $args]]
    }
}


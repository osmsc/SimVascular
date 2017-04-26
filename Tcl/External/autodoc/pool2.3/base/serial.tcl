# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: serial.tcl,v 1.5 1998/06/01 19:55:16 aku Exp $
#
# @c Generator for globally unique sequence-numbers. Useful as
# @c object handles, filenames, ... It is allowed to give a used
# @c number back. The system will reuse such numbers. The namespace
# @c holding its procedures is used to encapsulate the internal state.
#
# @s Generation of sequence numbers
#
# @i serial numbers, sequence, handles

# Constraints on the procedures:
#
# 1) In initial state (no numbers generated)
#
#	(x := new ; delete x ; y := new)  ==> (x = y)
#
# 2) In general
#
#	(x := new ; delete x) ==> (E(i): (repeat i [y := new]) ==> (x = y))
#
#    Alternative phrasing:
#	After creation and deletion of a number it will appear again as
#	result of 'new' sometime in the future.
#
#	Nothing is said about the exact value of 'i'. It depends on the
#	context (new/delete sequence executed before) and the chosen
#	strategy for reusing numbers (lifo vs. fifo).
#
#	We use FIFO here, but this is NOT documented to the user!


package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval serial {
	variable version @base:mFullVersion@
	namespace export *

	# Internal state of the generator
	# The last generated number.
	variable next 0

	# Contains a list of all numbers given back
	# and therefore available for reuse
	variable revoked ""
    }
}



proc ::pool::serial::new {} {
    # @c Generates a new serial number.
    #
    # @r The new serial number.

    variable next
    variable revoked

    if {$revoked == {}} {
	# Nothing is reusable, take next number

	return [incr next]
    } else {
	# Recycle an old number

	return [::pool::list::shift revoked]
    }

    # we will not come to this line!
}



proc ::pool::serial::delete {s} {
    # @c Marks the specified serial number <arg s> as deleted. This
    # @c number will be reused by <proc ::pool::serial::new>.
    #
    # @a s: serial number to revoke

    variable revoked
    lappend  revoked $s
    return
}


# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: udbBase.cls,v 1.1 1998/06/01 19:56:16 aku Exp $
#
# @c Management of a database to map from users to authentication
# @c codes (passwords) and storage references. Definition of its
# @c interface as required by the POP3 server core, see <c pop3Server>.
#
# @s User authentication database, interface definition
# @i User authentication, authentication database, user database, passwords
# -----------------------------

class userdbBase {
    # @c This class provides the interface to an account database, as seen by
    # @c the POP3 server core in <c pop3Server>.

    method lookup {name} {
	# @c Abstract method.
	# @c Query database for information about user <a name>.
	# @a name: Name of the user to query for.
	# @r a 2-element list containing password and storage 
	# @r location of user <a name>, in this order.

	error "[oinfo class]: abstract method 'lookup' not overidden"
    }
}


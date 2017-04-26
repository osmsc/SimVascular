# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Net @net:mFullVersion@
#
# CVS: $Id: adb.cls,v 1.1 1998/06/01 19:56:15 aku Exp $
#
# @c Management of a database to map from users to authentication
# @c codes (passwords) and storage references.
# @c Complete definition.
#
# @s User authentication database
# @i User authentication, authentication database, user database, passwords
# -----------------------------

class aDB : userdbBase {
    # @c A file based implementation of the interface as defined by
    # @c <c userdbBase>.

    # @v user: The in-memory database. It is indexed by user names and maps
    # @v user: them to 2-element lists containing the associated password and
    # @v user: storage reference, in this order.

    var -array  user {}

    # @v externalFile: The name of the last file used as argument to <m read>.
    # @v externalFile: Used by <m save> if called without or empty argument.

    var externalFile



    method add {usrName pwd storage} {
	# @c Add the user <a usrName> to the database, together with its
	# @c password and a storage reference. The latter is stored and passed
	# @c through this system without interpretation of the given value.

	# @a usrName:  The name of the user defined here.
	# @a pwd:      Password given to the user.
	# @a storage:  symbolic reference to the maildrop of user <a usrName>.
	# @a storage:  Usable for a storage system only.

	if {$usrName == {}} {error "user specification missing"}
	if {$pwd     == {}} {error "password not specified"}
	if {$storage == {}} {error "storage location not defined"}

	set user($usrName) [list $pwd $storage]
	return
    }


    method remove {usrName} {
	# @c Remove the user <a usrName> from the database.
	#
	# @a usrName: The name of the user to remove.

	unset user($usrName)
	return
    }


    method rename {usrName newName} {
	# @c Renames user <a usrName> to <a newName>.
	# @a usrName: The name of the user to rename.
	# @a newName: The new name to give to the user

	set data $user($usrName)
	unset     user($usrName)

	set user($newName) $data
	return
    }


    method lookup {usrName} {
	# @c Query database for information about user <a usrName>.
	# @c Overrides <m userdbBase:lookup>.
	# @a usrName: Name of the user to query for.
	# @r a 2-element list containing password and storage 
	# @r reference for user <a usrName>, in this order.

	return $user($usrName)
    }


    method isRegistered {usrName} {
	# @c Determines wether user <a usrName> is registered or not.
	# @a usrName:     The name of the user to check for.

	return [::info exists user($usrName)]
    }


    method who {} {
	# @c Determines the names of all registered users.
	# @r A list containing the names of all registered users.

	return [array names user]
    }


    method save {{file {}}} {
	# @c Stores the current contents of the in-memory user database
	# @c into the specified file.

	# @a file: The name of the file to write to. If it is not specified, or
	# @a file: as empty, the value of the member variable <v externalFile>
	# @a file: is used instead.

	# save operation: do a backup of the file, write new contents,
	# restore backup in case of problems.

	if {$file == {}} {
	    set file $externalFile
	}

	set dir [file directory $file]
	set tmp [file join $dir [pid]]

	set   f [open $tmp w]
	puts $f "# -*- tcl -*-"
	puts $f "# ----------- POPsy user authentication database -"
	puts $f ""

	foreach name [array names user] {
	    set pwd     [lindex $user($name) 0]
	    set storage [lindex $user($name) 1]

	    puts $f "\tadd [list $name] [list $pwd] [list $storage]"
	}

	puts  $f ""
	close $f
	
	file rename -force $file $file.old
	file rename -force $tmp  $file
	return
    }


    method read {file} {
	# @c Reads the contents of the specified <a file> into the in-memory
	# @c database of users, passwords and storage references.

	# @a file: The name of the file to read.

	# @n The name of the file is remembered internally, and used by
	# @n <m save> (if called without or empty argument).

	set externalFile $file

	::pool::array::clear user

	# automatically uses the 'add' method of this object.
	source $file
	return
    }
}


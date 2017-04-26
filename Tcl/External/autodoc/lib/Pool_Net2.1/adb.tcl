# -*- tcl -*-
# Automatically generated from file '/home/aku/.mkd28810/pool2.3/net/adb.cls'.
# Date: Thu Sep 14 23:03:27 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> aDB <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::aDB {
    variable  _superclasses    userdbBase
    variable  _scChainForward  aDB
    variable  _scChainBackward aDB
    variable  _classVariables  {}
    variable  _methods         {add isRegistered lookup read remove rename save who}

    variable  _variables
    array set _variables  {externalFile {aDB {isArray 0 initialValue {}}} user {aDB {isArray 1 initialValue {}}}}

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {rename . read . add . remove . lookup . isRegistered . who . save .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::aDB::add {usrName pwd storage} {
    ::pool::oo::support::SetupVars aDB
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



proc ::pool::oo::class::aDB::isRegistered {usrName} {
    ::pool::oo::support::SetupVars aDB
    # @c Determines wether user <a usrName> is registered or not.
	# @a usrName:     The name of the user to check for.

	return [::info exists user($usrName)]
}



proc ::pool::oo::class::aDB::lookup {usrName} {
    ::pool::oo::support::SetupVars aDB
    # @c Query database for information about user <a usrName>.
	# @c Overrides <m userdbBase:lookup>.
	# @a usrName: Name of the user to query for.
	# @r a 2-element list containing password and storage 
	# @r reference for user <a usrName>, in this order.

	return $user($usrName)
}



proc ::pool::oo::class::aDB::read {file} {
    ::pool::oo::support::SetupVars aDB
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



proc ::pool::oo::class::aDB::remove {usrName} {
    ::pool::oo::support::SetupVars aDB
    # @c Remove the user <a usrName> from the database.
	#
	# @a usrName: The name of the user to remove.

	unset user($usrName)
	return
}



proc ::pool::oo::class::aDB::rename {usrName newName} {
    ::pool::oo::support::SetupVars aDB
    # @c Renames user <a usrName> to <a newName>.
	# @a usrName: The name of the user to rename.
	# @a newName: The new name to give to the user

	set data $user($usrName)
	unset     user($usrName)

	set user($newName) $data
	return
}



proc ::pool::oo::class::aDB::save {{file {}}} {
    ::pool::oo::support::SetupVars aDB
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



proc ::pool::oo::class::aDB::who {} {
    ::pool::oo::support::SetupVars aDB
    # @c Determines the names of all registered users.
	# @r A list containing the names of all registered users.

	return [array names user]
}



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::aDB::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::userdbBase::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences aDB

# Create object instantiation procedure
interp alias {} aDB {} ::pool::oo::support::New aDB

# -------------------------------


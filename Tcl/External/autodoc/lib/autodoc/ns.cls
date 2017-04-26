# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: ns.cls,v 1.1 2000/09/05 20:10:43 aku Exp $
#
# @c Management of namespaces.
# @s Namespaces
# @i namespaces
# ----------------------------------------------


class namespaceDescription : azIndexEntry {
    # @c This class manages the properties of a single class.


    # @v listtype: Either one of [strong comma] or [strong par].
    # @v listtype: Defines the appearance of the lists used to
    # @v listtype: reference containing namespace, procedures and classes.
    # @v listtype: Takes its value from <o distribution:clisttype>.

    var listtype
    # Note: should check that!

    # @o log: Handle of the <x syslogConnection> object to use for logging

    option log

    # @v classes: List of classes contained in the namespace. Actually
    # @v classes: contains the handles of their <c classDescription>
    # @v classes: objects and not their names.

    var classes

    # @v namespaces: List of namespaces contained in the namespace. Actually
    # @v namespaces: contains the handles of their <c classDescription>
    # @v namespaces: objects and not their names.

    var namespaces

    # @v procs: List of procedures contained in the namespace. Actually
    # @v procs: contains the handles of their <c procDescription>
    # @v procs: objects and not their names.

    var procs

    # @v parent: Handle of the parent namespace.

    var parent


    method namespaceDescription {} {
	# @c Constructor. Takes the name of the namespace, extracts
	# @c the name of the containing namespace and retrieves the
	# @c associated object. If that does not exist it is
	# @c constructed and added to the global index.

	set entity namespace

	if {0 != [string compare "::" $opt(-name)]} {
	    set parent [$opt(-dist) nsContaining $opt(-name)]
	    $parent addNamespace $this
	} else {
	    # :: is root namespace, without a parent
	    set parent {}
	}
	return
    }


    method getPage {} {
	# @r The url of the page containing the namespace description.

	set nsname $opt(-name)

	if {[catch {set nsname [string map {:: _} $nsname]}]} {
	    regsub -all {::} $nsname {_} nsname
	}
	return [$fmt pageFile ns_$nsname]
    }


    method addProcedure {o} {
	# @c Add a procedure defined in this namespace to it.
	# @a o: The <c procDescription> object added to the namespace.
	lappend procs $o
	return
    }


    method addClass {o} {
	# @c Add a class defined in this namespace to it.
	# @a o: The <c classDescription> object added to the namespace.
	lappend classes $o
	return
    }


    method addNamespace {o} {
	# @c Add a namespace defined in this namespace to it.
	# @a o: The <c namespaceDescription> object added to the namespace.
	lappend namespaces $o
	return
    }


    method write {} {
	# @c Generates the formatted text describing the namespace.

	$opt(-log) log debug writing namespace [name] ([page])
	set listtype [$dist cget -clisttype]

	$dist pushContext $this
	$fmt  pushClass   namespace

	$fmt  newPage [page] "Namespace '[name]'"
	$dist writeJumpbar

	if {$parent != {}} {
	    $fmt definitionList {
		$fmt defterm {Contained in} [$parent link]
	    }
	}

	$fmt pushClass namespace-listing
	WriteList Namespaces [$fmt sortByName $namespaces]
	$fmt popClass

	$fmt pushClass proc-listing
	WriteList Procedures [$fmt sortByName $procs]
	$fmt popClass

	$fmt pushClass class-listing
	WriteList Classes    [$fmt sortByName $classes]
	$fmt popClass

	$fmt  closePage
	$dist popContext
	$fmt  popClass
	return
    }


    method WriteList {title mList} {
	# @c Internal method used by the page generator routine (<m write>) to
	# @c produce the output for all procedures contained in the namespace.
	#
	# @a title: The term under which the list is written.
	# @a mList: The list of objects to call.

	if {[llength $mList] == 0} {
	    return
	}

	$fmt section $title
	$fmt itemize {
	    foreach p $mList {
		$fmt item [$p link]
	    }
	}

	if {0} {
	    set text [list]
	    foreach p $mList {
		lappend text [$p link]
	    }
	    set text [join $text [$fmt getString {$fmt parbreak}]]

	    $fmt defterm $title $text
	}
	return
    }


    method clear {} {
	# @c Resets state information.

	azIndexEntry_clear
	return
    }


    method firstLetter {} {
	# @r the first letter of the name of this index entry.

	# Skip over ':' (namespaces) but not for '::' alone.

	set n   $opt(-name)
	set pfx [$dist cget -namespace-prefix]
	if {$pfx != {}} {
	    regsub "^$pfx" $n {} n
	}
	set n [string trim $n :]
	if {$n == {}} {
	    return [string index $opt(-name) 0]
	} else {
	    return [string index $n 0]
	}
    }
}


# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: classIndex.cls,v 1.3 2000/09/05 20:10:42 aku Exp $
#
# @c Management of class indices.
# @s Class indices.
# @i classes, class index, indices
# ----------------------------------------------------------------------


class classIndex : azIndex problemIndex {
    # @c Manages a single class index. Entries are the classes encountered
    # @c during the scan of the directory hierarchy. The system recognizes
    # @c only classes written by using the OO kernel in the <d Pool_Base>
    # @c package and <d iTcl> classes.


    method classIndex {} {
	# @c Constructor, parameterizes the base class.

	set indexPage       classes
	set indexName       classes
	set indexTitle      "Index of classes"
	set indexShortTitle Classes
	set entity          class
	return
    }


    method getRef {name} {
	# @c Override of baseclass functionality (<m indexBase:getRef>). 
	# @c A class not in the index may have an external dependency
	# @c defined for it. If that is the case the link associated
	# @c with that reference is returned. Only if this fails too
	# @c an error is generated.
	#
	# @a name: The name of the class searched by the caller.

	foreach i $items {
	    if {[string compare $name [$i name]] == 0} {
		return [list 1 [$i link]]
	    }
	}

	# Class not known, look for external dependency.

	if {![catch {set link [$fmt linkRef dep_$name]}]} {
	    return [list 1 $link]
	}

	if {![catch {set link [$fmt linkRef xr_$name]}]} {
	    return [list 1 $link]
	}

	return [list 0 [refError $name]]
    }


    method mref {class name} {
	# @c Determines wether <a name> is a method of <a class> or not and
	# @c returns the appropriately formatted text (a hyperlink, or the
	# @c name marked as error). Indirectly used by
	# @c <m distribution:crResolve> to resolve embedded crossreferences.
	# @c Errors are added to the list of problems associated to the entity
	# @c containing the cross reference.
	#
	# @a name:  The name of the method to look for.
	# @a class: The name of the class to look for.
	#
	# @r Formatted text for a hyperlink to the definition of <a name> or
	# @r the name marked as error.

	set fail [catch {set classObj [itemByName $class]}]
	if {$fail} {
	    return "[ref $class]:$name"
	} else {
	    if {[string compare $classObj [$dist CurrentClass]] == 0} {
		return [$classObj mref $name]
	    } else {
		return [ref $class]:[$classObj mref $name]
	    }
	}
    }



    method oref {class name} {
	# @c Determines wether <a name> is an option of <a class> or not and
	# @c returns the appropriately formatted text (a hyperlink, or the
	# @c name marked as error). Indirectly used by
	# @c <m distribution:crResolve> to resolve embedded crossreferences.
	# @c Errors are added to the list of problems associated to the entity
	# @c containing the cross reference.
	#
	# @a name: The name of the option to look for.
	# @a class: The name of the class to look for.
	#
	# @r Formatted text for a hyperlink to the definition of <a name> or
	# @r the name marked as error.

	set fail [catch {set classObj [itemByName $class]}]
	if {$fail} {
	    return "[ref $class]:$name"
	} else {
	    if {[string compare $classObj [$dist CurrentClass]] == 0} {
		return [$classObj oref $name]
	    } else {
		return [ref $class]:[$classObj oref $name]
	    }
	}
    }



    method vref {class name} {
	# @c Determines wether <a name> is a member variable of <a class> or
	# @c not and returns the appropriately formatted text (a hyperlink, or
	# @c the name marked as error). Indirectly used by
	# @c <m distribution:crResolve> to resolve embedded crossreferences.
	# @c Errors are added to the list of problems associated to the entity
	# @c containing the cross reference.
	#
	# @a name:  The name of the member variable to look for.
	# @a class: The name of the class to look for.
	#
	# @r Formatted text for a hyperlink to the definition of <a name> or
	# @r the name marked as error.

	set fail [catch {set classObj [itemByName $class]}]
	if {$fail} {
	    return "[ref $class]:$name"
	} else {
	    if {[string compare $classObj [$dist CurrentClass]] == 0} {
		return [$classObj vref $name]
	    } else {
		return [ref $class]:[$classObj vref $name]
	    }
	}
    }



    method clear {} {
	# @c Resets state information

	azIndex_clear
	problemIndex_clear
	return
    }



    method writeProblemPage {} {
	# @c Writes a page containing references to the detailed problem
	# @c descriptions of classes having such.

	if {[numProblemObjects] > 0} {
	    $fmt  newPage [pPage] "Problematic classes"
	    $dist writeJumpbar

	    writeProblemIndex
	    $fmt closePage

	    foreach o $problemObjects {
		$o writeProblemPage
	    }
	}
	return
    }
}


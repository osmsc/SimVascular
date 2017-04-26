# -*- tcl -*-
# Automatically generated from file 'classIndex.cls'.
# Date: Thu Sep 07 18:20:48 MEST 2000
# -------------------------------
# ** Do NOT edit manually **
#
# ** Provided class       **     >> classIndex <<
# -------------------------------

package require Pool_Base

# -------------------------------
# Namespace describing the class
namespace eval ::pool::oo::class::classIndex {
    variable  _superclasses    {azIndex problemIndex}
    variable  _scChainForward  classIndex
    variable  _scChainBackward classIndex
    variable  _classVariables  {}
    variable  _methods         {clear constructor getRef mref oref vref writeProblemPage}

    variable  _variables
    array set _variables {_ _}
    unset     _variables(_)

    variable  _options
    array set _options {_ _}
    unset     _options(_)

    variable  _optionAliases
    array set _optionAliases {_ _}
    unset     _optionAliases(_)

    variable  _methodTable
    array set _methodTable  {oref . getRef . writeProblemPage . mref . constructor . clear . vref .}

    # Export every method
    namespace export -clear *
}

# -------------------------------


proc ::pool::oo::class::classIndex::clear {} {
    ::pool::oo::support::SetupVars classIndex
    # @c Resets state information

	azIndex_clear
	problemIndex_clear
	return
}



proc ::pool::oo::class::classIndex::constructor {} {
    ::pool::oo::support::SetupVars classIndex
    # @c Constructor, parameterizes the base class.

	set indexPage       classes
	set indexName       classes
	set indexTitle      "Index of classes"
	set indexShortTitle Classes
	set entity          class
	return
}



proc ::pool::oo::class::classIndex::getRef {name} {
    ::pool::oo::support::SetupVars classIndex
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



proc ::pool::oo::class::classIndex::mref {class name} {
    ::pool::oo::support::SetupVars classIndex
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



proc ::pool::oo::class::classIndex::oref {class name} {
    ::pool::oo::support::SetupVars classIndex
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



proc ::pool::oo::class::classIndex::vref {class name} {
    ::pool::oo::support::SetupVars classIndex
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



proc ::pool::oo::class::classIndex::writeProblemPage {} {
    ::pool::oo::support::SetupVars classIndex
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



# -------------------------------
# Entrypoint for autoloader
proc ::pool::oo::class::classIndex::loadClass {} {}

# Request information about all superclasses
::pool::oo::class::azIndex::loadClass
::pool::oo::class::problemIndex::loadClass

# Integrate superclasses into definition
::pool::oo::support::FixReferences classIndex

# Create object instantiation procedure
interp alias {} classIndex {} ::pool::oo::support::New classIndex

# -------------------------------


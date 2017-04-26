# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: string.tcl,v 1.11 1999/02/14 19:48:16 aku Exp $
#
# @c Additional string operations. Some procedures might be better placed
# @c below the standard string command, but I've decided to wait for ensembles
# @c before doing this.
#
# @s Additional string operations.
# @i string operation

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval string {
	variable version @base:mFullVersion@
	namespace export *
    }
}


proc ::pool::string::rep {n text} {
    # @c Replicates <a n> times the string <a text>.
    #
    # @r The <a text>, replicated <a n> times.
    #
    # @a text: string to replicate.
    # @a n:    Number of replications. A value < 0 is handled as 0
    #
    # @i replication
    #
    # @note This algorithm proved to be rather fast, even in the
    # @note small range of n in {60..90}. An alternative definition
    # @note using regsub and format with O(n) complexity, thus doing
    # @note most things at C-level is beaten regularly for n > 74!

    if {$n <= 0} {
	# No replication required

	return ""
    } elseif {$n == 1} {
	# Quick exit for recursion

	return $text
    } elseif {$n == 2} {
	# Another quick exit for recursion

	return $text$text
    } elseif {0 == ($n % 2)} {
	# Halving the problem results in O (log n) complexity.

	set result [rep [expr {$n / 2}] $text]
	return "$result$result"
    }

    # Uneven length, reduce problem by one
    return "$text[rep [incr n -1] $text]"
}



proc ::pool::string::blank {n} {
    # @c Generates a string consisting out of <a n> spaces.
    # @c This is a convenient wrapper to <proc ::pool::string::rep>
    # @c for creation of an arbitrary number of spaces.
    #
    # @r A string consisting out of <a n> spaces.
    #
    # @a n: length of the string to generate.
    #
    # @i replication, generate blanks, blank generation, whitespace.

    return [::pool::string::rep $n { }]
}



proc ::pool::string::chop {string} {
    # @c Removes the last character from the given <a string>.
    #
    # @a string: The string to manipulate.
    #
    # @r The <a string> without its last character.
    #
    # @i chopping

    return [string range $string 0 [expr {[string length $string]-2}]]
}



proc ::pool::string::tail {string} {
    # @c Removes the first character from the given <a string>.
    # @c Convenience procedure.
    #
    # @a string: string to manipulate.
    #
    # @r The <a string> without its first character.
    #
    # @i tail

    return [string range $string 1 end]
}



proc ::pool::string::cap {string} {
    # @c Capitalizes first character of the given <a string>.
    # @c Complementary procedure to <p ::pool::string::uncap>.
    #
    # @a string: string to manipulate.
    #
    # @r The <a string> with its first character capitalized.
    #
    # @i capitalize

    return \
	    [string toupper \
	    [string index $string 0]][string range $string 1 end]
}



proc ::pool::string::uncap {string} {
    # @c unCapitalizes first character of the given <a string>.
    # @c Complementary procedure to <p ::pool::string::cap>.
    #
    # @a string: string to manipulate.
    #
    # @r The <a string> with its first character uncapitalized.
    #
    # @i uncapitalize

    return \
	    [string tolower \
	    [string index $string 0]][string range $string 1 end]
}



proc ::pool::string::replace {string from to {new {}}} {
    # @c Replaces the part of the <a string> between indices
    # @c <a from> and <to> with the text in <a new>. <a to>
    # @c must not be smaller than <a from>.
    #
    # @a string: The string to manipulate.
    # @a from:   The index of the first character to cut out of <a string>.
    # @a to:     The index behind the last character to cut of <a string>.
    # @a to:     The special value 'new' denotes replacement to the end of
    # @a to:     the string.
    # @a new:    The string replacing the information cut out of <a string>.
    #
    # @r The changed string.
    #
    # @i replace

    if {"$to" == "end"} {
	incr from -1
	return [string range $string 0 $from]$new
    } elseif {$to < $from } {
	error "illegal range specification"
    } else {
	incr from -1
	#incr to
	return [string range $string 0 $from]$new[string range $string $to end]
    }

    # We will not reach this line
}



proc ::pool::string::stripPrefix {text prefix} {
    # @c Strips <a prefix> from <a text>, if found at its start.
    #
    # @a text: The string to check for <a prefix>.
    # @a prefix: The string to remove from <a text>.
    #
    # @r The <a text>, but without <a prefix>.
    #
    # @i remove, prefix

    # Be careful, protect all special characters in the given prefix,
    # we want them as characters, not their special meaning.

    regsub -all {([][)(.*+^$?|])} $prefix {\\\1} prefix
    regsub --   "^$prefix"        $text   {}     text
    return $text
}



proc ::pool::string::wrap {text len} {
    # @author Jeffrey Hobbs <jeff.hobbs@acm.org>
    #
    # @c Wraps the given <a text> into multiple lines not
    # @c exceeding <a len> characters each. Lines shorter
    # @c than <a len> characters might get filled up.
    #
    # @a text: The string to operate on.
    # @a len: The maximum allowed length of a single line.
    #
    # @r Basically <a text>, but with changed newlines to
    # @r restrict the length of individual lines to at most
    # @r <a len> characters.

    # @n This procedure is not checked by the testsuite.

    # @i wrap, word wrap

    # Convert all newlines into spaces and initialize the result
    # see ::pool::string::oneLine too.

    regsub -all "\n" $text { } text
    incr len -1

    set out {}

    # As long as the string is longer than the intended length of
    # lines in the result:

    while {[string len $text] > $len} {
	# - Find position of last space in the part of the text
	#   which could a line in the result.

	# - We jump out of the loop if there is none and the whole
	#   text does not contain spaces anymore. In the latter case
	#   the rest of the text is one word longer than an intended
	#   line, we cannot avoid the longer line.

	set i [string last { } [string range $text 0 $len]]

	if {$i == -1 && [set i [string first { } $text]] == -1} {
	    break
	}

	# Get the just fitting part of the text, remove any heading
	# and trailing spaces, then append it to the result string,
	# don't close it with a newline!

	append out [string trim [string range $text 0 [incr i -1]]]\n

	# Shorten the text by the length of the processed part and
	# the space used to split it, then iterate.

	set text [string range $text [incr i 2] end]
    }

    return $out$text
}



proc ::pool::string::rhel {text} {
    # @c Removes the Heading Empty Lines of <a text>.
    #
    # @a text: The text block to manipulate.
    #
    # @r The <a text>, but without heading empty lines.
    #
    # @i remove, empty lines

    regsub -- "^(\[ \t\]*\n)*" $text {} text
    return $text
}



proc ::pool::string::rhc {text} {
    # @c Removes the heading comments from tcl code stored
    # @c in <a text> and returns the modified result. Empty
    # @c lines between comment lines are considered as part
    # @c of the comment block and therefore removed.
    #
    # @a text: The code block to manipulate.
    #
    # @r Basically <a text>, but without heading comments.
    #
    # @i remove, heading comments, tcl code, scripts

    set pattern \
	    "^\[ \t]*#\[^\n]*\n*(\[ \t]*#\[^\n]*\[ \t\n]*)*"

    regsub $pattern $text {} text
    return $text
}



proc ::pool::string::indent {text prefix} {
    # @c The specified <a text>block is indented
    # @c by <a prefix>ing each line.
    #
    # @a text:   The paragraph to indent.
    # @a prefix: The string to use as prefix for each line
    # @a prefix: of <a text> with.
    #
    # @r Basically <a text>, but indented a certain amount.
    #
    # @i indent

    # @n This procedure is not checked by the testsuite.

    set text [string trim $text]

    regsub --      {^}            $text $prefix     text
    regsub -all -- "\n"           $text "\n$prefix" text
    regsub -all -- "\n\[ \t\]*\n" $text "\n\n"      text

    return $text
}



proc ::pool::string::hangingIndent {text prefix} {
    # @c The specified <a text>block is indented
    # @c by <a prefix>ing each line [strong after] the first [strong !]
    #
    # @a text:   The paragraph to indent.
    # @a prefix: The string to use as prefix for each line
    # @a prefix: of <a text> with.
    #
    # @r Basically <a text>, but indented a certain amount.
    #
    # @i indent, hanging

    # @n This procedure is not checked by the testsuite.

    set text [string trim $text]

    regsub -all -- "\n"           $text "\n$prefix" text
    regsub -all -- "\n\[ \t\]*\n" $text "\n\n"      text
    return [string trim $text]
}



proc ::pool::string::replaceInFile {file before after} {
    # @c Replaces all occurences of <a before> in the named <a file>
    # @c with the string <a after>. <a before> can be any legal regexp
    # @c pattern and <a after> may use \<i> syntax to denote parts of
    # @c the matched expression.
    #
    # @a file: name of the file to modify..
    # @a before: string to search for (and to replace by <a after>).
    # @a after:  string to insert in place of <a before>.
    #
    # @i replace, file
    #
    # @n The file is read completely into memory before processing it.
    # @n The file must be readable and writable.

    # @n This procedure is not checked by the testsuite.

    set    fh   [open $file r]
    set    text [read $fh]
    close $fh

    regsub -all -- $before $text $after text

    set    fh [open $file w]
    puts  $fh $text
    close $fh
}



proc ::pool::string::multipleReplaceInFile {file replacements} {
    # @c Replaces all occurences of the strings named as keys of the
    # @c array variable <a replacements> in the named <a file> with
    # @c the associated values. The same functionality as provided by
    # @c <p ::pool::string::replaceInFile>, but for a set of strings.
    #
    # @note There are no guarantees about the order of replacements.
    #
    # @a file: name of the file to modify..
    # @a replacements: name of an array variable containing strings
    # @a replacements: and their corresponding substitutions.
    #
    # @i replace, file
    #
    # @n The file read completely into memory before processing it.
    # @n The file must be readable and writable.

    # @n This procedure is not checked by the testsuite.

    set    fh   [open $file r]
    set    text [read $fh]
    close $fh

    upvar $replacements r

    foreach k [array names r] {
	regsub -all -- $k $text $r($k) text
    }

    set    fh [open $file w]
    puts  $fh $text
    close $fh
}



# ------------------------------------------------------------
# things done during compactification:
#
# 1) eliminate comments alone on a line
#    ( [blank,tab]*#.* )
#
# 2) eliminate of comments at the end of a line.
#    be sure to start the rule with a ; to match tcl's ruling!
#    ( ;[blank,tab]*#.* )
#
# 3) eliminate empty lines.
#
# 4) transform tabs into blanks.
#    compress multiple blanks into a single one.
#    strip leading and/or trailing blanks.
#
# 5) concatenate continuation lines (\ at end of line!) into one line.
#
# 6) strip irrelevant newlines (after '{', before '}').
#
# ------------------------------------------------------------
#
# BEWARE, DANGER
# ------------------------------------------------------------
#
# Do not! compress files containing regular expressions and
# strings containing multiple blanks, newlines, etc.  They will
# be messed up by this process, resulting in algorithm and/or
# formatting errors!
#
# Tricks:  placing ;# at the end of a line permits the removal
# of the following space and newline, which would have been left
# in by sensitive crunching otherwise.
#
# ------------------------------------------------------------

proc ::pool::string::removeComments {text} {
    # @c Removes comments and continuation lines from tcl code
    # @c stored in <a text> and returns the modified result. The
    # @c process used here will leave regular expressions and
    # @c strings intact whilst doing at least some compression.
    #
    # @a text: the string to compress.
    #
    # @r The compressed string
    #
    # @i remove, comments, continuation lines, script, tcl code

    # @n This procedure is not checked by the testsuite.

    # Remove all comments at the head of the whole text

    set text [rhc $text]

    # Remove comments at the beginning of a line
    # Remove comments at the end of a line

    regsub -all "\n(\[ \t]*#\[^\n]*\[ \t\n]*)*"      $text "\n" text
    regsub -all "\[ \t]*;\[ \t]*#\[^\n]*\n\[ \t\n]*" $text "\n" text

    # Remove continutation lines.

    regsub -all "\\\\\n" $text { } text

    return $text
}



proc ::pool::string::removeContinuations {text} {
    # @c Removes continuation lines from the tcl code specified
    # @c in <a text>.
    #
    # @a text: The string to compress.
    #
    # @r The compressed string
    #
    # @i script, tcl code, remove, continuation lines

    # @n This procedure is not checked by the testsuite.

    regsub -all "\[ \t]*\\\\\n\[ \t]*" $text { } text
    return $text
}



proc ::pool::string::removeSpaces {text} {
    # @c Removes all non-essential spacing from tcl-code stored
    # @c in <a text> and returns the modified result. Only
    # @c spaces, tabs and line-endings are considered as spacing.
    #
    # @a text: The string to compress.
    #
    # @r The compressed string
    #
    # @i script, tcl code, remove, non-essential spacing, spacing

    # @n This procedure is not checked by the testsuite.

    # Compress spacing sequences longer than 1 character
    # into a single character

    regsub -all "\[ \t]+" $text { } text

    # Remove spacing at the beginning of a line
    # Remove spacing at the end of a line

    regsub -all " \n" $text "\n" text
    regsub -all "\n " $text "\n" text

    # Remove empty lines at the beginning of the whole text
    # Remove empty lines inside the text

    regsub -all "^\n+" $text {}   text
    regsub -all "\n+"  $text "\n" text

    return $text
}



proc ::pool::string::removeWhitespace {text} {
    # @c Removes all non-essential whitespace from the tcl-code stored
    # @c in <a text> and returns the modified result. Comments are
    # @c considered as whitespace!
    #
    # @a text: The string to compress.
    #
    # @r The compressed string
    #
    # @i script, tcl code, remove non-essential whitespace, whitespace

    # @n This procedure is not checked by the testsuite.

    set text [removeComments $text]
    set text [removeSpaces   $text]

    # Join two lines if the preceding one has a brace at its end
    # Join two line if the second one starts with a brace

    regsub -all "\{\n" $text "\{" text
    regsub -all "\n\}" $text "\}" text

    return $text
}



proc ::pool::string::oneLine {text} {
    # @c Compresses the given <a text> into a single line.
    # @c Convenience procedure.
    #
    # @a text: The string to compress.
    #
    # @r The compressed string

    regsub -all "\n" $text " " text
    return $text
}



proc ::pool::string::fillPrefixes {arrayVar} {
    # @c Computes all unique prefixes of the values in <a arrayVar>
    # @c and maps to their longforms. Can be used to compute all
    # @c possible shortcuts for a set of (widget) options.
    #
    # @a arrayVar: The name of the array containing the keys whose
    # @a arrayVar: prefixes shall be computed here.

    upvar $arrayVar a

    array set asave [array get a]

    foreach k [array names asave] {
	set pfx [chop $k]
	while {($pfx != {}) && ([llength [array names asave ${pfx}*]] <= 1)} {
	    set a($pfx) $k
	    set pfx [chop $pfx]
	}
    }
    return
}


proc ::pool::string::prefixMap {arrayVar} {

    # @c Same as <p ::pool::string::fillPrefixes>, but the original
    # @c contents of <a arrayVar> will be removed.
    #
    # @a arrayVar: The name of the array containing the keys whose
    # @a arrayVar: prefixes shall be computed here.

    upvar $arrayVar a

    set keys [array names a]
    fillPrefixes a

    foreach k $keys {
	unset a($k)
    }

    return
}


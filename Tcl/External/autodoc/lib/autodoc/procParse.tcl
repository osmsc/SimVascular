# -*- tcl -*-
# (C) 1997 Andreas Kupries <a.kupries@westend.com>
#
# CVS: $Id: procParse.tcl,v 1.3 2000/09/05 20:10:43 aku Exp $
#
# @c Helper procedures used by <c procDescription> to extract procedure
# @c level documentation.
# @s <c procDescription> helper procedures.
# @i helper procedures, documentation parsing, definition extraction
#-----------------------------------------------------------------------
package require Pool_Base

proc pd_util_init {} {
    # @c Noop. Just an entrypoint for autoloading.
}


# shortcuts
interp alias {} pd_c  {} pd_comment
interp alias {} pd_d  {} pd_danger
interp alias {} pd_n  {} pd_note
interp alias {} pd_r  {} pd_result
interp alias {} pd_a  {} pd_argument
interp alias {} pd_i  {} pd_index
interp alias {} pd_b  {} pd_bug
interp alias {} pd_ex {} pd_example


proc pd_example {line} {
    # @c Process @example, @ex commands.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output. Leading whitespace is
    # @a line: preserved, trailing whitespace not.

    upvar  example example
    append example "\n[string trimright $line]"
    set    example [string trimleft $example \n]
    return
}


proc pd_bug {line} {
    # @c Process @bug, @b commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  bug bug
    append bug " $line"
    return
}


proc pd_date {line} {
    # @c Process @date commands. No shortcut, @d is already used for @danger.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output.

    upvar  date date
    append date "\n[string trim $line]"
    set    date [string trimleft $date \n]
    return
}


proc pd_version {line} {
    # @c Process @version commands. No shortcut, @v is already used for @var.
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation). Each line in the input will be on a
    # @a line: separate line in the output.

    upvar  version version
    append version "\n[string trim $line]"
    set    version [string trimleft $version \n]
    return
}


proc pd_result {line} {
    # @c Process @result, @r commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  result result
    append result " $line"
    return
}


proc pd_argument {line} {
    # @c Process @argument, @a commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar argDef argDef
    set line [string trimleft $line]

    # slight hack, we have a string here, not a list!
    # lshift may fail in the presence of braces

    regexp -indices "^(\[^ \t\]*)" $line dummy word
    set a [lindex $word 0]
    set e [lindex $word 1]

    set a    [string trimright [string range $line $a $e] :]
    set line [string range $line [incr e] end]

    append argDef($a,comment) " $line"
    return
}


proc pd_comment {line} {
    # @c Process @comment, @c commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  comment comment
    append comment " $line"
    return
}


proc pd_danger {line} {
    # @c Process @danger, @d commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  danger danger
    append danger " $line"
    return
}


proc pd_note {line} {
    # @c Process @note, @n commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  note note
    append note " $line"
    return
}


proc pd_index {line} {
    # @c Process @index, @i commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar  keywords keywords
    append keywords ", $line"
    return
}


proc pd_author {line} {
    # @c Process @author commands
    # @a line: tail of line containing the command (= the embedded
    # @a line: documentation)

    upvar authorName authorName
    set   authorName $line
    return
}


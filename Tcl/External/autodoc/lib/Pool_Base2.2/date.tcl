# -*- tcl -*-
#		Pool 2.3, as of September 14, 2000
#		Pool_Base @base:mFullVersion@
#
# CVS: $Id: date.tcl,v 1.2 2000/07/31 19:15:15 aku Exp $
#
# @c Additional date/time functionality
# @s Additional date/time functionality
# @i date operations, operations on dates and times, time operations

package require Tcl 8.0

# Create the required namespaces before adding information to them.
# Initialize some info variables.

namespace eval ::pool {
    variable version 2.3
    variable asOf    September 14, 2000

    namespace eval date {
	variable version @base:mFullVersion@
	namespace export *

	# some tables used by the procedures defined here.

	variable monthLength
	variable monthIndex
	variable monthName
	variable monthNumber
	variable weekdayName

	# length of months, set up for
	# - leap years, normal years,
	# - leading zeros, no leading zeros
	#
	# indexed by (leapyear,month) = (0,1)x(1..12,01..09)

	array set monthLength {
	    0,1  31	1,1  31		0,01  31	1,01 31
	    0,2  28	1,2  29		0,02  28	1,02 29
	    0,3  31	1,3  31		0,03  31	1,03 31
	    0,4  30	1,4  30		0,04  30	1,04 30
	    0,5  31	1,5  31		0,05  31	1,05 31
	    0,6  30	1,6  30		0,06  30	1,06 30
	    0,7  31	1,7  31		0,07  31	1,07 31
	    0,8  31	1,8  31		0,08  31	1,08 31
	    0,9  30	1,9  30		0,09  30	1,09 30

	    0,10 31	1,10 31
	    0,11 30	1,11 30
	    0,12 31	1,12 31
	}

	# specify distance of month/01/year to 01/01/year
	# this is equal to the sum of monthLengths of all
	# the preceding months.
	#
	# indexed by (leapyear,month) = (0,1)x(1..12,01..09)

	array set monthIndex {
	    0,1    0	1,1    0	0,01   0	1,01   0
	    0,2   31	1,2   31	0,02  31	1,02  31
	    0,3   59	1,3   60	0,03  59	1,03  60
	    0,4   90	1,4   91	0,04  90	1,04  91
	    0,5  120	1,5  121	0,05 120	1,05 121
	    0,6  151	1,6  152	0,06 151	1,06 152
	    0,7  181	1,7  182	0,07 181	1,07 182
	    0,8  212	1,8  213	0,08 212	1,08 213
	    0,9  243	1,9  244	0,09 243	1,09 244

	    0,10 273	1,10 274
	    0,11 304	1,11 305
	    0,12 334	1,12 335
	}

	# Map from month numbers to the appropriate english names

	array set monthName {
	    1	january		01	january  
	    2	february	02	february 
	    3	march		03	march    
	    4	april		04	april    
	    5	may		05	may      
	    6	june		06	june     
	    7	july		07	july     
	    8	august		08	august   
	    9	september	09	september
	    10	october
	    11	november
	    12	december
	}

	# Map month names back to their number

	array set monthNumber {
	    january   1	    february  2
	    march     3	    april     4
	    may       5	    june      6
	    july      7	    august    8
	    september 9	    october  10
	    november 11	    december 12
	}

	# Map from weekday numbers to the appropriate english names

	array set weekdayName {
	    0 sunday
	    1 monday
	    2 tuesday
	    3 wednesday
	    4 thursday
	    5 friday
	    6 saturday
	}

	# ------------------------------------------
    }
}


# -----------------------------
# date  = mm/dd/yyyy
# month = mm/yyyy
# year  = yyyy
# argument lists made out of single components always use the order 'y', 'm' and 'd'
#
# all numbers have leading zeros
# the single components are handled without leading zeros at all times.
# ------------------------------


proc ::pool::date::StripLeadingZeros {x} {
    # @c Strips leading zeros from a number, preventing octal interpretation
    #
    # @a x: Number forced into decimal interpretation
    #
    # @r a decimal number
    # @i data conversion

    # @n This implementation is significantly faster than
    # @n 'regsub {^0*((1-90-9*)|0)$} $x {\1} x'.
    # @n The regsub averages 160 microsecs in all cases.
    # @n This realization however requires only ~142 microsecs
    # @n in the worst case and goes down to ~128 or ~85 microsecs
    # @n (0-series, {}).&p
    #
    # @n Note, '0 != string compare "" $x' is definitely faster
    # @n than '$x != {}'. The same holds for the second comparison.&p
    #
    # @n All timings done using tcl 8.0

    # Donal K. Fellows.
    # >>   scan   $x %d x; return $x
    #
    # Way faster on 7.6, but the reverse is true for 8.0


    if {0 != [string compare "" $x]} {
	# do the heavy part only if the string is not empty.

	set x [string trimleft $x 0]
	if {0 == [string compare "" $x]} {
	    # the string is now empty, so it was a single 0
	    # before, retain that value

	    return 0
	}
    }

    return $x
}



proc ::pool::date::join {y m d} {
    # @c compose a date from single components
    # @a y: The year to use in the composed date
    # @a m: The month to use in the composed date
    # @a d: The day to use in the composed date
    # @r A date in the form mm/dd/yyyy

    return [format %02d $m]/[format %02d $d]/[format %04d $y]
}



proc ::pool::date::split {date y m d} {
    # @c Split a date into its components, strip away leading zeros
    # @c to avoid misintepretation as octal numbers.
    # @a date: The date to decompose
    # @a y: Name of the variable to store the year into.
    # @a m: Name of the variable to store the month into.
    # @a d: Name of the variable to store the day into.

    upvar $y yv $m mv $d dv

    set date [::split $date /]
    set yv   [StripLeadingZeros [lindex $date 2]]
    set mv   [StripLeadingZeros [lindex $date 0]]
    set dv   [StripLeadingZeros [lindex $date 1]]
    return
}



# analogous commands for months instead of dates
proc ::pool::date::joinMonth {y m} {
    # @c compose a month from single components
    # @a y: The year to use in the composed date
    # @a m: The month to use in the composed date
    # @r A month in the form mm/yyyy

    return [format %02d $m]/[format %04d $y]
}



proc ::pool::date::splitMonth {month y m} {
    # @c Split a month into its components, strip away leading zeros
    # @c to avoid misintepretation as octal numbers.
    # @a y: Name of the variable to store the year into.
    # @a m: Name of the variable to store the month into.
    # @a month: The month to decompose.

    upvar $y yv $m mv
    set date [::split $month /]
    set yv   [StripLeadingZeros [lindex $date 1]]
    set mv   [StripLeadingZeros [lindex $date 0]]
    return
}



proc ::pool::date::joinMonthDay {month day} {
    # @c merge month and day into a complete date
    # @a month: The month (mm/yyyy) to use in the composition
    # @a day: The day to use in the composition
    # @r A date in the form mm/dd/yyyy

    splitMonth $month y m
    return [join $y $m $day]
}



proc ::pool::date::now {} {
    # @c Determines current date
    # @r The current date in the form mm/dd/yyyy

    return [clock format [clock seconds] -format {%m/%d/%Y}]
}



proc ::pool::date::nowTime {} {
    # @c Determines current date and time, default format
    # @r The current date and time.

    return [clock format [clock seconds]]
}



proc ::pool::date::leapYear {y} {
    # @c Determines wether the given year is a leap year or not.
    # @c The gregorian rule is used, i.e.:
    # @c Every 4th is a leap year,
    # @c with the exception of every 100th,
    # @c but every 400th is one nevertheless.
    # @a y: The year to check
    # @r 1 for a leap year, 0 else.

    if {0 == ($y % 400)} {return 1}
    if {0 == ($y % 100)} {return 0}
    if {0 == ($y %   4)} {return 1}
    return 0
}



proc ::pool::date::yearLength {year} {
    # @c Computes the length of the given <a year>, in days.
    # @a year: Year whose length shall be determined
    # @r The length of <a year>, in days.

    return [expr {365+[leapYear $y]}]
}



proc ::pool::date::monthLength {month} {
    # @c Computes the length of the specified <a month>, in days
    # @a month: The month whose length shall be determined.
    # @r The length of <a month>, in days.

    variable monthLength

    splitMonth $month y m
    return $monthLength([leapYear $y],$m)
}



proc ::pool::date::2month {date} {
    # @c Extract the month information from a <a date>.
    # @a date: The date to look at.
    # @r A month in the form mm/yyyy.

    split $date y m d
    return [joinMonth $y $m]
}



proc ::pool::date::monthFirstDay {month} {
    # @r The date for the first day of the given <a month>.
    # @a month: month to look at.

    splitMonth $month y m
    return [join $y $m 1]
}



proc ::pool::date::monthLastDay {month} {
    # @r The date for the last day of the given <a month>.
    # @a month: month to look at.

    splitMonth $month y m
    return [join $y $m [monthLength $month]]
}



# length of the month of a given date
# no procedure, simply do
# [monthLength [2month $date]]

proc ::pool::date::index {date} {
    # @c Convert given <a date> into index of day
    # @c (01/01/year is mapped onto day 1).
    # @a date: The date to convert.
    # @r Index of date into its year.

    variable monthIndex

    split $date y m d
    return [expr {$d + $monthIndex([leapYear $y],$m)}]
}



proc ::pool::date::monthName {m} {
    # @c Map a month-number <a m> to an english name.
    # @a m: The index to convert (range 01..12)
    # @r The english name of the month <a m>

    variable monthName
    return  $monthName([StripLeadingZeros $m])
}



proc ::pool::date::monthNumber {monthname} {
    # @c Map the english name of a month (<a monthname>)
    # @c to its number (range 1..12).
    # @a monthname: The name to convert into an number.
    # @r The month number associated to the name.

    variable monthNumber
    return  $monthNumber([string tolower $monthname])
}



proc ::pool::date::weekdayName {weekday} {
    # @c Map a <a weekday> index (0..6, 0 = sunday)
    # @c to the english name of the weekday.
    # @c To obtain a short version do something like
    # @c (string range (date weekdayName ..) 1 2).
    # @a weekday: The index to convert.

    variable weekdayName
    return  $weekdayName([StripLeadingZeros $weekday])
}


proc ::pool::date::weekday {date} {
    # @c Determines day index in a week of a given date
    # @a date: The date to calculate the day index from.

    # Algorithm taken from the calendar.faq
    # Sent in by Ric Klaren <klaren@cs.utwente.nl>.

    split $date year month day

    set a [expr {(14 - $month) / 12}]
    set y [expr {$year - $a}]
    set m [expr {$month + 12 * $a - 2}]
    set d [expr {($day + $y + ($y / 4) - ($y / 100) + ($y / 400) + ((31 * $m) / 12)) % 7}]

    return $d
}


proc ::pool::date::printCalendar {month year {chan stdout}} {
    # @c Prints a formatted calendar (like from the 'cal' application)
    # @c to the specified channel.
    # @a month: Month of the <a year> to print the calendar for.
    # @a year:  Year to print the calendar for.
    # @a chan:  The channel to print the calendar to.
    #
    # @author Ric Klaren <klaren@cs.utwente.nl>.

    # Sent in by Ric Klaren <klaren@cs.utwente.nl>.
    # Slight generalization to arbitrary channels.

    set num_days   [monthLength "$month/$year"]
    set month_name [monthName   $month]

    foreach day { " S" " M" "Tu" " W" "Th" " F" " S" } {
	puts -nonewline $chan "$day "
    }
    puts $chan ""

    set offset [weekday "1/$month/$year"]
    for { set i 0 } { $i < $offset } { incr i } {
	puts -nonewline $chan "   "
    }

    set col_idx [expr {$offset + 1}]

    for { set i 1 } { $i <= $num_days } { incr i; incr col_idx } {
	puts -nonewline $chan [format "%2d " $i]
	if { $col_idx == 7 } {
	    puts $chan ""
	    set col_idx 0
	}
    }
    puts $chan ""
}


# relational operators for dates

proc ::pool::date::eq {a b} {
    # @c    Are the dates <a a> and <a b> equal?
    # @a a: first date to compare
    # @a b: second date to compare
    # @r 1, if answer is yes, 0 else.

    return [expr {[clock scan $a] == [clock scan $b]}]
}



proc ::pool::date::ne {a b} {
    # @c    Are the dates <a a> and <a b> different?
    # @a a: first date to compare
    # @a b: second date to compare
    # @r 1, if answer is yes, 0 else.

    return [expr {[clock scan $a] != [clock scan $b]}]
}



proc ::pool::date::lt {a b} {
    # @c    Is date <a a> smaller than date <a b>?
    # @a a: first date to compare
    # @a b: second date to compare
    # @r 1, if answer is yes, 0 else.

    return [expr {[clock scan $a] < [clock scan $b]}]
}



proc ::pool::date::le {a b} {
    # @c    Is date <a a> smaller than or equal to date <a b>?
    # @a a: first date to compare
    # @a b: second date to compare
    # @r 1, if answer is yes, 0 else.

    return [expr {[clock scan $a] <= [clock scan $b]}]
}



proc ::pool::date::gt {a b} {
    # @c    Is date <a a> greater than date <a b>?
    # @a a: first date to compare
    # @a b: second date to compare
    # @r 1, if answer is yes, 0 else.

    return [expr {[clock scan $a] > [clock scan $b]}]
}



proc ::pool::date::ge {a b} {
    # @c    Is date <a a> greater than or equal to date <a b>?
    # @a a: first date to compare
    # @a b: second date to compare
    # @r 1, if answer is yes, 0 else.

    return [expr {[clock scan $a] >= [clock scan $b]}]
}



proc ::pool::date::leMonth {a b} {
    # @c    Is month <a a> smaller than or equal to month <a b>?
    # @a a: first month to compare
    # @a b: second month to compare
    # @r 1, if answer is yes, 0 else.

    le [monthFirstDay $a] [monthFirstDay $b]
}



# step to next/previous date
# hack: add/subtract 26/22 hours, then restrict output to date information
#       this should handle DST / normal switches correctly.
#       Gregorian calendar !!. We don't handle entirely missing days.

proc ::pool::date::next {date} {
    # @c Step from <a date> to next day.    
    # @a date: The date to look at.
    # @r The day after <a date>.

    # @d A hack is used to get Normal/DST switches (+26 hours instead auf +24).
    # @d A gregorian calendar is assumed. Entirely missing days are not handled.

    return [clock format [expr {[clock scan $date] + 93600}] -format {%m/%d/%Y}]
}



proc ::pool::date::prev {date} {
    # @c Step from <a date> to previous day.    
    # @a date: The date to look at.
    # @r The day before <a date>.

    # @d A hack is used to get Normal/DST switches (-22 hours instead of -24).
    # @d A gregorian calendar is assumed. Entirely missing days are not handled.

    return [clock format [expr {[clock scan $date] - 79200}] -format {%m/%d/%Y}]
}



proc ::pool::date::nextMonth {month} {
    # @c step from specified month to the month after that
    # @a month: The month to look at.
    # @r The month after <a month>.

    # Done by expanding the month to its last day,
    # computation of its successor, then chopping
    # off the day again.

    return [2month [next [monthLastDay $month]]]
}



proc ::pool::date::prevMonth {month} {
    # @c step from specified month to the month before that
    # @a month: The month to look at.
    # @r The month before <a month>.

    # Done by expanding the month to its first day,
    # computation of its predecessor, then chopping
    # off the day again.

    return [2month [prev [monthFirstDay $month]]]
}



proc ::pool::date::intervalIsMonth {a b} {
    # @c Checks wether the interval defined by dates
    # @c <a a> and <a b> covers a single month.    
    # @a a: Start of interval, inclusive
    # @a b: End of interval, inclusive
    # @r 1, if answer is yes, 0 else.

    # True, if
    #	a =    1 m y
    #	b = mLen m y

    split $a ay am ad
    split $b by bm bd

    if {$ay != $by} {return 0}
    if {$am != $bm} {return 0}

    # days: 1 .. length of month
    if {$ad != 1} {return 0}
    if {$bd != [monthLength $ay $am]} {return 0}
    
    return 1
}



proc ::pool::date::intervalIsYear {a b} {
    # @c Checks wether the interval defined by dates
    # @c <a a> and <a b> covers a single year.    
    # @a a: Start of interval, inclusive
    # @a b: End of interval, inclusive
    # @r 1, if answer is yes, 0 else.

    # True, if
    #	a =  1  1 y
    #	b = 31 12 y

    split $a ay am ad
    split $b by bm bd

    if {$ay != $by} {return 0}

    # months: 1 .. 12
    if {$am !=  1} {return 0}
    if {$bm != 12} {return 0}

    # days:   1, 31
    if {$ad !=  1} {return 0}
    if {$bd != 31} {return 0}

    return 1
}



proc ::pool::date::isYearStart {date} {
    # @c Checks wether the given <a date> is the first of january or not.
    # @a date: The date to look at.
    # @r 1, if answer is yes, 0 else.

    # True if date = 1 1 y

    split $date y m d
    if {($m == 1) && ($d == 1)} {return 1}
    return 0
}



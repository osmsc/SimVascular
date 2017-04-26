#!/depot/path/tclsh

# This is a CGI script that displays another CGI script
# and massages "source" commands into hyperlinks

package require cgi

cgi_eval {
    source example.tcl

    cgi_input

    cgi_head {
	set scriptname [info script]; # display self by default!
	catch {cgi_import scriptname}
	set scriptname [file tail $scriptname]
	cgi_title "Source for $scriptname"
    }
    cgi_body {
	# Prevent people from opening directories!
	switch $scriptname . - .. - "" {
	    h3 "Illegal filename: $scriptname"
	    return
	}
	if {[catch {set fid [open $scriptname]}]} {
	    h3 "No such file: $scriptname"
	    return
	}
	cgi_preformatted {
	    while {-1 != [gets $fid buf]} {
		if {[regexp "^(\[ \t]*)source (.*)" $buf ignore space filename]} {
		    puts "[set space]source [cgi_url $filename [cgi_cgi display scriptname=$filename]]"
		} else {
		    puts [cgi_quote_html $buf]
		}
	    }
	}
    }
}


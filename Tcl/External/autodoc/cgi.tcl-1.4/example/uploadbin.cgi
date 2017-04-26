#!/depot/path/expect

# This is a CGI script that demonstrates file uploading.

package require cgi

cgi_eval {
    source example.tcl

    proc showfile {v} {
	catch {
	    set server [cgi_import_file -server $v]
	    set client [cgi_import_file -client $v]
	    set type   [cgi_import_file -type $v]

	    if {[string length $client]} {
		h4 "Uploaded: $client"
		if {0 != [string compare $type ""]} {
		    h4 "Content-type: $type"
		}
		h4 "Contents:"
		cgi_preformatted {puts [exec od -c $server]}
	    }
	    exec /bin/rm -f $server
	}
    }

    cgi_input

    cgi_head {
	cgi_title "File binary upload demo"
    }
    cgi_body {
	showfile file1
	showfile file2

	cgi_form uploadbin enctype=multipart/form-data {
	    p "Select up to two files to upload"
	    cgi_file_button file1; br
	    cgi_file_button file2; br
	    cgi_submit_button =Upload
	}
    }
}


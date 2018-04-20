set ui_files [list \
sv3gui_AboutDialog.ui \
sv3gui_ProjectCreate.ui \
sv3gui_WelcomeScreenViewControls.ui \
sv3gui_MeshCreate.ui \
sv3gui_MeshEdit.ui \
sv3gui_CapSelectionWidget.ui \
sv3gui_ModelCreate.ui \
sv3gui_ModelEdit.ui \
sv3gui_SegSelectionWidget.ui \
sv3gui_PathCreate.ui \
sv3gui_PathEdit.ui \
sv3gui_PathSmooth.ui \
sv3gui_ContourGroupCreate.ui \
sv3gui_LevelSet2DWidget.ui \
sv3gui_LoftParamWidget.ui \
sv3gui_Seg2DEdit.ui \
sv3gui_Seg3DEdit.ui \
sv3gui_CapBCWidget.ui \
sv3gui_SimJobCreate.ui \
sv3gui_SimulationPreferencePage.ui \
sv3gui_SimulationView.ui \
sv3gui_SplitBCWidget.ui \
]

# ignore this one!
#MitkCoreExports.h
set module_exports_h [list \
svCommonExports.h \
svCommonExports.h \
svMeshExports.h \
svMeshSimExports.h \
svModelExports.h \
svModelOCCTExports.h \
svModelParasolidExports.h \
svPathExports.h \
svProjectManagementExports.h \
svQtWidgetsExports.h \
svSegmentationExports.h \
svSimulationExports.h \
			  ]

proc file_find {dir wildcard args} {
  #author Nathan Wilson
  #@c This procedure recursively searches for
  #@c pattern and returns a tcl list of the files
  #@c matching pattern.
  #@a dir:  starting directory
  #@a wildcard: pattern to match
  #@a args:  optional return variable
  #@r status

  if {[llength $args] == 0} {
     set rtnme {}
  } else {
     upvar rtnme rtnme
  }

  foreach j $dir {
    set files [glob -nocomplain [file join $j $wildcard]]
    # print out headers
    foreach i $files {
      #puts "found file: $i"
      lappend rtnme $i
    }

    set files [glob -nocomplain [file join $j *]]
    foreach i $files {
      if {[file isdirectory $i] == 1} {
        file_find $i $wildcard 1
      }
    }
  }
  return [lsort -unique $rtnme]

}

puts "Make local copies of Plugins and Modules..."

exec rm -Rf Plugins
exec rm -Rf Modules
exec cp -Rf ../Plugins .
exec cp -Rf ../Modules .

puts "Check for existence of headers and #defines..."

set all_header_filenames {}
set all_cxx_filenames {}
set all_pound_defines {}

set ofn [open all-sv-to-replace-sorted.txt r]
while {[gets $ofn line] >= 0} {
    set line [string trim $line]
    if {$line != ""} {
	lappend all_header_filenames sv3gui_[string range $line 2 end].h
	lappend all_cxx_filenames sv3gui_[string range $line 2 end].cxx
	lappend all_pound_defines SV3GUI_[string toupper [string range $line 2 end]]_H
    }
}
close $ofn

set ofn [open all-sv-to-replace-sorted-stubby.txt r]
set functions_to_replace {}
while {[gets $ofn line] >= 0} {
    set line [string trim $line]
    if {$line != ""} {
	lappend functions_to_replace $line
    }
}
close $ofn


set emacs_edit {}

for {set i 0} {$i < [llength $all_header_filenames]} {incr i} {
    
    set find_me_hdr_fn  [lindex $all_header_filenames $i]
    set find_me_cxx_fn  [lindex $all_cxx_filenames $i]
    set find_me_defines [lindex $all_pound_defines $i]

    # check headers
    
    set found_file_hdr_fn [string trim [file_find {Modules Plugins} $find_me_hdr_fn]]
    if {$found_file_hdr_fn == ""} {
	puts "error finding file: $find_me_hdr_fn"
    } else {
        #puts "found file: $found_file_hdr_fn"
	set rstr ""
	if [catch {set rstr [exec grep $find_me_defines $found_file_hdr_fn]}] {
	    puts "error finding $find_me_defines in $found_file_hdr_fn"
	}
    }

    #check cxx files
    
    set found_file_cxx_fn [string trim [file_find {Modules Plugins} $find_me_cxx_fn]]
    if {$found_file_cxx_fn == ""} {
	puts "error finding file: $find_me_cxx_fn  (hdr: $found_file_hdr_fn)"
    } else {
        #puts "found file: $found_file_cxx_fn"
	set rstr ""
	if [catch {set rstr [exec grep $find_me_hdr_fn $found_file_cxx_fn]}] {
	    puts "error finding $find_me_hdr_fn in $found_file_cxx_fn"
	}
    
    }

}

if {0 == 1} {
puts "delete files to check what I'm not checking..."

for {set i 0} {$i < [llength $all_header_filenames]} {incr i} {
    
    set find_me_hdr_fn  [lindex $all_header_filenames $i]
    set find_me_cxx_fn  [lindex $all_cxx_filenames $i]
    set find_me_defines [lindex $all_pound_defines $i]

    # check headers
    
    set found_file_hdr_fn [string trim [file_find {Modules Plugins} $find_me_hdr_fn]]
    if {$found_file_hdr_fn == ""} {
	puts "error finding file: $find_me_hdr_fn"
    } else {
	#puts "found file: $found_file_hdr_fn"
	exec rm -f $found_file_hdr_fn
    }

    #check cxx files
    
    set found_file_cxx_fn [string trim [file_find {Modules Plugins} $find_me_cxx_fn]]
    if {$found_file_cxx_fn == ""} {
	puts "error finding file: $find_me_cxx_fn  (hdr: $found_file_hdr_fn)"
    } else {
	#puts "found file: $found_file_cxx_fn"
        exec rm -f $found_file_cxx_fn
    }

}
}

# replace header filenames and #defines

exec rm -f sed-replace-stubby.txt
set ofn [open sed-replace-stubby.txt w]

foreach me $module_exports_h {
    puts $ofn "s+[file rootname $me]\\.h+PROTECT_ME_[string toupper [string range [file rootname $me] 2 end]]+g"
}

foreach uifn $ui_files {
    puts $ofn "s+Ui::sv[string range [file rootname $uifn] 7 end]+PROTECT_ME_UI_[string toupper sv[string range [file rootname $uifn] 7 end]]+g"
}

foreach funcname [lsort -dictionary $functions_to_replace] {
    puts $ofn "s+$funcname+sv3gui[string range $funcname 2 end]+g"
}

foreach me $module_exports_h {
    puts $ofn "s+PROTECT_ME_[string toupper [string range [file rootname $me] 2 end]]+[file rootname $me]\\.h+g"
}

foreach uifn $ui_files {
    puts $ofn "s+PROTECT_ME_UI_[string toupper sv[string range [file rootname $uifn] 7 end]]+Ui::sv[string range [file rootname $uifn] 7 end]+g"
}

close $ofn

exec rm -Rf sv3gui
exec mkdir sv3gui

foreach fn [file_find {Modules Plugins} *.h] {

    set newfn [file tail $fn]
    puts "working on fn: $fn  ($newfn)"
    exec mkdir -p sv3gui/[file dirname $fn]
    exec sed -f sed-replace-stubby.txt $fn > sv3gui/[file dirname $fn]/$newfn
    catch {exec d2u sv3gui/[file dirname $fn]/$newfn}

}

foreach fn [file_find {Modules Plugins} *.cxx] {

    set newfn [file tail $fn]
    puts "working on fn: $fn  ($newfn)"
    exec mkdir -p sv3gui/[file dirname $fn]
    exec sed -f sed-replace-stubby.txt $fn > sv3gui/[file dirname $fn]/$newfn
    catch {exec d2u sv3gui/[file dirname $fn]/$newfn}

}

#foreach fn [file_find {Plugins} *.ui] {
#}

foreach fn [file_find {Modules Plugins} *] {

    if [file isdirectory $fn] continue 
    if {[file extension $fn] == ".h"} continue
#    if {[file extension $fn] == ".ui"} continue
    if {[file extension $fn] == ".cxx"} continue
   
    set newfn [file tail $fn]
    puts "copying fn: $fn  ($newfn)"
    exec mkdir -p sv3gui/[file dirname $fn]
    exec cp $fn sv3gui/[file dirname $fn]/$newfn

}

# need to manually copy these three unaltered files
exec cp Plugins/org.sv.gui.qt.datamanager/src/internal/svberrySingleNodeSelection.cxx sv3gui/Plugins/org.sv.gui.qt.datamanager/src/internal/svberrySingleNodeSelection.cxx
exec cp Plugins/org.sv.gui.qt.datamanager/src/internal/svberrySingleNodeSelection.h sv3gui/Plugins/org.sv.gui.qt.datamanager/src/internal/svberrySingleNodeSelection.h
exec cp Plugins/org.sv.gui.qt.datamanager/src/internal/svmitkIContextMenuAction.h sv3gui/Plugins/org.sv.gui.qt.datamanager/src/internal/svmitkIContextMenuAction.h

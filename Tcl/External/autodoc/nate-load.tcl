
set dirlist [glob lib/*]
foreach i $dirlist {
  cd $i
  set dir [pwd]
  source pkgIndex.tcl
  cd ../..
}


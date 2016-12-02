#/bin/bash

export PARENT_URL=http://simvascular.stanford.edu/downloads/public/simvascular/externals/windows/10/msvc_2013/2016.09.05

export EXTERNALS_TOP=/usr/local/sv/ext

mkdir -p $EXTERNALS_TOP
chmod -R a+rwx $EXTERNALS_TOP
mkdir -p $EXTERNALS_TOP/tarfiles
mkdir -p $EXTERNALS_TOP/bin/msvc-12.5/x64

pushd $EXTERNALS_TOP/tarfiles
wget $PARENT_URL/linux.msvc-12.5.x64.freetype-2.6.3-BUILD2016-09-05.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.gdcm-2.6.1-BUILD2016-09-05.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.itk-4.7.1-BUILD2016-09-05.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.mitk-2016.03-BUILD2016-11-29.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.mmg-5.1.0-BUILD2016-11-29.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.opencascade-7.0.0-BUILD2016-09-05.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.python-2.7.11-BUILD2016-09-05.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.tcltk-8.6.4-BUILD2016-09-05.tar.gz
wget $PARENT_URL/linux.msvc-12.5.x64.vtk-6.2.0-BUILD2016-09-05.tar.gz
popd

pushd $EXTERNALS_TOP/bin/msvc-12.5/x64
for i in $EXTERNALS_TOP/tarfiles/linux.msvc-12.5.x64.*.tar.gz; do
    tar xvzf $i
done
popd

source CygwinHelpers/msvc_2013_x64

make

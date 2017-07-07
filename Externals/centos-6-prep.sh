# generic
sudo yum -y update

# add need Developer Toolset since gcc 4.4 is too old for Qt
sudo yum -y install centos-release-scl
sudo yum -y install devtoolset-4
sudo yum -y install rh-git29
scl enable devtoolset-4 bash
scl enable rh-git29 bash

# for swig-3.0.12
sudo yum install pcre-devel

#some helpers
sudo yum -y install git
sudo yum -y install emacs
sudo yum -y install dos2unix

### compilers
sudo yum -y install g++
sudo yum -y install gfortran

### used by some of the SV cmake code
sudo yum -y install lsb-core

### cmake tools  (note: we need newer version of cmake installed below!)
#sudo yum -y install cmake
#sudo yum -y install cmake-qt-gui

### for flowsolver
sudo yum -y install libmpich2-dev

### for vtk
sudo yum -y install libglu1-mesa-dev
sudo yum -y install libxt-dev
sudo yum -y install libxi-dev

### for qt/mitk
 sudo yum -y install libicu-dev

### mitk
sudo yum -y install libXmu-dev
sudo yum -y install libXi-dev
sudo yum -y install libtiff4-dev
sudo yum -y install libwrap0-dev

### python
sudo yum -y install libssl-dev

### gdcm/mitk
sudo yum -y install swig3.0

# optional: mitk
sudo yum -y install doxygen

### install Qt
wget http://simvascular.stanford.edu/downloads/public/open_source/linux/qt/5.4/qt-opensource-linux-x64-5.4.2.run
chmod a+rx ./qt-opensource-linux-x64-5.4.2.run
sudo ./qt-opensource-linux-x64-5.4.2.run --script ./ubuntu-qt-installer-noninteractive.qs

### install latest version of CMake
wget http://simvascular.stanford.edu/downloads/public/open_source/linux/cmake/cmake-3.6.1-Linux-x86_64.sh
chmod a+rx ./cmake-3.6.1-Linux-x86_64.sh
sudo mkdir -p /usr/local/package/cmake-3.6.1
sudo ./cmake-3.6.1-Linux-x86_64.sh --prefix=/usr/local/package/cmake-3.6.1 --skip-license
sudo ln -s /usr/local/package/cmake-3.6.1/bin/ccmake    /usr/local/bin/ccmake
sudo ln -s /usr/local/package/cmake-3.6.1/bin/cmake     /usr/local/bin/cmake
sudo ln -s /usr/local/package/cmake-3.6.1/bin/cmake-gui /usr/local/bin/cmake-gui
sudo ln -s /usr/local/package/cmake-3.6.1/bin/cpack     /usr/local/bin/cpack
sudo ln -s /usr/local/package/cmake-3.6.1/bin/ctest     /usr/local/bin/ctest

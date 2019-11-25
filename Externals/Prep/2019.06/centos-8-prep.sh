# generic
sudo yum -y update

# needed for some makefile stuff
sudo yum -y install tcl

### to link against qt pre-built
#sudo dnf --enablerepo=PowerTools -y install glew
sudo dnf --enablerepo=PowerTools -y install glew-devel

# for qt
###sudo yum -y install rh-ruby23
sudo dnf --enablerepo=PowerTools -y install gperf
sudo yum -y install icu
sudo yum -y install libicu-devel
sudo yum -y install libxcb
sudo yum -y install libxcb-devel
sudo dnf --enablerepo=PowerTools -y install xcb-util
sudo dnf --enablerepo=PowerTools -y install xcb-util-devel

# for mitk
sudo yum -y install tcp_wrappers-devel
sudo yum -y install tcp_wrappers-libs
sudo dnf --enablerepo=PowerTools -y install tcp_wrappers-devel
sudo dnf --enablerepo=PowerTools -y install tcp_wrappers-libs
sudo yum -y install libtiff-devel

# for swig-3.0.12
sudo yum -y install pcre-devel

#some helpers
#sudo yum -y install git
sudo yum -y install emacs
sudo yum -y install dos2unix
#sudo yum -y install xterm
sudo apt-get -y install bbe

### used by some of the SV cmake code
sudo yum -y install redhat-lsb-core

### cmake tools  (note: we need newer version of cmake installed below!)
sudo yum -y install cmake

### for flowsolver
#sudo yum -y install libmpich2-dev

### for vtk
sudo yum -y install libGLU-devel
sudo yum -y install libXt-devel
sudo yum -y install libXi-devel

### for qt/mitk
 sudo yum -y install libicu-devel

### mitk
sudo yum -y install libXmu-devel
sudo yum -y install libXi-devel

### python
sudo yum -y install openssl-devel
sudo yum -y install sqlite-devel
sudo yum -y install ncurses-devel

# optional: mitk
sudo dnf --enablerepo=PowerTools -y install doxygen




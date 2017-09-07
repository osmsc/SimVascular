call "C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/vcvarsall.bat" x64

set SV_PYTHON_DIR=C:/cygwin64/usr/local/sv/ext/bin/msvc-19.3/x64/python-2.7.11
set PYTHONHOME=C:/cygwin64/usr/local/sv/ext/bin/msvc-19.3/x64/python-2.7.11
set PYTHONPATH="C:/cygwin64/usr/local/sv/ext/bin/msvc-19.3/x64/python-2.7.11/lib/python2.7/lib-dynload;C:/cygwin64/usr/local/sv/ext/bin/msvc-19.3/x64/python-2.7.11/lib;C:/cygwin64/usr/local/sv/ext/bin/msvc-19.3/x64/python-2.7.11/lib/python2.7;C:/cygwin64/usr/local/sv/ext/bin/msvc-19.3/x64/python-2.7.11/lib/python2.7/site-packages"

REPLACEME_SV_TOP_BIN_DIR_PYTHON/bin/python.exe C:/cygwin64/usr/local/sv/ext/src/BuildHelpers/Originals/python/get-pip.py
REPLACEME_SV_TOP_BIN_DIR_PYTHON/bin/python.exe -m pip install Cython --install-option="--no-cython-compile"

set BLAS=None
set LAPACK=None
set ATLAS=None

REPLACEME_SV_TOP_BIN_DIR_PYTHON/bin/python.exe setup.py build
REPLACEME_SV_TOP_BIN_DIR_PYTHON/bin/python.exe setup.py install --prefix C:\\cygwin64/usr/local/sv/ext/bin/msvc-19.3/x64/python-2.7.11

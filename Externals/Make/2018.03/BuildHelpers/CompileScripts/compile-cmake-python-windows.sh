#
# python
#

REPLACEME_SV_SPECIAL_COMPILER_SCRIPT

export CC=REPLACEME_CC
export CXX=REPLACEME_CXX

rm -Rf REPLACEME_SV_TOP_BIN_DIR_PYTHON
mkdir -p REPLACEME_SV_TOP_BIN_DIR_PYTHON
chmod u+w,a+rx REPLACEME_SV_TOP_BIN_DIR_PYTHON

rm -Rf REPLACEME_SV_TOP_BLD_DIR_PYTHON
mkdir -p REPLACEME_SV_TOP_BLD_DIR_PYTHON
pushd REPLACEME_SV_TOP_BLD_DIR_PYTHON

REPLACEME_SV_CMAKE_CMD -G REPLACEME_SV_CMAKE_GENERATOR \
   -DCMAKE_ASM_COMPILER:FILEPATH="C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/BIN/amd64/cl.exe" \
   -DCMAKE_ASM_MASM_COMPILER:FILEPATH="C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/BIN/amd64/ml64.exe" \
   -DCMAKE_ASM_MASM_COMPILE_OBJECT="<CMAKE_ASM_MASM_COMPILER> <FLAGS> /c /Fo <OBJECT> <SOURCE>" \
   -DBUILD_TESTING=OFF \
   -DBUILD_LIBPYTHON_SHARED=ON \
   -DENABLE_SSL=ON \
   -DBUILTIN_SSL=ON \
   -DBUILTIN_HASHLIB=ON \
   -DUSE_SYSTEM_OpenSSL=OFF \
   -DOPENSSL_INCLUDE_DIR=REPLACEME_SV_OPENSSL_INC_DIR \
   -DOPENSSL_LIBRARIES=REPLACEME_SV_OPENSSL_LIBRARIES \
   -DENABLE_CTYPES=ON \
   -DBUILTIN_CTYPES=ON \
   -DCMAKE_INSTALL_PREFIX=REPLACEME_SV_TOP_BIN_DIR_PYTHON \
   -DCMAKE_BUILD_TYPE=REPLACEME_SV_CMAKE_BUILD_TYPE \
   -DPYTHON_VERSION=REPLACEME_SV_PYTHON_FULL_VERSION \
REPLACEME_SV_TOP_SRC_DIR_PYTHON

REPLACEME_SV_MAKE_CMD REPLACEME_SV_PYTHON_MAKE_FILENAME REPLACEME_SV_MAKE_BUILD_PARAMETERS

REPLACEME_SV_MAKE_CMD REPLACEME_SV_PYTHON_MAKE_FILENAME REPLACEME_SV_MAKE_INSTALL_PARAMETERS

popd


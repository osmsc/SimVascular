BUILDDATE=`date +%Y.%m.%d`
SVFILEPREFIX=REPLACEME_SV_OS_MFG.REPLACEME_SV_OS_VERSION.REPLACEME_SV_COMPILER_TYPE.REPLACEME_SV_COMPILER_VERSION.REPLACEME_SV_ARCH_DIR.REPLACEME_SV_CMAKE_BUILD_TYPE.${BUILDDATE}

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

#  tcl/tk 8.6
if [[ $SV_SUPER_OPTIONS == *ZIP_TCL* ]]; then
  echo "ZIP_TCL"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_TCLTK_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_TCLTK_DIR.zip REPLACEME_SV_TCLTK_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# python 2.7
if [[ $SV_SUPER_OPTIONS == *ZIP_PYTHON* ]]; then
  echo "ZIP_PYTHON"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_PYTHON_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_PYTHON_DIR.zip REPLACEME_SV_PYTHON_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# numpy
# NOTE: numpy is contained in the python zip

# swig
if [[ $SV_SUPER_OPTIONS == *ZIP_SWIG* ]]; then
  echo "ZIP_SWIG"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_SWIG_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_SWIG_DIR.zip REPLACEME_SV_SWIG_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# qt
if [[ $SV_SUPER_OPTIONS == *ZIP_QT* ]]; then
  echo "ZIP_QT"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_QT_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_QT_DIR.zip REPLACEME_SV_QT_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# freetype
if [[ $SV_SUPER_OPTIONS == *ZIP_FREETYPE* ]]; then
  echo "ZIP_FREETYPE"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_FREETYPE_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_FREETYPE_DIR.zip REPLACEME_SV_FREETYPE_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# gdcm
if [[ $SV_SUPER_OPTIONS == *ZIP_GDCM* ]]; then
  echo "ZIP_GDCM"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_GDCM_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_GDCM_DIR.zip REPLACEME_SV_GDCM_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# vtk
if [[ $SV_SUPER_OPTIONS == *ZIP_VTK* ]]; then
  echo "ZIP_VTK"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_VTK_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_VTK_DIR.zip REPLACEME_SV_VTK_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# itk
if [[ $SV_SUPER_OPTIONS == *ZIP_ITK* ]]; then
  echo "ZIP_ITK"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_ITK_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_ITK_DIR.zip REPLACEME_SV_ITK_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# opencascade
if [[ $SV_SUPER_OPTIONS == *ZIP_OPENCASCADE* ]]; then
  echo "ZIP_OPENCASCADE"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_OPENCASCADE_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_OPENCASCADE_DIR.zip REPLACEME_SV_OPENCASCADE_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# mmg
if [[ $SV_SUPER_OPTIONS == *ZIP_MMG* ]]; then
  echo "ZIP_MMG"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_MMG_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_MMG_DIR.zip REPLACEME_SV_MMG_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# mitk
if [[ $SV_SUPER_OPTIONS == *ZIP_MITK* ]]; then
  echo "ZIP_MITK"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.REPLACEME_SV_MITK_DIR.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.REPLACEME_SV_MITK_DIR.zip REPLACEME_SV_MITK_DIR
  popd
fi

rm -Rf zip_output_tmp
mkdir -p zip_output_tmp

# everything
if [[ $SV_SUPER_OPTIONS == *ZIP_EVERYTHING* ]]; then
  echo "ZIP_EVERYTHING"
  REPLACEME_TAR -C zip_output_tmp/ -xvzf tar_output/${SVFILEPREFIX}.everything.tar.gz
  pushd zip_output_tmp
  REPLACEME_ZIP -r ../zip_output/${SVFILEPREFIX}.everything.zip \
    REPLACEME_SV_TCLTK_DIR \
    REPLACEME_SV_PYTHON_DIR \
    REPLACEME_SV_SWIG_DIR \
    REPLACEME_SV_QT_DIR \
    REPLACEME_SV_FREETYPE_DIR \
    REPLACEME_SV_GDCM_DIR \
    REPLACEME_SV_VTK_DIR \
    REPLACEME_SV_ITK_DIR \
    REPLACEME_SV_OPENCASCADE_DIR \
    REPLACEME_SV_MMG_DIR \
    REPLACEME_SV_MITK_DIR
  popd
fi

rm -Rf zip_output_tmp

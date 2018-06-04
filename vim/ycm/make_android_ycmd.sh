#!/bin/bash

BUILD_PATH=${1:-$HOME/builds/master}
CLANG_LIB=$BUILD_PATH/out/host/linux-x86/lib64/libclang.so
[ -f $CLANG_LIB ] || CLANG_LIB=$BUILD_PATH/out/soong/host/linux-x86/lib64/libclang.so

YCMD_PATH=$HOME/.vim/plugged/YouCompleteMe/third_party/ycmd
YCMD_CLANG_PATH=$YCMD_PATH/clang_lib

if [ ! -d $BUILD_PATH ]; then echo "Invalid build path: $BUILD_PATH"; exit 1; fi
if [ ! -f $CLANG_LIB ]; then echo "Unable to find $CLANG_LIB"; exit 1; fi

if [ ! -d $YCMD_PATH ]; then echo "Invalid ycmd path: $YCMD_PATH"; exit 1; fi

mkdir -p $YCMD_CLANG_PATH
if [ ! -d $YCMD_CLANG_PATH ]; then echo "Unable to create ycmd clang path: $YCMD_CLANG_PATH"; exit 1; fi

CLANG_DIR=$(dirname $CLANG_LIB)
cp ${CLANG_LIB} \
  ${CLANG_DIR}/libLLVM.so \
  ${CLANG_DIR}/libc++.so \
  $YCMD_CLANG_PATH

YCMD_TEMP_PATH=$(mktemp -d /tmp/ycmd.XXXXX)
cd $YCMD_TEMP_PATH

export CC=$(which clang)
export CXX=$(which clang++)
# prepare makefiles
cmake -G "Unix Makefiles" \
    -DPATH_TO_LLVM_ROOT=$BUILD_PATH/external/clang \
    -DEXTERNAL_LIBCLANG_PATH=$YCMD_CLANG_PATH/libclang.so \
    $YCMD_PATH $YCMD_PATH/cpp || echo "Fail to prepare makefiles"

# TODO: python flags needed?
#-DPYTHON_LIBRARY=/usr/lib/python2.7/config-x86_64-linux-gnu/libpython2.7.so \
#-DPYTHON_INCLUDE_DIR=/usr/include/python2.7 \
#-DUSE_PYTHON2=ON \

# build
cmake --build . --clean-first --target ycm_core --config Release -- -j

echo "Intermediate out files at: $YCMD_TEMP_PATH"

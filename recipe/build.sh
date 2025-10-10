#!/bin/bash

# Install to conda style directories
[[ -d lib64 ]] && mv lib64 lib

baseDir="$(ls)"
nsightVersion=$(echo $PKG_VERSION | cut -d. -f1-3)
nsightLib32="$baseDir/target/linux-desktop-glibc_2_11_3-x86/"

# Remove 32bit libraries
[[ -d "${nsightLib32}" ]] && rm -rf ${nsightLib32}

mkdir -p $PREFIX/nsight-compute-$nsightVersion
cp -rv $baseDir/* $PREFIX/nsight-compute-$nsightVersion/

mkdir -p $PREFIX/nsight-compute-$nsightVersion/target
mv -v $PREFIX/nsight-compute-$nsightVersion/linux-desktop* $PREFIX/nsight-compute-$nsightVersion/target

# Create symlinks to the binaries in bin for easier access
mkdir -p $PREFIX/bin
ln -s $PREFIX/nsight-compute-$nsightVersion/ncu $PREFIX/bin/
ln -s $PREFIX/nsight-compute-$nsightVersion/ncu-ui $PREFIX/bin/

check-glibc "$PREFIX"/bin/* "$PREFIX"/targets/*/bin/* "$PREFIX"/nsight-compute-*/**/*.so

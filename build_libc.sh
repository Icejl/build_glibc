#!/bin/bash

set -xv -o errexit

versions=("2.35" "2.39")

mkdir -p /glibc/source && mkdir -p /glibc/32 && mkdir -p /glibc/64

patch(){
    file=$1
    sed -i '1i\#pragma GCC push_options\n#pragma GCC optimize ("Og")' $file
    sed -i '$a\#pragma GCC pop_options' $file
}

for ver in "${versions[@]}"
do
    echo $ver
    
    tarfile=http://ftp.gnu.org/gnu/glibc/glibc-$ver.tar.xz
    
    if [ ! -f "$tarfile" ]
    then
        wget $tarfile -O glibc-$ver.tar.xz
    fi
    
    rm -rf /glibc/source/glibc-$ver
    tar Jxf glibc-$ver.tar.xz -C /glibc/source
    
    patch /glibc/source/glibc-$ver/malloc/malloc.c
    #patch /glibc/source/glibc-$ver/elf/dl-fini.c

    cd /glibc/source/glibc-$ver && mkdir build && \
        cd build && ../configure --prefix=/glibc/64/$ver --enable-debug=yes CFLAGS="-w -g -O2" && \
        make -j `nproc` && make install -j `nproc`
    rm -rf /glibc/source/glibc-$ver/build
    
    # build 32 bit
    #cd /glibc/source/glibc-$ver && mkdir build32 && \
    #    cd build32 && ../configure --prefix=/glibc/32/$ver --enable-debug=yes CFLAGS="-g -O2 -march=i686" CC="gcc -m32" --host=i686-linux-gnu && \
    #    make -j `nproc` && make install -j `nproc`
    rm -rf /glibc/source/glibc-$ver/build32
done





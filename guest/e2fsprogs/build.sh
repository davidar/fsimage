#!/bin/sh

set -ex

E2FSPROGS=e2fsprogs-1.35.tar.gz

for d in build install/target
do
  if [ ! -d "$d" ]; then
    mkdir -p "$d"
  fi
done

cd build
tar zxvf "$SRCDIR/$E2FSPROGS"
cd ..

INSTALLDIR="`/bin/pwd`/install/target"

export CC="$TARGET_CC"
export LD="$TARGET_LD"
export AR="$TARGET_AR"
export STRIP="$TARGET_STRIP"
export RANLIB="$TARGET_RANLIB"

cd build/*/
./configure --prefix=/ --host="$TARGET" --disable-nls \
--disable-evms --enable-dynamic-e2fsck
make
make install DESTDIR="$INSTALLDIR"

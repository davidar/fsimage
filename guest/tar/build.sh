#!/bin/sh

set -ex

TAR=tar-1.14.tar.bz2

for d in build install/target
do
  if [ ! -d "$d" ]; then
    mkdir -p "$d"
  fi
done

cd build
tar jxvf "$SRCDIR/$TAR"
cd ..

INSTALLDIR="`/bin/pwd`/install/target"

export CC="$TARGET_CC"
export LD="$TARGET_LD"
export AR="$TARGET_AR"
export STRIP="$TARGET_STRIP"
export RANLIB="$TARGET_RANLIB"

cd build/*/
./configure --prefix=/ --host="$TARGET" --disable-nls
make
make install DESTDIR="$INSTALLDIR"

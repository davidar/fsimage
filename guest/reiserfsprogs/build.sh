#!/bin/sh

set -ex

REISERFSPROGS=reiserfsprogs-3.6.19.tar.gz

for d in build install/target
do
  if [ ! -d "$d" ]; then
    mkdir -p "$d"
  fi
done

cd build
tar zxvf "$SRCDIR/$REISERFSPROGS"
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

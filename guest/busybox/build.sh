#!/bin/sh

set -ex

BUSYBOX=busybox-1.00.tar.bz2

for d in build install/target
do
  if [ ! -d "$d" ]; then
    mkdir -p "$d"
  fi
done

cd build
tar jxvf "$SRCDIR/$BUSYBOX"
cd ..

INSTALLDIR="`/bin/pwd`/install/target"

cd build/*/

cp ../../busybox.config .config
make oldconfig < /dev/null
make CC="$TARGET_CC" LD="$TARGET_LD" AR="$TARGET_AR" STRIP="$TARGET_STRIP"
make install PREFIX="$INSTALLDIR"

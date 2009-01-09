#!/bin/sh

TARGETDIR=$1

set -ex

export AS="$TARGET_AS"
export CC="$TARGET_CC"
export LD="$TARGET_LD"
export AR="$TARGET_AR"
export STRIP="$TARGET_STRIP"
export RANLIB="$TARGET_RANLIB"
export OBJCOPY="$TARGET_OBJCOPY"
export OBJDUMP="$TARGET_OBJDUMP"

cd build/*/

KERNELDIR="`/bin/pwd`"

cp initramfs_data.cpio usr/

cd "$TARGETDIR"
find . | cpio -o -H newc --force-local -A -F "$KERNELDIR/usr/initramfs_data.cpio"

cd "$KERNELDIR"
cd usr
rm initramfs_data.cpio.gz
ln -s initramfs_data.cpio initramfs_data.cpio.gz
cd ..

make bzImage ARCH=i386 CC="$CC" LD="$LD" AR="$AR" STRIP="$STRIP" RANLIB="$RANLIB" OBJCOPY="$OBJCOPY" OBJDUMP="$OBJDUMP" AS="$AS"

#!/bin/sh

set -ex

LINUX=linux-2.6.10.tar.bz2

for d in build install/target
do
  if [ ! -d "$d" ]; then
    mkdir -p "$d"
  fi
done

cd build
tar jxvf "$SRCDIR/$LINUX"
cd ..

INSTALLDIR="`/bin/pwd`/install/target"

export AS="$TARGET_AS"
export CC="$TARGET_CC"
export LD="$TARGET_LD"
export AR="$TARGET_AR"
export STRIP="$TARGET_STRIP"
export RANLIB="$TARGET_RANLIB"
export OBJCOPY="$TARGET_OBJCOPY"
export OBJDUMP="$TARGET_OBJDUMP"

cd build/*/

cat "$SRCDIR/linux-2.6.9-qemu_100hz-20041101.patch" | patch -p1

KERNELDIR="`/bin/pwd`"

LINUXDIR="`basename $KERNELDIR`"
cd ..
ln -s "$LINUXDIR" linux
cd "$LINUXDIR"

cp ../../linux.config .config
make oldconfig ARCH=i386 < /dev/null
make vmlinux ARCH=i386 CC="$CC" LD="$LD" AR="$AR" STRIP="$STRIP" RANLIB="$RANLIB" OBJCOPY="$OBJCOPY" OBJDUMP="$OBJDUMP" AS="$AS"

cp usr/initramfs_data.cpio initramfs_data.cpio

# build_final.sh takes care of the rest

#!/bin/sh

set -ex

CROSSTOOL=crosstool-0.28-rc37.tar.gz

for d in build install install/host install/target/lib
do
  if [ ! -d "$d" ]; then
    mkdir -p "$d"
  fi
done

cd build
tar zxvf "$SRCDIR/$CROSSTOOL"
cd ..

topdir=`/bin/pwd`

if [ -n "$TARGET_ARCH ]; then
  echo "fatal: TARGET_ARCH not setup"
  exit 1
fi

if [ -n "$TARGET_CC_LIBC ]; then
  echo "fatal: TARGET_CC_LIBC not setup"
  exit 1
fi

cd build/*/

target=$TARGET
arch=$TARGET_ARCH
cc_libc=$TARGET_CC_LIBC

unset TARGET
unset TARGET_ARCH
unset TARGET_CC_LIBC

unset TARGET_CC
unset TARGET_LD
unset TARGET_AR
unset TARGET_AS
unset TARGET_STRIP
unset TARGET_RANLIB
unset TARGET_OBJDUMP
unset TARGET_OBJCOPY

TARBALLS_DIR="$SRCDIR"
RESULT_TOP="${topdir}/install/host"
export TARBALLS_DIR RESULT_TOP
GCC_LANGUAGES="c"
export GCC_LANGUAGES

# Build the toolchain. Takes a couple of hours and some gigabytes..

eval `cat ${arch}.dat ${cc_libc}.dat; echo LINUX_DIR=linux-2.6.10` sh all.sh --notest

cd ../..

# copy libc files to target directory, don't keep .a and .o-files

tar cf - -C "$RESULT_TOP/$target/$cc_libc/$target/lib" . | tar xv -C "install/target/lib/"

find "install/target/lib/" -name "*.[a|o]" | xargs rm


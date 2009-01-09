#!/bin/sh

set -ex

rm -fR install/target
mkdir -p install/target

for e
do
  tar cf - -C ../$e/install/target . | tar xv -C install/target
done

tar cf - -C src . | tar xv -C install/target/

# remove unused data like man and info pages

rm -fR install/target/man
rm -fR install/target/info

# create a lib directory for our selected libs
mkdir -p install/target/lib.selected

# go through all files and strip them if possible
# find all used libraries too while at it

find install -type f | while read line
do
  if [ "`file -b $line| cut -c 1-14`" == "ELF 32-bit LSB" ]; then
    "$TARGET_STRIP" "$line"
    "$TARGET_OBJDUMP" -x "$line" 2>/dev/null | grep NEEDED | cut -c 15-
  fi
done | sort | uniq | while read line
do
  if [ -e "install/target/lib/$line" ]; then
    cp "install/target/lib/$line" "install/target/lib.selected/"
  else
    if [ -e "install/target/lib/gconv/$line" ]; then
      if [ ! -e "install/target/lib.selected/gconv" ]; then
        mkdir "install/target/lib.selected/gconv"
      fi
      cp "install/target/lib/gconv/$line" "install/target/lib.selected/gconv/"
    else
      exit 1
    fi
  fi
done

if [ $? -ne 0 ]; then
  exit 1
fi

# make sure some other files exist that objdump -x does not output
cp "install/target/lib/ld-linux.so.2" "install/target/lib.selected/"

# remove the old lib directory, rename lib.selected to lib
rm -fR install/target/lib
mv "install/target/lib.selected" "install/target/lib"

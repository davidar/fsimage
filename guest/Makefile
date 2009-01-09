
export TARGET_CC_LIBC=gcc-3.4.2-glibc-2.3.3
export TARGET_ARCH=i686
export TARGET=$(TARGET_ARCH)-unknown-linux-gnu

TOP=$(shell /bin/pwd)
X=$(TOP)/crosstool/install/host/$(TARGET)/$(TARGET_CC_LIBC)/bin/$(TARGET)-

export TARGET_CC=$(X)gcc
export TARGET_LD=$(X)ld
export TARGET_AR=$(X)ar
export TARGET_AS=$(X)as
export TARGET_STRIP=$(X)strip
export TARGET_RANLIB=$(X)ranlib
export TARGET_OBJDUMP=$(X)objdump
export TARGET_OBJCOPY=$(X)objcopy

export SRCDIR=$(TOP)/src

SUBDIRS = crosstool busybox tar e2fsprogs reiserfsprogs linux

.PHONY: $(SUBDIRS) root

all: root

root: $(SUBDIRS)
	cd $@ && ./build.sh $^
	cd linux && ./build_final.sh $(TOP)/root/install/target
	cp linux/build/linux/arch/i386/boot/bzImage .

$(SUBDIRS):
	@if [ ! -e $@/ok ]; then            \
          rm -fR $@/build $@/install;      \
          cd $@ && ./build.sh && touch ok; \
        fi

clean:
	rm -f */ok
	rm -fR */build
	rm -fR */install
	rm -f bzImage

-include Make.conf

ifndef PREFIX
$(error use ./configure before make)
endif

.PHONY: all install clean distclean bzImage

all: fsimage bzImage

fsimage: host/fsimage Makefile Make.conf
	echo "#!/bin/sh" > $@.tmp
	echo "guest=$(PREFIX)/share/fsimage/bzImage" >> $@.tmp
	cat host/fsimage >> $@.tmp
	chmod a+x $@.tmp
	cp $@.tmp $@
	rm -f $@.tmp

bzImage:
	if test -f guest/Makefile; then $(MAKE) -C guest; fi
	cp guest/bzImage $@

install: fsimage bzImage
	mkdir -p "$(PREFIX)/bin"
	cp fsimage "$(PREFIX)/bin/"
	mkdir -p "$(PREFIX)/share/fsimage"
	cp bzImage "$(PREFIX)/share/fsimage/"

hostclean:
	rm -f fsimage fsimage.tmp bzImage

hostdistclean: hostclean
	rm -f Make.conf

clean: hostclean
	if test -f guest/Makefile; then $(MAKE) -C guest clean; fi

distclean:
	$(MAKE) clean
	$(MAKE) hostdistclean


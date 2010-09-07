
ifeq ($(PREFIX),)
	PREFIX = /usr/local
endif

ifeq ($(DESTDIR),)
	INSTALL_ROOT = $(HOME)/.local
else
	INSTALL_ROOT=$(DESTDIR)$(PREFIX)
endif

all:

install:
	rm -rf ${INSTALL_ROOT}/share/tc-ext-tools
	install -m 755 -d ${INSTALL_ROOT}/bin
	install -m 755 -d ${INSTALL_ROOT}/etc/tc-ext-tools
	install -m 755 -d ${INSTALL_ROOT}/share/tc-ext-tools
	install -m 755 -c tools/* ${INSTALL_ROOT}/bin
	install -m 644 -c default/functions ${INSTALL_ROOT}/etc/tc-ext-tools/functions
	install -m 644 -c default/config ${INSTALL_ROOT}/etc/tc-ext-tools/config
	install -m 644 -c default/build ${INSTALL_ROOT}/share/tc-ext-tools/build

.PHONY: install


prefix ?= $(HOME)
bindir ?= $(prefix)/bin
docdir = $(prefix)/share/doc/jsonaxe

INSTALL = install
RM = rm -f
RM_R = rm -f -r
SED = sed

ifdef V
    TEST_OPTS += --verbose
    export TEST_OPTS
endif

SCRIPTS = jsonaxe
DOCS = COPYING README.md


all:

install: all
	$(INSTALL) -d -m 755 $(DESTDIR)$(bindir) $(DESTDIR)$(docdir)
	$(INSTALL) -m 644 $(SCRIPTS) $(DESTDIR)$(bindir)
	$(INSTALL) -m 644 $(DOCS) $(DESTDIR)$(docdir)

uninstall:
	$(RM_R) $(DESTDIR)$(bindir)/jsonaxe $(DESTDIR)$(docdir)

doc: all

test: all
	$(MAKE) --no-print-directory -C test

.PHONY: all install uninstall doc test

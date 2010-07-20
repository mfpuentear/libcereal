NULL = 

#Build in these directories:

SUBDIRS = \
	cereal \
	po \
	tests \
	$(NULL)

libcerealdocdir = ${prefix}/doc/libcereal
libcerealdoc_DATA = \
	ChangeLog \
	README \
	COPYING \
	AUTHORS \
	INSTALL \
	MAINTAINERS \
	NEWS \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = cereal-1.0.pc

dist-hook: gen-ChangeLog

.PHONY: gen-ChangeLog
gen-ChangeLog:
	if test -d .git; then \
	  $(top_srcdir)/gitlog-to-changelog	> $(distdir)/cl-t; \
	  rm -f $(distdir)/ChangeLog; \
	  mv $(distdir)/cl-t $(distdir)/ChangeLog; \
	fi

EXTRA_DIST = \
	$(libcerealdoc_DATA) \
	$(pkgconfig_DATA) \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in \
	$(NULL)

DISTCLEANFILES = \
	intltool-extract \
	intltool-merge \
	intltool-update \
	po/.intltool-merge-cache \
	$(NULL)


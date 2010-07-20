NULL = 

AM_CPPFLAGS = \
	$(LIBCEREAL_CFLAGS) \
	-include $(CONFIG_HEADER) \
	-I $(top_srcdir)/cereal \
	$(NULL)

noinst_PROGRAMS = posixtest

posixtest_SOURCES = \
	posixtest.vala \
	$(NULL)

posixtest_VALAFLAGS = \
	--pkg cereal-1.0 --vapidir $(top_srcdir)/cereal \
	--pkg posix \
	$(NULL)

posixtest_LDADD = \
	../cereal/libcereal.la \
	$(LIBCEREAL_LIBS) \
	$(NULL)

EXTRA_DIST = \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)


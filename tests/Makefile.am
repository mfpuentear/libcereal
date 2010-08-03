NULL = 

AM_CPPFLAGS = \
	$(LIBCEREAL_CFLAGS) \
	-include $(CONFIG_HEADER) \
	-I $(top_srcdir)/cereal \
	$(NULL)

noinst_PROGRAMS = bytestreamtest echotest stringstreamtest

bytestreamtest_SOURCES = \
	bytestreamtest.vala \
	$(NULL)

bytestreamtest_VALAFLAGS = \
	--pkg cereal-1.0 --vapidir $(top_srcdir)/cereal \
	$(NULL)

bytestreamtest_LDADD = \
	../cereal/libcereal.la \
	$(LIBCEREAL_LIBS) \
	$(NULL)

echotest_SOURCES = \
	echotest.vala \
	$(NULL)

echotest_VALAFLAGS = \
	--pkg cereal-1.0 --vapidir $(top_srcdir)/cereal \
	$(NULL)

echotest_LDADD = \
	../cereal/libcereal.la \
	$(LIBCEREAL_LIBS) \
	$(NULL)

stringstreamtest_SOURCES = \
	stringstreamtest.vala \
	$(NULL)

stringstreamtest_VALAFLAGS = \
	--pkg cereal-1.0 --vapidir $(top_srcdir)/cereal \
	--pkg gio-2.0 \
	$(NULL)

stringstreamtest_LDADD = \
	../cereal/libcereal.la \
	$(LIBCEREAL_LIBS) \
	$(NULL)

EXTRA_DIST = \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)


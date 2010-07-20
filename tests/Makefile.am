NULL = 

AM_CPPFLAGS = \
	$(LIBCEREAL_CFLAGS) \
	-include $(CONFIG_HEADER) \
	-I $(top_srcdir)/cereal \
	$(NULL)

noinst_PROGRAMS = echotest

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

EXTRA_DIST = \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)


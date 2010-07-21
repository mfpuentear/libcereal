NULL = 

AM_CPPFLAGS = \
	$(LIBCEREAL_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

lib_LTLIBRARIES = \
	libcereal.la
	$(NULL)

libcereal_la_SOURCES = \
	posixserialconnection.vala \
	serialconnection.vala \
	serialconnectionfactory.c \
	stringstream.vala \
	$(NULL)

libcereal_la_VALAFLAGS = \
	-H cereal.h \
	--vapi cereal-1.0.vapi \
	--library cereal-1.0 \
	--gir Cereal-1.0.gir \
	--pkg posix \
	$(NULL)

libcereal_la_LIBADD = \
	$(CEREAL_LIBS) \
	$(NULL)

libcereal_la_LDFLAGS = -version-info $(LIBCEREAL_LT_VERSION) -no-undefined

cerealincludedir = $(includedir)/cereal-1.0

cerealinclude_HEADERS = \
	cereal.h \
	$(NULL)

vapidir = $(datadir)/vala/vapi

vapi_DATA = \
	cereal-1.0.vapi \
	$(NULL)

girdir = $(datadir)/gir-1.0

gir_DATA = \
	Cereal-1.0.gir \
	$(NULL)

EXTRA_DIST = \
	$(cerealinclude_HEADERS) \
	$(vapi_DATA) \
	$(gir_DATA) \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)


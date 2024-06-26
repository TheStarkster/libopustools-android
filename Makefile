#################### COMPILE OPTIONS #######################

# Uncomment this for fixed-point build
#FIXED_POINT=1

# It is strongly recommended to uncomment one of these
 #VAR_ARRAYS: Use C99 variable-length arrays for stack allocation

# USE_ALLOCA: Use alloca() for stack allocation
# If none is defined, then the fallback is a non-threadsafe global array
CFLAGS := -DUSE_ALLOCA $(CFLAGS)
#CFLAGS := -DVAR_ARRAYS $(CFLAGS)

# These options affect performance
# HAVE_LRINTF: Use C99 intrinsics to speed up float-to-int conversion
#CFLAGS := -DHAVE_LRINTF $(CFLAGS)

###################### END OF OPTIONS ######################


TOOLCHAIN_PREFIX = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS17.0.sdk
CC = $(TOOLCHAIN_PREFIX)clang -arch arm64 -isysroot $(shell xcrun --sdk iphoneos --show-sdk-path)
AR = $(TOOLCHAIN_PREFIX)ar
RANLIB = $(TOOLCHAIN_PREFIX)ranlib
CFLAGS += -arch arm64 -isysroot $(shell xcrun --sdk iphoneos --show-sdk-path)


-include package_version

include silk_sources.mk
include celt_sources.mk
include opus_sources.mk

ifdef FIXED_POINT
SILK_SOURCES += $(SILK_SOURCES_FIXED)
else
SILK_SOURCES += $(SILK_SOURCES_FLOAT)
OPUS_SOURCES += $(OPUS_SOURCES_FLOAT)
endif

EXESUFFIX =
LIBPREFIX = lib
LIBSUFFIX = .a
OBJSUFFIX = .o

CC     = $(TOOLCHAIN_PREFIX)cc$(TOOLCHAIN_SUFFIX)
AR     = $(TOOLCHAIN_PREFIX)ar
RANLIB = $(TOOLCHAIN_PREFIX)ranlib
CP     = $(TOOLCHAIN_PREFIX)cp

cppflags-from-defines   = $(addprefix -D,$(1))
cppflags-from-includes  = $(addprefix -I,$(1))
ldflags-from-ldlibdirs  = $(addprefix -L,$(1))
ldlibs-from-libs        = $(addprefix -l,$(1))

WARNINGS = -Wall -W -Wstrict-prototypes -Wextra -Wcast-align -Wnested-externs -Wshadow
CFLAGS  += -O2 -g $(WARNINGS) -DOPUS_BUILD -DHAVE_CONFIG_H
CINCLUDES = include silk celt

ifdef FIXED_POINT
CFLAGS += -DFIXED_POINT=1 -DDISABLE_FLOAT_API
CINCLUDES += silk/fixed
else
CINCLUDES += silk/float
endif


LIBS = m

LDLIBDIRS = ./

CFLAGS  += $(call cppflags-from-defines,$(CDEFINES))
CFLAGS  += $(call cppflags-from-includes,$(CINCLUDES))
LDFLAGS += $(call ldflags-from-ldlibdirs,$(LDLIBDIRS))
LDLIBS  += $(call ldlibs-from-libs,$(LIBS))

COMPILE.c.cmdline   = $(CC) -c $(CFLAGS) -o $@ $<
LINK.o              = $(CC) $(LDPREFLAGS) $(LDFLAGS)
LINK.o.cmdline      = $(LINK.o) $^ $(LDLIBS) -o $@$(EXESUFFIX)

ARCHIVE.cmdline     = $(AR) $(ARFLAGS) $@ $^ && $(RANLIB) $@

%$(OBJSUFFIX):%.c
	$(COMPILE.c.cmdline)

%$(OBJSUFFIX):%.cpp
	$(COMPILE.cpp.cmdline)

# Directives


# Variable definitions
LIB_NAME = opusTool
TARGET = $(LIBPREFIX)$(LIB_NAME)$(LIBSUFFIX)

SRCS_C = $(SILK_SOURCES) $(CELT_SOURCES) $(OPUS_SOURCES)

OBJS := $(patsubst %.c,%$(OBJSUFFIX),$(SRCS_C))

OPUSDEMO_SRCS_C = src/opus_demo.c
OPUSDEMO_OBJS := $(patsubst %.c,%$(OBJSUFFIX),$(OPUSDEMO_SRCS_C))


# Rules
all: lib opus_demo

lib: $(TARGET)

$(TARGET): $(OBJS)
	$(ARCHIVE.cmdline)

opus_demo$(EXESUFFIX): $(OPUSDEMO_OBJS) $(TARGET)
	$(LINK.o.cmdline)


celt/celt.o: CFLAGS += -DPACKAGE_VERSION='$(PACKAGE_VERSION)'
celt/celt.o: package_version

package_version: force
	@if [ -x ./update_version ]; then \
		./update_version || true; \
	elif [ ! -e ./package_version ]; then \
		echo 'PACKAGE_VERSION="unknown"' > ./package_version; \
	fi

force:

clean:
	rm -f opus_demo$(EXESUFFIX) $(TARGET) \
		$(OBJS) $(OPUSDEMO_OBJS)

.PHONY: all lib clean

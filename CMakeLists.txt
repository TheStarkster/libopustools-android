cmake_minimum_required(VERSION 3.10)

# Set the project name
project(opustool)

# Add include directories
include_directories(include silk celt silk/fixed)

# Add sources
file(GLOB SILK_SOURCES silk/*.c)
file(GLOB CELT_SOURCES celt/*.c)
file(GLOB OPUS_SOURCES src/*.c)
file(GLOB OGG_SOURCES ogg/*.c)
file(GLOB OPUS_FILE_SOURCES opusfile/*.c)

# Create the library
add_library(opustool STATIC ${SILK_SOURCES} ${CELT_SOURCES} ${OPUS_SOURCES} ${OGG_SOURCES} ${OPUS_FILE_SOURCES})

# Add definitions
add_definitions(-DUSE_ALLOCA -DOPUS_BUILD -DHAVE_CONFIG_H -DFIXED_POINT=1)

cmake_minimum_required(VERSION 3.10)

set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_OSX_ARCHITECTURES x86_64) # or arm64 if you are targeting that
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "iOS deployment target")

set(CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphonesimulator")

execute_process(COMMAND xcrun --sdk iphonesimulator --show-sdk-path OUTPUT_VARIABLE CMAKE_OSX_SYSROOT OUTPUT_STRIP_TRAILING_WHITESPACE)
set(CMAKE_OSX_SYSROOT ${CMAKE_OSX_SYSROOT} CACHE PATH "Path to the iOS simulator SDK")

# Include default paths for the standard libraries
include_directories(SYSTEM ${CMAKE_OSX_SYSROOT}/usr/include)
link_directories(${CMAKE_OSX_SYSROOT}/usr/lib)


# Project Name
project(OpusTool)

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/silk
    ${CMAKE_CURRENT_SOURCE_DIR}/silk/float
    ${CMAKE_CURRENT_SOURCE_DIR}/celt
    ${CMAKE_CURRENT_SOURCE_DIR}/opusfile
    ${CMAKE_CURRENT_SOURCE_DIR}/ogg
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Manually specify source files or use file(GLOB ...) to find them
file(GLOB CELT_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/celt/*.c")
file(GLOB SILK_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/silk/*.c")
file(GLOB OPUS_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/opus/*.c")
file(GLOB OPUS_FILE_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/opusfile/*.c")
file(GLOB OGG_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/ogg/*.c")
file(GLOB SRC_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c")

# Combine all sources
set(SOURCE_FILES ${CELT_SOURCES} ${SILK_SOURCES} ${OPUS_SOURCES} ${OPUS_FILE_SOURCES} ${OGG_SOURCES} ${SRC_SOURCES})

# Define the static library
add_library(opustool STATIC ${SOURCE_FILES})

# Compiler options
target_compile_options(opustool PRIVATE
    -Wall -W -Wstrict-prototypes -Wextra -Wcast-align -Wnested-externs -Wshadow
    -DNULL=0 -D_FILE_OFFSET_BITS=64
    -DOPUS_BUILD -DHAVE_CONFIG_H -DUSE_ALLOCA -DHAVE_LRINT -DHAVE_LRINTF
    -O2 -std=gnu99 -g
)

# Link libraries
target_link_libraries(opustool m)

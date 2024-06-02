# ios.toolchain.cmake

# Define the system name and processor
set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_SYSTEM_PROCESSOR arm64)

# Specify the minimum iOS version
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.0")

# Define the compilers
set(CMAKE_C_COMPILER /usr/bin/clang)
set(CMAKE_CXX_COMPILER /usr/bin/clang++)

# Specify the sysroot
execute_process(COMMAND xcrun --sdk iphoneos --show-sdk-path OUTPUT_VARIABLE CMAKE_OSX_SYSROOT OUTPUT_STRIP_TRAILING_WHITESPACE)

# Set CMAKE_OSX_SYSROOT to the path returned by xcrun
set(CMAKE_OSX_SYSROOT ${CMAKE_OSX_SYSROOT})

# Enable position-independent code (required for iOS)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Set the standard to C99
set(CMAKE_C_STANDARD 99)

# Additional configurations to avoid architecture mismatch
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -arch arm64")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch arm64")
set(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} -arch arm64")

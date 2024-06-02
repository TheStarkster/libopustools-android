to build for ios

1. Create a build folder and cd into it
2. Run `cmake -DCMAKE_TOOLCHAIN_FILE=../ios.toolchain.cmake ..`
3. Run `cmake --build .`
4. (Completely Optinal) Run `nm -gU libopustool.a` to check if the build has all the symbols we need
5. (Completely Optional as well) Run `lipo -info libopustool.a` to check the architecture of the build

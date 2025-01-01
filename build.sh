#!/bin/sh

# Clean build directory
rm -rf build
mkdir -p build
cd build

# Setup conan profile
conan profile detect --force

# Continue with build
conan install .. --output-folder=. --build=missing
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build . 
# halo-halo++

[![build](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/build.yml/badge.svg)](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/build.yml)

A simple C++ software template project for multimedia, machine learning,
and computer vision tasks (and probably more in the future), this
project builds SFML, PyTorch/LibTorch, and OpenCV library (for now).

# Requirements

- Python + pip
- C & C++ compilers
- CMake
- git

# Ubuntu

```bash
# install opencv
sudo apt install libopencv-dev

# clone and open this project
cd sfml-opencv-libtorch

# configure
cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

# build
cmake --build build --config Release -j2
```

# macOS

```bash
# install opencv
brew install opencv

# clone and open this project
cd sfml-opencv-libtorch

# configure
cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

# build
cmake --build build --config Release -j2
```

# Windows MSVC visual studio 16

Use `-G "Visual Studio 17 2022" -A x64` for visual studio 17.

Use `-G "Visual Studio 18 2025" -A x64` for visual studio 18 (maybe?).

First open cmd and follow the commands below:

```bash
# clone and open this project
cd sfml-opencv-libtorch

# download cmake source
curl -L -o 4.11.0.zip https://github.com/opencv/opencv/archive/refs/tags/4.11.0.zip

# extract cmake source
tar -xf "4.11.0.zip" -C ".\\"

# go to OpenCV source directory
cd opencv-4.11.0

# configure OpenCV (see above for other generators of MSVC)
cmake -S . -B build ^
    -G "Visual Studio 16 2019" -A x64 ^
    -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="build/install" -DBUILD_PERF_TESTS=OFF ^
    -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DWITH_CUDA=OFF ^
    -DBUILD_EXAMPLES=OFF -DINSTALL_CREATE_DISTRIB=ON

# build compile OpenCV
cmake --build build --config Release -j2

# install OpenCV, remember this OpenCV directory because this
# will be used when we configure sfml-opencv-libtorch project
cmake --build build --target install --config Release

# go back to sfml-opencv-libtorch project folder
cd ..

# configure sfml-opencv-libtorch project
cmake -S . -B build -DOpenCV_DIR="opencv-4.11.0/build/install" ^
    -G "Visual Studio 16 2019" -A x64 ^
    -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

# build compile sfml-opencv-libtorch
cmake --build build --config Release -j2

# the compiled binary is in the build/bin/Release or build/bin/Debug folder
```

# Windows GCC or Clang

```bash
# clone and open this project
cd sfml-opencv-libtorch

# download cmake source
curl -L -o 4.11.0.zip https://github.com/opencv/opencv/archive/refs/tags/4.11.0.zip

# extract cmake source
tar -xf "4.11.0.zip" -C ".\\"

# go to OpenCV source directory
cd opencv-4.11.0

# configure OpenCV (see above for other generators of MSVC)
cmake -S . -B build ^
    -G -G "Unix Makefiles" ^
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ^
    -DCPU_BASELINE=SSE3 -DCPU_DISPATCH= ^ # (optional, clang might need this line)
    -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="build/install" -DBUILD_PERF_TESTS=OFF ^
    -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DWITH_CUDA=OFF ^
    -DBUILD_EXAMPLES=OFF -DINSTALL_CREATE_DISTRIB=ON

# build compile OpenCV
cmake --build build --config Release -j2

# install OpenCV, remember this OpenCV directory because this
# will be used when we configure sfml-opencv-libtorch project
cmake --build build --target install --config Release

# go back to sfml-opencv-libtorch project folder
cd ..

# configure sfml-opencv-libtorch project
cmake -S . -B build -DOpenCV_DIR="opencv-4.11.0/build/install" ^
    -G -G "Unix Makefiles" ^
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ^
    -DCPU_BASELINE=SSE3 -DCPU_DISPATCH= ^ # (optional, clang might need this line)
    -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

# build compile sfml-opencv-libtorch
cmake --build build --config Release -j2

# the compiled binary is in the build/bin/Release or build/bin/Debug folder
```
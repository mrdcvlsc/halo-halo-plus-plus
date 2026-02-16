# halo-halo++

[![build](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/build.yml/badge.svg)](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/build.yml)
[![win-clang](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/win-clang.yml/badge.svg)](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/win-clang.yml)
[![win-gcc](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/win-gcc.yml/badge.svg)](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/win-gcc.yml)
[![mac13-x86-64](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/mac13-x86-64.yml/badge.svg)](https://github.com/mrdcvlsc/halo-halo-plus-plus/actions/workflows/mac13-x86-64.yml)

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
# install SFML requirements
sudo apt update

sudo apt install libxrandr-dev libxcursor-dev libxi-dev \
    libudev-dev libfreetype-dev libflac-dev libvorbis-dev \
    libgl1-mesa-dev libegl1-mesa-dev libfreetype-dev

# install opencv
sudo apt install libopencv-dev

# clone and open this project in the terminal/cli

# configure
cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

# build
cmake --build build --config Release -j2
```

# macOS

```bash
# install opencv
brew install opencv

# clone and open this project in the terminal/cli

# configure
cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

# build
cmake --build build --config Release -j2
```

# Windows MSVC (CLI)

Use `-G "Visual Studio 17 2022" -A x64` for visual studio 17.

Use `-G "Visual Studio 18 2026" -A x64` for visual studio 18 (cmake 4.2^).

First open cmd and follow the commands below:

```bash
# clone and open this project in the terminal/cli

# download opencv source
curl -L -o 4.13.0.zip https://github.com/opencv/opencv/archive/refs/tags/4.13.0.zip

# extract opencv source
tar -xf "4.13.0.zip" -C ".\\"

# clone opencv contrib
git clone https://github.com/opencv/opencv_contrib.git

# go to OpenCV source directory
cd opencv-4.13.0

# configure OpenCV (see above for other generators of MSVC)
cmake -S . -B build ^
    -G "Visual Studio 18 2026" -A x64 ^
    -DCMAKE_INSTALL_PREFIX="build/install" ^
    -DOPENCV_EXTRA_MODULES_PATH="../opencv_contrib/modules" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS=FALSE ^
    -DBUILD_PERF_TESTS=OFF ^
    -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DWITH_CUDA=OFF ^
    -DBUILD_EXAMPLES=OFF -DINSTALL_CREATE_DISTRIB=ON ^
    -DOPENCV_ENABLE_ALLOCATOR_STATS=OFF -DOPENCV_FORCE_3RDPARTY_BUILD=ON

# build compile OpenCV
cmake --build build --config Release -j2

# install OpenCV, remember this OpenCV directory because this
# will be used when we configure sfml-opencv-libtorch project
cmake --build build --target install --config Release

# go back to sfml-opencv-libtorch project folder
cd ..

# configure sfml-opencv-libtorch project
cmake -S . -B build -DOpenCV_DIR="opencv-4.13.0/build/install" ^
    -G "Visual Studio 18 2026" -A x64 ^
    -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release ^
    -DOpenCV_DIR="./opencv-4.13.0/build/install"

# build compile sfml-opencv-libtorch
cmake --build build --config Release -j2

# the compiled binary is in the build/bin/Release or build/bin/Debug folder
```

# Windows GCC or Clang

```bash
# clone and open this project in the terminal/cli

# download cmake source
curl -L -o 4.13.0.zip https://github.com/opencv/opencv/archive/refs/tags/4.13.0.zip

# extract cmake source
tar -xf "4.13.0.zip" -C ".\\"

# go to OpenCV source directory
cd opencv-4.13.0

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
cmake -S . -B build -DOpenCV_DIR="opencv-4.13.0/build/install" ^
    -G -G "Unix Makefiles" ^
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ^
    -DCPU_BASELINE=SSE3 -DCPU_DISPATCH= ^ # (optional, clang might need this line)
    -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

# build compile sfml-opencv-libtorch
cmake --build build --config Release -j2

# the compiled binary is in the build/bin/Release or build/bin/Debug folder
```
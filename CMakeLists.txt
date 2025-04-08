cmake_minimum_required(VERSION 3.30)

project(sfml_opencv_libtorch_project)

# ------------------------------------------------------------------
# INITIAL SETUPS
# ------------------------------------------------------------------

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_STANDARD 17)

if(NOT BUILD_SHARED_LIBS)
    set(OpenCV_STATIC_LIBRARIES ON)
    set(OpenCV_STATIC ON)
    set(OpenCV_SHARED OFF)
else()
    set(OpenCV_STATIC_LIBRARIES OFF)
    set(OpenCV_STATIC OFF)
    set(OpenCV_SHARED ON)
endif()

if(MSVC)
    if(BUILD_SHARED_LIBS)
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
        add_compile_options(
            $<$<CONFIG:Release>:/MD>
            $<$<CONFIG:Debug>:/MDd>
        )
    else()
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded")
        add_compile_options(
            $<$<CONFIG:Release>:/MT>
            $<$<CONFIG:Debug>:/MTd>
        )
    endif()

    message(STATUS "CMAKE_MSVC_RUNTIME_LIBRARY=${CMAKE_MSVC_RUNTIME_LIBRARY}")
    message(STATUS "CONFIG=${CONFIG}")
endif()

if(APPLE)
    find_package(Eigen3)
    find_package(Iconv)

    if(BUILD_SHARED_LIBS)
        set(CMAKE_MACOSX_RPATH ON)
        set(CMAKE_INSTALL_NAME_DIR @rpath)
        set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
        set(CMAKE_INSTALL_RPATH_USE_LINK_PATH ON)
    endif()
endif()

if (CMAKE_GENERATOR MATCHES "Visual Studio" AND CMAKE_VS_PLATFORM_TOOLSET STREQUAL "ClangCL")
    message(STATUS "PRINT0: Configuring for Clang-CL on Windows")
    set(CPU_BASELINE SSE3)
    set(CPU_DISPATCH "SSE4_1;SSE4_2;POPCNT;FP16;AVX;AVX2")
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_SIMULATE_ID STREQUAL "MSVC")
    message(STATUS "PRINT1: Configuring for Clang-CL on Windows")
    set(CPU_DISPATCH "SSE4_1;SSE4_2;POPCNT;FP16;AVX;AVX2")
endif()

if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    find_package(Eigen3)
    find_package(Iconv)
endif ()

message("============================================================")
message(STATUS "BUILD_SHARED_LIBS   : ${BUILD_SHARED_LIBS}")
message(STATUS "CMAKE_BUILD_TYPE    : ${CMAKE_BUILD_TYPE}")
message(STATUS "CPU_BASELINE        : ${CPU_BASELINE}")
message(STATUS "CPU_DISPATCH        : ${CPU_DISPATCH}")
message(STATUS "Eigen3_DIR          : ${Eigen3_DIR}")
message(STATUS "CMAKE_CXX_COMPILER  : ${CMAKE_CXX_COMPILER}")
message(STATUS "CMAKE_C_COMPILER    : ${CMAKE_C_COMPILER}")
message(STATUS "CPU_BASELINE        : ${CPU_BASELINE}")
message(STATUS "CPU_DISPATCH        : ${CPU_DISPATCH}")

# ------------------------------------------------------------------
# SFML
# ------------------------------------------------------------------

include(FetchContent)
FetchContent_Declare(SFML
    GIT_REPOSITORY https://github.com/SFML/SFML.git
    GIT_TAG 3.0.0
    GIT_SHALLOW ON
    EXCLUDE_FROM_ALL
    SYSTEM)
FetchContent_MakeAvailable(SFML)

# ------------------------------------------------------------------
# OpenCV
# ------------------------------------------------------------------

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

message(STATUS "OpenCV_DIR          : ${OpenCV_DIR}")
message(STATUS "OpenCV_INSTALL_PATH : ${OpenCV_INSTALL_PATH}")

# ------------------------------------------------------------------
# LIBTORCH
# ------------------------------------------------------------------

include(FetchContent)

set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_SILENT OFF)

# libtorch - get the libtorch shared binaries (THIS IS FOR LINUX - CPU)
message("--------------------------")
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  message("Operating System Type: LINUX")
  FetchContent_Declare(Torch
    URL https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.5.0%2Bcpu.zip
  )
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  message("Operating System Type: APPLE")
  if(${CMAKE_HOST_SYSTEM_PROCESSOR} MATCHES "x86_64")
      message(STATUS "x86_64 architecture detected")
      FetchContent_Declare(Torch
        URL https://download.pytorch.org/libtorch/cpu/libtorch-macos-x86_64-2.5.0.zip
      )
  elseif(${CMAKE_HOST_SYSTEM_PROCESSOR} MATCHES "arm64")
      message(STATUS "arm64 architecture detected")
      FetchContent_Declare(Torch
        URL https://download.pytorch.org/libtorch/cpu/libtorch-macos-arm64-2.5.0.zip
      )
  else()
      message(FATAL_ERROR "Other architecture detected")
  endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  message("Operating System Type: WINDOWS")
  FetchContent_Declare(Torch
    URL https://download.pytorch.org/libtorch/cpu/libtorch-win-shared-with-deps-2.5.0%2Bcpu.zip
  )
else()
  message("Operating System Type: Unknown")
  message(FATAL_ERROR "Cannot be supported")
endif()
message("--------------------------")

# libtorch - make the libtorch library available to the project
FetchContent_MakeAvailable(Torch)

# libtorch - add the lib paths of the downloaded library from FetchContent
list(APPEND CMAKE_PREFIX_PATH "${torch_SOURCE_DIR}")

# libtorch - find the libtorch lib and require it for the project
find_package(Torch REQUIRED)

# libtorch - link the libtorch libraries
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")

# ------------------------------------------------------------------

message("============================================================")

# ==================================================================
# live_cam_object_detection (OpenCV + libtorch)
# ==================================================================

add_executable(live_cam_object_detection
    src/live_cam_object_detection.cpp
    src/get_cameras.cpp
    src/event_keys.cpp
    src/preprocess_frame.cpp
    src/get_class_color.cpp
    src/logger.cpp
    src/benchmark.cpp
)

target_link_libraries(live_cam_object_detection PRIVATE "${TORCH_LIBRARIES}")
# target_link_libraries(live_cam_object_detection PRIVATE opencv_highgui opencv_imgcodecs opencv_core opencv_imgproc)

# link all opencv library modules
target_link_libraries(live_cam_object_detection PRIVATE ${OpenCV_LIBS})
target_link_libraries(live_cam_object_detection PRIVATE SFML::Audio)
set_property(TARGET live_cam_object_detection PROPERTY CXX_STANDARD 17)

if (MSVC)
    # the official libtorch libraries are shared libs so we need to
    # accomodate that despite our other library builds are static
    file(GLOB TORCH_DLLS "${TORCH_INSTALL_PREFIX}/lib/*.dll")
    add_custom_command(TARGET live_cam_object_detection
                        POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                        ${TORCH_DLLS}
                        $<TARGET_FILE_DIR:live_cam_object_detection>)
endif (MSVC)

if (BUILD_SHARED_LIBS)
    file(GLOB ALL_PROJECT_SHARED_LIBS   "${OpenCV_INSTALL_PATH}/bin/*.dll")

    file(GLOB OPENCV_BIN_SO    "${OpenCV_INSTALL_PATH}/bin/*.so")
    file(GLOB OPENCV_BIN_LIB   "${OpenCV_INSTALL_PATH}/bin/*.lib")
    file(GLOB OPENCV_LIB_DLL   "${OpenCV_INSTALL_PATH}/lib/*.dll")
    file(GLOB OPENCV_LIB_SO    "${OpenCV_INSTALL_PATH}/lib/*.so")
    file(GLOB OPENCV_LIB_DYLIB "${OpenCV_INSTALL_PATH}/lib/*.dylib")
    file(GLOB OPENCV_LIB_LIB   "${OpenCV_INSTALL_PATH}/lib/*.lib")

    file(GLOB TORCH_LIB_DYLIBS "_deps/torch-src/lib/*.dylib")
    file(GLOB TORCH_LIB_LIBS "_deps/torch-src/lib/*.lib")
    file(GLOB TORCH_LIB_DLL "_deps/torch-src/lib/*.dll")
    file(GLOB TORCH_LIB_SO "_deps/torch-src/lib/*.so")

    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_BIN_SO})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_BIN_LIB})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_DLL})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_SO})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_DYLIB})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_LIB})

    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_DYLIBS})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_LIBS})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_DLL})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_SO})


    add_custom_command(TARGET live_cam_object_detection
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ALL_PROJECT_SHARED_LIBS}
        $<TARGET_FILE_DIR:live_cam_object_detection>
    )
endif()

# ==================================================================
# live_cam_motion_detection (OpenCV only)
# ==================================================================

add_executable(live_cam_motion_detection
    src/live_cam_motion_detection.cpp
    src/get_cameras.cpp
    src/event_keys.cpp
    src/logger.cpp
)

# target_link_libraries(live_cam_motion_detection PRIVATE "${TORCH_LIBRARIES}")
# target_link_libraries(live_cam_motion_detection PRIVATE opencv_highgui opencv_imgcodecs opencv_core opencv_imgproc)

# link all opencv library modules
target_link_libraries(live_cam_motion_detection PRIVATE ${OpenCV_LIBS})
target_link_libraries(live_cam_motion_detection PRIVATE SFML::Audio)
set_property(TARGET live_cam_motion_detection PROPERTY CXX_STANDARD 17)

# if (MSVC)
      # the official libtorch libraries are shared libs so we need to
      # accomodate that despite our other library builds are static
#     file(GLOB TORCH_DLLS "${TORCH_INSTALL_PREFIX}/lib/*.dll")
#     add_custom_command(TARGET live_cam_motion_detection
#                             POST_BUILD
#                             COMMAND ${CMAKE_COMMAND} -E copy_if_different
#                             ${TORCH_DLLS}
#                             $<TARGET_FILE_DIR:live_cam_motion_detection>)
# endif (MSVC)

if (BUILD_SHARED_LIBS)
    file(GLOB ALL_PROJECT_SHARED_LIBS   "${OpenCV_INSTALL_PATH}/bin/*.dll")
    
    file(GLOB OPENCV_BIN_SO    "${OpenCV_INSTALL_PATH}/bin/*.so")
    file(GLOB OPENCV_BIN_LIB   "${OpenCV_INSTALL_PATH}/bin/*.lib")
    file(GLOB OPENCV_LIB_DLL   "${OpenCV_INSTALL_PATH}/lib/*.dll")
    file(GLOB OPENCV_LIB_SO    "${OpenCV_INSTALL_PATH}/lib/*.so")
    file(GLOB OPENCV_LIB_DYLIB "${OpenCV_INSTALL_PATH}/lib/*.dylib")
    file(GLOB OPENCV_LIB_LIB   "${OpenCV_INSTALL_PATH}/lib/*.lib")

    file(GLOB TORCH_LIB_DYLIBS "_deps/torch-src/lib/*.dylib")
    file(GLOB TORCH_LIB_LIBS "_deps/torch-src/lib/*.lib")
    file(GLOB TORCH_LIB_DLL "_deps/torch-src/lib/*.dll")
    file(GLOB TORCH_LIB_SO "_deps/torch-src/lib/*.so")

    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_BIN_SO})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_BIN_LIB})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_DLL})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_SO})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_DYLIB})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_LIB})

    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_DYLIBS})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_LIBS})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_DLL})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_SO})
    
    add_custom_command(TARGET live_cam_motion_detection
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ALL_PROJECT_SHARED_LIBS}
        $<TARGET_FILE_DIR:live_cam_motion_detection>
    )
endif()

# ==================================================================
# draw_bounding_box (OpenCV + libtorch)
# ==================================================================

add_executable(draw_bounding_box
    src/draw_bounding_box.cpp
    src/preprocess_frame.cpp
    src/get_class_color.cpp
    src/event_keys.cpp
    src/logger.cpp
)
target_link_libraries(draw_bounding_box PRIVATE "${TORCH_LIBRARIES}")
# target_link_libraries(draw_bounding_box PRIVATE opencv_highgui opencv_imgcodecs opencv_core opencv_imgproc)

# link all opencv library modules
target_link_libraries(draw_bounding_box PRIVATE ${OpenCV_LIBS})
set_property(TARGET draw_bounding_box PROPERTY CXX_STANDARD 17)

if (MSVC)
    # the official libtorch libraries are shared libs so we need to
    # accomodate that despite our other library builds are static
    file(GLOB TORCH_DLLS "${TORCH_INSTALL_PREFIX}/lib/*.dll")
    add_custom_command(TARGET draw_bounding_box
                            POST_BUILD
                            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                            ${TORCH_DLLS}
                            $<TARGET_FILE_DIR:draw_bounding_box>)
endif (MSVC)

if (BUILD_SHARED_LIBS)
    file(GLOB ALL_PROJECT_SHARED_LIBS   "${OpenCV_INSTALL_PATH}/bin/*.dll")
        
    file(GLOB OPENCV_BIN_SO    "${OpenCV_INSTALL_PATH}/bin/*.so")
    file(GLOB OPENCV_BIN_LIB   "${OpenCV_INSTALL_PATH}/bin/*.lib")
    file(GLOB OPENCV_LIB_DLL   "${OpenCV_INSTALL_PATH}/lib/*.dll")
    file(GLOB OPENCV_LIB_SO    "${OpenCV_INSTALL_PATH}/lib/*.so")
    file(GLOB OPENCV_LIB_DYLIB "${OpenCV_INSTALL_PATH}/lib/*.dylib")
    file(GLOB OPENCV_LIB_LIB   "${OpenCV_INSTALL_PATH}/lib/*.lib")

    file(GLOB TORCH_LIB_DYLIBS "_deps/torch-src/lib/*.dylib")
    file(GLOB TORCH_LIB_LIBS "_deps/torch-src/lib/*.lib")
    file(GLOB TORCH_LIB_DLL "_deps/torch-src/lib/*.dll")
    file(GLOB TORCH_LIB_SO "_deps/torch-src/lib/*.so")

    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_BIN_SO})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_BIN_LIB})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_DLL})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_SO})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_DYLIB})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${OPENCV_LIB_LIB})

    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_DYLIBS})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_LIBS})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_DLL})
    list(APPEND ALL_PROJECT_SHARED_LIBS ${TORCH_LIB_SO})
    
    add_custom_command(TARGET draw_bounding_box
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ALL_PROJECT_SHARED_LIBS}
        $<TARGET_FILE_DIR:draw_bounding_box>
    )
endif()

# ==================================================================

# //////////////////////////////////////////////////////////////////
# copy assets folder to the build/bin folder
# //////////////////////////////////////////////////////////////////

add_custom_target(copy_assets_folder ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different "${CMAKE_SOURCE_DIR}/assets" "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/assets"
    DEPENDS
        live_cam_object_detection
        live_cam_motion_detection
        draw_bounding_box
)
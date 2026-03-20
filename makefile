.PHONY: config build run

# Requirements:
# sudo apt install libopencv-dev

EXECUTABLE:=./build/bin/draw_bounding_box

config:
	cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

build:
	cmake --build build --config Release -j2

dconfig:
	cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Debug

dbuild:
	cmake --build build --config Debug -j2

clean:
	rm -rf bb*.jpg *.pt *.torchscript runs exp10-new datasets

download-test-files:
	curl -L -o test_folder/shibuya.jpg  https://github.com/mrdcvlsc/halo-halo-plus-plus/releases/download/test-resources/shibuya.jpg
	curl -L -o test_folder/office.jpg   https://github.com/mrdcvlsc/halo-halo-plus-plus/releases/download/test-resources/office.jpg
	curl -L -o test_folder/bus.jpg      https://github.com/mrdcvlsc/halo-halo-plus-plus/releases/download/test-resources/bus.jpg
	curl -L -o test_folder/crossing.jpg https://github.com/mrdcvlsc/halo-halo-plus-plus/releases/download/test-resources/crossing.jpg

test:
	$(EXECUTABLE) 0.4  0.3 yolo11n.torchscript 640  test_folder/shibuya.jpg  test_folder/bb-shibuya-640.jpg
	$(EXECUTABLE) 0.5  0.5  yolo11n.torchscript 640 test_folder/office.jpg   test_folder/bb-office-640.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n.torchscript 640 test_folder/bus.jpg      test_folder/bb-bus-640.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n.torchscript 640 test_folder/crossing.jpg test_folder/bb-crossing-640.jpg

	$(EXECUTABLE) 0.4  0.3 yolo11n-320-in-dim.torchscript 320 test_folder/shibuya.jpg  test_folder/bb-shibuya-320.jpg
	$(EXECUTABLE) 0.5  0.5  yolo11n-320-in-dim.torchscript 320 test_folder/office.jpg   test_folder/bb-office-320.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n-320-in-dim.torchscript 320 test_folder/bus.jpg      test_folder/bb-bus-320.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n-320-in-dim.torchscript 320 test_folder/crossing.jpg test_folder/bb-crossing-320.jpg

	$(EXECUTABLE) 0.4  0.3 yolo11n-160-in-dim.torchscript 160 test_folder/shibuya.jpg  test_folder/bb-shibuya-160.jpg
	$(EXECUTABLE) 0.5  0.5  yolo11n-160-in-dim.torchscript 160 test_folder/office.jpg   test_folder/bb-office-160.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n-160-in-dim.torchscript 160 test_folder/bus.jpg      test_folder/bb-bus-160.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n-160-in-dim.torchscript 160 test_folder/crossing.jpg test_folder/bb-crossing-160.jpg

	$(EXECUTABLE) 0.4  0.3 yolo11n-96-in-dim.torchscript 96 test_folder/shibuya.jpg  test_folder/bb-shibuya-96.jpg
	$(EXECUTABLE) 0.5  0.5  yolo11n-96-in-dim.torchscript 96 test_folder/office.jpg   test_folder/bb-office-96.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n-96-in-dim.torchscript 96 test_folder/bus.jpg      test_folder/bb-bus-96.jpg
	$(EXECUTABLE) 0.5  0.3  yolo11n-96-in-dim.torchscript 96 test_folder/crossing.jpg test_folder/bb-crossing-96.jpg

test-best:
	$(EXECUTABLE) 0.4  0.3 runs/detect/train3/weights/best.torchscript 320 test_folder/shibuya.jpg  test_folder/bb-shibuya-320.jpg
	$(EXECUTABLE) 0.5  0.5  runs/detect/train3/weights/best.torchscript 320 test_folder/office.jpg   test_folder/bb-office-320.jpg
	$(EXECUTABLE) 0.5  0.3  runs/detect/train3/weights/best.torchscript 320 test_folder/bus.jpg      test_folder/bb-bus-320.jpg
	$(EXECUTABLE) 0.5  0.3  runs/detect/train3/weights/best.torchscript 320 test_folder/crossing.jpg test_folder/bb-crossing-320.jpg

	$(EXECUTABLE) 0.4  0.3 runs/detect/train2/weights/best.torchscript 160 test_folder/shibuya.jpg  test_folder/bb-shibuya-160.jpg
	$(EXECUTABLE) 0.5  0.5  runs/detect/train2/weights/best.torchscript 160 test_folder/office.jpg   test_folder/bb-office-160.jpg
	$(EXECUTABLE) 0.5  0.3  runs/detect/train2/weights/best.torchscript 160 test_folder/bus.jpg      test_folder/bb-bus-160.jpg
	$(EXECUTABLE) 0.5  0.3  runs/detect/train2/weights/best.torchscript 160 test_folder/crossing.jpg test_folder/bb-crossing-160.jpg

	$(EXECUTABLE) 0.4  0.3 runs/detect/train/weights/best.torchscript 96 test_folder/shibuya.jpg  test_folder/bb-shibuya-96.jpg
	$(EXECUTABLE) 0.5  0.5  runs/detect/train/weights/best.torchscript 96 test_folder/office.jpg   test_folder/bb-office-96.jpg
	$(EXECUTABLE) 0.5  0.3  runs/detect/train/weights/best.torchscript 96 test_folder/bus.jpg      test_folder/bb-bus-96.jpg
	$(EXECUTABLE) 0.5  0.3  runs/detect/train/weights/best.torchscript 96 test_folder/crossing.jpg test_folder/bb-crossing-96.jpg

# ===== for windows msvc compiler build =====

win_msvc_opencv_clean:
	rd /S /Q .\opencv-4.13.0\build
	rd /S /Q .\build

win_msvc_opencv_config:
	cmake -S .\opencv-4.13.0 -B .\opencv-4.13.0\build -G "Visual Studio 18 2026" -A x64 -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DOPENCV_EXTRA_MODULES_PATH="./opencv_contrib/modules" -DCMAKE_INSTALL_PREFIX="./opencv-4.13.0/build/install" -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DWITH_CUDA=OFF -DBUILD_EXAMPLES=OFF -DINSTALL_CREATE_DISTRIB=ON -DOPENCV_ENABLE_ALLOCATOR_STATS=OFF -DOPENCV_FORCE_3RDPARTY_BUILD=ON

win_msvc_opencv_build:
	cmake --build .\opencv-4.13.0\build --config Release -j8
	cmake --build .\opencv-4.13.0\build --target install --config Release

win_msvc_apps_config:
	cmake -S . -B build -G "Visual Studio 18 2026" -A x64 -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR="./opencv-4.13.0/build/install"

win_msvc_apps_build:
	cmake --build build --config Release -j8

run_motion_detection:
	.\build\bin\Release\live_cam_motion_detection.exe

win_msvc_test:
	mkdir test_folder
	make download-test-files
	python pt_to_torchscript.py
	make test EXECUTABLE=./build/bin/Release/draw_bounding_box.exe

	cp yolo11n.torchscript ./build/bin/Release/
	cp yolo11n-96-in-dim.torchscript ./build/bin/Release/
	cp yolo11n-160-in-dim.torchscript ./build/bin/Release/
	cp yolo11n-320-in-dim.torchscript ./build/bin/Release/

# ============================================

# ===== for windows msvc compiler build =====

template_msvc_opencv_config:
	cmake -S . -B build ${{ matrix.platform.flags }} ${{ matrix.config.flags }} ${{ matrix.build.flags }} -DOPENCV_EXTRA_MODULES_PATH="../opencv_contrib/modules" -DCMAKE_INSTALL_PREFIX="./build/install" -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF -DWITH_CUDA=OFF -DBUILD_EXAMPLES=OFF -DINSTALL_CREATE_DISTRIB=ON -DOPENCV_ENABLE_ALLOCATOR_STATS=OFF -DOPENCV_FORCE_3RDPARTY_BUILD=ON

template_msvc_opencv_build:
	cmake --build build --config ${{ matrix.build.name }}
	cmake --build build --target install --config ${{ matrix.build.name }}

template_msvc_apps_config:
	cmake -S . -B build ${{ matrix.platform.flags }} ${{ matrix.config.flags }} ${{ matrix.build.flags }} -DOpenCV_DIR="./${{ matrix.opencv.folder_version }}/build/install${{ matrix.platform.cmake_conf }}"

template_msvc_apps_build:
	cmake --build build --config ${{ matrix.build.name }}

template_msvc_test:
	mkdir test_folder
	make download-test-files
	python pt_to_torchscript.py
	make test EXECUTABLE=${{ matrix.platform.folder }}${{ matrix.platform.bin }}draw_bounding_box${{ matrix.platform.extension }}

	cp yolo11n.torchscript ${{ matrix.platform.folder }}
	cp yolo11n-96-in-dim.torchscript ${{ matrix.platform.folder }}
	cp yolo11n-160-in-dim.torchscript ${{ matrix.platform.folder }}
	cp yolo11n-320-in-dim.torchscript ${{ matrix.platform.folder }}

# ============================================
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
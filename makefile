.PHONY: config build run

# Requirements:
# sudo apt install libopencv-dev

config:
	cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Release

build:
	cmake --build build --config Release -j2

dconfig:
	cmake -S . -B build -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DBUILD_SHARED_LIBS=FALSE -DCMAKE_BUILD_TYPE=Debug

dbuild:
	cmake --build build --config Debug -j2

run:
	./build/bin/test

clean:
	rm -rf bb*.jpg *.pt *.torchscript runs exp10-new datasets

test:
	./build/bin/draw_bounding_box 0.02 0.75 yolo11n-96-in-dim.torchscript 96 shibuya.jpg bb-shibuya-96.jpg
	./build/bin/draw_bounding_box 0.5  0.5  yolo11n-96-in-dim.torchscript 96 office.jpg bb-office-96.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n-96-in-dim.torchscript 96 bus.jpg bb-bus-96.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n-96-in-dim.torchscript 96 crossing.jpg bb-crossing-96.jpg

	./build/bin/draw_bounding_box 0.02 0.75 yolo11n-160-in-dim.torchscript 160 shibuya.jpg bb-shibuya-160.jpg
	./build/bin/draw_bounding_box 0.5  0.5  yolo11n-160-in-dim.torchscript 160 office.jpg bb-girl-160.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n-160-in-dim.torchscript 160 bus.jpg bb-bus-160.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n-160-in-dim.torchscript 160 crossing.jpg bb-crossing-160.jpg

	./build/bin/draw_bounding_box 0.02 0.75 yolo11n-320-in-dim.torchscript 320 shibuya.jpg bb-shibuya-320.jpg
	./build/bin/draw_bounding_box 0.5  0.5  yolo11n-320-in-dim.torchscript 320 office.jpg bb-girl-320.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n-320-in-dim.torchscript 320 bus.jpg bb-bus-320.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n-320-in-dim.torchscript 320 crossing.jpg bb-crossing-320.jpg

	./build/bin/draw_bounding_box 0.02 0.75 yolo11n.torchscript 640 shibuya.jpg bb-shibuya-640.jpg
	./build/bin/draw_bounding_box 0.5  0.5  yolo11n.torchscript 640 office.jpg bb-girl-640.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n.torchscript 640 bus.jpg bb-bus-640.jpg
	./build/bin/draw_bounding_box 0.5  0.3  yolo11n.torchscript 640 crossing.jpg bb-crossing-640.jpg

test-best:
	./build/bin/draw_bounding_box 0.02 0.75 runs/detect/train/weights/best.torchscript 96 shibuya.jpg bb-shibuya-96.jpg
	./build/bin/draw_bounding_box 0.5  0.5  runs/detect/train/weights/best.torchscript 96 office.jpg bb-office-96.jpg
	./build/bin/draw_bounding_box 0.5  0.3  runs/detect/train/weights/best.torchscript 96 bus.jpg bb-bus-96.jpg
	./build/bin/draw_bounding_box 0.5  0.3  runs/detect/train/weights/best.torchscript 96 crossing.jpg bb-crossing-96.jpg

	./build/bin/draw_bounding_box 0.02 0.75 runs/detect/train2/weights/best.torchscript 160 shibuya.jpg bb-shibuya-160.jpg
	./build/bin/draw_bounding_box 0.5  0.5  runs/detect/train2/weights/best.torchscript 160 office.jpg bb-girl-160.jpg
	./build/bin/draw_bounding_box 0.5  0.3  runs/detect/train2/weights/best.torchscript 160 bus.jpg bb-bus-160.jpg
	./build/bin/draw_bounding_box 0.5  0.3  runs/detect/train2/weights/best.torchscript 160 crossing.jpg bb-crossing-160.jpg

	./build/bin/draw_bounding_box 0.02 0.75 runs/detect/train3/weights/best.torchscript 320 shibuya.jpg bb-shibuya-320.jpg
	./build/bin/draw_bounding_box 0.5  0.5  runs/detect/train3/weights/best.torchscript 320 office.jpg bb-girl-320.jpg
	./build/bin/draw_bounding_box 0.5  0.3  runs/detect/train3/weights/best.torchscript 320 bus.jpg bb-bus-320.jpg
	./build/bin/draw_bounding_box 0.5  0.3  runs/detect/train3/weights/best.torchscript 320 crossing.jpg bb-crossing-320.jpg


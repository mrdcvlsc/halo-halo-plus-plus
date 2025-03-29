#include <array>
#include <iostream>

#include <opencv2/videoio.hpp>
#include <stdexcept>
#include <memory>

#include "get_cameras.hpp"

// Camera Resolutions x W x H - sorted by highest to lowest.
const std::array<std::array<int, 2>, 7> StandardCameraResolutions{{
    {4000, 3000},
    {3840, 2160},
    {1920, 1080},
    {1280, 1024},
    {1280, 960},
    {1280, 720},
    {720, 480}
}};

std::vector<Camera> get_available_cameras(int max_cam_to_check)
{
    std::vector<Camera> available_cameras;

    for (int i = 0; i < max_cam_to_check; ++i) {
        cv::VideoCapture cap(i);
        if (cap.isOpened()) {
            cv::Mat frame;

            for (const auto &resolution: StandardCameraResolutions) {
                bool is_supported_width = cap.set(cv::CAP_PROP_FRAME_WIDTH, static_cast<double>(resolution[0]));
                bool is_supported_height = cap.set(cv::CAP_PROP_FRAME_HEIGHT, static_cast<double>(resolution[1]));

                if (is_supported_width && is_supported_height) {
                    break;
                }
            }

            cap >> frame;

            if (frame.empty()) {
                throw std::length_error("frame captured was empty");
            }

            if (frame.size.dims() != 2) {
                throw std::length_error("detected camera frame dimension is not equal to 2");
            }

            available_cameras.push_back({
              /*camera_index : */ i,
              /*channels     : */ frame.channels(),
              /*width        : */ frame.size.p[1],
              /*height       : */ frame.size.p[0],
            });

            std::cout << "Camera[" << i << "] : ch(" << frame.channels()
                      << ")"
                         ", dim("
                      << frame.size.p[1] << 'x' << frame.size.p[0] << ")\n";

            cap.release();
        }
    }

    return available_cameras;
}

std::unique_ptr<Camera> get_highest_resolution_cam(const std::vector<Camera> &cameras)
{
    int                     max_pixels = 0;
    std::unique_ptr<Camera> highest_resolution_camera;

    for (auto &camera: cameras) {
        int pixels = camera.height * camera.width;
        if (pixels > max_pixels) {
            max_pixels = pixels;
            highest_resolution_camera = std::make_unique<Camera>(camera);
        }
    }

    return std::move(highest_resolution_camera);
}
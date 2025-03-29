#ifndef MRDCVLSC_OPENCV_CMAKE_TEMPLATE_BENCHMARK_HPP
#define MRDCVLSC_OPENCV_CMAKE_TEMPLATE_BENCHMARK_HPP

#include <chrono>
#include <string_view>

namespace chrono = std::chrono;

struct Benchmark {
    chrono::time_point<chrono::system_clock, chrono::nanoseconds> start;
    chrono::time_point<chrono::system_clock, chrono::nanoseconds> end;

    void new_start();
    void done();
    void print_result_nanoseconds(std::string_view);

    void done_with_print_ns(std::string_view);
};

#endif
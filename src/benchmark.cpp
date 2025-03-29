#include "benchmark.hpp"
#include <iostream>
#include <string_view>

void Benchmark::new_start()
{
    start = std::chrono::system_clock::now();
}

void Benchmark::done()
{
    end = std::chrono::system_clock::now();
}

void Benchmark::print_result_nanoseconds(std::string_view leading_output)
{
    auto dur = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start);
    std::cout << leading_output << (end - start).count() << "ns\n";
}

void Benchmark::done_with_print_ns(std::string_view leading_output) {
    done();
    print_result_nanoseconds(leading_output);
}
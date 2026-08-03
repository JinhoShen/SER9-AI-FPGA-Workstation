#include <hip/hip_runtime.h>

#include <cstdlib>
#include <iostream>

#define HIP_CHECK(call)                                                     \
    do {                                                                    \
        hipError_t error = (call);                                          \
        if (error != hipSuccess) {                                          \
            std::cerr << "HIP error: " << hipGetErrorString(error)          \
                      << " at " << __FILE__ << ":" << __LINE__ << '\n';     \
            std::exit(EXIT_FAILURE);                                        \
        }                                                                   \
    } while (0)

int main()
{
    int device_count = 0;
    HIP_CHECK(hipGetDeviceCount(&device_count));

    if (device_count < 1) {
        std::cerr << "No HIP devices detected\n";
        return EXIT_FAILURE;
    }

    std::cout << "HIP device count: " << device_count << '\n';

    for (int device = 0; device < device_count; ++device) {
        hipDeviceProp_t properties{};
        HIP_CHECK(hipGetDeviceProperties(&properties, device));

        std::cout << "Device " << device << '\n';
        std::cout << "  Name: " << properties.name << '\n';
        std::cout << "  Architecture: " << properties.gcnArchName << '\n';
        std::cout << "  Compute units: "
                  << properties.multiProcessorCount << '\n';
        std::cout << "  Global memory: "
                  << properties.totalGlobalMem << " bytes\n";
    }

    std::cout << "HIP device query: PASS\n";
    return EXIT_SUCCESS;
}

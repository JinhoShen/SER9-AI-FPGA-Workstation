#include <hip/hip_runtime.h>

#include <cmath>
#include <cstdlib>
#include <iostream>
#include <vector>

#define HIP_CHECK(call)                                                     \
    do {                                                                    \
        hipError_t error = (call);                                          \
        if (error != hipSuccess) {                                          \
            std::cerr << "HIP error: " << hipGetErrorString(error)          \
                      << " at " << __FILE__ << ":" << __LINE__ << '\n';     \
            std::exit(EXIT_FAILURE);                                        \
        }                                                                   \
    } while (0)

__global__ void vector_add(
    const float* input_a,
    const float* input_b,
    float* output,
    std::size_t count)
{
    const std::size_t index =
        blockIdx.x * blockDim.x + threadIdx.x;

    if (index < count) {
        output[index] = input_a[index] + input_b[index];
    }
}

int main()
{
    constexpr std::size_t element_count = 1 << 20;
    constexpr float tolerance = 1.0e-5F;
    const std::size_t bytes = element_count * sizeof(float);

    std::vector<float> host_a(element_count);
    std::vector<float> host_b(element_count);
    std::vector<float> host_output(element_count);

    for (std::size_t index = 0; index < element_count; ++index) {
        host_a[index] = static_cast<float>(index) * 0.5F;
        host_b[index] = static_cast<float>(index) * 0.25F;
    }

    float* device_a = nullptr;
    float* device_b = nullptr;
    float* device_output = nullptr;

    HIP_CHECK(hipMalloc(&device_a, bytes));
    HIP_CHECK(hipMalloc(&device_b, bytes));
    HIP_CHECK(hipMalloc(&device_output, bytes));

    HIP_CHECK(hipMemcpy(
        device_a,
        host_a.data(),
        bytes,
        hipMemcpyHostToDevice));

    HIP_CHECK(hipMemcpy(
        device_b,
        host_b.data(),
        bytes,
        hipMemcpyHostToDevice));

    constexpr int threads_per_block = 256;
    const int block_count = static_cast<int>(
        (element_count + threads_per_block - 1) /
        threads_per_block);

    hipLaunchKernelGGL(
        vector_add,
        dim3(block_count),
        dim3(threads_per_block),
        0,
        0,
        device_a,
        device_b,
        device_output,
        element_count);

    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    HIP_CHECK(hipMemcpy(
        host_output.data(),
        device_output,
        bytes,
        hipMemcpyDeviceToHost));

    std::size_t errors = 0;

    for (std::size_t index = 0; index < element_count; ++index) {
        const float expected = host_a[index] + host_b[index];

        if (std::fabs(host_output[index] - expected) > tolerance) {
            ++errors;

            if (errors <= 5) {
                std::cerr << "Mismatch at " << index
                          << ": expected " << expected
                          << ", received " << host_output[index]
                          << '\n';
            }
        }
    }

    HIP_CHECK(hipFree(device_a));
    HIP_CHECK(hipFree(device_b));
    HIP_CHECK(hipFree(device_output));

    if (errors != 0) {
        std::cerr << "HIP vector addition: FAIL"
                  << " (" << errors << " errors)\n";
        return EXIT_FAILURE;
    }

    std::cout << "Elements processed: " << element_count << '\n';
    std::cout << "HIP vector addition: PASS\n";
    return EXIT_SUCCESS;
}

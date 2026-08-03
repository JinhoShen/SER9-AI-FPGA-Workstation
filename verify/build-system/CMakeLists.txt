cmake_minimum_required(VERSION 3.20)

project(
    SER9BuildSystemVerification
    VERSION 1.0
    LANGUAGES C CXX
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(hello_c src/hello.c)
add_executable(hello_cpp src/hello.cpp)

if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(hello_c PRIVATE -Wall -Wextra -Werror)
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(hello_cpp PRIVATE -Wall -Wextra -Werror)
endif()

enable_testing()

add_test(
    NAME verify_c
    COMMAND hello_c
)

set_tests_properties(
    verify_c
    PROPERTIES
    PASS_REGULAR_EXPRESSION "C build verification: PASS"
)

add_test(
    NAME verify_cpp
    COMMAND hello_cpp
)

set_tests_properties(
    verify_cpp
    PROPERTIES
    PASS_REGULAR_EXPRESSION "C\\+\\+ build verification: PASS"
)

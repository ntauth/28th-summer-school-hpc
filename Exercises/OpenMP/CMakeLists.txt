cmake_minimum_required(VERSION 3.14)
project(OpenMP C)

set(CMAKE_C_STANDARD 99)

include(FindOpenMP REQUIRED)

if (OPENMP_FOUND)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()

include_directories(include)

add_executable(omp-hello-world src/omp-hello-world.c)
add_executable(omp-dgemm src/omp-dgemm.c)
add_executable(omp-integral-pi src/omp-integral-pi.c)
add_executable(omp-laplace src/omp-laplace.c)
add_executable(omp-nbody src/omp-nbody.c)

target_link_libraries(omp-laplace -lm)
target_link_libraries(omp-nbody -lm)
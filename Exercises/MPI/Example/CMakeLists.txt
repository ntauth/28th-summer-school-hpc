cmake_minimum_required(VERSION 3.14)
project(open-mpi-example C)

set(CMAKE_C_STANDARD 99)

add_executable(open-mpi-example main.c)

# OpenMPI
find_package(MPI REQUIRED)

target_include_directories(open-mpi-example SYSTEM PUBLIC ${MPI_C_INCLUDE_DIRECTORIES})
target_link_libraries(open-mpi-example ${MPI_C_LINK_LIBRARIES})
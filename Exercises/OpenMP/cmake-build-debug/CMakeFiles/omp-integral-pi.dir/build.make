# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/ntauthority/Programs/CLion-2019.1.4/clion-2019.1.4/bin/cmake/linux/bin/cmake

# The command to remove a file.
RM = /home/ntauthority/Programs/CLion-2019.1.4/clion-2019.1.4/bin/cmake/linux/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/omp-integral-pi.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/omp-integral-pi.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/omp-integral-pi.dir/flags.make

CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.o: CMakeFiles/omp-integral-pi.dir/flags.make
CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.o: ../src/omp-integral-pi.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.o   -c /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/src/omp-integral-pi.c

CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/src/omp-integral-pi.c > CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.i

CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/src/omp-integral-pi.c -o CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.s

# Object files for target omp-integral-pi
omp__integral__pi_OBJECTS = \
"CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.o"

# External object files for target omp-integral-pi
omp__integral__pi_EXTERNAL_OBJECTS =

omp-integral-pi: CMakeFiles/omp-integral-pi.dir/src/omp-integral-pi.c.o
omp-integral-pi: CMakeFiles/omp-integral-pi.dir/build.make
omp-integral-pi: CMakeFiles/omp-integral-pi.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable omp-integral-pi"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/omp-integral-pi.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/omp-integral-pi.dir/build: omp-integral-pi

.PHONY : CMakeFiles/omp-integral-pi.dir/build

CMakeFiles/omp-integral-pi.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/omp-integral-pi.dir/cmake_clean.cmake
.PHONY : CMakeFiles/omp-integral-pi.dir/clean

CMakeFiles/omp-integral-pi.dir/depend:
	cd /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/cmake-build-debug /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/cmake-build-debug /home/ntauthority/Desktop/28th-summer-school-hpc/Exercises/OpenMP/cmake-build-debug/CMakeFiles/omp-integral-pi.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/omp-integral-pi.dir/depend

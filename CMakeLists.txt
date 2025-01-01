cmake_minimum_required(VERSION 3.15)
project(my_project VERSION 1.0)

# C++ standard requirements
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Find dependencies
find_package(fmt REQUIRED)

# Add executable
add_executable(${PROJECT_NAME} 
    src/main.cpp
)

# Link libraries
target_link_libraries(${PROJECT_NAME} 
    PRIVATE fmt::fmt
) 
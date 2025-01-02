cmake_minimum_required(VERSION 3.15)
project(my_project VERSION 1.0)

# C++ standard requirements
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable threading support
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Find Boost with required components
find_package(Boost REQUIRED COMPONENTS system)

# Add executable
add_executable(${PROJECT_NAME} 
    src/main.cpp
)

# Link libraries
target_link_libraries(${PROJECT_NAME} 
    PRIVATE 
    Boost::system
    Boost::headers
    Threads::Threads
) 
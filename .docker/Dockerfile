# Build stage
FROM --platform=linux/arm64 public.ecr.aws/amazonlinux/amazonlinux:2 AS builder

# Install build dependencies
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
    cmake3 \
    python3 \
    python3-pip \
    git \
    file \
    && alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
    && alternatives --install /usr/local/bin/ctest ctest /usr/bin/ctest3 20 \
    && alternatives --install /usr/local/bin/cpack cpack /usr/bin/cpack3 20

# Install conan
RUN pip3 install conan==2.0.17

# Create app directory
WORKDIR /app

# Copy source files
COPY . .

# Create a custom conan profile for Amazon Linux 2
RUN conan profile detect --force && \
    echo "[settings]" > custom_profile && \
    echo "arch=armv8" >> custom_profile && \
    echo "build_type=Release" >> custom_profile && \
    echo "compiler=gcc" >> custom_profile && \
    echo "compiler.cppstd=gnu17" >> custom_profile && \
    echo "compiler.libcxx=libstdc++11" >> custom_profile && \
    echo "compiler.version=7" >> custom_profile && \
    echo "os=Linux" >> custom_profile

# Build with debug output
RUN set -x && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    conan install .. --build=missing -pr ../custom_profile && \
    cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake \
            -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . && \
    echo "Binary details:" && \
    file bin/my_project && \
    ldd bin/my_project || true

# Runtime stage
FROM --platform=linux/arm64 public.ecr.aws/amazonlinux/amazonlinux:2

# Install runtime dependencies
RUN yum update -y && \
    yum install -y \
    libstdc++ \
    glibc \
    file \
    && yum clean all

WORKDIR /app
COPY --from=builder /app/build/bin/my_project .

# Debug information
RUN set -x && \
    echo "System architecture:" && \
    uname -a && \
    echo "Binary details:" && \
    file my_project && \
    ldd my_project || true

# Expose the web server port
EXPOSE 8080

# Run with unbuffered output
ENV PYTHONUNBUFFERED=1
ENV BOOST_ASIO_DISABLE_BUFFER_DEBUGGING=1

ENTRYPOINT ["./my_project"] 
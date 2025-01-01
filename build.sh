#!/bin/sh

# Clean build directory
rm -rf build
mkdir -p build
cd build

# Setup conan profile
conan profile detect --force

# Continue with build
conan install .. --output-folder=. --build=missing
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build .

# Generate minimal Dockerfile in build directory
cat > Dockerfile << 'EOF'
FROM alpine:3.18

# Install only runtime dependencies
RUN apk add --no-cache \
    libstdc++ \
    libgcc

WORKDIR /app
COPY bin/my_project .

ENTRYPOINT ["./my_project"]
EOF

# Create .dockerignore to exclude everything except the binary
cat > .dockerignore << 'EOF'
*
!bin/my_project
EOF

# Optional: Build the minimal container
echo "Building minimal container..."
docker build -t my_project:minimal . 
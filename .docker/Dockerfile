# Build stage
FROM alpine:3.18 AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    cmake \
    python3 \
    py3-pip \
    git

# Install conan
RUN pip3 install conan==2.0.17

# Create app directory
WORKDIR /app

# Copy project files (now from parent directory)
COPY .. .

# Build the application
RUN chmod +x build.sh && ./build.sh

# Runtime stage
FROM alpine:3.18

# Install only runtime dependencies
RUN apk add --no-cache \
    libstdc++ \
    libgcc

# Copy the built executable from the new location
COPY --from=builder /app/build/bin/my_project /app/my_project

# Set the entrypoint
ENTRYPOINT ["/app/my_project"] 
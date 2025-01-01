FROM alpine:3.18

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

# Copy project files
COPY . .

# Build commands will be run when container starts
CMD ["sh", "./build.sh"] 
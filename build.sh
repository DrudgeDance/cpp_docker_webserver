#!/bin/sh

echo "Building using Docker..."

# Enable debug output
set -x

# Clean up any existing containers
docker compose -f .docker/docker-compose.yml down

# Create buildx instance if it doesn't exist
docker buildx create --name multiarch --driver docker-container --use || true
docker buildx inspect --bootstrap

# Build with debug output
DOCKER_BUILDKIT=1 BUILDKIT_PROGRESS=plain docker compose -f .docker/docker-compose.yml build --no-cache

# Show container and binary information
docker compose -f .docker/docker-compose.yml run --rm cpp_app /bin/sh -c '
    echo "=== System Information ==="
    uname -a
    echo
    echo "=== Binary Information ==="
    file my_project
    readelf -h my_project
' 
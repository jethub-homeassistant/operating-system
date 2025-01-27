#!/bin/sh
set -e

channel=$1

APPARMOR_URL="https://haversion.jethome.ru/apparmor.txt"

# Make sure we can talk to the Docker daemon
echo "Waiting for Docker daemon..."
while ! docker version 2> /dev/null > /dev/null; do
	sleep 1
done

# Install Supervisor, plug-ins and landing page
echo "Loading container images..."

# Make sure to order images by size (largest first)
# It seems docker load requires space during operation
# shellcheck disable=SC2045
for image in $(ls -S /build/images/*.tar); do
	docker load --input "${image}"
done

# Tag the Supervisor how the OS expects it to be tagged
supervisor=$(docker images --filter "label=io.jh.type=supervisor" --quiet)
arch=$(docker inspect --format '{{ index .Config.Labels "io.jh.arch" }}' "${supervisor}")
docker tag "${supervisor}" "ghcr.io/jethub-homeassistant/${arch}-jhio-supervisor:latest"

# Setup AppArmor
mkdir -p "/data/supervisor/apparmor"
wget -O "/data/supervisor/apparmor/jhio-supervisor" "${APPARMOR_URL}"

echo "{ \"channel\": \"${channel}\" }" > /data/supervisor/updater.json

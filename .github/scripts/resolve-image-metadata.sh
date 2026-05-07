#!/usr/bin/env bash
set -euo pipefail

version="${1:-}"
image="${2:-ghcr.io/hem-labs/hex-librarium-syncthing}"

if [ -z "$version" ]; then
  echo "Usage: resolve-image-metadata.sh VERSION [IMAGE]"
  exit 1
fi

release_sha="$(git rev-parse --short HEAD)"
release_revision="$(git rev-parse HEAD)"

{
  echo "version=${version}"
  echo "tags<<EOF"
  echo "${image}:${version}"
  if [[ "$version" != *-* ]]; then
    echo "${image}:${version%.*}"
    echo "${image}:latest"
  fi
  echo "${image}:sha-${release_sha}"
  echo "EOF"
  echo "labels<<EOF"
  echo "org.opencontainers.image.source=${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
  echo "org.opencontainers.image.revision=${release_revision}"
  echo "org.opencontainers.image.version=${version}"
  echo "EOF"
} >> "$GITHUB_OUTPUT"

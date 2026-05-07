#!/usr/bin/env bash
set -euo pipefail

version="${1:-}"

if [ -z "$version" ]; then
  echo "Usage: validate-release.sh VERSION"
  exit 1
fi

if [ "${GITHUB_REF_NAME:-}" != "master" ]; then
  echo "Releases must be dispatched from master."
  exit 1
fi

if git rev-parse -q --verify "refs/tags/v${version}" >/dev/null; then
  echo "Tag v${version} already exists."
  exit 1
fi

if ! [[ "$version" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?$ ]]; then
  echo "Version must be a valid Semantic Version without build metadata."
  exit 1
fi

if ! grep -F "## [${version}]" CHANGELOG.md >/dev/null; then
  echo "CHANGELOG.md must include a ## [${version}] release entry."
  exit 1
fi

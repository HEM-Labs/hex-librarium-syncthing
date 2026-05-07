#!/usr/bin/env bash
set -euo pipefail

version="${1:-}"

if [ -z "$version" ]; then
  echo "Usage: create-release.sh VERSION"
  exit 1
fi

printf '%s\n' "$version" > VERSION

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add VERSION
git diff --cached --quiet || git commit -m "Release ${version}"
git tag "v${version}"

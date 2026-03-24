#!/bin/bash

set -e

LDFLAGS="-X github.com/mineclover/images/cmd.buildStamp=$(date -u '+%Y-%m-%d_%I:%M:%S%p') -X github.com/mineclover/images/cmd.gitRevision=$(git describe --tags 2>/dev/null || git rev-parse HEAD) -s -w"

# Native build for current platform
CGO_ENABLED=0 go build -ldflags "$LDFLAGS"

# Cross-compile for release platforms
platforms=(
  "linux/amd64"
  "darwin/amd64"
  "windows/amd64"
  "windows/386"
)

for platform in "${platforms[@]}"; do
  IFS='/' read -r os arch <<< "$platform"
  output="dist/images_${os}_${arch}"
  echo "Building ${output}..."
  CGO_ENABLED=0 GOOS="$os" GOARCH="$arch" go build -ldflags "$LDFLAGS" -o "$output" .
done

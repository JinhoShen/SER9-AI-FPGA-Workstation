#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(mktemp -d)"

cleanup()
{
    rm -rf "$BUILD_DIR"
}

trap cleanup EXIT

echo "[M2-02] Build system verification"
echo "[M2-02] Generator: Ninja"

cmake \
    -S "$PROJECT_DIR" \
    -B "$BUILD_DIR" \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release

cmake --build "$BUILD_DIR"

ctest \
    --test-dir "$BUILD_DIR" \
    --output-on-failure

echo "[M2-02] Clean rebuild verification"

cmake --build "$BUILD_DIR" --target clean
cmake --build "$BUILD_DIR"

ctest \
    --test-dir "$BUILD_DIR" \
    --output-on-failure

echo "[M2-02] Build system verification: PASS"

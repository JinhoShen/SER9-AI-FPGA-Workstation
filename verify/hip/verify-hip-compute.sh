#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(mktemp -d)"

cleanup()
{
    rm -rf "$BUILD_DIR"
}

trap cleanup EXIT

export PATH="/opt/rocm/bin:$PATH"

echo "===== M2-06 HIP COMPUTE VERIFICATION ====="
echo "Timestamp: $(date --iso-8601=seconds)"
echo

echo "===== HIP COMPILER ====="
hipcc --version
echo

echo "===== COMPILE DEVICE QUERY ====="
hipcc \
    -O2 \
    -Wall \
    -Wextra \
    "$PROJECT_DIR/src/device_query.cpp" \
    -o "$BUILD_DIR/device_query"

echo "Device query compilation: PASS"
echo

echo "===== RUN DEVICE QUERY ====="
"$BUILD_DIR/device_query"
echo

echo "===== COMPILE VECTOR ADD ====="
hipcc \
    -O2 \
    -Wall \
    -Wextra \
    "$PROJECT_DIR/src/vector_add.cpp" \
    -o "$BUILD_DIR/vector_add"

echo "Vector addition compilation: PASS"
echo

echo "===== RUN VECTOR ADD ====="
"$BUILD_DIR/vector_add"
echo

echo "===== ARCHITECTURE CHECK ====="
ROCMINFO_OUTPUT="$BUILD_DIR/rocminfo.txt"
rocminfo >"$ROCMINFO_OUTPUT" 2>&1 || true

if grep -q 'gfx1150' "$ROCMINFO_OUTPUT"; then
    echo "gfx1150 execution target: PASS"
else
    echo "gfx1150 execution target: FAIL"
    exit 1
fi

echo
echo "[M2-06] HIP compute verification: PASS"

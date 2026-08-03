#!/usr/bin/env bash
set -euo pipefail

status=0

echo "===== M2-05 ROCm VERIFICATION ====="
echo "Timestamp: $(date --iso-8601=seconds)"
echo "Kernel: $(uname -r)"
echo

echo "===== USER GROUPS ====="
id
echo

for group in render video; do
    if id -nG | tr ' ' '\n' | grep -qx "$group"; then
        echo "$group group active: PASS"
    else
        echo "$group group active: REBOOT REQUIRED"
        status=2
    fi
done

echo
echo "===== ROCm TOOLS ====="

for tool in rocminfo rocm-smi hipcc; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "$tool: PASS ($(command -v "$tool"))"
    elif [[ -x "/opt/rocm/bin/$tool" ]]; then
        echo "$tool: PASS (/opt/rocm/bin/$tool)"
    else
        echo "$tool: FAIL"
        status=1
    fi
done

export PATH="/opt/rocm/bin:$PATH"

echo
echo "===== HIP VERSION ====="
if command -v hipcc >/dev/null 2>&1; then
    hipcc --version || status=1
fi

echo
echo "===== ROCm AGENTS ====="
ROCMINFO_OUTPUT="$(mktemp)"
trap 'rm -f "$ROCMINFO_OUTPUT"' EXIT

if command -v rocminfo >/dev/null 2>&1; then
    rocminfo >"$ROCMINFO_OUTPUT" 2>&1 || true
    cat "$ROCMINFO_OUTPUT"
fi

echo
echo "===== gfx1150 CHECK ====="
if grep -q 'gfx1150' "$ROCMINFO_OUTPUT"; then
    echo "gfx1150 ROCm agent: PASS"
else
    echo "gfx1150 ROCm agent: FAIL"
    status=1
fi

echo
echo "===== PACKAGE RECORD ====="
dpkg-query -W -f='${binary:Package}\t${Version}\n' \
    2>/dev/null |
    grep -E '^(rocm|hip|hsa|amd-smi|amdgpu-install)' |
    sort || true

echo
echo "===== FINAL RESULT ====="

case "$status" in
    0)
        echo "[M2-05] ROCm installation: PASS"
        ;;
    2)
        echo "[M2-05] ROCm installation: REBOOT REQUIRED"
        ;;
    *)
        echo "[M2-05] ROCm installation: FAIL"
        ;;
esac

exit "$status"

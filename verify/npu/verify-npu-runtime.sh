#!/usr/bin/env bash
set -euo pipefail

status=0

echo "===== M3-01 NPU RUNTIME DETECTION ====="
echo "Timestamp: $(date --iso-8601=seconds)"
echo "Kernel: $(uname -r)"
echo

echo "===== KERNEL MODULE ====="

if [[ -d /sys/module/amdxdna ]] || lsmod | grep -q '^amdxdna'; then
    echo "amdxdna kernel module: PASS"
else
    echo "amdxdna kernel module: FAIL"
    status=1
fi

echo
echo "===== DEVICE NODE ====="

if [[ -e /dev/accel/accel0 ]]; then
    ls -l /dev/accel/accel0
    echo "/dev/accel/accel0: PASS"
elif [[ -e /dev/accel0 ]]; then
    ls -l /dev/accel0
    echo "/dev/accel0: PASS"
else
    echo "NPU accelerator node: FAIL"
    status=1
fi

echo
echo "===== DEVICE CLASS ====="

if [[ -d /sys/class/accel ]]; then
    find /sys/class/accel -maxdepth 2 -type l -o -type f 2>/dev/null | sort
    echo "sysfs accelerator class: PASS"
else
    echo "sysfs accelerator class: WARN"
fi

echo
echo "===== NPU PCI DEVICE ====="

lspci -nnk | grep -A4 -B2 -Ei 'Signal processing|Co-processor|XDNA|NPU' || true

echo
echo "===== FIRMWARE ====="

if [[ -d /lib/firmware/amdnpu ]]; then
    find /lib/firmware/amdnpu \
        -maxdepth 3 \
        -type f \
        -printf '%p\n' |
        sort

    if find /lib/firmware/amdnpu -type f | grep -q '17f0'; then
        echo "Strix NPU firmware: PASS"
    else
        echo "Strix NPU firmware: WARN"
    fi
else
    echo "AMD NPU firmware directory: FAIL"
    status=1
fi

echo
echo "===== ROCm AGENT VISIBILITY ====="

ROCMINFO_OUTPUT="$(mktemp)"
trap 'rm -f "$ROCMINFO_OUTPUT"' EXIT

if command -v rocminfo >/dev/null 2>&1; then
    rocminfo >"$ROCMINFO_OUTPUT" 2>&1 || true

    grep -E \
        'Name:|Marketing Name:|Vendor Name:' \
        "$ROCMINFO_OUTPUT" |
        grep -A2 -B2 -E 'aie2p|RyzenAI-npu4' || true

    if grep -q 'aie2p' "$ROCMINFO_OUTPUT"; then
        echo "aie2p NPU agent: PASS"
    else
        echo "aie2p NPU agent: WARN"
    fi
else
    echo "rocminfo: unavailable"
fi

echo
echo "===== DRIVER MESSAGES ====="

dmesg 2>/dev/null |
    grep -Ei 'amdxdna|xdna|npu|aie' |
    tail -n 80 ||
    echo "Kernel messages unavailable without elevated permissions"

echo
echo "===== FINAL RESULT ====="

if [[ "$status" -eq 0 ]]; then
    echo "[M3-01] NPU runtime detection: PASS"
else
    echo "[M3-01] NPU runtime detection: FAIL"
fi

exit "$status"

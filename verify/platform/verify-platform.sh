#!/usr/bin/env bash
set -euo pipefail

echo "===== M2-03 PLATFORM DETECTION ====="
echo "Timestamp: $(date --iso-8601=seconds)"
echo

echo "===== SYSTEM ====="
hostnamectl
uname -a
echo

echo "===== CPU ====="
lscpu
echo

echo "===== AMD PCI DEVICES ====="
lspci -nnk | grep -A4 -B2 -Ei \
    'AMD|ATI|VGA|Display|Audio|Encryption|Signal processing|Co-processor' \
    || true
echo

echo "===== GPU DEVICE NODES ====="
if [[ -d /dev/dri ]]; then
    ls -la /dev/dri
else
    echo "/dev/dri: NOT FOUND"
fi
echo

echo "===== NPU DEVICE NODES ====="
if [[ -e /dev/accel0 ]]; then
    ls -la /dev/accel0
    echo "/dev/accel0: PASS"
elif [[ -e /dev/accel/accel0 ]]; then
    ls -la /dev/accel/accel0
    echo "/dev/accel/accel0: PASS"
else
    echo "NPU accelerator node: NOT FOUND"
fi

if [[ -d /dev/accel ]]; then
    ls -la /dev/accel
fi
echo

echo "===== KERNEL MODULES ====="
lsmod | grep -Ei 'amdgpu|amdxdna|xrt' || true
echo

echo "===== GPU DRIVER ====="
if command -v glxinfo >/dev/null 2>&1; then
    glxinfo -B || true
else
    echo "glxinfo: not installed"
fi
echo

echo "===== VULKAN ====="
if command -v vulkaninfo >/dev/null 2>&1; then
    vulkaninfo --summary || true
else
    echo "vulkaninfo: not installed"
fi
echo

echo "===== OPENCL ====="
if command -v clinfo >/dev/null 2>&1; then
    clinfo || true
else
    echo "clinfo: not installed"
fi
echo

echo "===== ROCm COMMANDS ====="
for tool in rocminfo rocm-smi hipcc; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "$tool: FOUND ($(command -v "$tool"))"
    else
        echo "$tool: NOT INSTALLED"
    fi
done
echo

echo "===== NPU FIRMWARE ====="
if [[ -d /lib/firmware/amdnpu ]]; then
    find /lib/firmware/amdnpu -maxdepth 3 -type f -printf '%p\n' | sort
else
    echo "/lib/firmware/amdnpu: NOT FOUND"
fi
echo

echo "===== IOMMU ====="
dmesg 2>/dev/null | grep -Ei 'iommu|amd-vi' | tail -n 30 || \
    echo "IOMMU information unavailable without elevated permissions"
echo

echo "===== BASIC RESULT ====="

status=0

if [[ -e /dev/dri/renderD128 ]]; then
    echo "GPU render node: PASS"
else
    echo "GPU render node: FAIL"
    status=1
fi

if lspci | grep -Eqi 'VGA|Display'; then
    echo "Display controller detection: PASS"
else
    echo "Display controller detection: FAIL"
    status=1
fi

if [[ -e /dev/accel0 || -e /dev/accel/accel0 ]]; then
    echo "NPU accelerator node: PASS"
else
    echo "NPU accelerator node: WARN"
fi

if [[ -d /sys/module/amdgpu ]] || lspci -nnk | grep -A3 -Ei 'VGA|Display' | grep -q 'Kernel driver in use: amdgpu'; then
    echo "amdgpu driver: PASS"
else
    echo "amdgpu driver: FAIL"
    status=1
fi

if lsmod | grep -q '^amdxdna'; then
    echo "amdxdna kernel module: PASS"
else
    echo "amdxdna kernel module: WARN"
fi

if [[ "$status" -eq 0 ]]; then
    echo "[M2-03] Platform detection: PASS"
else
    echo "[M2-03] Platform detection: FAIL"
fi

exit "$status"

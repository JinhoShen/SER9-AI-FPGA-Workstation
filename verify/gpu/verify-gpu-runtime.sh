#!/usr/bin/env bash
set -euo pipefail

status=0

echo "===== M2-04 GPU RUNTIME FOUNDATION ====="
echo "Timestamp: $(date --iso-8601=seconds)"
echo

echo "===== DEVICE NODES ====="

if [[ -e /dev/dri/renderD128 ]]; then
    ls -l /dev/dri/renderD128
    echo "GPU render node: PASS"
else
    echo "GPU render node: FAIL"
    status=1
fi

echo
echo "===== PCI DRIVER ====="

lspci -nnk | grep -A4 -B2 -Ei 'VGA|Display' || true

if [[ -d /sys/module/amdgpu ]] || \
   lspci -nnk | grep -A4 -Ei 'VGA|Display' | grep -q 'Kernel driver in use: amdgpu'; then
    echo "amdgpu driver: PASS"
else
    echo "amdgpu driver: FAIL"
    status=1
fi

echo
echo "===== OPENGL ====="

if command -v glxinfo >/dev/null 2>&1; then
    glxinfo -B || true

    if glxinfo -B 2>/dev/null | grep -Eqi \
        'OpenGL renderer.*(AMD|Radeon|gfx1150)'; then
        echo "OpenGL renderer: PASS"
    else
        echo "OpenGL renderer: WARN"
    fi
else
    echo "glxinfo: FAIL"
    status=1
fi

echo
echo "===== VULKAN ====="

if command -v vulkaninfo >/dev/null 2>&1; then
    vulkaninfo --summary || true

    if vulkaninfo --summary 2>/dev/null | grep -Eqi \
        'deviceName.*(AMD|Radeon|RADV|gfx1150)'; then
        echo "Vulkan AMD device: PASS"
    else
        echo "Vulkan AMD device: FAIL"
        status=1
    fi
else
    echo "vulkaninfo: FAIL"
    status=1
fi

echo
echo "===== VULKAN ICD ====="

if find /usr/share/vulkan/icd.d \
    -maxdepth 1 -type f \
    \( -iname '*radeon*' -o -iname '*amd*' \) \
    -print -quit 2>/dev/null | grep -q .; then
    find /usr/share/vulkan/icd.d \
        -maxdepth 1 -type f \
        \( -iname '*radeon*' -o -iname '*amd*' \) \
        -print
    echo "AMD Vulkan ICD: PASS"
else
    echo "AMD Vulkan ICD: FAIL"
    status=1
fi

echo
echo "===== OPENCL ====="

if command -v clinfo >/dev/null 2>&1; then
    clinfo || true

    platform_count="$(
        clinfo 2>/dev/null |
        awk -F: '/Number of platforms/ {
            gsub(/[[:space:]]/, "", $2)
            print $2
            exit
        }'
    )"

    if [[ "${platform_count:-0}" =~ ^[0-9]+$ ]] &&
       (( platform_count > 0 )); then
        echo "OpenCL platform: PASS"
    else
        echo "OpenCL platform: PENDING ROCm"
    fi
else
    echo "clinfo: FAIL"
    status=1
fi

echo
echo "===== PACKAGE VERSIONS ====="

dpkg-query -W -f='${binary:Package}\t${Version}\n' \
    mesa-utils \
    mesa-vulkan-drivers \
    vulkan-tools \
    clinfo \
    ocl-icd-libopencl1 \
    2>/dev/null || true

echo
echo "===== FINAL RESULT ====="

if [[ "$status" -eq 0 ]]; then
    echo "[M2-04] GPU runtime foundation: PASS"
else
    echo "[M2-04] GPU runtime foundation: FAIL"
fi

exit "$status"

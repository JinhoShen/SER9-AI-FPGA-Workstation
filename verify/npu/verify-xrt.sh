#!/usr/bin/env bash
set -euo pipefail

export LD_LIBRARY_PATH="/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH:-}"
source /opt/xilinx/xrt/setup.sh >/dev/null

echo "===== M3-03 NPU XRT VERIFICATION ====="
echo "Timestamp: $(date --iso-8601=seconds)"
echo

echo "===== XRT PACKAGE STATUS ====="
dpkg-query -W -f='${binary:Package}\t${Version}\n' \
  xrt-base \
  xrt-base-dev \
  xrt-npu \
  xrt-plugin-amdxdna \
  2>/dev/null || true

echo
echo "===== XRT-SMI ====="
xrt-smi examine

echo
echo "===== RESULT ====="

output="$(xrt-smi examine 2>&1)"

if grep -q 'RyzenAI-npu4' <<<"$output" &&
   grep -q 'Version.*2.21.75' <<<"$output"; then
    echo "[M3-03] NPU XRT verification: PASS"
else
    echo "[M3-03] NPU XRT verification: FAIL"
    exit 1
fi

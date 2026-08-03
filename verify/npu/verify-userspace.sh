#!/usr/bin/env bash
set -euo pipefail

echo "===== M3-02 NPU USERSPACE AUDIT ====="
echo

echo "===== XRT ====="
dpkg -l | grep -Ei '^ii.*xrt' || true
echo

echo "===== Ryzen AI ====="
dpkg -l | grep -Ei 'ryzen|amd-ai|vai|vitis-ai' || true
echo

echo "===== ONNX Runtime ====="
python3 - <<'PY'
try:
    import onnxruntime as ort
    print("Python package : PASS")
    print("Version :", ort.__version__)
    print("Providers :", ort.get_available_providers())
except Exception:
    print("Python package : NOT INSTALLED")
PY
echo

echo "===== Python Packages ====="
python3 -m pip list 2>/dev/null | \
grep -Ei 'onnx|onnxruntime|torch|tensorflow|vai|ryzen' || true
echo

echo "===== Executables ====="
for exe in \
    xrt-smi \
    xbutil \
    xbutil2 \
    vai_q_onnx \
    ryzen-ai-runner
do
    if command -v "$exe" >/dev/null 2>&1; then
        echo "$exe : FOUND"
    else
        echo "$exe : NOT FOUND"
    fi
done
echo

echo "===== Environment ====="
env | grep -Ei 'XRT|RYZEN|VITIS|XDNA|ROCM' || true
echo

echo "[M3-02] Userspace audit complete"

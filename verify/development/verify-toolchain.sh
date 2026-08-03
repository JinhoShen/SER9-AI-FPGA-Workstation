#!/usr/bin/env bash
set -euo pipefail

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

echo "[M2-01] Development toolchain verification"

for tool in git gcc g++ cmake ninja make pkg-config python3 pip3 node npm; do
    command -v "$tool" >/dev/null
    echo "$tool: PASS"
done

cat > "$work_dir/test.c" <<'SRC'
#include <stdio.h>

int main(void)
{
    puts("C compiler verification: PASS");
    return 0;
}
SRC

gcc -Wall -Wextra -Werror \
    "$work_dir/test.c" \
    -o "$work_dir/test-c"

"$work_dir/test-c"

cat > "$work_dir/test.cpp" <<'SRC'
#include <iostream>

int main()
{
    std::cout << "C++ compiler verification: PASS\n";
    return 0;
}
SRC

g++ -std=c++17 -Wall -Wextra -Werror \
    "$work_dir/test.cpp" \
    -o "$work_dir/test-cpp"

"$work_dir/test-cpp"

python3 -m venv "$work_dir/venv"
"$work_dir/venv/bin/python" \
    -c 'print("Python virtual environment verification: PASS")'

echo "[M2-01] All required development tools: PASS"

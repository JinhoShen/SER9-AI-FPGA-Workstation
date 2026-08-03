# M2-01 Development Toolchain Audit

## Purpose

This document records and verifies the native development toolchain available on the SER9 AI + FPGA Workstation.

The audit establishes a reproducible engineering reference before installing and validating the GPU, NPU, AI framework, and FPGA development environments.

---

## Milestone

| Item              | Value                               |
| ----------------- | ----------------------------------- |
| Milestone         | M2 – Development Foundation         |
| Task              | M2-01 – Development Toolchain Audit |
| Verification Date | 2026-08-03                          |
| Result            | PASS                                |

---

## System Platform

| Item             | Verified Value                             |
| ---------------- | ------------------------------------------ |
| Hostname         | AMD-HX370-SHEN                             |
| Hardware Vendor  | AZW                                        |
| Hardware Model   | SER9                                       |
| CPU              | AMD Ryzen AI 9 HX 370                      |
| Operating System | Ubuntu 24.04.4 LTS                         |
| Kernel           | 6.17.0-35-generic                          |
| Architecture     | x86-64                                     |
| Filesystem       | ext4                                       |
| Firmware         | STX.3xx.SER9.V103.P8C0M0C15.55.Link.GID.90 |

---

## Version Control

| Tool    | Version | Status |
| ------- | ------: | ------ |
| Git     |  2.43.0 | PASS   |
| Git LFS |   3.4.1 | PASS   |

Git and Git LFS are installed and available for source control and large-file management.

---

## Compiler Toolchain

| Tool    |       Version | Status   |
| ------- | ------------: | -------- |
| GCC     |        13.3.0 | PASS     |
| G++     |        13.3.0 | PASS     |
| Clang   | Not installed | OPTIONAL |
| Clang++ | Not installed | OPTIONAL |

GCC and G++ provide the required native C and C++ compiler foundation.

Clang is not required to complete M2-01. It may be installed later when required by ROCm, LLVM, vendor SDK, or FPGA workflows.

---

## Build Tools

| Tool       | Version | Status |
| ---------- | ------: | ------ |
| CMake      |  3.28.3 | PASS   |
| Ninja      |  1.11.1 | PASS   |
| GNU Make   |     4.3 | PASS   |
| pkg-config |   1.8.1 | PASS   |

The workstation supports Make-based and Ninja-based native software builds.

---

## Python Environment

| Tool         |   Version | Status |
| ------------ | --------: | ------ |
| Python       |    3.12.3 | PASS   |
| pip          |      24.0 | PASS   |
| python3-venv | Available | PASS   |

Python virtual environment support was verified successfully.

Project-specific Python packages should be installed inside virtual environments whenever practical.

---

## Node.js Environment

| Tool    | Version | Status |
| ------- | ------: | ------ |
| Node.js | 24.18.0 | PASS   |
| npm     | 11.16.0 | PASS   |

The Node.js environment is currently used by the Mermaid documentation-generation pipeline.

The npm notice recommending a major-version upgrade does not block this milestone. The installed version remains unchanged to preserve the verified environment.

---

## Container Environment

| Tool   | Status        |
| ------ | ------------- |
| Docker | Not installed |
| Podman | Not installed |

Container tooling is not required for M2-01.

Docker or Podman may be evaluated later if required for SDK isolation, reproducible framework builds, CI workflows, or vendor-provided containers.

---

## Installed Development Packages

The following Ubuntu development packages were confirmed:

* `build-essential`
* `gcc`
* `g++`
* `cmake`
* `ninja-build`
* `make`
* `pkg-config`
* `python3`
* `python3-pip`
* `python3-venv`
* `git`
* `git-lfs`

---

## Functional Verification

The toolchain was verified using:

```bash
verify/development/verify-toolchain.sh
```

The verification covered:

1. Required command discovery
2. Native C compilation
3. Native C executable execution
4. C++17 compilation
5. Native C++ executable execution
6. Python virtual-environment creation
7. Python execution inside the virtual environment

### Verification Result

```text
[M2-01] Development toolchain verification
git: PASS
gcc: PASS
g++: PASS
cmake: PASS
ninja: PASS
make: PASS
pkg-config: PASS
python3: PASS
pip3: PASS
node: PASS
npm: PASS
C compiler verification: PASS
C++ compiler verification: PASS
Python virtual environment verification: PASS
[M2-01] All required development tools: PASS
```

---

## Engineering Records

Raw environment inventory:

```text
baseline/m2-development-toolchain.txt
```

Functional verification output:

```text
baseline/m2-development-toolchain-verification.txt
```

Reusable verification script:

```text
verify/development/verify-toolchain.sh
```

---

## Exceptions and Observations

### Optional tools

Clang, Docker, and Podman are not installed.

These tools are not required for the current task and do not affect the M2-01 result.

### Version reporting

Ubuntu package versions may differ from the application version displayed by commands such as:

```bash
gcc --version
cmake --version
git --version
```

The baseline inventory preserves both runtime version information and installed package records.

### Accidental terminal input

During the audit, package inventory output was accidentally interpreted as shell commands.

No packages, project files, or system configuration were modified by those failed commands. The development tools were rechecked afterward and remained operational.

---

## Verification Status

| Verification                  | Result |
| ----------------------------- | ------ |
| Git availability              | PASS   |
| GCC availability              | PASS   |
| G++ availability              | PASS   |
| CMake availability            | PASS   |
| Ninja availability            | PASS   |
| Make availability             | PASS   |
| pkg-config availability       | PASS   |
| Python availability           | PASS   |
| pip availability              | PASS   |
| Python virtual environment    | PASS   |
| Node.js availability          | PASS   |
| npm availability              | PASS   |
| C compilation and execution   | PASS   |
| C++ compilation and execution | PASS   |

---

## Final Result

**PASS**

The SER9 workstation has the required native development foundation for continuing the M2 milestone.

No installation or upgrade is required before proceeding to M2-02.

---

## Next Task

**M2-02 Build System Verification**

Planned scope:

* Minimal CMake C/C++ project
* Ninja generator verification
* Out-of-source build
* CTest execution
* Clean rebuild
* Repeatability verification

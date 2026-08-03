# SER9 AI + FPGA Workstation Engineering Manual

## Project Overview

This repository documents the complete engineering process for building a reproducible AI and FPGA development workstation based on the AMD Ryzen AI platform.

The objective is to provide a fully documented environment that can be rebuilt from a clean Ubuntu installation with consistent results.

---

## Hardware Platform

| Item | Specification |
|------|---------------|
| Mini PC | Beelink SER9 |
| CPU | AMD Ryzen AI 9 HX 370 |
| iGPU | AMD Radeon 890M (gfx1150) |
| NPU | AMD XDNA2 NPU |
| Memory | 32 GB DDR5 |
| Storage | NVMe SSD |
| Filesystem | ext4 |

---

## Software Platform

| Component | Status |
|-----------|--------|
| Ubuntu 24.04.4 LTS | ✅ Complete |
| Linux Kernel 6.17.0-35 | ✅ Complete |
| Git | ✅ Complete |
| Git LFS | ✅ Complete |
| Baseline Inventory | ✅ Complete |
| Timeshift | ✅ Complete |
| VS Code Documentation Environment | ✅ Complete |
| Mermaid CLI | ✅ Complete |
| Documentation Build Pipeline | ✅ Complete |
| ROCm | Planned |
| Vulkan | Planned |
| Ryzen AI SDK | Planned |
| Vivado | Planned |
| Vitis | Planned |
| Hermes Agent | Planned |

---

## Repository Structure

```text
baseline/          System baseline information
benchmark/         Performance benchmark results
config/            Configuration files
diagrams/          Diagram source files
docs/              Engineering documentation
figures/           Architecture diagrams
install/           Installation scripts
output/            Generated documentation assets
scripts/           Utility and build scripts
templates/         Document templates
verify/            Verification scripts
```

---

## Engineering Workflow

Each milestone follows the same engineering process:

1. Install
2. Verify
3. Document
4. Git Commit
5. Git Tag
6. Timeshift Snapshot

---

## Milestones

| Milestone | Description | Status |
|-----------|-------------|--------|
| M0.0 | Golden Baseline | ✅ Complete |
| M0.1 | Maintenance Update | ✅ Complete |
| M1.0 | Documentation Environment and Build Pipeline | ✅ Complete |
| M2 | Development Foundation | Next |
| M3 | AMD AI Platform | Planned |
| M4 | AI Framework | Planned |
| M5 | FPGA Platform | Planned |
| M6 | Hermes Agent | Planned |
| M7 | Maintenance | Planned |

---

## Current Status

Current milestone:

**M2 – Development Foundation**

Latest completed milestone:

**M1.0 – Documentation Build Pipeline**

Latest Git Commit:

`568e6e1`

Latest Git Tag:

`M1.0`

---

## License

This project is maintained as an engineering documentation repository for the SER9 AI + FPGA Workstation.

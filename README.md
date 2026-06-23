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
| NPU | AMD XDNA 2 NPU |
| Memory | DDR5 |
| Storage | NVMe SSD |
| Filesystem | ext4 |

---

## Software Platform

| Component | Status |
|-----------|--------|
| Ubuntu 24.04.4 LTS | ✅ |
| Git | ✅ |
| Git LFS | ✅ |
| Baseline Inventory | ✅ |
| Timeshift | ✅ |
| ROCm | Planned |
| Vulkan | Planned |
| Ryzen AI SDK | Planned |
| Vivado | Planned |
| Vitis | Planned |
| Hermes Agent | Planned |

---

## Repository Structure
baseline/ System baseline information
benchmark/ Performance benchmark results
config/ Configuration files
docs/ Engineering documentation
figures/ Architecture diagrams
install/ Installation scripts
scripts/ Utility scripts
templates/ Document templates
verify/ Verification scripts

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
| M0 | Golden Baseline | ✅ |
| M1 | Documentation Environment | Planned |
| M2 | Development Foundation | Planned |
| M3 | AMD AI Platform | Planned |
| M4 | AI Framework | Planned |
| M5 | FPGA Platform | Planned |
| M6 | Hermes Agent | Planned |
| M7 | Maintenance | Planned |

---

## Current Status

Current milestone:

**M0 – Golden Baseline**

Latest Git Commit:

81093ce

---

## License

This project is maintained as an engineering documentation repository for the SER9 AI + FPGA Workstation.

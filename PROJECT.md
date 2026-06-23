# PROJECT

## Project Name

SER9 AI + FPGA Workstation Engineering Manual

---

## Vision

Build a reproducible and maintainable AI + FPGA engineering workstation based on AMD Ryzen AI technology.

The goal is to create a documented engineering platform that can be rebuilt from a clean operating system installation with predictable and verifiable results.

---

## Target Hardware

| Component | Specification |
|------------|--------------|
| Platform | Beelink SER9 |
| CPU | AMD Ryzen AI 9 HX 370 |
| GPU | Radeon 890M (gfx1150) |
| NPU | AMD XDNA2 |
| Memory | DDR5 |
| Storage | NVMe SSD |

---

## Target Software

### Operating System

- Ubuntu 24.04 LTS

### Development Tools

- Git
- VS Code
- CMake
- Ninja
- Python

### AI Platform

- ROCm
- Vulkan
- Ryzen AI SDK
- ONNX Runtime
- llama.cpp
- Ollama

### FPGA Platform

- Vivado
- Vitis
- XRT

### Automation

- Hermes Agent
- OpenAI API
- MCP

---

## Repository Structure

baseline/
benchmark/
config/
docs/
figures/
install/
scripts/
templates/
verify/

---

## Engineering Rules

Every milestone must include:

1. Installation
2. Verification
3. Documentation
4. Git Commit
5. Git Tag
6. Timeshift Snapshot

---

## Milestones

### M0 Golden Baseline

System initialization and recovery baseline.

### M1 Documentation Environment

Documentation and engineering workflow.

### M2 Development Foundation

Common development tools and build environment.

### M3 AMD AI Platform

ROCm, Vulkan, Ryzen AI SDK.

### M4 AI Framework

llama.cpp, Ollama, ONNX Runtime.

### M5 FPGA Platform

Vivado, Vitis and FPGA workflow.

### M6 AI Agent

Hermes Agent and automation platform.

### M7 Maintenance

Upgrade, recovery and troubleshooting.

---

## Success Criteria

The workstation can be rebuilt from a clean Ubuntu installation by following the engineering manual and verification procedures.


#!/usr/bin/env bash

set -e

PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

mkdir -p "$PROJECT_ROOT/docs/M0"

HOSTNAME=$(hostnamectl --static)
OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
KERNEL=$(uname -r)
DATE=$(date +%F)
COMMIT=$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || echo "N/A")

cat > "$PROJECT_ROOT/README.md" <<EOT
# SER9 AI + FPGA Workstation Engineering Manual

## Current Milestone

- ✅ M0 Golden Baseline

Generated: $DATE
EOT

cat > "$PROJECT_ROOT/CHANGELOG.md" <<EOT
# CHANGELOG

## M0 - Golden Baseline

Date: $DATE

### System

- Hostname: $HOSTNAME
- OS: $OS
- Kernel: $KERNEL

### Git

- Commit: $COMMIT

Status: PASS
EOT

cat > "$PROJECT_ROOT/docs/M0/M0.md" <<EOT
# M0 Golden Baseline

## Objective

Create a reproducible Ubuntu engineering baseline.

## Hostname

$HOSTNAME

## Operating System

$OS

## Kernel

$KERNEL

## Git Commit

$COMMIT

## Status

PASS
EOT

echo
echo "========================================="
echo " Documentation Generated Successfully"
echo "========================================="
echo
echo "README.md"
echo "CHANGELOG.md"
echo "docs/M0/M0.md"

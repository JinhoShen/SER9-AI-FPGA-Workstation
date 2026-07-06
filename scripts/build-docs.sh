#!/usr/bin/env bash
set -euo pipefail

INPUT_DIR="diagrams/mermaid"
SVG_DIR="output/svg"
PNG_DIR="output/png"
PDF_DIR="output/pdf"

mkdir -p "$SVG_DIR" "$PNG_DIR" "$PDF_DIR"

echo "[M1] Building Mermaid diagrams..."

for file in "$INPUT_DIR"/*.mmd; do
  [ -e "$file" ] || {
    echo "[M1] No Mermaid files found."
    exit 0
  }

  base="$(basename "$file" .mmd)"

  echo "[M1] Rendering $base"

  npx mmdc -p puppeteer-config.json -i "$file" -o "$SVG_DIR/$base.svg"
  npx mmdc -p puppeteer-config.json -i "$file" -o "$PNG_DIR/$base.png"
  npx mmdc -p puppeteer-config.json -i "$file" -o "$PDF_DIR/$base.pdf"
done

echo "[M1] Documentation build complete."

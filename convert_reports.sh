#!/usr/bin/env bash
# Convert module_summary.md to PDF with pandoc (install pandoc if missing).
set -euo pipefail
cd "$(dirname "$0")"
pandoc module_summary.md -o module_summary.pdf
echo "Wrote module_summary.pdf"

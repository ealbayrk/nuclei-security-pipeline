#!/bin/bash

set -euo pipefail

TARGET="${TARGET_URL:-http://127.0.0.1:3000}"
OUTPUT="reports/misconfig-scan.json"

mkdir -p reports

if ! curl -fsS "$TARGET" -o /dev/null; then
  echo "Error: Target is not accessible."
  exit 1
fi

echo "Starting misconfiguration scan..."

nuclei \
  -u "$TARGET" \
  -tags misconfig \
  -no-interactsh \
  -etags dos,fuzz,intrusive \
  -rl 2 \
  -c 1 \
  -json-export "$OUTPUT"

echo "Scan completed. Report: $OUTPUT"

#!/bin/bash

set -euo pipefail

TARGET="${TARGET_URL:-http://127.0.0.1:3000}"
OUTPUT="reports/tech-scan.json"

mkdir -p reports

if ! curl -fsS "$TARGET" -o /dev/null; then
  echo "Hata: Juice Shop çalışmıyor veya erişilemiyor: $TARGET"
  exit 1
fi

nuclei \
  -u "$TARGET" \
  -tags tech \
  -no-interactsh \
  -rl 5 \
  -c 2 \
  -json-export "$OUTPUT"

echo "Tarama tamamlandı. Rapor: $OUTPUT"

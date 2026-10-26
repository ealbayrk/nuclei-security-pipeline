#!/bin/bash

set -euo pipefail

echo "================================"
echo " Nuclei Security Pipeline"
echo "================================"

echo ""
echo "[1/2] Technology Detection"
./scripts/tech-scan.sh

echo ""
echo "[2/2] Misconfiguration Scan"
./scripts/misconfig-scan.sh

echo ""
echo "================================"
echo " All scans completed successfully"
echo "================================"

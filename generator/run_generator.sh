#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="${SCRIPT_DIR}/src"
OUT_DIR="${SCRIPT_DIR}/out"
DATA_DIR="${PROJECT_DIR}/data"

TOTAL_ROWS="${1:-70000000}"
OUTPUT_DIR="${2:-${DATA_DIR}}"
PARTITIONS="${3:-20}"

echo "=== Compiling data generator ==="
mkdir -p "$OUT_DIR"
javac -d "$OUT_DIR" "${SRC_DIR}"/*.java
echo "Compilation successful."

echo ""
echo "=== Running data generator ==="
echo "  Rows:       ${TOTAL_ROWS}"
echo "  Partitions: ${PARTITIONS}"
echo "  Output:     ${OUTPUT_DIR}"
echo ""

java -cp "$OUT_DIR" GeneratorMain "$TOTAL_ROWS" "$OUTPUT_DIR" "$PARTITIONS"

echo ""
echo "=== Generator finished ==="
echo "Output files:"
ls -lh "${OUTPUT_DIR}"/benchmark_part_*.csv 2>/dev/null | awk '{print "  " $NF, $5}' || echo "  (no files found)"

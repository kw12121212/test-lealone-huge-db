#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LEALONE_JAR="${LEALONE_JAR:-${PROJECT_DIR}/lealone-source/target/lealone-8.0.0-SNAPSHOT.jar}"
DDL_FILE="${PROJECT_DIR}/schema.sql"
MODE="${LEALONE_MODE:-embed}"

if [ ! -f "$DDL_FILE" ]; then
    echo "ERROR: schema.sql not found at $DDL_FILE"
    exit 1
fi

if [ ! -f "$LEALONE_JAR" ]; then
    echo "ERROR: Lealone JAR not found at $LEALONE_JAR"
    echo "Set LEALONE_JAR to the correct path."
    exit 1
fi

DDL=$(cat "$DDL_FILE")

echo "=== Creating table ==="
java -jar "$LEALONE_JAR" -${MODE} -sql "$DDL"
echo "Table created."

echo ""
echo "=== Verifying table structure ==="
java -jar "$LEALONE_JAR" -${MODE} -sql "SHOW COLUMNS FROM benchmark;"
echo ""
echo "Schema verification complete."

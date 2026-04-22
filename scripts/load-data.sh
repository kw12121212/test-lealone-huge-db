#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LEALONE_SRC="$PROJECT_ROOT/lealone-source"
DATA_DIR="$PROJECT_ROOT/data"
LOADER_SRC="$PROJECT_ROOT/loader/src"
LOADER_OUT="$PROJECT_ROOT/loader/out"

TOTAL_ROWS="${1:-70000000}"
BATCH_SIZE="${2:-5000}"
JDBC_URL="${3:-jdbc:lealone:tcp://127.0.0.1:9210/lealone}"

if [ -z "${JAVA_HOME:-}" ]; then
    echo "ERROR: JAVA_HOME must be set"
    exit 1
fi

JAVA="$JAVA_HOME/bin/java"

# Assemble classpath (same pattern as create-table.sh)
CLASSPATH="$LOADER_OUT"
for jar in "$LEALONE_SRC"/*/target/*.jar; do
    case "$jar" in
        *-sources.jar|*-tests.jar|*-test-sources.jar) ;;
        *) CLASSPATH="$CLASSPATH:$jar" ;;
    esac
done
CLASSPATH="$CLASSPATH:$LEALONE_SRC/lealone-main/target/classes"

# Generate data if missing
if [ ! -d "$DATA_DIR" ] || [ -z "$(ls -A "$DATA_DIR"/benchmark_part_*.csv 2>/dev/null || true)" ]; then
    echo "=== No CSV data found. Running generator ==="
    bash "$PROJECT_ROOT/generator/run_generator.sh" "$TOTAL_ROWS" "$DATA_DIR" 20
    echo ""
fi

CSV_COUNT=$(ls "$DATA_DIR"/benchmark_part_*.csv 2>/dev/null | wc -l)
echo "=== Found $CSV_COUNT CSV partition files in $DATA_DIR ==="
echo ""

# Compile loader
echo "=== Compiling loader ==="
mkdir -p "$LOADER_OUT"
javac -d "$LOADER_OUT" "$LOADER_SRC"/*.java
echo "Compilation successful."
echo ""

# Run loader
echo "=== Starting data load ==="
$JAVA -cp "$CLASSPATH" LoaderMain "$DATA_DIR" "$BATCH_SIZE" "$JDBC_URL"

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LEALONE_SRC="$PROJECT_ROOT/lealone-source"
BENCH_SRC="$PROJECT_ROOT/bench/src"
BENCH_OUT="$PROJECT_ROOT/bench/out"

ITERATIONS="${1:-10000}"
CONCURRENCY="${2:-1,10,50,100}"
JDBC_URL="${3:-jdbc:lealone:tcp://127.0.0.1:9210/lealone}"

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    echo "Usage: bash scripts/run-benchmarks.sh [iterations] [concurrencyLevels] [jdbcUrl]"
    echo "  iterations          Per-worker iterations (default: 10000)"
    echo "  concurrencyLevels   Comma-separated thread counts (default: 1,10,50,100)"
    echo "  jdbcUrl             JDBC connection URL (default: jdbc:lealone:tcp://127.0.0.1:9210/lealone)"
    exit 0
fi

if [ -z "${JAVA_HOME:-}" ]; then
    echo "ERROR: JAVA_HOME must be set"
    exit 1
fi

JAVA="$JAVA_HOME/bin/java"

# Assemble classpath
CLASSPATH="$BENCH_OUT"
for jar in "$LEALONE_SRC"/*/target/*.jar; do
    case "$jar" in
        *-sources.jar|*-tests.jar|*-test-sources.jar) ;;
        *) CLASSPATH="$CLASSPATH:$jar" ;;
    esac
done
CLASSPATH="$CLASSPATH:$LEALONE_SRC/lealone-main/target/classes"

# Compile benchmark tool
echo "=== Compiling benchmark tool ==="
mkdir -p "$BENCH_OUT"
javac -d "$BENCH_OUT" "$BENCH_SRC"/*.java
echo "Compilation successful."
echo ""

# Run benchmark
echo "=== Starting benchmark ==="
$JAVA -cp "$CLASSPATH" BenchmarkMain "$ITERATIONS" "$CONCURRENCY" "$JDBC_URL"

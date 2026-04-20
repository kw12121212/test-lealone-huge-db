#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LEALONE_SRC="$PROJECT_ROOT/lealone-source"
DDL_FILE="$PROJECT_ROOT/schema.sql"

if [ -z "${JAVA_HOME:-}" ]; then
    echo "ERROR: JAVA_HOME must be set"
    exit 1
fi

if [ ! -f "$DDL_FILE" ]; then
    echo "ERROR: schema.sql not found at $DDL_FILE"
    exit 1
fi

CLASSPATH="$LEALONE_SRC/lealone-main/target/classes"
for jar in "$LEALONE_SRC"/*/target/*.jar; do
    case "$jar" in
        *-sources.jar|*-tests.jar|*-test-sources.jar) ;;
        *) CLASSPATH="$CLASSPATH:$jar" ;;
    esac
done

NODES=("127.0.0.1:9210" "127.0.0.1:9211" "127.0.0.1:9212")
JAVA="$JAVA_HOME/bin/java"

DDL=$(cat "$DDL_FILE")

run_sql() {
    local url="$1"
    local sql="$2"
    output=$($JAVA -cp "$CLASSPATH" com.lealone.main.Lealone -client \
            -url "$url" -sql "$sql" 2>&1) || true
    if echo "$output" | grep -q "Error:"; then
        echo "$output"
        return 1
    fi
    return 0
}

echo "=== Creating benchmark table on all cluster nodes ==="
echo "DDL: $DDL_FILE"
echo ""

FAIL=0

for node in "${NODES[@]}"; do
    url="jdbc:lealone:tcp://$node/lealone"
    echo -n "  CREATE TABLE on $node ... "
    if run_sql "$url" "$DDL"; then
        echo "OK"
    else
        echo "FAILED"
        FAIL=$((FAIL + 1))
    fi
done

echo ""
echo "=== Verifying table structure ==="

for node in "${NODES[@]}"; do
    url="jdbc:lealone:tcp://$node/lealone"
    echo -n "  SHOW COLUMNS on $node ... "
    if run_sql "$url" "SHOW COLUMNS FROM benchmark"; then
        echo "OK"
    else
        echo "FAILED"
        FAIL=$((FAIL + 1))
    fi
done

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo "=== All nodes OK ==="
else
    echo "=== $FAIL node(s) FAILED ==="
    exit 1
fi

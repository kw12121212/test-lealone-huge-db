#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LEALONE_SRC="$PROJECT_ROOT/lealone-source"

if [ -z "${JAVA_HOME:-}" ]; then
    echo "ERROR: JAVA_HOME must be set"
    exit 1
fi

# Build classpath (same as start-cluster.sh)
CLASSPATH="$LEALONE_SRC/lealone-main/target/classes"
for jar in "$LEALONE_SRC"/*/target/*.jar; do
    case "$jar" in
        *-sources.jar|*-tests.jar|*-test-sources.jar) ;;
        *) CLASSPATH="$CLASSPATH:$jar" ;;
    esac
done

NODES=("127.0.0.1:9210" "127.0.0.1:9211" "127.0.0.1:9212")
CLUSTER_URL="jdbc:lealone:tcp://127.0.0.1:9210,127.0.0.1:9211,127.0.0.1:9212/lealone"
JAVA="$JAVA_HOME/bin/java"
TABLE="SMOKE_TEST"

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

PASS=0
FAIL=0

step() {
    local desc="$1"
    shift
    echo -n "  $desc ... "
    if "$@"; then
        PASS=$((PASS + 1))
        echo "OK"
    else
        FAIL=$((FAIL + 1))
        echo "FAILED"
    fi
}

echo "=== Lealone Cluster Smoke Test ==="
echo "Nodes: ${NODES[*]}"
echo ""

# DDL must run on each node individually (Lealone does not auto-replicate DDL)
for node in "${NODES[@]}"; do
    url="jdbc:lealone:tcp://$node/lealone"
    step "CREATE TABLE on $node" run_sql "$url" "CREATE TABLE IF NOT EXISTS $TABLE (id INT PRIMARY KEY, val VARCHAR(100))"
done

# DML uses the multi-node URL (client-side routing)
step "INSERT" run_sql "$CLUSTER_URL" "INSERT INTO $TABLE (id, val) VALUES (1, 'hello')"
step "SELECT" run_sql "$CLUSTER_URL" "SELECT * FROM $TABLE WHERE id = 1"
step "UPDATE" run_sql "$CLUSTER_URL" "UPDATE $TABLE SET val = 'world' WHERE id = 1"
step "SELECT after UPDATE" run_sql "$CLUSTER_URL" "SELECT val FROM $TABLE WHERE id = 1"
step "DELETE" run_sql "$CLUSTER_URL" "DELETE FROM $TABLE WHERE id = 1"

# Cleanup on each node
for node in "${NODES[@]}"; do
    url="jdbc:lealone:tcp://$node/lealone"
    step "DROP TABLE on $node" run_sql "$url" "DROP TABLE IF EXISTS $TABLE"
done

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1

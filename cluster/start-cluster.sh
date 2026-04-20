#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LEALONE_SRC="$PROJECT_ROOT/lealone-source"

if [ -z "${JAVA_HOME:-}" ]; then
    echo "ERROR: JAVA_HOME must be set"
    exit 1
fi

# Build classpath from all module target jars
CLASSPATH="$LEALONE_SRC/lealone-main/target/classes"
for jar in "$LEALONE_SRC"/*/target/*.jar; do
    case "$jar" in
        *-sources.jar|*-tests.jar|*-test-sources.jar) ;;
        *) CLASSPATH="$CLASSPATH:$jar" ;;
    esac
done

NODES=("node1" "node2" "node3")
PORTS=("9210" "9211" "9212")
PIDS=()

cleanup() {
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
        fi
    done
}
trap cleanup EXIT

for i in "${!NODES[@]}"; do
    node="${NODES[$i]}"
    port="${PORTS[$i]}"
    config="$SCRIPT_DIR/${node}.sql"
    datadir="$SCRIPT_DIR/data/${node}"

    mkdir -p "$datadir"

    echo "Starting $node on port $port..."
    "$JAVA_HOME/bin/java" \
        -cp "$CLASSPATH" \
        com.lealone.main.Lealone \
        -config "$config" \
        -baseDir "$datadir" \
        -host "127.0.0.1" \
        -port "$port" \
        &
    PIDS+=($!)
done

echo "Waiting for nodes to become ready..."
for i in "${!PORTS[@]}"; do
    port="${PORTS[$i]}"
    node="${NODES[$i]}"
    for attempt in $(seq 1 30); do
        if "$JAVA_HOME/bin/java" -cp "$CLASSPATH" com.lealone.main.Lealone -client \
                -url "jdbc:lealone:tcp://127.0.0.1:${port}/lealone" -sql "SELECT 1" >/dev/null 2>&1; then
            echo "$node is ready (port $port)"
            break
        fi
        if [ "$attempt" -eq 30 ]; then
            echo "WARNING: $node did not become ready within 30 seconds"
        fi
        sleep 1
    done
done

echo ""
echo "Cluster started with ${#NODES[@]} nodes."
echo "JDBC URL: jdbc:lealone:tcp://127.0.0.1:9210,127.0.0.1:9211,127.0.0.1:9212/<database>"
echo "PID file: $SCRIPT_DIR/cluster.pids"

# Write PID file for stop-cluster.sh
printf '%s\n' "${PIDS[@]}" > "$SCRIPT_DIR/cluster.pids"

# Detach: wait for all background processes
wait

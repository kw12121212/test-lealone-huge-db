#!/usr/bin/env bash
# Unit tests that verify each node config has unique port and base_dir
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLUSTER_DIR="$PROJECT_ROOT/cluster"

PASS=0
FAIL=0

assert() {
    local desc="$1" actual="$2" expected="$3"
    if [ "$actual" = "$expected" ]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        echo "FAIL: $desc — expected '$expected', got '$actual'"
    fi
}

# Check all three config files exist
for node in node1 node2 node3; do
    [ -f "$CLUSTER_DIR/${node}.sql" ] || { echo "FAIL: $CLUSTER_DIR/${node}.sql missing"; FAIL=$((FAIL + 1)); }
done

# Verify unique ports
PORT1=$(grep -oP 'port:\s*\K\d+' "$CLUSTER_DIR/node1.sql")
PORT2=$(grep -oP 'port:\s*\K\d+' "$CLUSTER_DIR/node2.sql")
PORT3=$(grep -oP 'port:\s*\K\d+' "$CLUSTER_DIR/node3.sql")

assert "node1 port" "$PORT1" "9210"
assert "node2 port" "$PORT2" "9211"
assert "node3 port" "$PORT3" "9212"

# Verify ports are distinct
assert "ports are unique" "$PORT1:$PORT2:$PORT3" "9210:9211:9212"

# Verify unique base_dirs
DIR1=$(grep -oP 'base_dir:.*?cluster/data/\K\w+' "$CLUSTER_DIR/node1.sql")
DIR2=$(grep -oP 'base_dir:.*?cluster/data/\K\w+' "$CLUSTER_DIR/node2.sql")
DIR3=$(grep -oP 'base_dir:.*?cluster/data/\K\w+' "$CLUSTER_DIR/node3.sql")

assert "node1 base_dir" "$DIR1" "node1"
assert "node2 base_dir" "$DIR2" "node2"
assert "node3 base_dir" "$DIR3" "node3"

# Verify base_dirs are distinct
assert "base_dirs are unique" "$DIR1:$DIR2:$DIR3" "node1:node2:node3"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1

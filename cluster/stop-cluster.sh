#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$SCRIPT_DIR/cluster.pids"

if [ ! -f "$PID_FILE" ]; then
    echo "No PID file found at $PID_FILE. Is the cluster running?"
    exit 1
fi

while read -r pid; do
    if kill -0 "$pid" 2>/dev/null; then
        echo "Stopping PID $pid..."
        kill "$pid" 2>/dev/null || true
    fi
done < "$PID_FILE"

# Wait briefly for graceful shutdown
sleep 2

# Force kill any remaining
while read -r pid; do
    if kill -0 "$pid" 2>/dev/null; then
        echo "Force killing PID $pid..."
        kill -9 "$pid" 2>/dev/null || true
    fi
done < "$PID_FILE"

rm -f "$PID_FILE"
echo "Cluster stopped."

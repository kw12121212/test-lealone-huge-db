#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LEALONE_SRC="$PROJECT_ROOT/lealone-source"

EXPECTED_ROWS="${1:-70000000}"

if [ -z "${JAVA_HOME:-}" ]; then
    echo "ERROR: JAVA_HOME must be set"
    exit 1
fi

JAVA="$JAVA_HOME/bin/java"

# Build classpath (same pattern as smoke-test-cluster.sh)
CLASSPATH="$LEALONE_SRC/lealone-main/target/classes"
for jar in "$LEALONE_SRC"/*/target/*.jar; do
    case "$jar" in
        *-sources.jar|*-tests.jar|*-test-sources.jar) ;;
        *) CLASSPATH="$CLASSPATH:$jar" ;;
    esac
done

CLUSTER_URL="jdbc:lealone:tcp://127.0.0.1:9210,127.0.0.1:9211,127.0.0.1:9212/lealone"

PASS=0
FAIL=0

run_sql() {
    local url="$1"
    local sql="$2"
    local output
    output=$($JAVA -cp "$CLASSPATH" com.lealone.main.Lealone -client \
            -url "$url" -sql "$sql" 2>&1) || {
        echo "$output"
        return 1
    }
    echo "$output"
}

# Extract the first integer-only line from SQL output (the data row for COUNT queries)
extract_count() {
    grep -E '^[0-9]+$' | head -1
}

echo "=== Lealone Data Integrity Verification ==="
echo "Cluster: $CLUSTER_URL"
echo "Expected rows: $EXPECTED_ROWS"
echo ""

# Check 1: Row count
echo "Check 1: Row count"
count_output=$(run_sql "$CLUSTER_URL" "SELECT COUNT(*) FROM benchmark") || {
    echo "  FAIL: Could not connect to cluster or execute query"
    echo "  $count_output"
    FAIL=$((FAIL + 1))
    echo ""
    echo "=== Results: $PASS passed, $FAIL failed ==="
    exit 1
}
actual_count=$(echo "$count_output" | extract_count)

if [ "${actual_count:-}" = "$EXPECTED_ROWS" ]; then
    echo "  PASS: Row count = $actual_count (expected $EXPECTED_ROWS)"
    PASS=$((PASS + 1))
else
    echo "  FAIL: Row count = ${actual_count:-unknown} (expected $EXPECTED_ROWS)"
    FAIL=$((FAIL + 1))
fi

# Check 2: Non-null check on key fields
echo "Check 2: Non-null fields (field_int, field_name)"
null_count="error"
if null_output=$(run_sql "$CLUSTER_URL" "SELECT COUNT(*) FROM benchmark WHERE field_int IS NULL OR field_name IS NULL"); then
    null_count=$(echo "$null_output" | extract_count)
else
    echo "  FAIL: Query execution failed"
    FAIL=$((FAIL + 1))
fi

if [ "${null_count:-error}" = "0" ]; then
    echo "  PASS: No NULL values in field_int or field_name"
    PASS=$((PASS + 1))
else
    echo "  FAIL: Found ${null_count:-unknown} rows with NULL in field_int or field_name"
    FAIL=$((FAIL + 1))
fi

# Check 3: INT range check
echo "Check 3: field_int range validity"
range_count="error"
if range_output=$(run_sql "$CLUSTER_URL" "SELECT COUNT(*) FROM benchmark WHERE field_int < -2147483648 OR field_int > 2147483647"); then
    range_count=$(echo "$range_output" | extract_count)
else
    echo "  FAIL: Query execution failed"
    FAIL=$((FAIL + 1))
fi

if [ "${range_count:-error}" = "0" ]; then
    echo "  PASS: All field_int values within valid INT range"
    PASS=$((PASS + 1))
else
    echo "  FAIL: Found ${range_count:-unknown} rows with field_int outside INT range"
    FAIL=$((FAIL + 1))
fi

# Check 4: Sample data spot check
echo "Check 4: Sample data spot check"
if sample_output=$(run_sql "$CLUSTER_URL" "SELECT id, field_int, field_name, field_uuid FROM benchmark LIMIT 5"); then
    if echo "$sample_output" | grep -qiE "error|exception"; then
        echo "  FAIL: Error in sample query"
        echo "$sample_output"
        FAIL=$((FAIL + 1))
    else
        data_lines=$(echo "$sample_output" | grep -cE '^[0-9]+' || true)
        if [ "$data_lines" -ge 1 ]; then
            echo "  PASS: Sample rows retrieved successfully"
            PASS=$((PASS + 1))
        else
            echo "  FAIL: No data rows returned"
            FAIL=$((FAIL + 1))
        fi
    fi
else
    echo "  FAIL: Could not fetch sample rows"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1

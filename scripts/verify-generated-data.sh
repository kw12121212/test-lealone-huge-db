#!/usr/bin/env bash
# Verifies that generated CSV files match the benchmark schema.
# Checks: field count (9 fields per row), type patterns for each field.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="${1:-${PROJECT_DIR}/data}"
SAMPLE_COUNT="${2:-100}"
ERRORS=0

# Expected fields (excluding auto-increment id):
# 1. field_int   - integer
# 2. field_long  - integer
# 3. field_money - decimal (NNNNNNNN.NN)
# 4. field_score - decimal
# 5. field_name  - alphanumeric string
# 6. field_code  - 20-char uppercase alphanumeric
# 7. field_flag  - true/false
# 8. field_ts    - timestamp (YYYY-MM-DD HH:MM:SS)
# 9. field_uuid  - UUID format

EXPECTED_FIELDS=9

CSV_FILES=()
for f in "${DATA_DIR}"/benchmark_part_*.csv; do
    [ -f "$f" ] && CSV_FILES+=("$f")
done

if [ ${#CSV_FILES[@]} -eq 0 ]; then
    echo "ERROR: No CSV files found in ${DATA_DIR}"
    echo "Run the generator first: bash generator/run_generator.sh"
    exit 1
fi

echo "=== Verifying generated data ==="
echo "Found ${#CSV_FILES[@]} CSV file(s) in ${DATA_DIR}"
echo "Checking ${SAMPLE_COUNT} sample rows per file..."
echo ""

TOTAL_ROWS=0

for csv_file in "${CSV_FILES[@]}"; do
    FILE_ERRORS=0
    FILE_ROWS=0
    BASENAME=$(basename "$csv_file")

    while IFS= read -r line; do
        FILE_ROWS=$((FILE_ROWS + 1))
        TOTAL_ROWS=$((TOTAL_ROWS + 1))

        # Only validate sample rows
        if [ "$FILE_ROWS" -gt "$SAMPLE_COUNT" ]; then
            continue
        fi

        # Check field count
        FIELD_COUNT=$(echo "$line" | awk -F',' '{print NF}')
        if [ "$FIELD_COUNT" -ne "$EXPECTED_FIELDS" ]; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] Expected ${EXPECTED_FIELDS} fields, got ${FIELD_COUNT}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
            continue
        fi

        # field_int (field 1) - should be an integer (possibly negative)
        FIELD_INT=$(echo "$line" | cut -d',' -f1)
        if ! echo "$FIELD_INT" | grep -qE '^-?[0-9]+$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_int not integer: ${FIELD_INT}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_long (field 2) - should be an integer
        FIELD_LONG=$(echo "$line" | cut -d',' -f2)
        if ! echo "$FIELD_LONG" | grep -qE '^-?[0-9]+$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_long not integer: ${FIELD_LONG}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_money (field 3) - decimal with 2 decimal places
        FIELD_MONEY=$(echo "$line" | cut -d',' -f3)
        if ! echo "$FIELD_MONEY" | grep -qE '^[0-9]+\.[0-9]{2}$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_money not decimal(10,2): ${FIELD_MONEY}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_score (field 4) - decimal
        FIELD_SCORE=$(echo "$line" | cut -d',' -f4)
        if ! echo "$FIELD_SCORE" | grep -qE '^[0-9]+\.[0-9]+$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_score not decimal: ${FIELD_SCORE}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_name (field 5) - alphanumeric string (non-empty)
        FIELD_NAME=$(echo "$line" | cut -d',' -f5)
        if [ ${#FIELD_NAME} -eq 0 ]; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_name is empty"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_code (field 6) - exactly 20 uppercase alphanumeric chars
        FIELD_CODE=$(echo "$line" | cut -d',' -f6)
        if ! echo "$FIELD_CODE" | grep -qE '^[A-Z0-9]{20}$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_code not 20-char uppercase: ${FIELD_CODE}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_flag (field 7) - true or false
        FIELD_FLAG=$(echo "$line" | cut -d',' -f7)
        if ! echo "$FIELD_FLAG" | grep -qE '^(true|false)$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_flag not boolean: ${FIELD_FLAG}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_ts (field 8) - timestamp format YYYY-MM-DD HH:MM:SS
        FIELD_TS=$(echo "$line" | cut -d',' -f8)
        if ! echo "$FIELD_TS" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_ts not timestamp: ${FIELD_TS}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

        # field_uuid (field 9) - UUID format
        FIELD_UUID=$(echo "$line" | cut -d',' -f9)
        if ! echo "$FIELD_UUID" | grep -qE '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'; then
            echo "  FAIL [${BASENAME}:row ${FILE_ROWS}] field_uuid not UUID: ${FIELD_UUID}"
            FILE_ERRORS=$((FILE_ERRORS + 1))
        fi

    done < "$csv_file"

    echo "  ${BASENAME}: ${FILE_ROWS} total rows, ${FILE_ERRORS} errors in ${SAMPLE_COUNT} sampled"
    ERRORS=$((ERRORS + FILE_ERRORS))
done

echo ""
echo "=== Total rows across all files: ${TOTAL_ROWS} ==="

if [ "$ERRORS" -eq 0 ]; then
    echo "PASS: All sampled rows valid."
    exit 0
else
    echo "FAIL: ${ERRORS} validation error(s) found."
    exit 1
fi

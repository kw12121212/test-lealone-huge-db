# Proposal: verify-data-integrity

## What
Write a `scripts/verify-data.sh` script that connects to the Lealone cluster, checks that the total row count in the `benchmark` table matches the expected 70 million, and runs spot-check queries to confirm field values are plausible and non-empty.

## Why
Milestone 04 requires data integrity verification after loading. Two of three planned changes are complete (`create-target-table`, `load-data`), but row count validation and spot queries are unimplemented. This is the last blocker before milestone 05 (performance testing) can begin.

## Scope
- A single bash script (`scripts/verify-data.sh`) that:
  - Connects to the Lealone cluster via the existing JDBC client pattern.
  - Runs `SELECT COUNT(*) FROM benchmark` and compares to the expected row count (default 70,000,000).
  - Runs spot-check queries: non-null checks on key columns, value range checks on numeric fields, format checks on `field_uuid`.
  - Reports pass/fail per check and exits 0 on success, non-zero on failure.
- A delta spec describing the observable requirements.

## Unchanged Behavior
- Existing scripts (`create-table.sh`, `load-data.sh`, `smoke-test-cluster.sh`, `verify-generated-data.sh`) are not modified.
- The cluster configuration and table schema remain unchanged.

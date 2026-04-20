# Tasks: create-target-table

## Implementation
- [x] Write `scripts/create-table.sh` that reads `schema.sql` and executes the DDL on each of the 3 cluster nodes
- [x] Add verification step: run `SHOW COLUMNS FROM benchmark` on each node after creation to confirm table exists with expected columns

## Testing
- [x] Run `bash -n scripts/create-table.sh` — validate script syntax
- [x] Run `bash scripts/create-table.sh` — unit test: execute against running cluster and verify table exists on all nodes

## Verification
- [x] Verify implementation matches proposal scope

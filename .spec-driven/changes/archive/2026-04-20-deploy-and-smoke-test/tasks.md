# Tasks: deploy-and-smoke-test

## Implementation
- [x] Write `scripts/smoke-test-cluster.sh` that connects to the cluster and runs DDL (CREATE TABLE), DML (INSERT, SELECT), and cleanup (DROP TABLE)
- [x] Start the cluster using `cluster/start-cluster.sh` and run the smoke test script to verify all nodes respond

## Testing
- [x] Run `bash scripts/smoke-test-cluster.sh` — validate smoke test passes against the running cluster
- [x] Run `bash scripts/test-configs.sh` — unit test for configuration validation (if applicable)

## Verification
- [x] Verify the smoke test script exits 0 on success and reports each SQL step result
- [x] Verify implementation matches proposal scope

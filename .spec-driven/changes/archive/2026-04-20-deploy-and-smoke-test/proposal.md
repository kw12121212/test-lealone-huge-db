# Proposal: deploy-and-smoke-test

## What
Start the 3-node Lealone cluster using existing configuration and scripts, then run basic SQL smoke tests (DDL + DML) against the cluster to verify it is functional.

## Why
Milestone 03 requires a running cluster before data loading (milestone 04) can begin. The cluster configuration files and start/stop scripts already exist from the `configure-cluster` change. We now need to actually start the cluster and prove that all three nodes respond correctly to SQL operations.

## Scope
- Start the cluster using `cluster/start-cluster.sh`.
- Write a smoke test script that connects to the cluster via JDBC and runs:
  - DDL: CREATE TABLE
  - DML: INSERT, SELECT (with verification of inserted data)
  - Verify the operation succeeds against the clustered nodes.
- Verify that all three nodes are reachable and form a working cluster.
- Clean up test data after verification.

## Unchanged Behavior
- Cluster configuration files (`cluster/node*.sql`) are not modified.
- Startup/shutdown scripts are not modified.
- The data generator and schema remain unchanged.

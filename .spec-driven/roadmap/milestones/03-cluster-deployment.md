# 03-cluster-deployment

## Goal
Configure and start a Lealone cluster environment, verify nodes communicate, and confirm basic SQL functionality via smoke tests.

## In Scope
- Writing cluster configuration files.
- Starting multiple Lealone nodes.
- Verifying cluster health and connectivity.
- Running basic SQL smoke tests (create table, insert, select).

## Out of Scope
- Performance testing.
- Data loading at scale.

## Done Criteria
- Multiple Lealone nodes are running.
- Nodes form a cluster successfully.
- The cluster status can be verified.
- Basic SQL operations (DDL + DML) work on the cluster.

## Planned Changes
- `configure-cluster` - Declared: planned - Write cluster configuration files for a small multi-node setup (2-3 nodes).
- `deploy-and-smoke-test` - Declared: planned - Start the cluster nodes and run basic SQL smoke tests to verify functionality.

## Dependencies
- Milestone 01 must be complete.

## Risks
- Network configuration issues between nodes.
- Misconfiguration of cluster properties.

## Status
- Declared: proposed

## Notes
- Start with a small cluster (2-3 nodes) to verify the concept before scaling.

# 04-data-loading

## Goal
Load all 70 million generated records into the Lealone cluster and verify data integrity.

## In Scope
- Loading the generated data into the cluster.
- Monitoring the loading process for errors.
- Verifying row count and data integrity after loading.

## Out of Scope
- Performance benchmarking (milestone 05).
- Tuning the Lealone source code.

## Done Criteria
- All 70 million records are successfully inserted.
- Row count matches expectations.
- Spot-check queries return correct data.

## Planned Changes
- `create-target-table` - Declared: complete - Execute the schema DDL on the cluster to create the target table.
- `load-data` - Declared: planned - Import all 70 million records into the cluster, handling batch sizing and error recovery.
- `verify-data-integrity` - Declared: planned - Run row count checks and spot queries to confirm data correctness.

## Dependencies
- Milestone 02 must be complete (generated data ready).
- Milestone 03 must be complete (cluster running with smoke tests passed).

## Risks
- The cluster may become unstable under heavy write load.
- Resource constraints (CPU, RAM, Disk I/O) on the testing environment.
- Loading may need multiple attempts or parameter tuning.

## Status
- Declared: proposed

## Notes
- Need to determine whether to use JDBC, Lealone's specific client, or bulk import tools.
- Batch size and concurrency may need tuning during loading.


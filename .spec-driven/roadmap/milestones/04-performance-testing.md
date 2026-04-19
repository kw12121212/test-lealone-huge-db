# 04-performance-testing

## Goal
Load 70 million records into the Lealone cluster and run performance benchmarks.

## In Scope
- Loading the generated data into the cluster.
- Running read and write performance tests.
- Collecting and documenting performance metrics.

## Out of Scope
- Tuning the Lealone source code for performance.

## Done Criteria
- All 70 million records are successfully inserted.
- Benchmark scripts are executed.
- A summary of performance metrics (e.g., throughput, latency) is available.

## Planned Changes
- `load-data-and-benchmark` - Declared: planned - Import the generated data into the cluster, execute performance tests, and collect metrics.

## Dependencies
- Successful completion of milestone 02 and 03.

## Risks
- The cluster may become unstable under heavy load.
- Resource constraints (CPU, RAM, Disk I/O) on the testing environment.

## Status
- Declared: proposed

## Notes
- Need to determine whether to use JDBC or Lealone's specific client for benchmarks.
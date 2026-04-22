# 05-performance-testing

## Goal
Run performance benchmarks against the loaded Lealone cluster and document results.

## In Scope
- Writing benchmark scripts for read and write operations.
- Executing benchmarks with varying concurrency levels.
- Collecting and documenting performance metrics (throughput, latency, etc.).
- Cluster configuration tuning (JVM parameters, cluster properties) if needed for fair benchmarks.

## Out of Scope
- Modifying Lealone source code for performance.

## Done Criteria
- Benchmark scripts are written and executed.
- A summary of performance metrics (throughput, latency) is available.
- Results are documented for reference.

## Planned Changes
- `create-benchmarks` - Declared: complete - Write benchmark scripts for read and write operations with configurable concurrency.
- `run-benchmarks` - Declared: planned - Execute benchmarks, collect metrics, and document the results.

## Dependencies
- Milestone 04 must be complete (all 70M records loaded and verified).

## Risks
- Resource constraints may limit the accuracy of benchmark results.
- Network latency between client and cluster nodes may skew results.

## Status
- Declared: active

## Notes
- Benchmark results should include both single-node and cross-node query patterns if applicable.



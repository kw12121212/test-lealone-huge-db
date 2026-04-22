# create-benchmarks

## What

Write benchmark scripts that measure read and write performance against the loaded Lealone cluster (70M rows in `benchmark` table). Benchmarks cover point SELECT, range SELECT, and INSERT operations at configurable concurrency levels (1, 10, 50, 100 threads).

## Why

Milestone 05 requires performance metrics (throughput, latency) to evaluate Lealone's cluster capabilities under load. This is the final phase of the roadmap after all data is loaded and verified.

## Scope

- Java JDBC benchmark tool with configurable concurrency and operation types
- Shell script wrapper to compile and run the benchmark
- Benchmark operations: point SELECT by PK, range SELECT, INSERT
- Concurrency levels: 1, 10, 50, 100 threads
- Single-node target (port 9210)
- Output: throughput (ops/sec) and latency (ms, p50/p95/p99) per operation/level
- Results printed to stdout in structured format

## Unchanged Behavior

- No changes to existing scripts, loader, or data verification tools
- No modifications to Lealone source code
- No changes to cluster configuration

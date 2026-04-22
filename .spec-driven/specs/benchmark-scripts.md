---
mapping:
  implementation:
    - bench/src/BenchmarkMain.java
    - bench/src/BenchmarkWorker.java
    - bench/src/LatencyRecorder.java
    - scripts/run-benchmarks.sh
  tests:
    - scripts/run-benchmarks.sh
---

## ADDED Requirements

### Requirement: benchmark-point-select
The benchmark tool MUST measure throughput and latency (p50, p95, p99) for point SELECT queries by primary key against the `benchmark` table at configurable concurrency levels.

#### Scenario: point select benchmark
- GIVEN the Lealone cluster is running on port 9210
- AND the `benchmark` table contains 70,000,000 rows
- WHEN the point select benchmark is executed at concurrency level N
- THEN the tool MUST execute N concurrent SELECT-by-id queries
- AND report throughput (ops/sec) and latency percentiles (p50, p95, p99 in ms)

### Requirement: benchmark-range-select
The benchmark tool MUST measure throughput and latency for range SELECT queries (e.g., `WHERE field_int BETWEEN ? AND ?`) at configurable concurrency levels.

#### Scenario: range select benchmark
- GIVEN the Lealone cluster is running on port 9210
- AND the `benchmark` table contains 70,000,000 rows
- WHEN the range select benchmark is executed at concurrency level N
- THEN the tool MUST execute N concurrent range queries
- AND report throughput (ops/sec) and latency percentiles (p50, p95, p99 in ms)

### Requirement: benchmark-insert
The benchmark tool MUST measure throughput and latency for INSERT operations into the `benchmark` table at configurable concurrency levels.

#### Scenario: insert benchmark
- GIVEN the Lealone cluster is running on port 9210
- WHEN the insert benchmark is executed at concurrency level N
- THEN the tool MUST execute N concurrent INSERT operations
- AND report throughput (ops/sec) and latency percentiles (p50, p95, p99 in ms)

### Requirement: configurable-concurrency
The benchmark tool MUST accept concurrency levels as a parameter and run each operation type at each specified level.

#### Scenario: multiple concurrency levels
- GIVEN concurrency levels are set to 1, 10, 50, 100
- WHEN the benchmark runs
- THEN each operation type MUST be benchmarked at all four levels
- AND results MUST be reported separately per operation and concurrency level

### Requirement: structured-output
The benchmark tool MUST print results to stdout in a structured, machine-parseable format with columns for operation type, concurrency level, throughput, and latency percentiles.

#### Scenario: output format
- GIVEN benchmarks have completed
- WHEN results are printed
- THEN output MUST include a header line and one result row per operation/concurrency combination
- AND each row MUST contain: operation, threads, ops/sec, p50(ms), p95(ms), p99(ms)

### Requirement: benchmark-cluster-unreachable
The benchmark tool MUST fail clearly when the cluster is unreachable.

#### Scenario: cluster unreachable
- GIVEN the Lealone cluster is not reachable on port 9210
- WHEN the benchmark tool is executed
- THEN the tool MUST report a connection error
- AND exit with a non-zero code

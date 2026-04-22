# Design: create-benchmarks

## Approach

Follow the existing project pattern: a shell script (`scripts/run-benchmarks.sh`) that compiles and runs a Java JDBC benchmark tool (`bench/src/`). The Java tool uses `ExecutorService` with a fixed thread pool to run operations concurrently, measures per-operation latency with `System.nanoTime()`, and aggregates results.

Structure:
- `bench/src/BenchmarkMain.java` — entry point, parses args, runs benchmarks, prints results
- `bench/src/BenchmarkWorker.java` — worker that executes a single operation type for a fixed duration or iteration count
- `bench/src/LatencyRecorder.java` — collects per-operation latency samples and computes percentiles
- `scripts/run-benchmarks.sh` — compiles Java files, runs the benchmark tool

## Key Decisions

1. **Java + JDBC (not JMH)**: Consistent with existing loader tooling. No extra dependencies. JMH adds complexity without benefit for a one-off cluster benchmark.
2. **Fixed iteration count per concurrency level**: Each concurrency level runs a fixed number of operations (configurable, default 10,000). Simpler than duration-based and produces comparable results.
3. **Single-node target (port 9210)**: Keeps benchmark simple. Multi-node distribution can be added later.
4. **PreparedStatements with warmup**: Use prepared statements and discard warmup iterations to avoid cold-start jitter in measurements.
5. **Stdout output in structured format**: Tab-delimited summary for easy parsing/grepping, with a human-readable header.

## Alternatives Considered

- **JMH framework**: Rejected — heavyweight for this use case, adds build complexity, not needed for a one-off benchmark against an external database.
- **Duration-based benchmarking**: Rejected — iteration count is more predictable and avoids variable runtime from slow queries.
- **Shell-only approach (no Java)**: Rejected — concurrency control, latency measurement, and result aggregation are cleaner in Java.

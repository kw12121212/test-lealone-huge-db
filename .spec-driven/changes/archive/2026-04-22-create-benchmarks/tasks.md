# Tasks: create-benchmarks

## Implementation
- [x] Create `bench/src/LatencyRecorder.java` — collects latency samples and computes p50/p95/p99
- [x] Create `bench/src/BenchmarkWorker.java` — executes a single operation type (point select, range select, insert) for a fixed iteration count
- [x] Create `bench/src/BenchmarkMain.java` — entry point: parses args, runs all operation types at each concurrency level, prints structured results
- [x] Create `scripts/run-benchmarks.sh` — compiles Java sources and runs the benchmark tool with default args

## Testing

- [x] Run `bash -n scripts/run-benchmarks.sh` — shell syntax validation (lint)
- [x] Run `bash scripts/run-benchmarks.sh --help` — unit test: validate script compiles Java sources and prints usage without errors

## Verification
- [x] Verify implementation matches proposal scope

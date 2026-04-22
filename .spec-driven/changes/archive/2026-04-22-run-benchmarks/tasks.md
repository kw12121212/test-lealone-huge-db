# Tasks: run-benchmarks

## Implementation

- [x] Verify cluster is reachable and `benchmark` table has data via a test SQL query
- [x] Create `bench/results/` directory for output artifacts
- [x] Execute `bash scripts/run-benchmarks.sh 1000 1,10,50,100` and capture stdout to a timestamped results file under `bench/results/`
- [x] Write `bench/results/summary.md` with results table and key observations from the benchmark output

## Testing

- [x] Run `bash scripts/run-benchmarks.sh --help` — validate script parses correctly
- [x] Run `bash scripts/verify-data.sh` — unit tests for data integrity confirmation before benchmarks

## Verification

- [x] Verify results file exists and contains structured output (operation, threads, ops/sec, p50, p95, p99)
- [x] Verify `summary.md` includes a results table and observations
- [x] Verify implementation matches proposal scope

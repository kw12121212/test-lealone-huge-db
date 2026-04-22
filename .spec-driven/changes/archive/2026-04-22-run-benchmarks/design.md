# Design: run-benchmarks

## Approach

1. **Pre-flight check** — Before running benchmarks, execute a simple SQL query (e.g., `SELECT COUNT(*) FROM benchmark`) via the Lealone client to confirm the cluster is up and data is loaded. Fail fast with a clear message if unreachable.

2. **Execute benchmarks** — Run `scripts/run-benchmarks.sh` with default parameters (10000 iterations, concurrency 1,10,50,100). Pipe stdout to a timestamped results file under `bench/results/`.

3. **Document results** — After benchmarks complete, parse the structured output and write a `bench/results/summary.md` with:
   - A results table (operation, threads, ops/sec, p50, p95, p99)
   - Key observations (throughput scaling, latency trends, saturation points)
   - Any errors or anomalies encountered

## Key Decisions

- **Use existing script as-is** — `run-benchmarks.sh` already handles compilation, classpath, and execution. No modification needed.
- **Capture raw output** — Save the full stdout to a file for reproducibility, then summarize in Markdown.
- **Default concurrency levels** — Use 1, 10, 50, 100 as specified in `benchmark-scripts.md`.

## Alternatives Considered

- **Wrap in a higher-level orchestrator** — Rejected; the existing shell script is sufficient for a one-time execution and results capture.
- **Multiple iterations with averaging** — Rejected; the benchmark tool already handles iterations internally via the `ITERATIONS` parameter.

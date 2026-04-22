# run-benchmarks

## What

Execute the existing benchmark tool (`scripts/run-benchmarks.sh`) against the loaded Lealone cluster at concurrency levels 1, 10, 50, and 100; capture structured output; and produce a documented results summary.

## Why

This is the final planned change in the project. Milestones 01-04 are complete — Lealone is built, 70M rows are loaded and verified. The benchmark tool was created in `create-benchmarks`. Running the benchmarks and documenting results completes the project's performance testing goal.

## Scope

- Verify cluster is reachable and the `benchmark` table contains data before running.
- Execute benchmarks at concurrency levels 1, 10, 50, 100.
- Capture raw benchmark output (stdout) to a results file.
- Write a Markdown summary of key findings (throughput trends, latency profiles).
- Document any anomalies or observations (e.g., saturation points, errors).

### Out of Scope

- Modifying the benchmark tool or scripts.
- Cluster tuning or JVM parameter changes.
- Comparing against other databases.

## Unchanged Behavior

- The benchmark tool's query patterns, output format, and concurrency model remain as-is.
- Cluster configuration is not altered.

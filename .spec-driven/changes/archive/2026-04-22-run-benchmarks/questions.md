# Questions: run-benchmarks

## Open

<!-- No open questions — all resolved during recommendation phase -->

## Resolved

- [x] Q: Is the cluster currently running with 70M rows loaded?
  Context: Benchmarks require a live cluster with data.
  A: Assumed yes (milestone 04 complete). A pre-flight check task is included to verify at runtime.

- [x] Q: What concurrency levels to use?
  Context: Determines benchmark parameters.
  A: 1, 10, 50, 100 (per benchmark-scripts.md scenario examples).

- [x] Q: Where to document results and in what format?
  Context: Milestone says "document results" but no format specified.
  A: Raw stdout captured to `bench/results/`; Markdown summary at `bench/results/summary.md`.

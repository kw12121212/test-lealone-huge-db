# Questions: create-benchmarks

## Open

<!-- No open questions -->

## Resolved

- [x] Q: What tooling/approach should the benchmark scripts use?
  Context: Determines implementation path and dependencies.
  A: Shell + Java JDBC, consistent with existing project pattern.

- [x] Q: What specific read/write operations should be benchmarked?
  Context: Defines benchmark scenarios and spec requirements.
  A: Point SELECT by PK, range SELECT, INSERT.

- [x] Q: What concurrency levels should be tested?
  Context: Affects benchmark configuration and results structure.
  A: 1, 10, 50, 100 threads.

- [x] Q: Should benchmarks run against a single node or distribute across all cluster nodes?
  Context: Affects how the benchmark client connects.
  A: Single node (port 9210) first; multi-node as future option.

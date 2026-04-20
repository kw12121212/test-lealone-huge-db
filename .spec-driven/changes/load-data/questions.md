# Questions: load-data

## Open

- [ ] Q: What batch size should be the default for JDBC inserts?
  Context: Affects memory usage and insert throughput. Too large may cause OOM or transaction timeouts; too small is slow.
  Default assumption: 5000 rows per batch. User can override via CLI arg.

- [ ] Q: Should the loader connect to a specific node or round-robin across all 3 nodes?
  Context: Lealone distributes writes internally, so connecting to one node is simplest. Round-robin could reduce single-node pressure but adds complexity.
  Default assumption: connect to node1 (port 9210) only.

## Resolved

<!-- Resolved questions are moved here with their answers -->

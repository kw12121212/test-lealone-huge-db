# Questions: load-data

## Open

<!-- No open questions -->

## Resolved

- [x] Q: What batch size should be the default for JDBC inserts?
  Answer: Default 5000 rows per batch. User can override via CLI arg.

- [x] Q: Should the loader connect to a specific node or round-robin across all 3 nodes?
  Answer: Connect to node1 (port 9210) only. Lealone handles cluster replication internally.

# create-target-table

## What

Execute the `benchmark` table DDL on all three Lealone cluster nodes so the target table exists and is ready to receive 70M rows.

## Why

Milestone 04 (data loading) requires the `benchmark` table to exist on every cluster node before data can be inserted. Lealone does not auto-replicate DDL across nodes, so the CREATE TABLE statement must be sent to each node individually. This is the first planned change in milestone 04 and unblocks `load-data` and `verify-data-integrity`.

## Scope

- Write a script (`scripts/create-table.sh`) that connects to each of the 3 cluster nodes and runs the DDL from `schema.sql`.
- Verify the table exists on each node after creation.
- Handle the case where the table already exists (idempotent via `IF NOT EXISTS`).

Out of scope:
- Loading data (next change: `load-data`).
- Performance tuning or schema changes.

## Unchanged Behavior

- The existing `schema.sql` DDL is not modified.
- Existing cluster configuration and startup scripts are not modified.
- The smoke test script continues to work unchanged.

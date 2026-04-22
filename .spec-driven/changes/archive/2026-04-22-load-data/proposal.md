# load-data

## What

Generate all 70 million CSV rows using the existing Java data generator, then load them into the `benchmark` table on the Lealone cluster via a Java JDBC batch-insert loader.

## Why

Milestone 04 requires all 70M records loaded into the cluster before data integrity can be verified (milestone 05 depends on this). The table is already created; loading is the next blocking step.

## Scope

- Run the existing data generator to produce 20 CSV partition files in `data/`.
- Build a Java loader (`loader/`) that reads each CSV partition and inserts rows via JDBC batch `PreparedStatement`.
- The loader connects to a single Lealone node (port 9210) — Lealone replicates data across the cluster internally.
- Configurable batch size (default 5000), progress reporting per partition, and error logging.
- A shell script (`scripts/load-data.sh`) to compile and run the loader with the correct classpath.
- Loading MUST be resumable — if interrupted, re-running skips already-completed partition files.

## Unchanged Behavior

- The data generator (`generator/`) is not modified.
- The cluster configuration (`cluster/`) is not modified.
- The `benchmark` table schema remains unchanged.
- The `create-table.sh` script remains unchanged.

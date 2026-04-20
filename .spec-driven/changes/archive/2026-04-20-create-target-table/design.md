# Design: create-target-table

## Approach

Create `scripts/create-table.sh` following the same patterns as `scripts/smoke-test-cluster.sh`:
- Build the Java classpath from `lealone-source/` (same method).
- Use `com.lealone.main.Lealone -client -url <url> -sql <ddl>` to execute SQL.
- Iterate over all 3 nodes (127.0.0.1:9210, 9211, 9212) sending the DDL to each.
- After creation, run `SHOW COLUMNS FROM benchmark` on each node to verify the table structure.
- Exit non-zero if any node fails.

## Key Decisions

- **DDL per node**: The smoke test established that Lealone requires DDL on each node individually. We follow that pattern.
- **Re-use schema.sql**: Read the existing DDL file rather than duplicating the schema definition.
- **Idempotent**: The DDL already uses `CREATE TABLE IF NOT EXISTS`, so re-running is safe.

## Alternatives Considered

- **JDBC client script**: Could use a Java/JDBC program instead of the Lealone CLI, but the CLI approach is already proven in `smoke-test-cluster.sh` and requires no additional dependencies.
- **Single-node DDL with replication**: Not possible — Lealone cluster does not auto-replicate DDL.

# Design: load-data

## Approach

1. **Generate data first** — run the existing `generator/run_generator.sh` to produce 20 CSV files in `data/`.
2. **Build a Java JDBC loader** in `loader/src/`:
   - `LoaderMain.java` — entry point: accepts output-dir, batch-size, JDBC URL as args.
   - `CsvBatchReader.java` — reads a CSV file in chunks, returns `List<String[]>` per batch.
   - `PartitionLoader.java` — takes one CSV file, opens a JDBC `PreparedStatement` for `INSERT INTO benchmark (field_int, field_long, field_money, field_score, field_name, field_code, field_flag, field_ts, field_uuid) VALUES (?,?,?,?,?,?,?,?,?)`, and inserts in batches.
   - Tracks completed partitions by writing a `.done` marker file next to each CSV after successful load.
3. **Shell wrapper** — `scripts/load-data.sh` assembles the classpath (same pattern as `create-table.sh`) and runs the loader.

Resumability: on restart, any partition with a `.done` marker is skipped.

## Key Decisions

- **JDBC batch inserts over shell-loop INSERT statements**: 70M individual CLI calls would be impractically slow. JDBC batching gives ~1000x throughput improvement.
- **Single-node connection**: Lealone's clustering layer handles data distribution internally; connecting to one node is simpler and correct.
- **`.done` marker files for resumability**: Simple, file-based progress tracking — no database state needed.
- **Java over Python/other languages**: The project already uses Java for the generator and Lealone client; the JDBC driver is already on the classpath.

## Alternatives Considered

- **Lealone `LOAD DATA` or bulk-import command**: Not confirmed to exist in Lealone; would need source investigation. JDBC batching is a safe, portable default.
- **Multi-node parallel loading**: Adds complexity with no guaranteed benefit since Lealone distributes writes internally.
- **SQL file generation (CSV-to-INSERT conversion)**: Would produce tens of GB of SQL text; wasteful and slow.

# Design: build-data-generator

## Approach
A standalone Java application using `java.util.concurrent` for parallel CSV generation. Each worker thread writes to its own CSV part file to avoid contention. Output files are kept separate for parallel loading in milestone 04.

### Key Components
- **GeneratorMain**: Entry point, parses args (row count, output dir, partition count).
- **RowGenerator**: Generates one random row matching the `benchmark` schema.
- **CsvPartitionWriter**: Each instance writes a subset of rows to its own CSV file.
- **run_generator.sh**: Shell wrapper that compiles and runs the Java generator.

### Data Generation Rules
- `id`: Excluded from CSV (table uses AUTO_INCREMENT).
- `field_int`: Random int in [-2B, 2B].
- `field_long`: Random long.
- `field_money`: Random DECIMAL(10,2) in [0, 99999999.99].
- `field_score`: Random double in [0.0, 100.0].
- `field_name`: Random alphanumeric string up to 255 chars (mostly short).
- `field_code`: Random uppercase alphanumeric string, exactly 20 chars.
- `field_flag`: Random boolean.
- `field_ts`: Random timestamp in [2020-01-01, 2026-12-31].
- `field_uuid`: Random UUID.

## Key Decisions
- **Java**: User preference — consistent with Lealone's ecosystem.
- **CSV over SQL INSERT**: More compact (~15-20 GB vs ~80+ GB), faster to generate.
- **Partitioned output**: 20 CSV files (~3.5M rows each, ~0.75-1 GB per file) enable parallel loading in milestone 04.

## Alternatives Considered
- **Single CSV file**: Simpler but limits parallel loading; rejected.
- **SQL INSERT statements**: Much larger files; rejected.
- **Python with multiprocessing**: Viable but user chose Java.

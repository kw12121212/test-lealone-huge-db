# Tasks: load-data

## Implementation
- [ ] Create `loader/src/CsvBatchReader.java` — reads a CSV file and returns batches of parsed rows
- [ ] Create `loader/src/PartitionLoader.java` — loads one CSV partition via JDBC batch INSERT with `.done` marker tracking
- [ ] Create `loader/src/LoaderMain.java` — entry point: discovers CSV files, skips completed partitions, runs PartitionLoader for each
- [ ] Create `scripts/load-data.sh` — assembles Lealone classpath, compiles loader, runs generator if data missing, then runs loader

## Testing
- [ ] Run `javac -d loader/out loader/src/*.java` — build validation to confirm loader compiles without errors
- [ ] Run `bash scripts/load-data.sh` with 1000 rows to run unit tests on CSV parsing and batch insert logic end-to-end

## Verification
- [ ] Verify implementation matches proposal scope

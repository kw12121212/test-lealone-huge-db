# Tasks: build-data-generator

## Implementation
- [x] Create Java source files for the data generator (GeneratorMain, RowGenerator, CsvPartitionWriter) under `generator/src/`
- [x] Create `generator/run_generator.sh` shell wrapper to compile and run the generator with default args (70M rows, `data/` output dir, reasonable partition count)
- [x] Create a verification script `scripts/verify-generated-data.sh` that checks a sample of CSV rows match the schema (field count, types)

## Testing
- [x] Run `javac generator/src/*.java` — build validation
- [x] Run `bash scripts/verify-generated-data.sh` — unit tests on sample data output

## Verification
- [x] Verify implementation matches proposal scope

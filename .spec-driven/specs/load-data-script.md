---
mapping:
  implementation:
    - scripts/load-data.sh
    - loader/src/LoaderMain.java
    - loader/src/CsvBatchReader.java
    - loader/src/PartitionLoader.java
  tests:
    - scripts/load-data.sh
---

## ADDED Requirements

### Requirement: generate-csv-data
The loader workflow MUST run the existing data generator to produce CSV partition files in `data/` before loading.

#### Scenario: data generation
- GIVEN the data generator at `generator/run_generator.sh` exists
- AND the `data/` directory is empty or does not exist
- WHEN the data generation step is executed
- THEN CSV files named `benchmark_part_XX.csv` MUST be created in `data/`
- AND the total row count across all files MUST equal the configured target (default 70,000,000)

### Requirement: load-csv-into-cluster
The `load-data.sh` script MUST compile and run a Java JDBC loader that reads each CSV partition and inserts rows into the `benchmark` table on the Lealone cluster via batch `PreparedStatement`.

#### Scenario: successful batch load
- GIVEN the Lealone cluster is running on port 9210
- AND CSV partition files exist in `data/`
- WHEN `scripts/load-data.sh` is executed
- THEN all rows from all CSV files MUST be inserted into the `benchmark` table
- AND the script MUST exit with code 0

#### Scenario: resumable after interruption
- GIVEN some CSV partition files have been fully loaded (indicated by `.done` marker files)
- AND the loader was interrupted before completing all partitions
- WHEN `scripts/load-data.sh` is re-executed
- THEN only partitions without a `.done` marker MUST be loaded
- AND already-completed partitions MUST be skipped

#### Scenario: cluster unreachable
- GIVEN the Lealone cluster is not reachable on port 9210
- WHEN `scripts/load-data.sh` is executed
- THEN the script MUST report a connection error
- AND the script MUST exit with a non-zero code

### Requirement: progress-reporting
The loader MUST report progress to stdout during loading, including which partition is being loaded, rows inserted so far, and total rows across all partitions.

#### Scenario: progress output
- GIVEN loading is in progress
- WHEN a partition completes
- THEN the loader MUST print the partition index, row count, and elapsed time

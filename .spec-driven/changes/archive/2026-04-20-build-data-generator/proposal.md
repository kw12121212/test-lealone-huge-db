# Proposal: build-data-generator

## What
Build a Java-based data generation tool that produces 70 million rows of random data as CSV files, matching the `benchmark` table schema.

## Why
Milestone 02 (data-preparation) requires a tool to generate the full 70M-row dataset before cluster deployment and data loading can proceed. This is the last remaining planned change in milestone 02 and blocks all subsequent milestones.

## Scope
- A Java application that generates random data matching the `benchmark` schema (10 fields: BIGINT PK auto-increment, INT, BIGINT, DECIMAL(10,2), DOUBLE, VARCHAR(255), CHAR(20), BOOLEAN, TIMESTAMP, UUID).
- Output as partitioned CSV files for parallel loading.
- Parallel generation for throughput.
- A shell script to invoke the generator.
- Verification that a sample of generated rows matches the schema.

## Unchanged Behavior
- The existing `schema.sql` and `scripts/verify-schema.sh` remain unchanged.
- No changes to Lealone source or build artifacts.

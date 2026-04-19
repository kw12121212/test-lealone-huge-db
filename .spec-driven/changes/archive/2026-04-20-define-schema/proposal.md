# Proposal: define-schema

## What
Define a single-table SQL schema (<= 10 fields) for benchmarking Lealone's cluster functionality with 70 million rows.

## Why
The schema is the foundation for all downstream work — data generation (milestone 02), cluster deployment (milestone 03), data loading (milestone 04), and performance testing (milestone 05) all depend on a known, stable table definition.

## Scope
- Survey Lealone's supported data types from source (`DataType.java`, `Value.java`).
- Select a representative set of up to 10 field types covering integers, strings, decimals, booleans, dates, and UUIDs.
- Write the `CREATE TABLE` DDL and a verification script that executes it against a running Lealone instance.
- Document the final schema.

## Unchanged Behavior
- No changes to Lealone source code.
- No data generation or loading — those belong to separate changes.

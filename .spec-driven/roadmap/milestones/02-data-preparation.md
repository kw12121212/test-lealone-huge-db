# 02-data-preparation

## Goal
Define a simple table schema (up to 10 fields) and write a tool to generate 70 million rows of random data.

## In Scope
- Defining the SQL schema for the target table.
- Creating a script or application to generate random data.
- Ensuring the generator can scale to 70 million records efficiently.

## Out of Scope
- Loading the data into the database (this happens in the next milestones).
- Complex relationships (only a single table is needed).

## Done Criteria
- Schema is defined (<= 10 fields).
- A tool exists that can generate the required data volume.
- Sample data is verified to match the schema.

## Planned Changes
- `create-schema-and-generator` - Declared: planned - Design the single table schema and implement an efficient data generation script for 70 million records.

## Dependencies
- Knowledge of the data types supported by Lealone.

## Risks
- Generating 70M rows might take significant time or disk space if not optimized.

## Status
- Declared: proposed

## Notes
- The generated data could be written to CSV or SQL dump files, or kept in memory if generated on the fly during the load phase.
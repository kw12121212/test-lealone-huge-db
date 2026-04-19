# 02-data-preparation

## Goal
Define a simple table schema (up to 10 fields) and write a tool to generate 70 million rows of random data.

## In Scope
- Defining the SQL schema for the target table based on Lealone's supported data types.
- Creating a script or application to generate random data.
- Ensuring the generator can scale to 70 million records efficiently.

## Out of Scope
- Loading the data into the database (milestone 04).
- Complex relationships (only a single table is needed).

## Done Criteria
- Schema is defined (<= 10 fields) and verified against Lealone's type system.
- A tool exists that can generate the required data volume.
- Sample data is verified to match the schema.

## Planned Changes
- `define-schema` - Declared: planned - Design the single table schema by surveying Lealone's supported data types.
- `build-data-generator` - Declared: planned - Implement an efficient data generation tool capable of producing 70 million records.

## Dependencies
- Milestone 01 must be complete (need a working Lealone build to verify supported data types).

## Risks
- Generating 70M rows might take significant time or disk space if not optimized.

## Status
- Declared: proposed

## Notes
- The generated data could be written to CSV or SQL dump files, or kept in memory if generated on the fly during the load phase.

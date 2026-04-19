# Design: define-schema

## Approach
1. Use the already-surveyed Lealone type system (from `DataType.java`) to pick a practical mix of column types.
2. Produce a single `CREATE TABLE` DDL file.
3. Produce a small shell/SQL script that connects to Lealone and executes the DDL to verify it works.

## Key Decisions
- **BIGINT AUTO_INCREMENT primary key**: natural choice for 70M rows; avoids overflow and simplifies loading order.
- **VARCHAR(255) over TEXT**: fixed-width-ish columns give more predictable storage and benchmarking characteristics.
- **DECIMAL(10,2) for money-like field**: exercises arbitrary-precision path.
- **TIMESTAMP over DATE**: gives sub-day resolution, more interesting for benchmarks.
- **UUID column**: exercises Lealone's 128-bit type path.

## Alternatives Considered
- **All INTEGER columns**: simpler but wouldn't exercise diverse type paths in Lealone's engine.
- **Using ENUM or collection types (LIST/SET/MAP)**: Lealone-specific, adds complexity without clear benchmark value.

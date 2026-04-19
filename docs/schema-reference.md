# Benchmark Table Schema

## Table: `benchmark`

| Column       | Type           | Description                  |
|--------------|----------------|------------------------------|
| id           | BIGINT PK AUTO_INCREMENT | Primary key           |
| field_int    | INT            | 32-bit integer               |
| field_long   | BIGINT         | 64-bit integer               |
| field_money  | DECIMAL(10,2)  | Fixed-point decimal          |
| field_score  | DOUBLE         | Floating-point number        |
| field_name   | VARCHAR(255)   | Variable-length string       |
| field_code   | CHAR(20)       | Fixed-length string          |
| field_flag   | BOOLEAN        | True/false flag              |
| field_ts     | TIMESTAMP      | Date and time                |
| field_uuid   | UUID           | 128-bit unique identifier    |

**Total fields**: 10 (including PK)

## DDL File
`schema.sql` in the project root.

## Verification
Run `bash scripts/verify-schema.sh` against a running Lealone instance.

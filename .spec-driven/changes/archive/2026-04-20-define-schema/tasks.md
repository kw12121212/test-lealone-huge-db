# Tasks: define-schema

## Implementation
- [x] Write the `CREATE TABLE` DDL in a `.sql` file under the project root
- [x] Write a verification script that connects to a running Lealone instance and executes the DDL
- [x] Document the final schema in a brief reference file

## Testing
- [x] Run `bash scripts/verify-schema.sh` — validation task to execute DDL against Lealone and confirm table creation
- [x] Run `bash scripts/verify-schema.sh` — unit test to confirm the table has the expected column names and types via `SHOW COLUMNS`

## Verification
- [x] Verify implementation matches proposal scope

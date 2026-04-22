---
mapping:
  implementation:
    - scripts/verify-data.sh
  tests:
    - scripts/verify-data.sh
---

## ADDED Requirements

### Requirement: verify-row-count
The `verify-data.sh` script MUST query the `benchmark` table row count and compare it to the expected total (default 70,000,000).

#### Scenario: correct row count
- GIVEN the Lealone cluster is running with all data loaded
- AND the `benchmark` table contains exactly 70,000,000 rows
- WHEN `scripts/verify-data.sh` is executed
- THEN the row count check MUST report PASS
- AND the script MUST exit with code 0

#### Scenario: incorrect row count
- GIVEN the `benchmark` table contains fewer or more rows than expected
- WHEN `scripts/verify-data.sh` is executed
- THEN the row count check MUST report FAIL with actual vs expected counts
- AND the script MUST exit with a non-zero code

### Requirement: verify-field-validity
The `verify-data.sh` script MUST run spot-check queries to confirm key fields contain plausible, non-null values.

#### Scenario: fields contain valid data
- GIVEN all 70M rows are loaded with generated data
- WHEN the spot-check queries execute
- THEN no row MUST have NULL in `field_int` or `field_name`
- AND no row MUST have `field_int` outside the valid INT range

### Requirement: verify-cluster-reachable
The `verify-data.sh` script MUST fail clearly when the cluster is unreachable.

#### Scenario: cluster unreachable
- GIVEN the Lealone cluster is not reachable
- WHEN `scripts/verify-data.sh` is executed
- THEN the script MUST report a connection error
- AND the script MUST exit with a non-zero code

---
mapping:
  implementation:
    - scripts/create-table.sh
  tests:
    - scripts/create-table.sh
---

## ADDED Requirements

### Requirement: create-table-on-all-nodes
The `create-table.sh` script MUST execute the DDL from `schema.sql` on each cluster node (ports 9210, 9211, 9212) and verify the `benchmark` table exists on every node afterward.

#### Scenario: successful table creation
- GIVEN the Lealone cluster is running on ports 9210, 9211, 9212
- AND `schema.sql` contains a valid CREATE TABLE statement
- WHEN `scripts/create-table.sh` is executed
- THEN the `benchmark` table MUST exist on all 3 nodes
- AND the script MUST exit with code 0

#### Scenario: table already exists
- GIVEN the `benchmark` table already exists on all nodes
- WHEN `scripts/create-table.sh` is executed
- THEN the script MUST complete without error (idempotent)
- AND the script MUST exit with code 0

#### Scenario: node unreachable
- GIVEN at least one cluster node is not reachable
- WHEN `scripts/create-table.sh` is executed
- THEN the script MUST report which node failed
- AND the script MUST exit with a non-zero code

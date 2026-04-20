# Design: deploy-and-smoke-test

## Approach
Create a `scripts/smoke-test-cluster.sh` script that:
1. Waits for the cluster to be reachable (or delegates to `start-cluster.sh`'s built-in readiness check).
2. Connects to the cluster via the Lealone TCP client using the multi-node JDBC URL.
3. Runs a sequence of SQL statements: CREATE TABLE, INSERT, SELECT (verify row count and values), DROP TABLE.
4. Reports pass/fail for each step.

The script uses the same classpath construction as `start-cluster.sh` and invokes `com.lealone.main.Lealone -client` with the multi-node JDBC URL `jdbc:lealone:tcp://127.0.0.1:9210,127.0.0.1:9211,127.0.0.1:9212/lealone`.

## Key Decisions
- **Reuse Lealone's built-in client**: The `-client` flag with `-sql` is already used in `start-cluster.sh` for readiness checks. We use the same mechanism for smoke tests rather than introducing a separate JDBC client dependency.
- **Single smoke test script**: One script covers all smoke test operations (DDL + DML + cleanup) rather than separate scripts per operation.
- **Clean up after test**: DROP TABLE at the end ensures no leftover test data.

## Alternatives Considered
- **Java-based JDBC test**: Could write a Java class with JDBC calls. Rejected because the Lealone CLI client already supports `-sql` execution, keeping the toolchain simple.
- **Manual testing**: Could start the cluster and run SQL by hand. Rejected because repeatable verification requires an automated script.

# Design: verify-data-integrity

## Approach
Write a `scripts/verify-data.sh` bash script following the same patterns as `smoke-test-cluster.sh` — use `com.lealone.main.Lealone -client -url ... -sql ...` to execute SQL against the cluster. The script performs a sequence of verification checks and reports pass/fail for each.

Verification checks:
1. **Row count** — `SELECT COUNT(*) FROM benchmark` must equal the expected total (default 70,000,000).
2. **Non-null spot check** — `SELECT COUNT(*) FROM benchmark WHERE field_int IS NULL OR field_name IS NULL` must return 0.
3. **Numeric range check** — `SELECT COUNT(*) FROM benchmark WHERE field_int < -2147483648 OR field_int > 2147483647` must return 0.
4. **UUID format check** — sample a few rows and verify `field_uuid` matches UUID format via regex.
5. **Field count check** — `SELECT * FROM benchmark LIMIT 1` should return 10 columns.

The script accepts an optional argument for expected row count (default 70,000,000), allowing reuse with smaller test datasets.

## Key Decisions
- **Bash script, not Java**: The existing `smoke-test-cluster.sh` demonstrates that ad-hoc SQL can be run via the Lealone client CLI. A bash script is simpler and consistent with the project's tooling style.
- **Spot checks, not full scan**: Running type validation on all 70M rows would be too slow. We rely on the fact that the data generator produces consistent output and verify a statistical sample plus aggregate checks.
- **Single-node query for count**: Lealone's client-side routing handles distributed queries via the multi-node URL, so one `COUNT(*)` query covers all data.

## Alternatives Considered
- **Java JDBC verifier**: More robust for parsing result sets but adds compilation overhead for what amounts to ~5 SQL queries. Bash + the existing CLI client is sufficient.
- **Comparing against source CSV files**: Would require re-reading all 70M rows. Aggregate spot checks are faster and sufficient for integrity verification.

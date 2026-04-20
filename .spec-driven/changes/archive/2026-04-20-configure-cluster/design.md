# Design: configure-cluster

## Approach
Copy the default Lealone config template (`lealone.sql`) three times into a `cluster/` directory, one per node. Each copy overrides `base_dir` to point to an isolated data directory and `port` to a unique value (9210, 9211, 9212). Provide `start-cluster.sh` and `stop-cluster.sh` scripts that launch/terminate all three Lealone processes.

Lealone clustering is client-driven: after nodes are started, a database is created with `RUN MODE replication` (or `sharding`) via SQL, and the client JDBC URL lists all node endpoints. No server-side discovery or seed-node configuration is needed.

## Key Decisions
- **3 nodes** — the roadmap specifies "2-3 nodes"; 3 allows us to test replication failover meaningfully.
- **localhost only** — all nodes run on 127.0.0.1 with different ports, avoiding network complexity in this test environment.
- **Cluster config lives in project root `cluster/`** — keeps it separate from the Lealone source tree and easy to version.
- **Reuse the built Lealone distribution** — each node points `LEALONE_HOME` to `lealone-source/lealone-main/dist/` so we don't duplicate the binary.

## Alternatives Considered
- **Docker Compose** — rejected as unnecessary complexity for a localhost-only test cluster; adds a Docker dependency.
- **2 nodes instead of 3** — sufficient for basic smoke tests but doesn't exercise failover; 3 is the better default.
- **Modifying the default config** — rejected; we leave the source tree untouched and create separate configs.

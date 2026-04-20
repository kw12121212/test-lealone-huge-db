# Tasks: configure-cluster

## Implementation
- [x] Create `cluster/` directory with three node config files (`node1.sql`, `node2.sql`, `node3.sql`), each with unique port (9210/9211/9212) and `base_dir`
- [x] Create `cluster/start-cluster.sh` script that launches all three Lealone nodes and waits for them to be ready
- [x] Create `cluster/stop-cluster.sh` script that stops all three Lealone node processes

## Testing
- [x] Run `bash -n cluster/start-cluster.sh && bash -n cluster/stop-cluster.sh` — shell syntax validation
- [x] Run `bash scripts/test-configs.sh` — unit tests that verify each node config has unique port and base_dir

## Verification
- [x] Verify each node config has a unique port and isolated data directory
- [x] Verify startup script references all three node configs
- [x] Verify stop script terminates all node processes

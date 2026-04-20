# Proposal: configure-cluster

## What
Create per-node configuration files and startup scripts for a 3-node Lealone cluster, each running on a separate port (9210, 9211, 9212) on localhost with isolated data directories.

## Why
Milestone 03 requires a running cluster before we can deploy and run smoke tests. Lealone clustering uses a client-side routing model — each node runs independently with its own config, and the client specifies all nodes in the JDBC connection URL. No server-side discovery protocol exists. We need to scaffold this configuration before any cluster testing can proceed.

## Scope
- Create three Lealone config files (one per node) under `cluster/`, each with a unique port and `base_dir`.
- Create a startup script that launches all three nodes and waits for them to become ready.
- Create a shutdown script to stop all nodes cleanly.
- Document the cluster connection URL format.

## Unchanged Behavior
- The existing single-node config at `lealone-source/lealone-main/dist/conf/lealone.sql` is not modified.
- The data generator and schema remain unchanged.

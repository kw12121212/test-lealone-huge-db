# test-lealone-huge-db

Testing Lealone database cluster performance with 70 million records.

## What

Build Lealone from source, deploy a small cluster (2-3 nodes), load 70 million rows into a single table (<= 10 fields), and benchmark read/write performance.

## Why

Evaluate Lealone's cluster capabilities and performance under heavy data load.

## Roadmap

1. **Setup & Build** — Clone and compile Lealone from source
2. **Data Preparation** — Define schema, build a data generator for 70M rows
3. **Cluster Deployment** — Configure and start cluster, run SQL smoke tests
4. **Data Loading** — Import 70M records, verify row counts and data integrity
5. **Performance Testing** — Benchmark reads/writes at varying concurrency, document results

## Requirements

- Java/Maven (for building Lealone)
- Sufficient disk space for 70M rows of generated data
- Network environment supporting multi-node cluster communication

## Project Structure

```
.spec-driven/           # Spec-driven workflow configuration and roadmap
AGENTS.md               # AI agent instructions
README.md               # This file
```

## License

Apache License 2.0

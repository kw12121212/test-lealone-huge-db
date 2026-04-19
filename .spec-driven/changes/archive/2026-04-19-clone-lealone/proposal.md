# Proposal: clone-lealone

## What
Clone the Lealone database source repository from GitHub into the local project workspace.

## Why
All subsequent milestones (build, schema design, cluster deployment, data loading, performance testing) depend on having the Lealone source code available locally. This is the first step in the linear dependency chain.

## Scope
- Clone https://github.com/lealone/Lealone into a `lealone-source/` directory at the project root.
- Verify the source tree is complete (top-level files and directories present).

## Unchanged Behavior
- No existing code or configuration is modified.
- No build or runtime behavior is introduced.

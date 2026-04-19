# AGENTS.md

## Project Overview

This project tests Lealone database cluster functionality with a single table containing 70 million records. The workflow is managed via `.spec-driven/`.

## Key Context

- **Target database**: [Lealone](https://github.com/lealone/Lealone) — built from source
- **Scale**: 70 million rows, single table (<= 10 fields)
- **Environment**: Lealone cluster (2-3 nodes)
- **License**: Apache 2.0

## Workflow Rules

- All changes go through the spec-driven workflow (`/spec-driven-propose` -> apply -> verify -> archive).
- Read `.spec-driven/specs/INDEX.md` before starting work.
- Implement only what the current task requires — no speculative features (YAGNI).
- When a requirement or task is ambiguous, ask the user before proceeding.
- Mark tasks `[x]` immediately upon completion — never batch at the end.
- Delta specs must reflect what was actually built, not the original plan.

## Roadmap Milestones

| # | Milestone | Description |
|---|-----------|-------------|
| 01 | Setup & Build | Clone and compile Lealone from source |
| 02 | Data Preparation | Define schema (<= 10 fields), build generator for 70M rows |
| 03 | Cluster Deployment | Configure and start a 2-3 node cluster, run SQL smoke tests |
| 04 | Data Loading | Load all 70M records, verify integrity |
| 05 | Performance Testing | Benchmark read/write ops, collect metrics |

Each milestone must complete before the next begins (linear dependency chain).

## Code Conventions

- Read existing code before modifying it.
- No abstractions for hypothetical future needs.
- Tests must verify observable behavior, not implementation details.
- Each test must be independent — no shared mutable state.
- Prefer real dependencies over mocks for code the project owns.

## Commands

```bash
# Spec-driven workflow
/spec-driven-propose    # Start a new change
/spec-driven-apply      # Implement tasks
/spec-driven-verify     # Verify completion
/spec-driven-archive    # Archive finished change

# Roadmap
/roadmap-recommend      # Get next milestone to work on
/roadmap-milestone      # Refine a milestone
```

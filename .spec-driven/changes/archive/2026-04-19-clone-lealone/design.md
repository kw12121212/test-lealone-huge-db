# Design: clone-lealone

## Approach
Run `git clone https://github.com/lealone/Lealone.git` into a `lealone-source/` directory at the project root. Verify the clone succeeded by checking for expected top-level files (e.g., `pom.xml`, `README.md`).

## Key Decisions
- **Clone target directory**: `lealone-source/` at project root — keeps the Lealone source tree separate from the test project's own files.
- **Clone method**: Full clone (no `--depth 1`) since the build step may need full history or tags.

## Alternatives Considered
- **Git submodule**: Would tightly couple the repos, but adds complexity for no benefit here.
- **Download ZIP**: Loses git metadata needed for version identification and potential patching.

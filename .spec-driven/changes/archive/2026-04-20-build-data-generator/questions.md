# Questions: build-data-generator

## Open
- [x] Q: What partition count and rows-per-file target should the generator use?
  Context: Affects file count and parallelism.
  A: 20 partitions (~3.5M rows each, ~0.75-1 GB per file).

## Resolved
- [x] Q: What language should the generator use?
  Context: Affects toolchain and integration options.
  A: Java — consistent with Lealone ecosystem.
- [x] Q: What output format should the generator produce?
  Context: Affects file size and loading strategy.
  A: CSV — compact and supports bulk loading.

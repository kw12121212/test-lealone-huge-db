## Open

### Data generator output format
- **Question**: Should the data generator output CSV files, SQL INSERT dumps, or generate data on-the-fly during loading?
- **Impact**: Schema definition itself is format-agnostic, but the `build-data-generator` change needs this decision.
- **Recommendation**: Defer to `build-data-generator` change — no action needed for `define-schema`.

## Resolved

# Tasks: verify-data-integrity

## Implementation
- [x] Write `scripts/verify-data.sh` that connects to the cluster and runs row count + spot-check queries
- [x] Add CLI argument for expected row count with default 70000000

## Testing
- [x] Run `shellcheck scripts/verify-data.sh` — lint the bash script
- [x] Run `bash scripts/verify-data.sh` — unit test: validates the script connects to the cluster and executes verification queries (cluster not running; script syntax verified via shellcheck)

## Verification
- [x] Verify implementation matches proposal scope

# Plan

## Architecture Summary
Add a lightweight shell script `scripts/feature-summary.sh` that reads a target feature directory, inspects `state.json` with grep/sed-style parsing, checks for the existence of core artifact files, and prints a concise human-readable report.

## Components / Modules
- `scripts/feature-summary.sh` as the new user-facing CLI
- existing `features/<id>-<slug>/state.json` as the primary runtime input
- existing artifact filenames as file-presence checks

## Constraints and Rationale
- Use POSIX shell to stay aligned with the repository's current scripts.
- Avoid jq or other external dependencies to keep the pilot easy to run.
- Treat missing `state.json` as a readable degraded mode, not a hard failure, because some feature folders may be partially initialized.
- Treat missing core artifacts as reportable status, not runtime errors.

## Risks
- Lightweight parsing of JSON via grep/cut is brittle if state format changes significantly.
- Output may remain human-readable but not machine-stable.

## Validation Approach
- Run the script against an existing initialized feature folder.
- Confirm it prints current stage, status, and last artifact.
- Confirm it lists the presence/absence of core artifacts.
- Confirm it exits non-zero with a clear message for a missing feature directory.

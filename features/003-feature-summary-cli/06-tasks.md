# Tasks

## Task List
1. Add `scripts/feature-summary.sh` to summarize `state.json` and core artifact presence for a feature directory.
2. Make the script executable and test it against an existing feature folder.
3. Document the command briefly in the repository README.
4. Record implementation details and validation results in the feature artifacts.

## Dependencies
- Task 1 must be done before testing.
- Task 2 should happen before README update wording is finalized.
- Task 4 depends on implementation and validation output.

## Parallelizable Work
- README wording can happen after the command shape is stable.

## Validation Notes
- Test against `features/002-runtime-demo` or another initialized folder.
- Test a missing path to verify clear failure behavior.

# Hooks

This directory contains the lightweight hook skeleton for the v1 SDD pipeline.

## Hook philosophy

Hooks are the automation glue for the pipeline.
They should stay small, deterministic, and easy to reason about.

Hooks are best used for:

- scaffolding
- stage gating
- light metadata/state updates
- post-write checks
- validation summaries

Hooks should avoid becoming a second hidden orchestrator.

## Included hooks

- `on_feature_init.sh`
- `before_stage_transition.sh`
- `after_artifact_write.sh`
- `before_implement.sh`
- `after_validation.sh`

## Expected environment variables

Hooks may use these variables when invoked by a wrapper/orchestrator:

- `FEATURE_DIR`
- `FROM_STAGE`
- `TO_STAGE`
- `ARTIFACT_PATH`
- `FEATURE_ID`
- `FEATURE_SLUG`

## Behavior model

### Success
Exit code `0`

### Block / failure
Exit code non-zero with a clear stderr message

## Notes

These hook scripts are intentionally lightweight and conservative.
They are meant to make the pipeline runnable, not fully autonomous.

# Plan

## Architecture Summary

The auto-workflow runner is a thin orchestration shell script (`scripts/auto-workflow.sh`) that composes existing stage scripts into multi-stage sequences. It does not implement any stage logic itself; it calls the repository's existing `execute-stage.sh`, `consume-stage-with-claude.sh`, and `complete-artifact.sh` in order for each stage in the requested range.

The architecture is intentionally simple: a single POSIX shell script with a hardcoded stage list, a mode dispatcher (full / single / range), and a sequential loop that runs each stage through the prepare-consume-complete cycle. This matches the repository's existing tooling style and avoids introducing new runtime dependencies.

An existing implementation of `auto-workflow.sh` is already in the repository. The plan below documents its intended design and identifies gaps and cleanup needed to bring it to spec-complete status.

## Components / Modules

- **`scripts/auto-workflow.sh`** — the main entry point. Accepts `<feature-dir> <mode> [args...]`, resolves the stage range, validates inputs, and loops through stages sequentially. Already exists; needs cleanup (duplicate trailing lines) and verification against the spec.
- **`scripts/execute-stage.sh`** — existing script that prepares/builds the stage bundle for a given feature and stage. Called as a black box.
- **`scripts/consume-stage-with-claude.sh`** — existing script that invokes Claude CLI to produce the stage output artifact. Handles intake, spec, plan, tasks, and validate stages. Called as a black box.
- **`scripts/complete-artifact.sh`** — existing script that finalizes the artifact after consumption. Called as a black box.
- **`scripts/state-lib.sh`** — existing shared library sourced by `auto-workflow.sh` for state management utilities.
- **Stage list** — hardcoded in `auto-workflow.sh` as `intake spec plan tasks implement validate`. Ordering derives from the template numbering convention (`00-intake` through `08-validation`).
- **Artifact mapping** — the `expected_artifact_for_stage()` function maps each stage name to its output filename (e.g., `plan` -> `02-plan.md`). Used to verify the artifact was actually produced after each stage.

## Constraints and Rationale

- **POSIX shell only.** The repository uses `sh` scripts throughout. No bash-isms, no new interpreters. This keeps the runner portable and consistent with existing tooling.
- **No new runtime dependencies.** The runner composes existing scripts and uses only standard shell utilities (`test`, `echo`, arithmetic).
- **Sequential execution only.** Stages depend on prior stage output, so parallelism is not viable and not a goal.
- **Hardcoded stage list.** Auto-discovery would add complexity for no current benefit. The stage list changes rarely and is easy to update in one place.
- **Overwrite-on-rerun.** When a stage's output artifact already exists, the runner re-runs the stage and overwrites it. This avoids silent stale artifacts and matches the single-stage behavior already in use.
- **Halt on first failure.** `set -eu` plus explicit exit codes ensure the runner stops immediately on any error, reporting which stage failed. No retry or skip logic.
- **No interactive prompts.** The runner is fully driven by arguments and exit codes, suitable for both human operators and CI/automation.
- **`implement` stage lacks an automated consumer.** The existing `consume_stage()` function returns exit code 2 for unrecognized stages including `implement`. This is acceptable for v1 — the `full` mode defaults to `spec` through `tasks`, skipping `implement` and `validate` unless explicitly requested. If `implement` is included in a range, the runner will fail with a clear error.

## Risks

- **Duplicate code in `auto-workflow.sh`.** Lines 130-136 are an exact duplicate of lines 122-128 (the stage loop and completion message). This is a copy-paste artifact that will cause the loop to execute twice. Must be fixed before the feature is considered complete.
- **`implement` stage has no consumer.** If a user runs `full` mode with a range that includes `implement`, it will fail at that stage. This is by design for v1, but should be documented clearly in usage output. The `full` mode defaults (`spec` to `tasks`) intentionally avoid this gap.
- **Claude CLI availability.** `consume-stage-with-claude.sh` requires the `claude` CLI to be installed and accessible. If it is missing, the consumer exits with code 2. The runner inherits this dependency without additional checking — the error message from the consumer is sufficient.
- **Artifact path assumptions.** The `expected_artifact_for_stage()` mapping is duplicated between `auto-workflow.sh` and `consume-stage-with-claude.sh`. If either is updated without the other, the post-stage verification could give false failures. This is acceptable for v1 given the small stage count, but is a maintenance risk.
- **No idempotency guarantee beyond overwrite.** Re-running a stage overwrites its artifact, but upstream stages are not re-validated. A stale upstream artifact could produce inconsistent downstream output. This is a known limitation accepted by the spec.

## Validation Approach

- **Manual smoke test (full mode):** Run `auto-workflow.sh <feature-dir> full` on a test feature with a valid `request.txt`. Verify that artifacts `00-intake.md` through `06-tasks.md` are produced in order and contain plausible content.
- **Manual smoke test (single mode):** Run `auto-workflow.sh <feature-dir> single spec` on a feature with an existing `00-intake.md`. Verify only `01-spec.md` is produced/updated.
- **Manual smoke test (range mode):** Run `auto-workflow.sh <feature-dir> range spec plan` on a feature with an existing `00-intake.md`. Verify `01-spec.md` and `02-plan.md` are produced in order.
- **Error case: invalid stage name.** Run with a nonexistent stage name and verify non-zero exit and clear error message.
- **Error case: reversed range.** Run `range plan spec` and verify the runner rejects it.
- **Error case: missing feature directory.** Run with a nonexistent path and verify failure before any stage executes.
- **Error case: missing input artifact.** Remove a required input file and verify the consumer fails with a descriptive error.
- **Code review:** Verify the duplicate trailing lines (130-136) are removed. Verify `set -eu` is present. Verify exit codes are non-zero on all failure paths.

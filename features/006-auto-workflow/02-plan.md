# Plan

## Architecture Summary

The auto-workflow runner is a single POSIX shell script (`scripts/auto-workflow.sh`) that orchestrates the existing per-stage pipeline scripts into multi-stage runs. It sits one layer above the current stage tooling (`execute-stage.sh`, `consume-stage-with-claude.sh`, `complete-artifact.sh`) and composes them without modification. The runner accepts a feature directory and a mode argument, resolves the requested stage range, then iterates through stages sequentially, delegating each stage's prepare/consume/complete cycle to the existing scripts.

Key architectural decisions:

- **Composition over reimplementation.** The runner calls `execute-stage.sh`, `consume-stage-with-claude.sh`, and `complete-artifact.sh` as black-box building blocks. It never duplicates their logic.
- **Hardcoded stage list.** Stage ordering is defined as an explicit ordered list (`intake spec plan tasks implement validate`) rather than discovered from the filesystem. This keeps the runner simple and predictable.
- **Fail-fast sequential execution.** Stages run one at a time in pipeline order. On any failure the runner halts immediately with a non-zero exit code and an error message identifying the failing stage.

The existing implementation in `scripts/auto-workflow.sh` is already substantially complete. This plan documents its design and identifies the remaining constraints and risks.

## Components / Modules

- **`scripts/auto-workflow.sh`** — the entry-point runner script. Responsibilities:
  - Parse CLI arguments (feature directory, mode, optional stage names).
  - Validate inputs: stage names are recognized, range ordering is valid.
  - Resolve the effective start and end stages based on mode (`full`, `single`, `range`).
  - Iterate through the stage list and, for each stage in the resolved range, call the per-stage execution cycle via `run_stage_once`.
  - Print summary-level progress output (completion message).
  - Exit non-zero with a descriptive message on any failure.

- **`scripts/execute-stage.sh`** (existing) — prepares a stage bundle (prompt file, context) for the given feature and stage.

- **`scripts/consume-stage-with-claude.sh`** (existing) — invokes the Claude CLI to consume the stage bundle and produce the output artifact. Handles all six stages: intake, spec, plan, tasks, implement, validate.

- **`scripts/complete-artifact.sh`** (existing) — marks a stage artifact as complete in the feature's state tracking.

- **`scripts/state-lib.sh`** (existing) — shared state-management utilities sourced by the runner for feature state operations.

- **Helper functions within the runner:**
  - `stage_exists` — validates a stage name against the known list.
  - `stage_order` — returns the 1-based index of a stage for range comparison.
  - `expected_artifact_for_stage` — maps a stage name to its output filename for post-stage verification.
  - `consume_stage` — routes a stage name to the appropriate consumer script.
  - `run_stage_once` — executes the full prepare/consume/complete cycle for a single stage and verifies the artifact exists afterward. Also triggers the `after_validation.sh` hook when the validate stage completes.
  - `resolve_full_defaults` — supplies default start/end stages for `full` mode (defaults to `intake` through `tasks`).

## Constraints and Rationale

- **POSIX shell (`#!/usr/bin/env sh`).** The rest of the pipeline tooling is shell-based. Staying with `sh` avoids introducing a new runtime dependency and keeps the script portable.
- **No new runtime dependencies.** The runner uses only standard shell builtins and the existing pipeline scripts. No external tools (jq, Python, etc.) are required.
- **Hardcoded stage ordering.** Dynamic discovery was explicitly declared a non-goal in the spec. A static list is simpler to reason about and avoids filesystem-scanning fragility.
- **Overwrite-on-rerun.** When a stage's output artifact already exists, the runner re-runs the stage and overwrites it. This matches the spec's decision to avoid silent skips that could mask stale output.
- **Non-interactive operation.** The runner works in environments without a TTY. It relies solely on arguments and exit codes — no prompts.
- **Full-mode default stops at `tasks`.** The `full` mode defaults to `intake → tasks` rather than running through `validate`, because `implement` and `validate` involve heavier operations that the operator should opt into explicitly. The operator can override this with optional start/end arguments.
- **Halt on first failure.** `set -eu` plus explicit exit codes ensure the runner stops immediately on any error. No retry or skip logic — this matches the spec's non-goal declaration.

## Risks

- **Claude CLI availability.** The consumer script requires `claude` on `$PATH`. If the CLI is absent or misconfigured, stages will fail at the consume step. Mitigation: `consume-stage-with-claude.sh` already checks for the CLI and exits with a clear error code.
- **Stage script interface changes.** The runner depends on the calling conventions of `execute-stage.sh`, `consume-stage-with-claude.sh`, and `complete-artifact.sh`. If any of these change their arguments or exit-code semantics, the runner will break. Mitigation: the pipeline is small and single-repo; changes are visible and testable.
- **Partial output on interrupt.** If the runner is killed mid-stage (e.g., SIGINT), the in-progress stage may leave a partial or corrupt artifact on disk. Previously completed artifacts remain intact. Mitigation: this is accepted behavior per the spec; no additional signal handling is planned for v1.
- **Stage list drift.** If new stages are added to the pipeline but not to the runner's hardcoded list, they will be silently skipped. Mitigation: document the stage list as the single source of truth within the runner and update it as part of any stage-addition work.
- **Artifact path mapping maintenance.** The `expected_artifact_for_stage` function duplicates knowledge about which numbered file each stage produces. The same mapping exists implicitly in `consume-stage-with-claude.sh`. If template naming changes, both must be updated in tandem. Mitigation: keep mapping co-located in the runner for easy discovery; the small stage count makes divergence unlikely.
- **No upstream re-validation.** Re-running a stage overwrites its artifact, but upstream stages are not re-validated. A stale upstream artifact could produce inconsistent downstream output. This is a known limitation accepted by the spec.

## Validation Approach

- **Manual smoke tests per mode:**
  - Run `auto-workflow.sh <feature-dir> full` on a test feature and confirm all stage artifacts from `00-intake.md` through `06-tasks.md` are produced in order.
  - Run `auto-workflow.sh <feature-dir> single spec` and confirm only `01-spec.md` is (re)generated.
  - Run `auto-workflow.sh <feature-dir> range intake plan` and confirm artifacts for `intake`, `spec`, and `plan` are produced.
- **Error path verification:**
  - Invoke with an invalid feature directory and confirm a descriptive error and non-zero exit.
  - Invoke with a non-existent stage name and confirm a usage error.
  - Invoke with a reversed range (e.g., `range plan intake`) and confirm rejection.
  - Invoke `range spec spec` and confirm it behaves identically to `single spec`.
- **Artifact integrity:** After a full run, verify that each expected artifact file exists and is non-empty in the feature directory.
- **Exit code semantics:** Confirm the runner exits `0` on success and non-zero on any failure, with the failing stage identified in stderr output.
- **Idempotency:** Run the same stage twice and confirm the artifact is overwritten without errors.
- **Code review:** Verify `set -eu` is present, all failure paths exit non-zero, and the stage list matches the current pipeline convention.

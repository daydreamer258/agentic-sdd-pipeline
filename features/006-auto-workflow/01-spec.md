# Spec

## Problem Statement

Advancing a feature through the SDD pipeline currently requires manually invoking each stage's prepare-consume-complete cycle one at a time. This is repetitive, error-prone, and creates a high barrier for contributors unfamiliar with the individual scripts. There is no single command that can orchestrate multiple stages in sequence.

## Users / Actors

- **Pipeline operator** — a developer or contributor who wants to advance a feature through one or more SDD stages without manually running each sub-script.
- **CI / automation harness** — a non-interactive environment that needs to drive the pipeline programmatically and react to exit codes.

## Desired Behavior

The system should provide a single entry-point shell script (`auto-workflow.sh` or equivalent) that accepts a feature directory and a mode flag, then orchestrates the existing stage scripts accordingly.

**Modes:**

1. **Full flow** — execute every pipeline stage in order for the given feature, from the first stage through the last.
2. **Single stage** — execute exactly one named stage for the given feature.
3. **Stage range** — execute a contiguous subset of stages (e.g., from `intake` through `spec`) for the given feature.

**Orchestration behavior:**

- The runner calls the repository's existing stage-preparation, backend-consumption, and artifact-completion mechanisms (`consume-stage-with-claude.sh` and related tooling) for each stage in sequence.
- Stage ordering follows the pipeline's established convention (stage numbering / template ordering).
- Each stage must complete successfully before the next stage begins.
- On any stage failure the runner halts immediately and exits with a non-zero code, reporting which stage failed.
- The runner must not modify existing artifacts, stage scripts, or any files outside the expected output artifact for each stage.

## Acceptance Criteria

- [ ] A single shell script accepts a feature directory path and a mode argument (`full`, `single <stage>`, or `range <from> <to>`).
- [ ] In **full** mode, all pipeline stages execute in order and produce their respective artifacts.
- [ ] In **single** mode, exactly one named stage executes and produces its artifact.
- [ ] In **range** mode, a contiguous subset of stages executes in order and produces their artifacts.
- [ ] The runner composes existing scripts rather than reimplementing stage logic.
- [ ] The runner exits with a non-zero code and a clear error message if any stage fails, identifying the failing stage.
- [ ] No new runtime dependencies are introduced beyond what the repository already uses.
- [ ] The runner does not alter existing artifacts or stage scripts as a side-effect of its own operation.
- [ ] Stage ordering matches the pipeline's established convention.

## Edge Cases

- A stage's output artifact already exists before the runner starts. **Default behavior:** the runner overwrites it (re-runs the stage). This matches the existing single-stage behavior and avoids silent skips that hide stale artifacts. *(Flagged as an ambiguity from intake — this default is chosen to keep behavior simple and predictable.)*
- The feature directory does not exist or is missing its intake file. The runner should fail immediately with a descriptive error before executing any stage.
- The user specifies a stage name that does not exist or a range where `from` comes after `to` in the pipeline order. The runner should reject the input with a usage error.
- The runner is invoked in a non-interactive environment (no TTY). It should operate without prompts, relying solely on arguments and exit codes.

## Non-Goals

- **Retry / skip logic on failure.** The runner halts on first failure. Retry or skip-and-continue behavior is out of scope for this feature.
- **Auto-discovery of stages from the filesystem.** The stage list may be hardcoded or derived from a known convention; building a generic plugin/discovery system is not a goal.
- **Verbose/silent logging modes.** Basic progress output (which stage is running, pass/fail) is expected, but a configurable verbosity system is out of scope.
- **Parallelism.** Stages execute sequentially. Concurrent stage execution is not a goal.
- **GUI, TUI, or interactive prompts.** The runner is a non-interactive CLI tool.

## Assumptions

- The existing `consume-stage-with-claude.sh` and related scripts are stable and can be called as black-box building blocks.
- The pipeline's stage ordering is well-defined and consistent (e.g., `00-intake`, `01-spec`, `02-plan`, etc.).
- The runner will be a POSIX-compatible shell script, consistent with the repository's current tooling approach.
- Each stage produces exactly one output artifact at a predictable path.

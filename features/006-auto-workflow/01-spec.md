# Spec

## Problem Statement

Advancing a feature through the SDD pipeline currently requires manually invoking each stage's prepare → consume → complete cycle one at a time. This is repetitive, error-prone, and creates a high barrier for contributors unfamiliar with the individual scripts. There is no single command that can orchestrate multiple stages in sequence, making the pipeline unusable in CI-like or automated contexts without custom wrapper scripts.

## Users / Actors

- **Pipeline operator** — a developer or contributor who wants to advance a feature through one or more SDD stages without manually running each sub-script.
- **CI / automation harness** — a non-interactive environment that needs to drive the pipeline programmatically and react to exit codes.

## Desired Behavior

The system provides a single entry-point shell script (the "auto-workflow runner") that accepts a feature directory and a mode flag, then orchestrates the existing stage scripts accordingly.

**Modes:**

1. **Full flow** — execute every pipeline stage in order for the given feature, from the first stage through the last.
2. **Single stage** — execute exactly one named stage for the given feature.
3. **Stage range** — execute a contiguous subset of stages (e.g., from `intake` through `spec`) for the given feature.

**Orchestration behavior:**

- The runner calls the repository's existing stage-preparation, backend-consumption, and artifact-completion mechanisms (`consume-stage-with-claude.sh` and related tooling) for each stage in sequence.
- Stage ordering follows the pipeline's established convention (stage numbering / template ordering).
- Each stage must complete successfully before the next stage begins.
- On any stage failure the runner halts immediately and exits with a non-zero code, reporting which stage failed.
- The runner prints a summary line per stage indicating start, success, or failure.
- The runner must not modify existing artifacts, stage scripts, or any files outside the expected output artifact for each stage.

## Acceptance Criteria

- [ ] A single shell script accepts a feature directory path and a mode argument (`full`, `single <stage>`, or `range <from> <to>`).
- [ ] In **full** mode, all pipeline stages execute in order and produce their respective artifacts.
- [ ] In **single** mode, exactly one named stage executes and produces its artifact.
- [ ] In **range** mode, a contiguous subset of stages executes in order and produces their artifacts.
- [ ] The runner composes existing scripts (`consume-stage-with-claude.sh` and related tooling) rather than reimplementing stage logic.
- [ ] The runner exits with a non-zero code and a clear error message if any stage fails, identifying the failing stage.
- [ ] The runner provides summary-level progress output (which stage is running, pass/fail).
- [ ] No new runtime dependencies are introduced beyond what the repository already uses.
- [ ] The runner does not alter existing artifacts or stage scripts as a side-effect of its own operation.
- [ ] Stage ordering matches the pipeline's established convention.

## Edge Cases

- **Stage output artifact already exists:** The runner re-runs the stage and overwrites the existing artifact. This avoids silent skips that could hide stale output. *(Resolved ambiguity from intake — overwrite chosen for simplicity and predictability.)*
- **Feature directory missing or no intake artifact:** The runner fails immediately with a descriptive error before executing any stage.
- **Invalid stage name or invalid range:** The runner rejects the input with a usage error (e.g., unrecognized stage name, or `from` stage comes after `to` stage in pipeline order).
- **Range where start equals end:** Behaves identically to single-stage mode.
- **Non-interactive environment (no TTY):** The runner operates without prompts, relying solely on arguments and exit codes.
- **Interrupted mid-run (e.g., SIGINT):** Previously completed stage artifacts remain intact; only the in-progress stage may have partial output.

## Non-Goals

- **Retry or skip logic on failure.** The runner halts on first failure. Retry or skip-and-continue behavior is out of scope.
- **Generic stage auto-discovery.** The stage list may be hardcoded or derived from a known convention; a plugin or filesystem-scanning discovery system is not a goal.
- **Configurable verbosity or log levels.** Basic progress output is expected, but a logging framework or verbosity flags are out of scope.
- **Parallel stage execution.** Stages execute sequentially only.
- **Interactive prompts during execution.** The runner is a non-interactive CLI tool.
- **CI integration or webhook triggers.** The runner is a local script; CI plumbing is a separate concern.

## Assumptions

- The existing `consume-stage-with-claude.sh` and related scripts are stable and can be called as black-box building blocks without modification.
- The pipeline's stage ordering is well-defined and consistent (e.g., `00-intake`, `01-spec`, `02-plan`, etc.).
- The runner is a bash shell script, consistent with the repository's current tooling approach.
- Each stage produces exactly one output artifact at a predictable path.
- The runner will be invoked from the repository root directory.

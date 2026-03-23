# Intake

## Request Summary

Add an automated workflow runner script that orchestrates the existing SDD pipeline stages into a single command. The runner should support three execution modes:

1. **Full flow** — run all stages end-to-end for a feature.
2. **Single stage** — run exactly one named stage.
3. **Stage range** — run a contiguous subset of stages (e.g., from intake through spec).

The runner chains the repository's existing stage-preparation, backend-consumption, and artifact-completion mechanisms rather than reimplementing them.

## Why It Matters

Currently, advancing a feature through the pipeline requires manually invoking each stage's prepare-consume-complete cycle. This is repetitive and error-prone, especially for multi-stage runs. An automated runner reduces friction, makes the pipeline usable in CI-like contexts, and lowers the barrier for contributors unfamiliar with the individual scripts.

## Constraints

- Must compose existing scripts (`consume-stage-with-claude.sh` and related tooling) rather than duplicating their logic.
- Must remain a lightweight shell-based solution consistent with the repository's current design (no new runtime dependencies).
- Must preserve the stage-ordering convention already defined in the pipeline.
- Must not alter existing artifacts or stage scripts as a side-effect of the runner itself.

## Unknowns / Questions

- **Error handling between stages:** If a mid-pipeline stage fails, should the runner halt immediately, skip to the next stage, or offer a retry? The request does not specify.
- **Stage discovery:** Should the runner auto-detect which stages exist (e.g., by scanning templates), or is the stage list hardcoded?
- **Idempotency:** If a stage's output artifact already exists, should the runner skip it, overwrite it, or prompt?
- **Logging / progress output:** What level of feedback should the runner provide during execution (silent, summary, verbose)?

## Initial Success Definition

- A single entry-point script that accepts a feature directory and a mode flag (full / single / range).
- Running in full mode produces all stage artifacts for the given feature in order.
- Running in single or range mode produces only the specified artifact(s).
- The runner exits with a non-zero code if any stage fails.
- No new runtime dependencies beyond what the repository already uses.

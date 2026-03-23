# Backend Consumers

## 1. Purpose

This document explains the real backend consumer integrations for the lightweight SDD workflow.

The immediate goal is not full automation across all stages.
The immediate goal is to prove that a real backend can consume early text-centric stages and produce artifacts.

---

## 2. Current implementation

### `scripts/consume-stage-with-claude.sh`

This script is the first real backend consumer.

Current scope:
- supports the `spec`, `plan`, `tasks`, and `validate` stages
- uses local `claude` CLI
- reads the stage's input artifact and prompt files
- instructs Claude Code to write the target artifact directly

---

## 3. Why start with `spec`, `plan`, `tasks`, and `validate`

`spec` is the cleanest first stage to automate because:

- its input is simple (`00-intake.md`)
- its output is simple (`01-spec.md`)
- it is mostly text transformation
- it does not yet require direct code modification

After `spec`, `plan` is the natural second stage because:

- it consumes an already structured artifact (`01-spec.md`)
- it still remains primarily markdown generation
- it advances the workflow without yet requiring code edits

After `plan`, `tasks` is the natural third stage because:

- it still outputs markdown rather than source code
- it tests whether the prompt layer can convert planning into executable decomposition
- it brings the workflow much closer to real implementation handoff

After implementation logging exists, `validate` becomes the natural fourth backend-consumed stage because:

- it is still artifact-oriented
- it tests whether the system can compare implementation evidence against upstream artifacts
- it closes the first real backend-driven loop

---

## 4. Current limitations

The current Claude consumer:

- supports `spec`, `plan`, `tasks`, and `validate`
- does not yet auto-run `complete-artifact.sh`
- does not yet auto-chain to the next stage
- does not yet consume the `.bundle.md` file as the only source of truth
- still contains some stage-specific mapping logic that could move closer to the bundle layer over time

It is intentionally small so the system can prove the execution path first.

---

## 5. Why this matters

Before this step, the system had:
- runtime wiring
- prompt files
- execution bundles

But it still needed a live backend to actually execute a stage.

With this consumer, the workflow has crossed the line from:
- staged orchestration

to:
- real backend-driven artifact production

---

## 6. Current status

The repository has now proven real backend-driven artifact generation for:

- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `08-validation.md`

using the local Claude Code CLI as the first backend.

This means the early text-centric half of the SDD loop has already been validated in practice.

---

## 7. Expected next upgrades

After the first `spec`, `plan`, `tasks`, and `validate` integrations work well, the natural next steps are:

1. auto-complete the artifact after successful generation
2. let the consumer read the bundle more directly
3. optionally support multiple backends in a unified interface
4. decide how much implementation evidence should be normalized before validation
5. eventually address implementation-stage automation separately from text-artifact generation

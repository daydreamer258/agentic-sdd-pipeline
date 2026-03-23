# Backend Consumers

## 1. Purpose

This document explains the first real backend consumer integration for the lightweight SDD workflow.

The immediate goal is not full automation across all stages.
The immediate goal is to prove that a real backend can consume a stage and produce an artifact.

---

## 2. Current implementation

### `scripts/consume-stage-with-claude.sh`

This script is the first real backend consumer.

Current scope:
- supports the `spec` stage only
- uses local `claude` CLI
- reads the stage's input artifact and prompt files
- instructs Claude Code to write the target artifact directly

---

## 3. Why start with `spec`

`spec` is the cleanest first stage to automate because:

- its input is simple (`00-intake.md`)
- its output is simple (`01-spec.md`)
- it is mostly text transformation
- it does not yet require direct code modification

That makes it the safest stage for the first backend integration.

---

## 4. Current limitations

The current Claude consumer:

- supports `spec` only
- does not yet auto-run `complete-artifact.sh`
- does not yet auto-chain to the next stage
- does not yet consume the `.bundle.md` file as the only source of truth

It is intentionally small so the system can prove the execution path first.

---

## 5. Why this matters

Before this step, the system had:
- runtime wiring
- prompt files
- execution bundles

But it still needed a live backend to actually execute a stage.

With this consumer, the workflow begins crossing the line from:
- staged orchestration

to:
- real backend-driven artifact production

---

## 6. Expected next upgrades

After the first `spec` stage integration works well, the natural next steps are:

1. auto-complete the artifact after successful generation
2. extend Claude consumer support to `plan`, `tasks`, and `validate`
3. let the consumer read the bundle more directly
4. optionally support multiple backends in a unified interface

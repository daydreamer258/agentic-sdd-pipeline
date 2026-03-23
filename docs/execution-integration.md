# Execution Integration

## 1. Purpose

This document explains the lightweight execution integration layer added on top of runtime wiring and prompt files.

The goal is to bridge:

- runtime stage control
- prompt-layer definitions
- future real agent/backend execution

---

## 2. Stage bundle concept

Each stage can now generate a **stage bundle**.

A stage bundle is a runtime artifact that contains:

- feature metadata
- current stage context
- read/write expectations
- linked Skill prompt path
- linked Subagent prompt path
- execution instructions

This makes the gap between orchestration and prompt execution much narrower.

---

## 3. Why stage bundles matter

Before stage bundles, handlers only printed recommendations.

After stage bundles, a stage handler now produces a concrete execution package that can be handed to:

- a human operator
- a wrapper script
- a backend consumer
- a future Skill/Subagent launcher

This is a practical intermediate step before fuller automation.

---

## 4. Current implementation

### `scripts/build-stage-bundle.sh`
Builds `features/<feature>/.runtime/<stage>.bundle.md`.

### `runtime/handlers/*.sh`
Call `build-stage-bundle.sh` and surface the resulting bundle path.

### `features/<feature>/.runtime/<stage>.bundle.md`
A generated execution package for the current stage.
This can be handed to a human, wrapper, or backend.

### `scripts/consume-stage-with-claude.sh`
A first real backend consumer that can now consume the early text-centric stages of the workflow.

---

## 5. What a stage bundle includes

A bundle currently records:

- feature id / slug / title
- feature directory
- current stage
- next stage
- current status
- stage goal
- artifacts to read
- artifacts to write
- Skill prompt file path
- Subagent prompt file path
- a short execution checklist

---

## 6. Current status

Execution integration is now partially but meaningfully landed:

- runtime wiring exists
- prompt files exist
- stage bundles now connect them
- a real Claude backend has already consumed the `spec`, `plan`, `tasks`, and `validate` stages

This means the system has gone beyond orchestration-only wiring and now has real backend-produced artifacts along the early SDD path.

---

## 7. Current limitation

The backend consumer still does not:

- auto-run `complete-artifact.sh`
- auto-chain to the next stage
- consume the `.bundle.md` file as the only source of truth
- hide all stage-specific mapping behind a cleaner adapter layer

So this is not yet a fully automatic execution engine.
It is, however, a real execution-integrated workflow.

---

## 8. Summary

Execution integration has crossed an important threshold:

- runtime wiring exists
- prompt files exist
- stage bundles exist
- real backend consumption exists

The next step is to tighten the integration so the backend relies more directly on bundles and less on backend-specific glue.

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
- a future Skill backend
- a future Subagent launcher

This is a practical intermediate step before full execution automation.

---

## 4. Current implementation

### `scripts/build-stage-bundle.sh`
Builds `features/<feature>/.runtime/<stage>.bundle.md`.

### `runtime/handlers/*.sh`
Now call `build-stage-bundle.sh` and surface the resulting bundle path.

### `features/<feature>/.runtime/<stage>.bundle.md`
A generated execution package for the current stage.
This can be handed to a human, wrapper, or future backend.

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

## 6. Current limitation

The bundle is not yet automatically consumed by a live Skill/Subagent backend.

However, this is now a much smaller remaining gap.
The system already knows:
- what stage is active
- what should be read
- what should be written
- which prompt files should guide execution

---

## 7. Summary

Execution integration is now partially landed:

- runtime wiring exists
- prompt files exist
- stage bundles now connect them
- a real Claude backend has already consumed the `spec` and `plan` stages

The next step is to extend this pattern to later stages and reduce duplication between bundles and backend-specific prompts.

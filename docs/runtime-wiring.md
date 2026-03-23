# Runtime Wiring

## 1. Purpose

This document explains the lightweight runtime wiring layer added after the first pilot.

The goal is to move from:
- stage preparation as mostly informational output

to:
- stage preparation with real handler dispatch
- centralized state management
- more meaningful state transitions after artifact completion and validation

---

## 2. Wiring components

### `scripts/state-lib.sh`
Shared helper for:
- reading state values
- writing normalized `state.json`
- deriving timestamps
- deriving next stage from artifacts

### `scripts/run-stage.sh`
Now does more than announce a stage.
It:
- runs pre-stage hooks
- writes normalized state
- dispatches to a stage handler in `runtime/handlers/`

### `scripts/complete-artifact.sh`
Now:
- records artifact completion
- updates state consistently
- derives next stage from the artifact path

### `scripts/execute-stage.sh`
Small convenience wrapper that:
- prepares the stage
- dispatches the handler
- prints the next human/agent action

### `runtime/handlers/*.sh`
Stage handlers are now explicit runtime wiring points.
In v1 they are still lightweight and mostly declarative, but they are the correct place to attach future Skill/Subagent execution.

---

## 3. State improvements

`state.json` now supports more fields:

- `feature_id`
- `feature_slug`
- `feature_title`
- `current_stage`
- `status`
- `last_artifact`
- `next_stage`
- `last_updated_at`
- `validation_result`
- `needs_review`

This is still lightweight, but it is much more useful than the earlier 3-field state.

---

## 4. Validation wiring

`hooks/after_validation.sh` now reads `08-validation.md` and updates state based on whether validation passed or requires rework.

This is important because validation is no longer just a doc-writing step; it now affects runtime state.

---

## 5. Why this matters

This change makes the system feel more like a workflow engine and less like a collection of templates.

It still does not fully execute real Skills/Subagents automatically.
But it now has:
- explicit runtime dispatch points
- explicit handler boundaries
- stronger state transitions
- validation-driven state updates

That is the correct stepping stone before wiring actual prompt-layer performers.

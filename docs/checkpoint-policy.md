# Checkpoint Policy

## 1. Purpose

This document defines how workflow checkpoints should work when automatic execution reaches a stage that is not safe to continue blindly.

---

## 2. Current focus

The first major use case is:

- `implement` with `medium` risk

Later, the same pattern can be extended to other sensitive situations.

---

## 3. When a checkpoint should trigger

A checkpoint should trigger when:

- the risk assessor returns `medium`
- a stage needs human review before continuing
- the system can continue, but should not continue silently

---

## 4. What a checkpoint summary should include

A checkpoint summary should contain:

- feature id / slug
- current stage
- current task scope
- risk level
- reasons for that risk level
- suggested action

Suggested actions:
- `continue`
- `continue-with-caution`
- `stop`

---

## 5. Current workflow behavior

At the current maturity level, the workflow should:

- create the checkpoint summary artifact
- print that a checkpoint is required
- stop before automatic implementation proceeds

This is intentionally simple and explicit.

---

## 6. Summary

A checkpoint is a structured pause, not a failure.

Its purpose is to keep automation useful without letting it become reckless.

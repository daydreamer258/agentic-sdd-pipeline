# Implement Safety Policy

## 1. Purpose

This document defines the safety policy for the `implement` stage in the lightweight SDD pipeline.

The goal is not to ban automation.
The goal is to make implementation automation proportional to risk.

---

## 2. Why implement is different

Earlier stages mostly generate markdown artifacts.

`implement` is different because it may:

- modify source files
- modify scripts
- change behavior
- introduce regressions
- drift beyond task boundaries

That means `implement` needs stronger safety controls than `intake`, `spec`, `plan`, or `tasks`.

---

## 3. Risk model

The `implement` stage should use three risk levels:

- `low`
- `medium`
- `high`

### `low`
Safe enough for bounded automatic execution.

### `medium`
Potentially acceptable, but should stop for a checkpoint before execution proceeds.

### `high`
Too risky for automatic implementation.
The workflow should stop and require explicit human review.

---

## 4. Suggested heuristics

### `low`
Examples:
- documentation-only changes
- small shell utilities
- isolated repo tooling changes
- bounded additions in clearly non-sensitive areas

Typical traits:
- no dependency changes
- no lockfile changes
- no deletes
- no CI/deploy changes
- no auth/permission/payment logic
- task scope is clear

### `medium`
Examples:
- multi-file logic changes in ordinary code paths
- moderate repo restructuring with clear boundaries
- edits to existing modules with unclear blast radius

Typical traits:
- multiple files changed
- existing logic being modified rather than only added
- validation still possible, but risk is non-trivial

### `high`
Examples:
- deleting files
- changing dependency manifests / lockfiles
- changing CI / deploy / infra
- security-sensitive logic
- auth / permission / payment logic
- database schema / migrations
- broad cross-directory refactors

Any one of these should be treated as a strong signal to stop automatic execution.

---

## 5. Default workflow policy

### Recommended default
- Auto workflow should run freely through `tasks`.
- `implement` should be guarded by risk assessment.

### Result mapping
- `low` -> allow automatic implement
- `medium` -> create checkpoint summary and stop
- `high` -> stop and require human review

---

## 6. Checkpoint policy

If `implement` is assessed as `medium`, the system should create a checkpoint summary containing:

- feature id / slug
- current task scope
- planned file changes (if known)
- risk reasons
- suggested action

The workflow should then stop until a human explicitly decides whether to proceed.

---

## 7. Current maturity note

The repository currently treats `implement` automation as:

> bounded and experimental

So even when risk is `low`, it should still be used more conservatively than earlier text-only stages.

---

## 8. Summary

Policy recommendation:

> Default to automatic early-stage flow, and gate `implement` through explicit risk assessment.

That balances momentum with control.

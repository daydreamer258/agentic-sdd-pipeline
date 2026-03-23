# Skill Interfaces

## 1. Purpose

This document defines the minimal stage-specific Skill interfaces for the lightweight v1 pipeline.

These are not vendor-specific APIs.
They are the repository-level expectations the runtime should enforce.

---

## 2. `sdd-intake`

### Responsibility
Turn a raw request into a structured intake artifact.

### Reads
- raw request
- optional project principles / constraints

### Writes
- `00-intake.md`

### Must include
- request summary
- why it matters
- constraints
- unknowns / questions
- initial success definition

### Escalate when
- request is too vague to summarize faithfully
- required constraints are missing

---

## 3. `sdd-spec`

### Responsibility
Turn intake into a behavior-oriented spec.

### Reads
- `00-intake.md`

### Writes
- `01-spec.md`

### Must include
- problem statement
- users / actors
- desired behavior
- acceptance criteria
- edge cases
- non-goals
- assumptions

### Must avoid
- prematurely committing to detailed implementation design unless needed for behavioral precision

### Escalate when
- user intent is still too ambiguous
- success criteria cannot be made explicit

---

## 4. `sdd-plan`

### Responsibility
Translate spec into a technical implementation plan.

### Reads
- `01-spec.md`

### Writes
- `02-plan.md`
- optional research / models / contracts

### Must include
- architecture summary
- components/modules
- constraints and rationale
- risks
- validation approach

### Must avoid
- silently redefining scope from the spec

### Escalate when
- critical technical assumptions are unresolved
- integration constraints are unknown

---

## 5. `sdd-tasks`

### Responsibility
Turn plan into bounded implementation tasks.

### Reads
- `01-spec.md`
- `02-plan.md`

### Writes
- `06-tasks.md`

### Must include
- ordered tasks
- dependencies
- parallelizable work (if any)
- validation notes

### Must avoid
- giant epic tasks that are not realistically executable in one bounded pass

### Escalate when
- tasks cannot be decomposed without additional planning clarification

---

## 6. `sdd-validate`

### Responsibility
Review implementation against both runtime quality and artifact intent.

### Reads
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- changed files / test results

### Writes
- `08-validation.md`

### Must include
- checks run
- results
- spec conformance
- plan conformance
- recommendation

### Must avoid
- reducing validation to test pass/fail only

### Escalate when
- failures point to spec/plan problems rather than code-only defects

---

## 7. Optional later Skills

These are intentionally excluded from the minimum v1 set, but likely to appear soon:

- `sdd-retrospective`
- `sdd-review`
- `sdd-contracts`
- `sdd-data-model`

---

## 8. Summary

The lightweight v1 system does not need a huge Skill taxonomy.
It needs a small number of stable, stage-oriented interfaces that are easy to reason about and easy to wire into an orchestrator.

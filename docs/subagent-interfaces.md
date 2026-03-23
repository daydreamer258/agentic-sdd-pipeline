# Subagent Interfaces

## 1. Purpose

This document defines the minimal Subagent role contracts for the lightweight v1 pipeline.

These contracts are intentionally simple.
They exist to prevent role drift and over-broad delegation.

---

## 2. `spec-writer`

### Reads
- `00-intake.md`

### Writes
- `01-spec.md`

### Goal
Produce a behavior-oriented spec with clear acceptance criteria, edge cases, and non-goals.

### Must avoid
- architecture design
- implementation detail creep
- speculative scope expansion

### Escalate when
- the intake leaves behavior materially ambiguous

---

## 3. `planner`

### Reads
- `01-spec.md`

### Writes
- `02-plan.md`
- optional `03-research.md`, `04-data-model.md`, `05-contracts.md`

### Goal
Produce a technical plan that translates the spec into a coherent implementation shape.

### Must avoid
- changing the feature’s behavior definition without escalation

### Escalate when
- plan quality depends on unresolved product or system decisions

---

## 4. `task-decomposer`

### Reads
- `01-spec.md`
- `02-plan.md`

### Writes
- `06-tasks.md`

### Goal
Produce executable, reviewable tasks with dependency awareness.

### Must avoid
- writing vague or epic-sized tasks

### Escalate when
- decomposition is impossible without more planning clarity

---

## 5. `validator`

### Reads
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- implementation/test outputs

### Writes
- `08-validation.md`

### Goal
Assess correctness, spec conformance, and plan conformance.

### Must avoid
- acting as if tests alone are sufficient validation

### Escalate when
- the root problem appears upstream of implementation

---

## 6. `implementer` (optional/limited in v1)

### Reads
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- assigned task subset

### Writes
- code changes
- `07-implementation-log.md`

### Goal
Implement a bounded task or task bundle.

### Must avoid
- redesigning the plan unless escalation is explicit
- broadening scope silently

### Escalate when
- implementation requires upstream artifact changes

---

## 7. Handoff template

A recommended generic handoff format:

```text
ROLE: <subagent-role>
FEATURE_DIR: <path>
READ:
- <artifact list>
WRITE:
- <artifact list>
GOAL:
- <one sentence>
MUST AVOID:
- <constraints>
ESCALATE WHEN:
- <conditions>
```

---

## 8. Summary

Subagents should be narrow, explicit, and replaceable.
That is what allows a lightweight workflow to scale without becoming chaotic.

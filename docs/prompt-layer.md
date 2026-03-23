# Prompt Layer

## 1. Purpose

This document explains the prompt layer of the lightweight SDD pipeline.

The prompt layer is where the abstract role/interface design becomes executable guidance for:

- stage-specific Skills
- role-specific Subagents

---

## 2. Why this layer matters

Before the prompt layer exists, the repository has:

- runtime wiring
- hooks
- handlers
- artifacts
- state transitions

But it still lacks the actual working instructions that tell performers how to behave.

That creates a gap between:
- runtime structure
- execution quality

The prompt layer closes that gap.

---

## 3. Skills vs Subagents in the prompt layer

### Skills
Skills define **stage behavior**.
They answer:
- what this stage is trying to produce
- what to read
- what to write
- what to avoid
- when to escalate

### Subagents
Subagents define **role behavior**.
They answer:
- who is doing the work
- what bounded responsibility they own
- what they must not overstep

---

## 4. Current prompt-layer structure

```text
skills/
  sdd-intake/SKILL.md
  sdd-spec/SKILL.md
  sdd-plan/SKILL.md
  sdd-tasks/SKILL.md
  sdd-validate/SKILL.md

subagents/
  spec-writer.md
  planner.md
  task-decomposer.md
  validator.md
```

---

## 5. Design principles

The prompt layer should remain:

- lightweight
- stage-aligned
- artifact-aware
- escalation-friendly
- free from unnecessary ceremony

The prompts should not assume magical context.
They should explicitly reference artifacts and outputs.

---

## 6. Relationship to runtime wiring

The runtime wiring layer determines:
- when a stage is entered
- which handler runs
- what state changes happen

The prompt layer determines:
- how the performer should think and act once invoked

In other words:

- runtime wiring = control flow
- prompt layer = execution guidance

---

## 7. Current limitation

The repository now contains the prompt files, but the runtime still does not automatically invoke them through a specific agent backend.

That is acceptable for the current stage of development.
The key point is that the contract and prompt artifacts now exist and are aligned.

---

## 8. Summary

With the prompt layer added, the project now has:

- research
- design
- artifact model
- runtime wiring
- prompt files
- real pilot features

That is enough to move from pure skeleton work toward real stage-by-stage execution integration.

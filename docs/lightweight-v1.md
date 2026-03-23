# Lightweight v1

## 1. Goal

This document defines the **lightweight, runnable v1** of the agentic SDD pipeline.

The point of v1 is **not** to be a perfect SDD platform.
The point is to create a system that can actually be used end-to-end with low enough overhead that people will try it.

---

## 2. v1 principles

v1 should be:

- lightweight
- artifact-driven
- hook-assisted
- usable with Skills + Subagents
- simple enough to pilot on a real feature

v1 should avoid:

- heavyweight bureaucracy
- giant templates
- excessive governance before real usage
- trying to simulate complex agent teams

---

## 3. v1 building blocks

### Core runtime pieces
- one orchestrator
- a small set of Skills
- a small set of Subagent roles
- a small set of Hooks

### Core artifact set
- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`

### Optional in v1
- `03-research.md`
- `04-data-model.md`
- `05-contracts.md`
- `09-retrospective.md`

---

## 4. v1 workflow

```text
feature init
-> intake
-> spec
-> plan
-> tasks
-> implement
-> validate
```

### Human checkpoints

Recommended lightweight checkpoints:

1. after spec
2. after plan
3. before implementation for non-trivial work
4. after validation

---

## 5. v1 Skills

Minimum useful set:

- `sdd-intake`
- `sdd-spec`
- `sdd-plan`
- `sdd-tasks`
- `sdd-validate`

Optional later:

- `sdd-retrospective`
- `sdd-review`
- `sdd-contracts`

---

## 6. v1 Subagents

Minimum useful set:

- spec writer
- planner
- task decomposer
- validator

Implementation can initially be handled by the orchestrator or a bounded implementer, depending on runtime constraints.

---

## 7. v1 Hooks

Minimum useful set:

- `on_feature_init`
- `before_stage_transition`
- `after_artifact_write`
- `before_implement`
- `after_validation`

These hooks should be used for:

- folder creation
- template materialization
- stage gating
- status updates
- validation summaries

---

## 8. What makes v1 “runnable”?

v1 is considered runnable when a user can:

1. initialize a feature folder
2. get the standard artifacts scaffolded
3. move stage by stage with clear rules
4. use the artifacts as inputs to Skills/Subagents
5. run lightweight validation before calling the feature done

A system that only has design docs but no scaffold, hooks, or templates is not runnable enough.

---

## 9. Success criteria for v1

v1 succeeds if it can support one real feature with:

- a complete artifact chain
- no direct jump from request to code
- usable stage boundaries
- enough structure to reduce ambiguity
- low enough overhead that the workflow still feels practical

---

## 10. Upgrade path after v1

After v1 proves itself, the next upgrades should be:

- stronger templates
- tighter validation rules
- CI drift checks
- richer contracts/data-models
- better retrospectives
- more systematic implementation delegation

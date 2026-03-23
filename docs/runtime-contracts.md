# Runtime Contracts

## 1. Purpose

This document defines the runtime contracts between:

- the orchestrator
- stage-specific Skills
- Subagents
- Hooks
- feature artifacts

The goal is to make the lightweight v1 pipeline executable without leaving critical handoffs implicit.

---

## 2. Core principle

Every stage must define:

- what it reads
- what it writes
- who performs the work
- what hooks run before/after
- what constitutes success

This keeps the runtime understandable even before a fully automated orchestrator exists.

---

## 3. Orchestrator contract

The orchestrator is responsible for:

1. determining the target stage
2. checking prerequisites
3. invoking pre-stage hooks
4. delegating work to the correct Skill/Subagent layer
5. invoking post-write / post-validation hooks
6. updating state metadata
7. returning explicit success or failure

The orchestrator should not silently skip hooks or required artifacts.

---

## 4. Stage contracts

## Stage: intake

### Reads
- raw request text
- optional project rules

### Writes
- `00-intake.md`

### Preferred performer
- Skill: `sdd-intake`
- optional performer: orchestrator or intake-focused subagent

### Hooks
- no mandatory pre-hook in v1
- may call `after_artifact_write` after writing intake

---

## Stage: spec

### Reads
- `00-intake.md`

### Writes
- `01-spec.md`

### Preferred performer
- Skill: `sdd-spec`
- Subagent: spec-writer

### Hooks
- pre: `before_stage_transition`
- post: `after_artifact_write`

---

## Stage: plan

### Reads
- `01-spec.md`

### Writes
- `02-plan.md`
- optional `03-research.md`, `04-data-model.md`, `05-contracts.md`

### Preferred performer
- Skill: `sdd-plan`
- Subagent: planner / architect

### Hooks
- pre: `before_stage_transition`
- post: `after_artifact_write`

---

## Stage: tasks

### Reads
- `01-spec.md`
- `02-plan.md`

### Writes
- `06-tasks.md`

### Preferred performer
- Skill: `sdd-tasks`
- Subagent: task-decomposer

### Hooks
- pre: `before_stage_transition`
- post: `after_artifact_write`

---

## Stage: implement

### Reads
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`

### Writes
- code changes
- `07-implementation-log.md`

### Preferred performer
- orchestrator or bounded implementer in v1
- later: implementer subagent(s)

### Hooks
- pre: `before_stage_transition`, `before_implement`
- post: `after_artifact_write`

---

## Stage: validate

### Reads
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`

### Writes
- `08-validation.md`

### Preferred performer
- Skill: `sdd-validate`
- Subagent: validator

### Hooks
- pre: `before_stage_transition`
- post: `after_validation`

---

## 5. Skill contracts

A stage Skill should receive enough context to perform exactly one stage.

Each Skill should know:

- target feature directory
- stage name
- required input files
- expected output file(s)
- completion criteria
- escalation rule

### Recommended minimal skill API

```text
INPUTS:
- feature_dir
- target_stage
- required_artifacts
- optional_project_rules

OUTPUTS:
- one or more updated artifacts
- explicit completion or escalation result
```

---

## 6. Subagent contracts

Subagents should receive bounded instructions.

A valid subagent contract should specify:

- exact artifacts to read
- exact artifact(s) to write
- forbidden behavior / scope expansions
- escalation behavior when ambiguity is high

### Example

```text
Read 00-intake.md and produce 01-spec.md.
Include acceptance criteria, edge cases, and non-goals.
Do not choose implementation details.
If ambiguity is blocking, add a clarification-needed section instead of guessing.
```

---

## 7. Hook contracts

Hooks should remain small and deterministic.

Each hook contract should define:

- invocation timing
- inputs (CLI args and env vars)
- outputs or side effects
- blocking behavior

### v1 hooks

- `on_feature_init.sh`
- `before_stage_transition.sh`
- `after_artifact_write.sh`
- `before_implement.sh`
- `after_validation.sh`

---

## 8. State contract

The runtime should maintain `state.json` in each feature folder.

Suggested v1 fields:

- `feature_id`
- `feature_slug`
- `feature_title`
- `current_stage`
- `status`
- `last_artifact`

The orchestrator should be the main writer of state.
Hooks may perform small updates, but should not own the state machine.

---

## 9. Failure contract

Every stage execution should end in one of these classes:

- `success`
- `blocked_missing_input`
- `blocked_ambiguity`
- `failed_runtime`
- `failed_validation`
- `needs_human_review`

This is better than vague free-form failure messages when building a real workflow.

---

## 10. Summary

The runtime contract layer exists so that the v1 skeleton can evolve into a true workflow engine without changing its mental model.

The system becomes stable when:

- stage boundaries are explicit
- performers are bounded
- hooks are predictable
- artifacts are canonical
- state transitions are inspectable

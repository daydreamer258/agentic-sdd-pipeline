# Skills and Subagents

## 1. Purpose

This document defines how a constrained runtime with **Skills + Subagents** can support a credible SDD pipeline without full agent-team orchestration.

The core principle is simple:

- **Skills** encode reusable process behavior
- **Subagents** execute isolated specialized work

---

## 2. Mental model

In this architecture:

- the **orchestrator** owns control flow
- **Skills** own procedural discipline
- **Subagents** own focused execution

This split is important because it prevents the system from becoming a set of agents improvising process ad hoc.

---

## 3. Role of Skills

Skills should define how each stage is supposed to work.

A Skill is the right place to encode:

- stage intent
- required inputs
- expected output format
- checklists
- quality criteria
- anti-patterns
- escalation rules

### Why Skills matter

Without Skills, every run has to re-invent process from scratch.
With Skills, the pipeline becomes more repeatable and less prompt-fragile.

---

## 4. Role of Subagents

Subagents should perform the heavy or specialized work for a specific stage.

Subagents are appropriate when you want:

- context isolation
- focused task execution
- parallel work
- specialized review
- bounded responsibility

### Why Subagents matter

A single overloaded agent thread tends to drift.
Subagents keep work scoped and make phase outputs easier to reason about.

---

## 5. Recommended v1 Skills

### 5.1 `sdd-intake`

Purpose:
- transform the raw request into a structured intake

Responsibilities:
- summarize objective
- identify unknowns
- surface constraints
- produce initial assumptions
- determine whether clarification is needed

Inputs:
- raw user request
- project/global rules

Outputs:
- `00-intake.md`

---

### 5.2 `sdd-spec-writer`

Purpose:
- produce the feature specification

Responsibilities:
- define behavior
- define success criteria
- include edge cases
- include non-goals
- keep implementation detail out unless needed for precision

Inputs:
- intake artifact
- clarifications
- global principles

Outputs:
- `01-spec.md`

---

### 5.3 `sdd-plan-architect`

Purpose:
- translate spec into technical plan

Responsibilities:
- choose architecture shape
- define constraints
- define validation approach
- identify risks
- optionally produce data model and contracts

Inputs:
- approved spec
- architecture rules
- coding standards

Outputs:
- `02-plan.md`
- optional `03-research.md`, `04-data-model.md`, `05-contracts.md`

---

### 5.4 `sdd-task-decomposer`

Purpose:
- convert plan into executable work units

Responsibilities:
- split work into reviewable tasks
- identify dependencies
- mark parallelizable work
- avoid over-large tasks

Inputs:
- spec + plan

Outputs:
- `06-tasks.md`

---

### 5.5 `sdd-implementer`

Purpose:
- implement task-scoped work

Responsibilities:
- execute one task or task bundle
- stay within scope
- run local checks when appropriate
- log what changed

Inputs:
- task assignment
- relevant artifacts
- repository context

Outputs:
- code changes
- `07-implementation-log.md`

---

### 5.6 `sdd-review-validator`

Purpose:
- validate implementation against both code-quality and artifact-quality expectations

Responsibilities:
- check tests/build/lint
- check spec conformance
- check plan conformance
- identify drift or unexplained deviations
- produce explicit pass/fail recommendation

Inputs:
- changed files
- spec + plan + tasks
- implementation log

Outputs:
- `08-validation.md`

---

### 5.7 `sdd-retrospective`

Purpose:
- improve the process over time

Responsibilities:
- classify failures
- identify root causes
- recommend changes to templates, Skills, or constraints
- preserve lessons for future work

Inputs:
- validation results
- implementation notes
- stage history

Outputs:
- `09-retrospective.md`

---

## 6. Recommended v1 Subagents

### 6.1 Spec Writer Subagent

Best used when:
- the request is non-trivial
- multiple scenarios/edge cases exist
- behavior needs careful normalization

Should not:
- design implementation detail prematurely

---

### 6.2 Planner / Architect Subagent

Best used when:
- architecture choices matter
- multiple modules or systems are involved
- constraints need to be made explicit

Should not:
- silently redefine feature scope

---

### 6.3 Task Decomposer Subagent

Best used when:
- implementation requires multiple reviewable steps
- parallelization is desirable
- dependencies must be made explicit

Should not:
- write tasks that are equivalent to full feature epics

---

### 6.4 Implementer Subagent(s)

Best used when:
- bounded task execution is needed
- parallel implementation is possible
- context isolation improves quality

Should not:
- freely redesign upstream artifacts
- silently expand scope

---

### 6.5 Reviewer / Validator Subagent

Best used when:
- a change must be checked independently of the implementer
- spec/plan drift needs detection
- review quality must be raised above self-checking

Should not:
- auto-approve unclear changes without explicit criteria

---

## 7. Handoff contracts

Every handoff between subagents should be explicit.

A handoff should specify:

- current stage
- artifact(s) to read
- output artifact(s) to produce
- scope boundaries
- success criteria
- what to do when blocked

Example handoff:

```text
Read 00-intake.md and produce 01-spec.md.
Do not propose implementation details unless necessary for behavioral precision.
Must include acceptance criteria, edge cases, and non-goals.
If ambiguity prevents completion, produce a clarification-needed section instead of guessing.
```

---

## 8. Escalation rules

A subagent should escalate instead of guessing when:

- core intent is ambiguous
- constraints conflict
- task granularity is unclear
- implementation requires changing upstream assumptions
- validation detects spec-level problems rather than code-only problems

Escalation is a feature, not a failure.
It preserves correctness.

---

## 9. Parallelism guidance

Parallelism should be introduced carefully.

Good candidates for parallel subagents:

- independent task implementations
- research threads
- validation across different axes
- documentation/test generation after stable plan exists

Bad candidates for parallelism:

- unresolved feature scope
- unclear architecture
- tightly coupled tasks with heavy shared state

Parallelism should happen **after** spec and plan stability, not before.

---

## 10. Governance principles

To keep Skills + Subagents credible in production-oriented use, the pipeline should follow these governance rules:

1. no direct jump from raw request to implementation for non-trivial work
2. subagents work from artifacts, not vague summaries
3. reviewers should be distinct from implementers when possible
4. phase completion should use definitions of done
5. failures should update process memory

---

## 11. Summary

The most important design insight is:

> You do not need Agent Teams to get multi-agent engineering value.

What you need is:

- a strong orchestrator
- a disciplined artifact model
- phase-specific Skills
- focused Subagents
- explicit handoff contracts

That is enough to build a serious v1 pipeline.

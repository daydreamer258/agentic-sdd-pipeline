# System Design

## 1. Overview

This document proposes a practical **v1 system design** for an **agentic programming pipeline** built around **Spec-Driven Development (SDD)**.

The target environment is constrained:

- Skills are available
- Subagents are available
- Agent Teams are not available

The design therefore assumes a **single orchestrator + phase-specific Skills + specialized Subagents** architecture.

---

## 2. Design goals

The system should:

1. turn vague requests into staged engineering artifacts
2. make AI coding work more reliably than raw prompt-to-code workflows
3. support traceability from implementation back to tasks, plan, and spec
4. keep humans in control of major state transitions
5. work in environments where orchestration primitives are limited to Skills + Subagents
6. improve over time through validation feedback and retrospectives

---

## 3. Non-goals for v1

The system does **not** attempt to:

- implement full spec-as-source development
- eliminate human review
- autonomously merge to production
- simulate complex agent-team topologies
- solve every project size with one identical workflow
- build a perfect universal standard for all organizations

v1 is intentionally scoped toward a **disciplined, reviewable, production-credible workflow**.

---

## 4. Core architecture

```text
User / Product Request
        |
        v
Main Orchestrator
  ├─ Intake / Clarify Skill
  ├─ Spec Writer Subagent
  ├─ Planner / Architect Subagent
  ├─ Task Decomposer Subagent
  ├─ Implementer Subagent(s)
  ├─ Reviewer / Validator Subagent
  └─ Retrospective / Feedback Stage
        |
        v
Artifact Store (feature folder + project-level process memory)
```

### 4.1 Main orchestrator responsibilities

The orchestrator is the control plane of the system.

Responsibilities:

- receive the original request
- determine current stage
- apply the correct Skill for that stage
- spawn the right subagent when needed
- validate required inputs exist before entering a stage
- decide whether to continue, block, or escalate to a human
- keep the artifact chain coherent
- record decisions and state transitions

The orchestrator should **not** be the primary heavy-lift implementer for large tasks.
Its value is workflow control, artifact discipline, and review routing.

---

## 5. Execution model

The v1 system uses a **phase-gated execution model**.

### Pipeline stages

1. Intake / Clarify
2. Specify
3. Plan
4. Task Decomposition
5. Implement
6. Validate / Review
7. Retrospective / Feedback

Each stage has:

- required inputs
- expected outputs
- a definition of done
- transition rules
- escalation conditions

### Why phase-gated?

This avoids the common failure mode where the agent jumps straight from request to implementation without:

- clarifying assumptions
- defining architecture
- constraining scope
- preparing validation criteria

---

## 6. State model

A feature/change request should be modeled as a stateful unit.

Suggested states:

- `intake_pending`
- `clarification_needed`
- `spec_drafting`
- `spec_review`
- `plan_drafting`
- `plan_review`
- `tasks_drafting`
- `tasks_review`
- `implementation_ready`
- `implementing`
- `validation_pending`
- `validation_failed`
- `revision_required`
- `validated`
- `retrospective_pending`
- `closed`

### State transition principle

A stage should not advance if required artifacts are missing or below quality threshold.

Example:

- no `01-spec.md` -> cannot enter planning
- no approved `02-plan.md` -> cannot enter task decomposition
- no `06-tasks.md` -> cannot start multi-task implementation
- validation failed -> must return to implementation or upstream artifact repair

---

## 7. Human-in-the-loop checkpoints

v1 should explicitly keep human checkpoints at major transitions.

Recommended approval points:

1. after spec drafting
2. after plan drafting
3. before implementation begins
4. after validation, before merge/closure

### Why this matters

Human review is the most efficient place to catch:

- wrong problem framing
- missing non-goals
- dangerous architectural assumptions
- over-scoped task plans
- implementation that passes tests but violates intent

---

## 8. Artifact-centric control plane

Artifacts are the backbone of the system.

The orchestrator should treat artifacts as the system state, not chat history alone.

Minimal v1 artifact set:

- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`
- `09-retrospective.md`

Optional but highly useful:

- `03-research.md`
- `04-data-model.md`
- `05-contracts.md` or `contracts/`

The orchestrator should always prefer reading current artifacts over relying on long conversational memory.

---

## 9. Subagent roles

### 9.1 Spec Writer

Input:
- intake artifact
- clarifications
- project-level rules

Output:
- draft spec

Focus:
- behavior
- success criteria
- edge cases
- non-goals

### 9.2 Planner / Architect

Input:
- approved or near-approved spec
- global architecture rules
- technical constraints

Output:
- implementation plan
- optional models/contracts/research

Focus:
- architecture
- boundaries
- stack choices
- operational constraints
- validation strategy

### 9.3 Task Decomposer

Input:
- spec + plan

Output:
- ordered task list

Focus:
- task granularity
- dependencies
- parallelizable work
- reviewable increments

### 9.4 Implementer

Input:
- task subset
- relevant artifacts
- repository context

Output:
- code changes
- implementation notes

Focus:
- bounded execution
- task conformance
- local validation

### 9.5 Reviewer / Validator

Input:
- changed files
- spec
- plan
- tasks

Output:
- validation report

Focus:
- spec conformance
- plan conformance
- drift detection
- quality and safety checks

---

## 10. Skills model

Skills should encode the reusable process layer.

Each phase-specific Skill should define:

- trigger conditions
- required inputs
- output template
- minimum completeness checks
- what to avoid
- when to escalate

Recommended v1 Skills:

- `sdd-intake`
- `sdd-spec-writer`
- `sdd-plan-architect`
- `sdd-task-decomposer`
- `sdd-implementer`
- `sdd-review-validator`
- `sdd-retrospective`

The orchestrator uses Skills to constrain behavior and Subagents to execute work.

---

## 11. Validation model

Validation in v1 should not be test-only.

The reviewer/validator should evaluate at least 3 axes:

1. **implementation correctness**
   - tests
   - linting
   - build success

2. **spec conformance**
   - does the implementation satisfy the intended behavior?
   - are success criteria covered?
   - are non-goals respected?

3. **plan conformance**
   - does the implementation respect architecture and constraints?
   - did it introduce drift or unapproved patterns?

A system that validates only tests will still accumulate architectural and behavioral drift.

---

## 12. Failure handling

The system should distinguish among failure classes.

### Class A: implementation failure
Examples:
- tests fail
- code broken
- task incomplete

Action:
- return to implement stage

### Class B: plan failure
Examples:
- chosen approach conflicts with constraints
- architecture assumptions invalid

Action:
- reopen planning

### Class C: spec failure
Examples:
- missing edge cases
- ambiguous intent
- repeated downstream misunderstanding

Action:
- reopen spec stage

### Class D: process failure
Examples:
- task granularity consistently wrong
- subagents repeatedly overstep boundaries
- validation catches the same defect type every run

Action:
- update Skills, templates, and process memory

---

## 13. Why this design is appropriate for v1

This design is intentionally conservative.

It favors:

- explicit state
- explicit artifacts
- human checkpoints
- simple orchestration
- reusable procedural constraints

over:

- highly autonomous graph execution
- speculative team-level delegation
- hidden state transitions
- free-form multi-agent improvisation

That tradeoff is appropriate because the first hard problem is not raw autonomy.
The first hard problem is **making the workflow inspectable, debuggable, and trustworthy**.

---

## 14. Open design questions

These questions should be resolved during the next planning pass:

1. What is the exact approval model between stages?
2. How strict should artifact templates be?
3. What should be mandatory vs optional in each feature folder?
4. How will project-level constitution/rules be stored?
5. How should implementation tasks be grouped for parallel execution?
6. How should validation results feed back into global process memory?
7. What should be persisted in repo vs external runtime memory?

---

## 15. Recommended next document

After this system design, the most natural next document is:

- [`artifact-model.md`](artifact-model.md)

because the artifact model is the concrete substrate the orchestrator will operate on.

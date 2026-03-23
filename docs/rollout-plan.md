# Rollout Plan

## 1. Purpose

This document outlines a practical rollout plan for evolving the project from research into a usable internal SDD-based agentic programming pipeline.

The plan assumes:

- constrained runtime (`Skills + Subagents`, no Agent Teams)
- desire for engineering credibility over flashy autonomy
- staged adoption with room for iteration

---

## 2. Rollout philosophy

The rollout should optimize for:

- usability over theoretical completeness
- inspectability over hidden autonomy
- repeatability over novelty
- progressive hardening over big-bang architecture

That means building the system in layers.

---

## 3. Maturity levels

### Level 0 — Research and documentation

Objective:
- clarify concepts, patterns, scope, and constraints

Outputs:
- shareable overview
- system design draft
- artifact model
- role definitions

Status:
- currently in progress

---

### Level 1 — Manual artifact-driven pipeline

Objective:
- prove the workflow before full automation

Characteristics:
- orchestrator follows explicit stages
- artifacts created manually or semi-manually
- subagents used selectively
- strong human checkpoints
- no aggressive CI automation yet

Success criteria:
- can run one feature from intake to validated implementation
- artifacts remain coherent
- no stage skipping for non-trivial work

---

### Level 2 — Operationalized Skills + Subagents pipeline

Objective:
- make the workflow repeatable and reusable

Characteristics:
- phase-specific Skills exist
- handoff contracts standardized
- feature folder structure stabilized
- subagent roles consistently applied
- validation artifact standardized

Success criteria:
- same workflow can be reused across multiple features
- repeated process errors begin to decline
- reviewers can understand changes from artifacts alone

---

### Level 3 — Semi-automated governance

Objective:
- harden the system for larger-scale or more serious internal use

Characteristics:
- some machine-readable contracts
- drift checks in CI
- stronger validation gates
- more systematic retrospectives
- tighter integration with project-level rules

Success criteria:
- system catches more failures before merge
- process memory starts improving future runs materially
- architecture drift becomes measurable

---

## 4. Recommended implementation order

### Step 1: finalize docs

Create stable docs for:
- system design
- artifact model
- Skills/subagents
- rollout plan

Why first:
- prevents early implementation chaos
- gives a stable design target

### Step 2: define templates

Create templates for:
- intake
- spec
- plan
- tasks
- validation
- retrospective

Why second:
- templates are the practical bridge between docs and execution

### Step 3: define stage rules

Specify:
- required inputs
- outputs
- done criteria
- transition rules
- escalation rules

Why third:
- stage rules make orchestrator behavior predictable

### Step 4: implement first Skills

Build at least:
- intake
- spec-writer
- plan-architect
- task-decomposer
- review-validator

Why fourth:
- these define process discipline before implementation scale increases

### Step 5: trial one real feature end-to-end

Use the pipeline on a non-trivial but bounded feature.

Measure:
- where ambiguity appears
- which artifacts are over/under-specified
- where subagent boundaries fail
- whether validation catches the right problems

### Step 6: revise process before scaling

Do not scale immediately after first success.

First revise:
- templates
- Skills
- artifact rules
- review checkpoints

---

## 5. Suggested pilot criteria

A good pilot feature should be:

- real enough to matter
- bounded enough to complete
- multi-step but not massive
- able to exercise spec -> plan -> tasks -> implementation -> validation
- not so urgent that experimentation becomes unsafe

Avoid using the very first pipeline run on:
- extremely high-risk production work
- vague strategy problems
- giant refactors
- broad platform rewrites

---

## 6. Metrics to watch

v1 metrics do not need to be fancy.

Useful rollout indicators:

### Process quality
- % of features with complete artifact chain
- % of runs that required spec revision
- % of runs where tasks were too large or too vague
- % of validation failures caused by artifact problems vs code problems

### Workflow efficiency
- time from intake to validated plan
- time from tasks to validated implementation
- review latency

### Reliability
- number of scope drifts caught before merge
- number of repeated failure patterns
- number of implementation deviations not explained in artifacts

### Adoption quality
- whether humans can understand the feature from docs alone
- whether subagents remain within scope
- whether retrospectives lead to actual template/Skill updates

---

## 7. Risks during rollout

### Risk 1: over-designing before proving workflow
Mitigation:
- pilot with a bounded real feature early

### Risk 2: making templates too rigid
Mitigation:
- allow optional sections and explicit omission notes

### Risk 3: false confidence from test-only validation
Mitigation:
- always include spec and plan conformance review

### Risk 4: subagents overstepping role boundaries
Mitigation:
- use explicit handoff contracts and escalation rules

### Risk 5: process fatigue
Mitigation:
- keep v1 minimal and only require artifacts that materially improve outcomes

---

## 8. What success looks like after the first few iterations

After several real runs, a healthy rollout should produce:

- a stable feature folder pattern
- better specs with fewer downstream misunderstandings
- better task granularity
- more predictable implementation handoffs
- clearer validation outcomes
- reusable Skills that reduce prompt variance
- retrospectives that actually change process behavior

---

## 9. Immediate next actions

The next likely implementation steps for this project are:

1. decide the exact repo layout for templates and examples
2. write artifact templates
3. define first-pass stage checklists
4. choose one pilot feature
5. execute the pilot end-to-end
6. run retrospective and tighten the process

---

## 10. Summary

The rollout plan should treat this project as a progressive engineering system, not a one-shot automation stunt.

The sequence should be:

```text
research -> documentation -> templates -> stage rules -> pilot -> refine -> operationalize
```

That is the most credible path from idea to a usable internal SDD pipeline.

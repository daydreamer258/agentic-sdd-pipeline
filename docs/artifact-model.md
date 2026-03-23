# Artifact Model

## 1. Purpose

This document defines the artifact model for the agentic SDD pipeline.

Artifacts are not just documentation.
They are the **state-bearing objects** that allow the system to:

- hand work across stages
- preserve traceability
- support review and validation
- make the workflow inspectable and repeatable

---

## 2. Design principles

The artifact model should be:

- minimal enough for v1
- explicit enough to support traceability
- readable by humans
- consumable by agents
- evolvable over time

Artifacts should be preferred over long implicit conversational state.

---

## 3. Feature folder structure

Each feature / change request should live in its own folder.

Suggested structure:

```text
features/
  <feature-id>-<slug>/
    00-intake.md
    01-spec.md
    02-plan.md
    03-research.md
    04-data-model.md
    05-contracts.md
    06-tasks.md
    07-implementation-log.md
    08-validation.md
    09-retrospective.md
```

Example:

```text
features/
  001-user-search/
    00-intake.md
    01-spec.md
    02-plan.md
    06-tasks.md
    07-implementation-log.md
    08-validation.md
```

v1 may allow some files to be absent when unnecessary.

---

## 4. Mandatory vs optional artifacts

### Mandatory in v1

- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`

### Optional in v1

- `03-research.md`
- `04-data-model.md`
- `05-contracts.md` or `contracts/`
- `09-retrospective.md`

### Recommended policy

Even if some artifacts are optional, the orchestrator should create placeholders or explicit "not needed" notes where useful.

That helps avoid ambiguity about whether a file is missing accidentally or intentionally omitted.

---

## 5. Artifact definitions

### 5.1 `00-intake.md`

Purpose:
- capture the original request in structured form
- record assumptions, questions, constraints, and initial scope

Should include:
- request summary
- known constraints
- unknowns / questions
- initial success definition
- links to source context if needed

---

### 5.2 `01-spec.md`

Purpose:
- define the intended behavior and outcomes
- act as the primary source of truth for what is being built

Should include:
- problem statement
- users / actors
- desired behavior
- acceptance criteria
- edge cases
- non-goals
- assumptions

The spec should describe **what** and **why**, not implementation detail unless needed for precision.

---

### 5.3 `02-plan.md`

Purpose:
- define the intended implementation approach
- translate behavioral intent into technical structure

Should include:
- architecture summary
- major components/modules
- stack choices
- constraints and rationale
- validation approach
- operational/security/performance considerations
- known risks

The plan defines **how** the feature should be built.

---

### 5.4 `03-research.md`

Purpose:
- capture supporting investigation

May include:
- technical option comparisons
- benchmark notes
- prior-art notes
- third-party library evaluation
- design references

Use when the feature requires non-trivial external investigation.

---

### 5.5 `04-data-model.md`

Purpose:
- define core entities and structures

May include:
- entities
- fields
- relations
- lifecycle/state notes
- schema decisions

Use when the feature changes storage, state, or domain models.

---

### 5.6 `05-contracts.md` or `contracts/`

Purpose:
- define integration contracts

May include:
- API endpoints
- request/response structure
- event payloads
- versioning notes
- compatibility constraints

Use when the feature exposes or consumes formal interfaces.

---

### 5.7 `06-tasks.md`

Purpose:
- define executable implementation units

Should include:
- ordered tasks
- task descriptions
- dependencies
- parallel markers where applicable
- validation hints per task

Tasks should be small enough to:
- implement in isolation
- review independently
- validate independently

---

### 5.8 `07-implementation-log.md`

Purpose:
- capture what was actually done during execution

Should include:
- task(s) attempted
- files changed
- important decisions made during execution
- blockers or deviations
- notes for reviewer

This is useful for both human review and retrospective improvement.

---

### 5.9 `08-validation.md`

Purpose:
- capture validation outcomes

Should include:
- checks run
- test/build/lint outcomes
- spec conformance findings
- plan conformance findings
- drift or quality concerns
- pass/fail recommendation

This is the core artifact for deciding whether the change can advance.

---

### 5.10 `09-retrospective.md`

Purpose:
- turn failures and lessons into process improvements

Should include:
- what went well
- what failed
- root causes
- whether the issue came from spec / plan / tasks / implementation / validation
- what should change in process/templates/Skills

This artifact closes the loop and improves future runs.

---

## 6. Naming and numbering

Feature folders should be stable and sortable.

Recommended format:

```text
<sequence>-<short-slug>
```

Examples:

- `001-user-search`
- `002-auth-hardening`
- `003-billing-webhook-retry`

Benefits:
- easy ordering
- stable references
- simple human scanning

---

## 7. Status metadata

Each artifact may optionally include frontmatter or a status block.

Example:

```md
status: draft
owner: spec-writer
updated_at: 2026-03-23
related_feature: 001-user-search
```

v1 can keep this lightweight.
The main goal is to support reliable stage tracking.

---

## 8. Artifact quality rules

### Intake quality
- request summarized correctly
- obvious unknowns surfaced

### Spec quality
- clear success criteria
- edge cases present
- non-goals present
- behavior oriented

### Plan quality
- architecture coherent
- constraints explicit
- validation strategy included

### Task quality
- tasks reviewable and bounded
- dependency ordering reasonable
- tasks not too large

### Validation quality
- checks actually run
- conformance discussed, not only tests

---

## 9. Artifact transition rules

Examples:

- `01-spec.md` must exist before `02-plan.md`
- `02-plan.md` must exist before `06-tasks.md`
- `06-tasks.md` must exist before implementation delegation
- validation cannot be finalized without implementation log + test results

The orchestrator should enforce these rules automatically where possible.

---

## 10. Global artifacts vs feature-local artifacts

### Feature-local artifacts
Used for one feature/change.

### Global artifacts
Used across all features.

Recommended global files for later:

```text
process/
  constitution.md
  engineering-principles.md
  coding-standards.md
  testing-policy.md
  security-constraints.md
```

These should shape planning and validation across all feature folders.

---

## 11. Future evolution

The artifact model can evolve in later versions to support:

- machine-readable contracts
- generated docs
- CI drift checking
- richer frontmatter metadata
- automated task status updates
- artifact graph visualizations

But v1 should remain simple enough to use consistently.

---

## 12. Summary

The artifact model is the operating substrate of the SDD pipeline.

Without it, the workflow collapses into prompt chains.
With it, the system gains:

- traceability
- inspectability
- reuse
- reviewability
- process memory

That is what makes the pipeline feel like engineering rather than improvisation.

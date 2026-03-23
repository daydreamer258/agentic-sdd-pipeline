# Stage Rules

## 1. Purpose

This document defines the stage rules for the lightweight v1 pipeline.

Each stage has:

- required inputs
- outputs
- definition of done
- failure / escalation conditions
- relevant hook touchpoints

---

## 2. Stage: feature init

### Purpose
Create the feature folder and seed baseline artifacts.

### Required inputs
- feature id
- feature slug
- short title

### Outputs
- feature folder created
- baseline files scaffolded
- `state.json` initialized

### Done when
- feature folder exists
- required files exist

### Hooks
- `on_feature_init`

---

## 3. Stage: intake

### Required inputs
- raw request
- existing project/global rules if available

### Outputs
- `00-intake.md`

### Done when
- request summarized
- constraints noted
- unknowns or assumptions noted

### Escalate when
- core objective is ambiguous
- critical constraints are missing

---

## 4. Stage: spec

### Required inputs
- `00-intake.md`

### Outputs
- `01-spec.md`

### Done when
- problem statement exists
- acceptance criteria exist
- edge cases exist
- non-goals exist

### Escalate when
- behavior is too ambiguous to specify
- feature scope is unstable

### Hooks
- `before_stage_transition`
- `after_artifact_write`

---

## 5. Stage: plan

### Required inputs
- `01-spec.md`

### Outputs
- `02-plan.md`
- optional `03-research.md`, `04-data-model.md`, `05-contracts.md`

### Done when
- architecture summary exists
- constraints/rationale exist
- validation approach exists

### Escalate when
- architecture depends on unresolved product decisions
- required integrations are unknown

### Hooks
- `before_stage_transition`
- `after_artifact_write`

---

## 6. Stage: tasks

### Required inputs
- `01-spec.md`
- `02-plan.md`

### Outputs
- `06-tasks.md`

### Done when
- tasks are ordered
- tasks are bounded
- dependencies are clear enough to execute

### Escalate when
- tasks are still epic-sized
- implementation boundaries remain unclear

### Hooks
- `before_stage_transition`
- `after_artifact_write`

---

## 7. Stage: implement

### Required inputs
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`

### Outputs
- code changes
- `07-implementation-log.md`

### Done when
- targeted task(s) implemented
- changed files logged
- local validation notes captured

### Escalate when
- implementation requires changing upstream scope or assumptions
- the task breakdown is not actually executable

### Hooks
- `before_stage_transition`
- `before_implement`
- `after_artifact_write`

---

## 8. Stage: validate

### Required inputs
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`

### Outputs
- `08-validation.md`

### Done when
- implementation checks recorded
- spec conformance assessed
- recommendation recorded

### Escalate when
- validation reveals spec/plan failures rather than code-only failures

### Hooks
- `before_stage_transition`
- `after_validation`

---

## 9. Stage: retrospective (optional in v1)

### Required inputs
- `08-validation.md`
- implementation history

### Outputs
- `09-retrospective.md`

### Done when
- root cause class identified
- improvement actions proposed

---

## 10. Transition rules summary

- `spec` requires `00-intake.md`
- `plan` requires `01-spec.md`
- `tasks` requires `01-spec.md` + `02-plan.md`
- `implement` requires `01-spec.md` + `02-plan.md` + `06-tasks.md`
- `validate` requires `07-implementation-log.md` in addition to upstream artifacts

No non-trivial feature should skip these transitions.

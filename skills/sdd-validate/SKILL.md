# sdd-validate

## Purpose

Review implementation results against both code execution outcomes and upstream artifacts, and write `08-validation.md`.

---

## When to use

Use this Skill when the pipeline is at the **validate** stage.

---

## Inputs

Read:
- `features/<feature>/01-spec.md`
- `features/<feature>/02-plan.md`
- `features/<feature>/06-tasks.md`
- `features/<feature>/07-implementation-log.md`
- changed files / available test outputs
- `templates/08-validation.md`

Write:
- `features/<feature>/08-validation.md`

---

## Required output

The validation artifact must include:

- checks run
- results
- spec conformance
- plan conformance
- recommendation

---

## Behavioral rules

- Validate behavior, not only code execution.
- Compare implementation to both spec and plan.
- Be explicit about whether issues are code-level or upstream-artifact-level.
- Prefer actionable review language.

---

## Must avoid

- treating test pass/fail as the whole validation story
- approving changes with unclear conformance
- hiding uncertainty about whether rework is needed

---

## Escalate when

Escalate if:
- the real failure source is the spec or plan
- validation cannot be completed due to missing evidence
- implementation behavior is too ambiguous to judge confidently

---

## Definition of done

This Skill is done when `08-validation.md` gives a clear pass/rework signal and explains why.

# sdd-implement

## Purpose

Execute the implementation stage of the lightweight SDD pipeline: apply bounded changes to the repository and record the work in `07-implementation-log.md`.

---

## When to use

Use this Skill when the pipeline is at the **implement** stage.

---

## Inputs

Read:
- `features/<feature>/01-spec.md`
- `features/<feature>/02-plan.md`
- `features/<feature>/06-tasks.md`
- repository files relevant to the current task
- `templates/07-implementation-log.md`

Write:
- repository code/docs/scripts as needed
- `features/<feature>/07-implementation-log.md`

---

## Required output

The implementation stage must produce:

- the intended bounded repository changes
- an implementation log covering tasks attempted, files changed, key decisions, and blockers/deviations

---

## Behavioral rules

- Stay within the current task scope.
- Prefer the smallest useful implementation that satisfies the current tasks.
- Respect upstream spec and plan constraints.
- Record meaningful decisions and deviations in the implementation log.

---

## Must avoid

- silent scope expansion
- redesigning the feature without escalation
- changing unrelated files
- skipping the implementation log

---

## Escalate when

Escalate if:
- tasks are too vague to implement safely
- implementation requires changing the spec or plan materially
- repository state makes the requested implementation ambiguous or unsafe

---

## Definition of done

This Skill is done when the bounded implementation changes are made and `07-implementation-log.md` accurately describes what happened.

# sdd-plan

## Purpose

Translate `01-spec.md` into a technical `02-plan.md` suitable for lightweight execution.

---

## When to use

Use this Skill when the pipeline is at the **plan** stage.

---

## Inputs

Read:
- `features/<feature>/01-spec.md`
- optional project/runtime constraints
- `templates/02-plan.md`

Write:
- `features/<feature>/02-plan.md`
- optionally `03-research.md`, `04-data-model.md`, `05-contracts.md`

---

## Required output

The plan must include:

- architecture summary
- components / modules
- constraints and rationale
- risks
- validation approach

---

## Behavioral rules

- Translate behavior into implementation structure.
- Keep the plan aligned with the spec.
- Name constraints explicitly.
- Prefer lightweight, repo-compatible decisions for v1.
- Call out risk instead of hiding uncertainty.

---

## Must avoid

- silently redefining feature behavior
- introducing unnecessary system complexity for a lightweight pilot
- using the plan as a place to expand scope casually

---

## Escalate when

Escalate if:
- technical direction depends on unresolved product decisions
- the repository/tooling constraints are insufficiently known
- the spec is too ambiguous to support coherent planning

---

## Definition of done

This Skill is done when `02-plan.md` is concrete enough that tasks can be decomposed without reopening basic architectural questions.

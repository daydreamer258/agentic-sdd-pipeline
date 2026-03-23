# sdd-spec

## Purpose

Turn `00-intake.md` into a behavior-oriented `01-spec.md`.

---

## When to use

Use this Skill when the pipeline is at the **spec** stage.

Typical trigger:
- intake has been completed
- `run-stage.sh` or `execute-stage.sh` indicates `sdd-spec`

---

## Inputs

Read:
- `features/<feature>/00-intake.md`
- `templates/01-spec.md`

Write:
- `features/<feature>/01-spec.md`

---

## Required output

The spec must include:

- problem statement
- users / actors
- desired behavior
- acceptance criteria
- edge cases
- non-goals
- assumptions

---

## Behavioral rules

- Focus on **what** the system should do and **why**.
- Keep the spec behavior-oriented.
- Make success criteria explicit.
- Include non-goals to prevent scope drift.
- Use implementation details only when necessary for precision.

---

## Must avoid

- writing a technical plan inside the spec
- adding architecture decisions too early
- broadening feature scope beyond intake without explicit note

---

## Escalate when

Escalate instead of guessing if:
- user behavior remains materially ambiguous
- success criteria cannot be made concrete
- the feature scope appears unstable or contradictory

If escalation is needed, record the blocking ambiguity inside the spec draft.

---

## Definition of done

This Skill is done when `01-spec.md` is clear enough that a planner can design implementation without having to infer core behavior.

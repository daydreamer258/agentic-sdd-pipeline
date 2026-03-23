# sdd-tasks

## Purpose

Turn `01-spec.md` + `02-plan.md` into executable, bounded `06-tasks.md`.

---

## When to use

Use this Skill when the pipeline is at the **tasks** stage.

---

## Inputs

Read:
- `features/<feature>/01-spec.md`
- `features/<feature>/02-plan.md`
- `templates/06-tasks.md`

Write:
- `features/<feature>/06-tasks.md`

---

## Required output

The task artifact must include:

- ordered tasks
- dependencies
- parallelizable work (if any)
- validation notes

---

## Behavioral rules

- Tasks must be bounded and reviewable.
- Prefer vertical slices over vague epics.
- Make dependencies explicit.
- Keep tasks actionable enough for an implementer to execute.

---

## Must avoid

- giant umbrella tasks
- task lists that merely restate the plan without decomposition
- hiding critical sequencing assumptions

---

## Escalate when

Escalate if:
- the plan is still too high-level for decomposition
- tasks cannot be made bounded without revisiting planning
- key technical assumptions remain unstable

---

## Definition of done

This Skill is done when an implementer can pick up a task and execute it without needing to rediscover the plan from scratch.

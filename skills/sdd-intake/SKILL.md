# sdd-intake

## Purpose

Convert a raw request into a structured `00-intake.md` artifact for the lightweight SDD workflow.

---

## When to use

Use this Skill when a feature folder exists and the pipeline is at the **intake** stage.

Typical trigger:
- a new feature has just been initialized
- `00-intake.md` still contains template content or needs to be rewritten from a real request

---

## Inputs

Read:
- raw request or task statement
- optional project constraints
- feature folder path
- `templates/00-intake.md` for expected structure

Write:
- `features/<feature>/00-intake.md`

---

## Required output

The intake artifact must include:

- request summary
- why it matters
- constraints
- unknowns / questions
- initial success definition

---

## Behavioral rules

- Be faithful to the original request.
- Prefer clarity over verbosity.
- Surface ambiguity instead of papering over it.
- Do not prematurely solve architecture or implementation design here.

---

## Must avoid

- turning the intake into a plan
- silently inventing missing constraints
- skipping unknowns just to make the document look complete

---

## Escalate when

Escalate instead of guessing if:
- the request is too vague to summarize accurately
- critical constraints are missing
- multiple conflicting interpretations seem plausible

In that case, write the ambiguity explicitly into the intake artifact.

---

## Definition of done

This Skill is done when `00-intake.md` gives the next stage enough clarity to write a proper spec without needing to reverse-engineer user intent.

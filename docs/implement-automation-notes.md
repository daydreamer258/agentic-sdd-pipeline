# Implement Automation Notes

## 1. Purpose

This document records the current state of `implement` automation in the lightweight SDD pipeline.

---

## 2. Current status

`implement` is now wired into:

- `sdd-implement` Skill
- `implementer` subagent role
- `consume-stage-with-claude.sh`
- `auto-workflow.sh`

This means the repository now has a structural path for automatic implementation.

---

## 3. Important caveat

`implement` is fundamentally different from the earlier stages.

Unlike:
- `intake`
- `spec`
- `plan`
- `tasks`
- `validate`

`implement` is not just markdown artifact generation.
It may modify actual repository files.

So even though the wiring exists, `implement` should still be treated as:

> bounded and experimental

until more validation and policy exist.

---

## 4. Why it is marked experimental

Reasons:

1. implementation may modify arbitrary files
2. validation quality is still lightweight
3. checkpoint policy is not yet formalized
4. backend quota and local environment constraints make repeated end-to-end proving slower than earlier text-only stages

---

## 5. Recommended usage right now

Best practice at the current maturity level:

- use auto workflow freely through `tasks`
- use `implement` automation only for bounded, low-risk repository tasks
- prefer inspection before automatically chaining into `validate`

---

## 6. What needs to happen next

To move `implement` from experimental to more standard use, the project should add:

- stronger validation
- better checkpoint policy
- more real implementation pilots
- cleaner backend/bundle integration
- optional safety controls for file modification scope

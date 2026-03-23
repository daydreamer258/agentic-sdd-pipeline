# agentic-sdd-pipeline

A research-first open-source project about building an **agentic programming pipeline** around **Spec-Driven Development (SDD)**.

This repository focuses on a practical constraint that many real systems have:

- you may have **Skills**
- you may have **Subagents**
- but you may **not** have full-blown **Agent Teams**

The goal of this project is to explore how far a disciplined, artifact-driven SDD workflow can go in that environment.

---

## What this repo is about

This project studies how to build an AI coding workflow that is:

- faster than traditional handoffs
- more reliable than raw vibe coding
- structured enough for real engineering work
- composable with Skills + Subagents
- suitable for future system design and implementation

In short:

> **Use specifications, plans, tasks, and validation artifacts to turn agentic coding into an engineering pipeline.**

---

## Why this matters

Modern coding agents are increasingly capable of:

- exploring repositories
- generating code
- debugging iteratively
- applying patches across multiple files
- running tests and reacting to failures

But they still struggle when:

- requirements are vague
- architecture is implicit
- constraints are scattered
- tasks are too large
- no validation gates exist

That is exactly where **Spec-Driven Development (SDD)** becomes useful.

SDD shifts the workflow from:

```text
prompt -> code -> patch problems later
```

to:

```text
intent -> spec -> plan -> tasks -> implementation -> validation
```

---

## Current thesis

The working thesis of this repo is:

> A serious agentic coding system does **not** need heavyweight agent-team orchestration first.
> It can start with **one orchestrator**, **phase-specific Skills**, **specialized Subagents**, and a strong **artifact model**.

That means a practical v1 can be built around:

- one orchestrator agent
- explicit phases
- reusable Skills for each phase
- Subagents for specialized execution
- feature folders with traceable artifacts
- validation and retrospective loops

---

## Repository structure

```text
.
├── README.md
└── docs/
    └── shareable-overview.md
```

As the project evolves, this repository will likely grow to include:

```text
.
├── README.md
├── docs/
│   ├── shareable-overview.md
│   ├── system-design.md
│   ├── artifact-model.md
│   ├── skills-and-subagents.md
│   └── rollout-plan.md
├── templates/
├── examples/
└── references/
```

---

## Recommended maturity model

This repo currently treats SDD as having three practical maturity levels:

### 1. Spec-First
- write the spec before coding
- already much better than pure vibe coding
- good starting point

### 2. Spec-Anchored
- keep the spec alive after implementation
- use it for evolution, review, and maintenance
- recommended target for a real internal pipeline

### 3. Spec-as-Source
- spec becomes the primary long-term editable artifact
- powerful, but too aggressive for most v1 systems

**Recommended starting point:**

- start with **Spec-First + Spec-Anchored**
- avoid jumping directly to full **Spec-as-Source**

---

## What a practical SDD loop looks like

A useful working loop is:

```text
Intake / Clarify
-> Specify
-> Plan
-> Task Decomposition
-> Implement
-> Validate / Review
-> Feed lessons back into specs, plans, and process
```

This creates an engineering loop where:

- every implementation traces back to tasks
- every task traces back to a plan/spec
- validation checks conformance, not just test pass/fail
- repeated failures improve upstream artifacts and process memory

---

## Who this repo is for

This repository is relevant if you are:

- designing an internal agentic coding platform
- experimenting with AI-native software engineering workflows
- trying to apply SDD in a practical way
- working in a constrained runtime that supports only Skills + Subagents
- interested in turning research into a real engineering pipeline

---

## Current document

The main shareable research write-up currently lives here:

- [`docs/shareable-overview.md`](docs/shareable-overview.md)

It covers:

- the Claude Code / agentic coding mental model
- what SDD is and why it matters
- how SDD differs from raw vibe coding
- why artifacts matter more than just adding more agents
- how to adapt SDD to a `skills + subagents` runtime
- what a strong v1 architecture should look like

---

## Project status

This repository is currently in the **research and synthesis** stage.

What has been done:

- gathered public material on SDD and agentic coding
- synthesized a shareable overview
- distilled a practical direction for a v1 pipeline

What comes next:

- formal system design
- artifact model definition
- Skill boundary design
- Subagent responsibility design
- rollout planning
- implementation prototypes

---

## References

Initial source themes include:

- GitHub Spec Kit docs and blog posts
- Microsoft articles on Spec Kit / SDD
- InfoQ analysis of SDD as an architectural pattern
- Thoughtworks observations on good specs and workflow design
- Martin Fowler’s comparison of SDD tool styles
- Google Cloud material on agentic coding

A fuller reference list is included in:

- [`docs/shareable-overview.md`](docs/shareable-overview.md)

---

## License

No license has been chosen yet.

Until a license is added, treat this repository as **all rights reserved by default**.

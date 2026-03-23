# agentic-sdd-pipeline

A research-first open-source project about building an **agentic programming pipeline** around **Spec-Driven Development (SDD)**.

This repository focuses on a practical constraint that many real systems have:

- you may have **Skills**
- you may have **Subagents**
- you may have **Hooks**
- but you may **not** have full-blown **Agent Teams**

The goal of this project is to explore how far a disciplined, artifact-driven SDD workflow can go in that environment.

---

## What this repo is about

This project studies how to build an AI coding workflow that is:

- faster than traditional handoffs
- more reliable than raw vibe coding
- structured enough for real engineering work
- composable with Skills + Subagents + Hooks
- suitable for future system design and implementation

In short:

> **Use specifications, plans, tasks, validation artifacts, and lightweight hooks to turn agentic coding into an engineering pipeline.**

---

## Current status

This repository has now moved beyond pure research notes.

It currently contains:

- shareable background research
- v1 system design docs
- a lightweight v1 definition
- stage rules
- minimal artifact templates
- hook skeletons
- a tiny runnable scaffold for initializing a feature folder

This means the repo now contains a **lightweight runnable skeleton**, not just theory.

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
> It can start with **one orchestrator**, **phase-specific Skills**, **specialized Subagents**, a strong **artifact model**, and a small set of **Hooks**.

That means a practical v1 can be built around:

- one orchestrator agent
- explicit phases
- reusable Skills for each phase
- Subagents for specialized execution
- Hooks for stage gating and scaffolding
- feature folders with traceable artifacts
- validation and retrospective loops

---

## Repository structure

```text
.
├── README.md
├── docs/
│   ├── artifact-model.md
│   ├── lightweight-v1.md
│   ├── rollout-plan.md
│   ├── shareable-overview.md
│   ├── skills-and-subagents.md
│   ├── stage-rules.md
│   └── system-design.md
├── examples/
│   └── 001-demo-search/
├── hooks/
│   ├── README.md
│   ├── after_artifact_write.sh
│   ├── after_validation.sh
│   ├── before_implement.sh
│   ├── before_stage_transition.sh
│   └── on_feature_init.sh
├── scripts/
│   └── init-feature.sh
├── templates/
│   ├── 00-intake.md
│   ├── 01-spec.md
│   ├── 02-plan.md
│   ├── 06-tasks.md
│   ├── 07-implementation-log.md
│   └── 08-validation.md
└── features/
```

---

## Runnable lightweight v1

The current repo includes a minimal runnable path.

### What it can do right now

- scaffold a feature folder
- create baseline artifacts from templates
- gate stage transitions using hooks
- check implementation prerequisites before entering implementation

### Quick demo

```sh
./scripts/init-feature.sh 001 demo-search "Demo Search"
./hooks/before_stage_transition.sh ./features/001-demo-search spec
./hooks/before_stage_transition.sh ./features/001-demo-search plan
./hooks/before_stage_transition.sh ./features/001-demo-search tasks
./hooks/before_implement.sh ./features/001-demo-search
```

After this, the feature folder contains:

- `00-intake.md`
- `01-spec.md`
- `02-plan.md`
- `06-tasks.md`
- `07-implementation-log.md`
- `08-validation.md`
- `state.json`

This is intentionally minimal, but it is enough to prove the workflow skeleton is executable.

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

## Core documents

### Overview and research
- [`docs/shareable-overview.md`](docs/shareable-overview.md)

### System design
- [`docs/system-design.md`](docs/system-design.md)
- [`docs/artifact-model.md`](docs/artifact-model.md)
- [`docs/skills-and-subagents.md`](docs/skills-and-subagents.md)
- [`docs/stage-rules.md`](docs/stage-rules.md)
- [`docs/lightweight-v1.md`](docs/lightweight-v1.md)
- [`docs/rollout-plan.md`](docs/rollout-plan.md)

### Hook and template layer
- [`hooks/README.md`](hooks/README.md)
- [`templates/`](templates/)
- [`scripts/init-feature.sh`](scripts/init-feature.sh)

---

## Who this repo is for

This repository is relevant if you are:

- designing an internal agentic coding platform
- experimenting with AI-native software engineering workflows
- trying to apply SDD in a practical way
- working in a constrained runtime that supports only Skills + Subagents + Hooks
- interested in turning research into a real engineering pipeline

---

## Project status

This repository is currently in the **lightweight runnable v1 skeleton** stage.

What has been done:

- gathered public material on SDD and agentic coding
- synthesized a shareable overview
- wrote system design documents
- defined a lightweight v1 model
- created minimal templates
- created hook skeletons
- verified the basic scaffold path works locally

What comes next:

- refine templates
- define stronger stage metadata
- add richer validation behavior
- pilot a real feature through the workflow
- tighten Skills/Subagent boundaries
- add implementation examples

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

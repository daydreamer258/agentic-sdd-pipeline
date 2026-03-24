# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**agentic-sdd-pipeline** is a research-and-runnable project demonstrating how to build an AI-native software development pipeline around **Spec-Driven Development (SDD)**. It uses shell scripts for orchestration, markdown artifacts as the unit of work, and Claude Code CLI as the primary backend consumer.

The core thesis: a serious agentic coding system can start with one orchestrator, phase-specific Skills, specialized Subagents, a strong artifact model, and a small set of Hooks — no heavyweight agent-team orchestration needed.

## Key Commands

```bash
# Initialize a new feature
./scripts/init-feature.sh <id> <slug> [title]
# Example: ./scripts/init-feature.sh 007 my-feature "My Feature"

# Run a single stage for a feature
./scripts/run-stage.sh <feature-dir> <stage>
# Example: ./scripts/run-stage.sh ./features/007-my-feature spec

# Run automated workflow (full pipeline or range)
./scripts/auto-workflow.sh <feature-dir> full [start-stage] [end-stage]
./scripts/auto-workflow.sh <feature-dir> single <stage>
./scripts/auto-workflow.sh <feature-dir> range <start-stage> <end-stage>
# Example: ./scripts/auto-workflow.sh ./features/007-my-feature full intake tasks

# Directly invoke Claude Code backend for a stage
./scripts/consume-stage-with-claude.sh <feature-dir> <stage>

# Mark artifact complete (update state.json)
./scripts/complete-artifact.sh <feature-dir> <artifact-path>

# Check feature status
./scripts/feature-summary.sh <feature-dir>
```

Valid stages: `intake`, `spec`, `plan`, `tasks`, `implement`, `validate`

## Architecture

### Pipeline Flow

Each feature progresses through 6 stages, each producing a markdown artifact:

```
intake (00-intake.md)
  → spec (01-spec.md)
    → plan (02-plan.md)
      → tasks (06-tasks.md)
        → implement (07-implementation-log.md)
          → validate (08-validation.md)
```

State is tracked in `features/<id>-<slug>/state.json`.

### Component Layers

**Orchestration (`scripts/`)** — Shell scripts manage stage sequencing, hook invocation, and backend dispatch. `auto-workflow.sh` is the main entry point; `run-stage.sh` handles individual stage execution; `state-lib.sh` provides shared state helpers.

**Runtime Handlers (`runtime/handlers/`)** — One handler per stage. Each handler calls `build-stage-bundle.sh` to assemble a `.runtime/<stage>.bundle.md` context file, then reports readiness. The bundle contains skill prompt, subagent role, templates, and input/output artifact paths.

**Hooks (`hooks/`)** — Lightweight stage gating. `before_stage_transition.sh` enforces artifact dependency chain (e.g., spec requires `00-intake.md`). `on_feature_init.sh` scaffolds the feature folder. Other hooks are skeletons awaiting implementation.

**Prompt Layer (`skills/`, `subagents/`)** — Skills define behavioral rules for each stage (`skills/sdd-<stage>/SKILL.md`). Subagents define role-specific personas (`subagents/<role>.md`). These are instruction prompts, not executable code.

**Templates (`templates/`)** — Minimal markdown scaffolds for each artifact type.

**Backend Consumer (`scripts/consume-stage-with-claude.sh`)** — Assembles the full prompt (skill + subagent + template + prior artifacts) and invokes `claude` CLI. This is what actually calls Claude Code for each stage.

### Feature Folder Structure

```
features/<id>-<slug>/
├── state.json               # Current stage, status, timestamps
├── 00-intake.md             # Raw request → structured intake
├── 01-spec.md               # Behavior-oriented spec
├── 02-plan.md               # Technical plan
├── 06-tasks.md              # Bounded task list
├── 07-implementation-log.md # Changes made during implement
├── 08-validation.md         # Validation results
└── .runtime/
    └── <stage>.bundle.md    # Assembled context for backend
```

### Implement Stage Safety

The implement stage has a risk assessment gate (`assess-implement-risk.sh`). If risk is `medium` or `high`, `implement-checkpoint.sh` creates a checkpoint and pauses the workflow for human review before proceeding. This is intentional — do not bypass it.

## Docs

- `docs/system-design.md` — Full v1 architecture
- `docs/auto-workflow.md` — Workflow runner documentation
- `docs/implement-safety-policy.md` — Risk assessment and checkpoint policy
- `docs/skills-and-subagents.md` — Prompt layer architecture
- `docs/runtime-wiring.md` — Handler dispatch mechanism
- `docs/命令使用说明.md` — Chinese command guide

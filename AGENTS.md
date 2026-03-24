# AGENTS.md

This file provides guidance for agentic coding agents operating in this repository.

## Project Overview

**agentic-sdd-pipeline** is a shell-script orchestration system for Spec-Driven Development (SDD). It uses markdown artifacts as the unit of work and Claude Code CLI as the backend consumer. The codebase consists primarily of shell scripts, markdown templates, and prompt definitions.

---

## Build / Lint / Test Commands

This project is a shell-script based pipeline. There is no traditional build system.

### Key Commands

```bash
# Initialize a new feature
./scripts/init-feature.sh <id> <slug> [title]

# Run a single stage for a feature
./scripts/run-stage.sh <feature-dir> <stage>

# Execute a stage (convenience wrapper around run-stage)
./scripts/execute-stage.sh <feature-dir> <stage>

# Run automated workflow
./scripts/auto-workflow.sh <feature-dir> full [start] [end]
./scripts/auto-workflow.sh <feature-dir> single <stage>
./scripts/auto-workflow.sh <feature-dir> range <start> <end>

# Use Claude Code as backend consumer
./scripts/consume-stage-with-claude.sh <feature-dir> <stage>

# Mark artifact complete (update state.json)
./scripts/complete-artifact.sh <feature-dir> <artifact-path>

# Check feature status
./scripts/feature-summary.sh <feature-dir> <feature-dir>
```

### Valid Stages

`intake`, `spec`, `plan`, `tasks`, `implement`, `validate`

### Example Workflow

```bash
# Create and run a full pipeline
./scripts/init-feature.sh 010 test-feature "Test Feature"
./scripts/auto-workflow.sh ./features/010-test-feature full intake tasks

# Run single stage
./scripts/consume-stage-with-claude.sh ./features/010-test-feature spec
./scripts/complete-artifact.sh ./features/010-test-feature 01-spec.md
```

### Linting Shell Scripts

No formal linter is configured. For shell scripts:

- Use `shellcheck` if available: `shellcheck scripts/*.sh`
- Ensure POSIX compatibility (use `#!/usr/bin/env sh`, not `#!/bin/bash`)

---

## Code Style Guidelines

### General Principles

- **Artifacts over code**: This is a markdown-driven pipeline. Focus on producing high-quality artifacts (`00-intake.md`, `01-spec.md`, etc.) rather than traditional code.
- **Explicit over implicit**: All constraints, assumptions, and non-goals must be documented in artifacts.
- **Stage discipline**: Never skip stages. Each artifact builds on previous ones.

### Shell Script Conventions

1. **Shebang**: Use `#!/usr/bin/env sh` for portability
2. **Variables**: Use lowercase with underscores (`feature_id`, `current_stage`)
3. **Functions**: Use lowercase with underscores (`state_get`, `json_escape`)
4. **Constants**: Use uppercase (`CURRENT_STAGE`, `STATUS`)
5. **Quoting**: Always quote variables containing paths or user input
6. **Error handling**: Use `set -e` for critical scripts; check file existence before reading
7. **Exit codes**: Return 0 for success, non-zero for failure

### Markdown Artifact Conventions

1. **Structure**: Follow templates in `templates/` directory
2. **Naming**: Use exact names: `00-intake.md`, `01-spec.md`, `02-plan.md`, `06-tasks.md`, `07-implementation-log.md`, `08-validation.md`
3. **Headers**: Use ATX-style (`#`, `##`, `###`)
4. **Lists**: Use `-` for unordered, `1.` for ordered
5. **Code blocks**: Use fenced code blocks with language identifiers
6. **Emphasis**: Use `**bold**` for critical items, `_italic_` for emphasis

### Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Feature folders | `<id>-<slug>` | `006-auto-workflow` |
| Stage artifacts | `<two-digit>-<stage>.md` | `01-spec.md` |
| State JSON keys | snake_case | `current_stage`, `needs_review` |
| Shell functions | snake_case | `state_get`, `feature_derive_id` |

### Error Handling

1. **Fail fast**: Use `set -e` in scripts that must succeed
2. **Check prerequisites**: Verify files exist before processing
3. **Meaningful errors**: Include context in error messages
4. **Escalate ambiguities**: When requirements are unclear, document the ambiguity rather than guessing

### State Management

- All feature state is tracked in `features/<id>-<slug>/state.json`
- Use `scripts/state-lib.sh` functions for state operations
- Never modify state.json manually; use `complete-artifact.sh`

---

## Pipeline Flow

```
intake (00-intake.md)
  → spec (01-spec.md)
    → plan (02-plan.md)
      → tasks (06-tasks.md)
        → implement (07-implementation-log.md)
          → validate (08-validation.md)
```

### Transition Rules

- `spec` requires `00-intake.md`
- `plan` requires `01-spec.md`
- `tasks` requires `01-spec.md` + `02-plan.md`
- `implement` requires `01-spec.md` + `02-plan.md` + `06-tasks.md`
- `validate` requires `07-implementation-log.md`

### Implement Stage Safety

The `implement` stage has a risk assessment gate. If risk is `medium` or `high`, a checkpoint is created and the workflow pauses for human review. **Never bypass this checkpoint.**

---

## Directory Structure

```
.
├── scripts/          # Orchestration shell scripts
├── runtime/handlers/ # Stage-specific handlers
├── hooks/            # Stage gating hooks
├── skills/           # Stage-specific skill prompts (sdd-*)
├── subagents/        # Role-specific subagent prompts
├── templates/        # Markdown artifact templates
├── features/         # Feature folders with artifacts
└── docs/             # System documentation
```

---

## Important Files

- `CLAUDE.md` - Claude Code specific guidance
- `docs/stage-rules.md` - Detailed stage definitions
- `docs/system-design.md` - Architecture documentation
- `docs/implement-safety-policy.md` - Risk assessment policy

---

## Style Checklist

Before completing any task, verify:

- [ ] Shell scripts use `#!/usr/bin/env sh` and are POSIX-compatible
- [ ] All variables are quoted where necessary
- [ ] Stage transitions follow the dependency chain
- [ ] Artifacts follow templates in `templates/`
- [ ] State.json is updated via `complete-artifact.sh`, not manually
- [ ] Implement stage checkpoints are respected
- [ ] Ambiguities are escalated, not guessed
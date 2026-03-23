# Auto Workflow

## 1. Purpose

This document describes the lightweight automated workflow runner for the SDD pipeline.

The goal is to support both:

- end-to-end early-stage automation
- targeted execution of a single stage or a stage range

---

## 2. Supported modes

The workflow runner supports three modes:

### `full`
Run a contiguous workflow automatically.

```sh
./scripts/auto-workflow.sh <feature-dir> full [start-stage] [end-stage]
```

Defaults:
- start stage: `spec`
- end stage: `tasks`

### `single`
Run one specific stage.

```sh
./scripts/auto-workflow.sh <feature-dir> single <stage>
```

### `range`
Run a stage interval.

```sh
./scripts/auto-workflow.sh <feature-dir> range <start-stage> <end-stage>
```

---

## 3. Current stage support

Current automation coverage:

- `spec` ✅
- `plan` ✅
- `tasks` ✅
- `validate` ✅

Current non-automated stages:

- `intake` → currently expects existing/manual content
- `implement` → no automated consumer configured yet

---

## 4. Execution model

For each stage, the runner performs:

1. `execute-stage.sh`
2. backend consumption (if configured)
3. `complete-artifact.sh`
4. `after_validation.sh` when the stage is `validate`

This creates the first real chained execution path in the repository.

---

## 5. Examples

### Full early-stage flow

```sh
./scripts/auto-workflow.sh ./features/005-claude-spec-consumer full spec tasks
```

### Run one stage only

```sh
./scripts/auto-workflow.sh ./features/005-claude-spec-consumer single validate
```

### Run a range

```sh
./scripts/auto-workflow.sh ./features/005-claude-spec-consumer range plan validate
```

---

## 6. Current limitations

The current auto workflow intentionally remains lightweight.

It does not yet:

- synthesize `intake` automatically
- automate `implement`
- recover from backend failures beyond exiting with an error
- support multiple backends through a shared adapter layer

---

## 7. Why this matters

Before this runner existed, the repo supported stage-level automation but not chained workflow execution.

With `auto-workflow.sh`, the project now supports:

- whole early-stage runs
- targeted stage execution
- stage range execution

That is the first step toward a more truly agentic pipeline.

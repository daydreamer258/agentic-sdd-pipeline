# Plan

## Architecture Summary

This feature introduces a single shell script that serves as the first real backend consumer in the SDD pipeline. The script (`consume-stage-with-claude.sh`) accepts a feature directory and stage name, assembles a stage bundle (a prompt text file referencing skill, subagent, template, and input artifact paths), and invokes Claude Code CLI to produce the output artifact.

The design is intentionally minimal: one shell script handles orchestration, one generated prompt file carries all stage context, and one Claude Code invocation performs the work. There is no framework, plugin system, or persistent process. All intelligence lives in the existing prompt layer; the script is a thin coordinator that wires files into a single CLI call.

The data flow is linear:

```
Operator → Script (validate + assemble) → Prompt file → Claude Code CLI → Output artifact
```

## Components / Modules

- **`scripts/consume-stage-with-claude.sh`** — Entry-point shell script. Accepts `<feature-dir>` and `<stage>` as arguments. Responsibilities:
  1. Parse and validate arguments.
  2. Resolve paths for the stage's skill prompt (`skills/sdd-<stage>/SKILL.md`), subagent prompt (`subagents/<role>.md`), template (`templates/<NN>-<stage>.md`), and input artifact (previous stage's output file).
  3. Validate that all resolved files exist; exit with a clear error if any are missing.
  4. Assemble a stage bundle prompt file and write it to `<feature-dir>/.runtime/<stage>.claude-prompt.txt`.
  5. Invoke `claude` CLI with the prompt file in non-interactive mode.

- **Stage bundle prompt file** (`<feature-dir>/.runtime/<stage>.claude-prompt.txt`) — A generated text file that serves as the sole interface between the script and Claude Code. It instructs the consumer on which files to read, what to produce, and where to write the output. All context is mediated through this file; nothing is hard-coded into the CLI invocation.

- **Prompt layer (existing, read-only)** — `skills/sdd-spec/SKILL.md`, `subagents/spec-writer.md`, `templates/01-spec.md`. These files define behavioral rules, role constraints, and output structure. They are consumed as-is and must not be modified by this feature.

- **Input artifact** — `features/<feature>/00-intake.md`. The source material that Claude Code transforms into the output.

- **Output artifact** — `features/<feature>/01-spec.md`. The sole file written by Claude Code during execution.

## Constraints and Rationale

- **No framework or abstraction layer.** The spec excludes a general-purpose consumer framework or plugin system. A standalone POSIX shell script keeps complexity minimal and avoids premature abstraction appropriate for a lightweight pilot.
- **Bundle-mediated context only.** All context must flow through the assembled stage bundle prompt file, not through hard-coded paths in the Claude invocation. This satisfies AC-4 and keeps the prompt layer as the single source of truth.
- **Single output artifact, no side effects.** Claude Code must create or modify only `01-spec.md` inside the feature directory. No other files may be touched (AC-5). The `.runtime/` directory is used only by the script itself for the prompt file.
- **Feature-directory-agnostic.** The script must work for any feature directory with a valid `00-intake.md`, not just feature 005 (AC-6). All paths are derived from the arguments and naming conventions, never hard-coded to a specific feature.
- **Fail-fast on missing inputs.** The script validates existence of the intake file and all prompt-layer files before invoking Claude Code. Invoking an LLM with missing context wastes time and produces unreliable output.
- **Non-interactive execution.** Claude Code must run without prompting the operator for clarification. Ambiguities are captured inside the output artifact per the spec's edge case requirements.
- **No state machine advancement.** The script produces the artifact and exits. It does not update `state.json` or advance the pipeline. State management is a separate concern.

## Risks

- **Claude Code output fidelity.** The consumer relies on Claude Code following prompt instructions precisely — correct template structure, no extra files, no follow-up questions. If the model deviates, the output may not meet acceptance criteria. Mitigation: the prompt file is explicit and tightly scoped; the operator reviews output manually.
- **Stage-name-to-file mapping brittleness.** The script maps stage names to file paths using naming conventions (e.g., `spec` → `01-spec.md`, `00-intake.md` as input). If naming conventions evolve, the mapping breaks. Mitigation: validate that all resolved paths exist before invocation and document the convention in the script.
- **Working directory sensitivity.** The prompt file contains relative paths that Claude Code must resolve from the repository root. If Claude Code's working directory is unexpected, file reads will fail silently or produce wrong output. Mitigation: the script should explicitly set the working directory when invoking `claude` CLI.
- **No automated quality gate.** The spec excludes automated quality validation, so a structurally complete but semantically incorrect spec can pass. This is an accepted v1 limitation; the operator is the quality gate.
- **CLI flag instability.** The `claude` CLI is relatively new; invocation flags for non-interactive mode or prompt file input may change between versions. Mitigation: document the tested CLI version and pin to known-working invocation patterns.

## Validation Approach

- **End-to-end execution:** Run `consume-stage-with-claude.sh features/005-claude-spec-consumer spec` and verify that `01-spec.md` is created in the feature directory with all template sections present (Problem Statement, Users/Actors, Desired Behavior, Acceptance Criteria, Edge Cases, Non-Goals, Assumptions).
- **Cross-feature portability:** Run the script against a different feature directory with a valid `00-intake.md` to confirm it is not coupled to feature 005.
- **Precondition failure — missing intake:** Run with a feature directory that lacks `00-intake.md`; verify the script exits non-zero with a descriptive error and does not invoke Claude Code.
- **Precondition failure — missing prompt layer:** Remove or rename a prompt-layer file; verify the script exits non-zero with a descriptive error before invocation.
- **Artifact isolation:** Compare the feature directory contents before and after a successful run; confirm only `01-spec.md` was created or modified (excluding `.runtime/`).
- **Structural completeness:** Parse the generated `01-spec.md` and confirm all section headings from the template are present.
- **Manual semantic review:** The operator reads the generated spec to verify it is behavior-oriented, aligned with the intake, and does not expand scope.

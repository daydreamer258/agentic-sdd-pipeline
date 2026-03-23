# Spec

## Problem Statement

The SDD pipeline has runtime wiring, prompt files, and stage bundles in place, but no real execution path where a backend consumer reads stage context and writes an output artifact. Without a working backend integration, the pipeline remains theoretical. This feature proves the first real consumer loop by automating the `spec` stage with Claude Code as the backend.

## Users / Actors

- **Pipeline operator** — a developer who runs a script against a feature directory to trigger a stage. They expect the backend to consume the stage bundle and produce the correct artifact without manual intervention.
- **Claude Code CLI (backend consumer)** — the automated agent that receives stage context (prompt, template, input artifact) and writes the output artifact.

## Desired Behavior

1. The operator invokes a script, passing a feature directory and the `spec` stage as arguments.
2. The script assembles the stage bundle: skill prompt, subagent prompt, template, and input artifact paths.
3. The script hands the assembled context to Claude Code CLI.
4. Claude Code reads `00-intake.md` and the repository's prompt layer (skill, subagent, template).
5. Claude Code produces `01-spec.md` inside the feature directory, following the template shape and behavioral rules defined in the prompt layer.
6. The process completes without requiring follow-up questions or operator intervention.

## Acceptance Criteria

- [ ] A single shell command (e.g., `consume-stage-with-claude.sh <feature-dir> spec`) triggers Claude Code to produce `01-spec.md` from `00-intake.md`.
- [ ] The generated `01-spec.md` follows the template structure defined in `templates/01-spec.md` (all sections present).
- [ ] The generated spec is behavior-oriented: it describes what the system should do, not how to build it.
- [ ] The consumer receives stage context exclusively through the assembled stage bundle (prompt file), not through ad-hoc hardcoded paths.
- [ ] No files other than `01-spec.md` are created or modified inside the feature directory by the consumer.
- [ ] The process works for any feature directory that has a valid `00-intake.md`, not just feature 005.

## Edge Cases

- The intake file contains ambiguities or open questions: the consumer should capture these inside the spec artifact (e.g., in an Assumptions section) rather than halting or prompting the operator.
- The intake file is missing or empty: the script should fail with a clear error message before invoking Claude Code.
- The prompt layer files (skill, subagent, template) are missing: the script should fail with a clear error before invoking the consumer.

## Non-Goals

- Automating stages beyond `spec` (other stages are future work).
- Building a general-purpose consumer framework or plugin system.
- Providing a web UI or API — the consumer is local CLI only.
- Validating the quality of the generated spec beyond structural completeness.
- Auto-advancing the pipeline state machine after artifact creation.

## Assumptions

- Claude Code CLI is installed and available on the operator's machine.
- The repository's prompt layer (skills, subagents, templates) is stable enough to be consumed as-is.
- The stage bundle format (a prompt text file referencing instruction sources) is sufficient context for the consumer to produce correct output.
- The operator is responsible for verifying spec quality; automated quality gates are out of scope.

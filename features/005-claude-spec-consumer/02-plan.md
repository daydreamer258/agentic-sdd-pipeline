# Plan

## Architecture Summary

The feature delivers a single shell script (`consume-stage-with-claude.sh`) that acts as the first real backend consumer in the SDD pipeline. The script takes a feature directory and a stage name, assembles a stage bundle (a prompt text file referencing the skill prompt, subagent prompt, template, and input artifact), and passes it to the Claude Code CLI for execution. Claude Code reads the referenced files, produces the output artifact, and writes it directly into the feature directory.

The architecture is deliberately minimal: one shell script orchestrates context assembly, one prompt file carries all stage context, and one Claude Code invocation performs the work. There is no framework, no plugin system, and no daemon — just a script that wires existing prompt-layer files into a single CLI call.

## Components / Modules

- **`scripts/consume-stage-with-claude.sh`** — The entry-point script. Accepts `<feature-dir>` and `<stage>` arguments. Responsibilities:
  1. Validate that the feature directory, intake artifact, and prompt-layer files (skill, subagent, template) all exist.
  2. Resolve file paths for the stage's skill prompt, subagent prompt, template, and input artifact based on the stage name.
  3. Assemble a stage bundle prompt file (a text file with instructions and file references) and write it to `<feature-dir>/.runtime/<stage>.claude-prompt.txt`.
  4. Invoke `claude` CLI, passing the prompt file as input.
  5. Exit with a clear error if any precondition fails.

- **Stage bundle prompt file** (`<feature-dir>/.runtime/<stage>.claude-prompt.txt`) — A generated text file that tells Claude Code what to read, what to produce, and where to write. This is the sole interface between the script and the consumer. It references:
  - The skill prompt (`skills/sdd-<stage>/SKILL.md`)
  - The subagent prompt (`subagents/<role>.md`)
  - The template (`templates/<NN>-<stage>.md`)
  - The input artifact (the previous stage's output, e.g., `00-intake.md` for the spec stage)

- **Prompt layer files (existing, not modified)** — `skills/sdd-spec/SKILL.md`, `subagents/spec-writer.md`, `templates/01-spec.md`. These are consumed as-is by the backend.

## Constraints and Rationale

- **Single-script, no framework.** The spec explicitly excludes a general-purpose consumer framework. A standalone shell script keeps the blast radius small and avoids premature abstraction. Future stages can reuse or fork the script without coordination overhead.
- **Stage bundle as sole context interface.** The consumer must receive all context through the assembled prompt file, not through hardcoded paths inside Claude Code. This keeps the consumer generic across feature directories and makes the contract between orchestration and execution explicit.
- **Claude Code CLI as the only backend.** No abstraction over different LLM backends. The script calls `claude` directly. This is appropriate for v1; abstracting the backend is future work.
- **No state machine advancement.** The script produces the artifact and exits. It does not update `state.json` or advance the pipeline. The operator (or a separate wrapper) is responsible for state transitions.
- **Feature-directory-agnostic.** The script must work for any feature directory with a valid intake file, not just feature 005. All paths are derived from the arguments, not hardcoded.
- **Fail-fast on missing inputs.** If the intake, skill, subagent, or template file is missing, the script exits with a non-zero code and a descriptive error before invoking Claude Code.

## Risks

- **Claude Code output fidelity.** The consumer relies on Claude Code following the prompt instructions precisely (template structure, no extra files, no follow-up questions). If the model drifts from instructions, the output artifact may not meet acceptance criteria. Mitigation: the prompt file is explicit and tightly scoped; the operator reviews output post-hoc.
- **Stage-name-to-file mapping brittleness.** The script maps stage names to file paths using naming conventions (e.g., `spec` → `skills/sdd-spec/`, `templates/01-spec.md`, `00-intake.md`). If naming conventions change, the script breaks silently. Mitigation: validate that resolved paths exist before invocation; document the naming convention in the script.
- **Prompt file path resolution across working directories.** The prompt file contains file paths that Claude Code must resolve. If Claude Code's working directory differs from expectations, file reads will fail. Mitigation: use paths relative to the repository root and ensure the script invokes Claude Code from the repo root.
- **No automated quality validation.** The spec explicitly excludes quality gates, so a structurally complete but semantically poor artifact will pass. This is accepted for v1; the operator is the quality gate.

## Validation Approach

- **Manual end-to-end test:** Run `consume-stage-with-claude.sh features/005-claude-spec-consumer spec` and verify that `01-spec.md` is created with all template sections present.
- **Cross-feature test:** Run the script against a second feature directory (e.g., `features/003-feature-summary-cli`) to confirm it is not hardcoded to feature 005.
- **Precondition failure test:** Run the script with a missing intake file and with a missing prompt-layer file; verify it exits with a clear error and does not invoke Claude Code.
- **Artifact isolation check:** After a successful run, verify that no files other than `01-spec.md` were created or modified inside the feature directory (excluding `.runtime/`).
- **Structural completeness check:** Confirm the generated `01-spec.md` contains all section headers defined in `templates/01-spec.md`.

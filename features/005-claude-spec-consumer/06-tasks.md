# Tasks

## Task List

1. **Create script skeleton with argument parsing and usage output**
   - Create `scripts/consume-stage-with-claude.sh` as a POSIX-compatible shell script.
   - Accept two positional arguments: `<feature-dir>` and `<stage>`.
   - Print a usage message and exit non-zero if either argument is missing.
   - Make the script executable (`chmod +x`).
   - **Output:** A runnable script that exits cleanly with usage text when called incorrectly.
   - **Verification:** Invoke with zero, one, and two arguments; confirm correct error messages and exit codes.

2. **Implement stage-name-to-path resolution**
   - Map the `<stage>` argument to its four prompt-layer paths:
     - Skill prompt: `skills/sdd-<stage>/SKILL.md`
     - Subagent prompt: `subagents/<role>.md` (derive role from stage, e.g., `spec` → `spec-writer`, `plan` → `planner`, `tasks` → `task-decomposer`)
     - Template: `templates/<NN>-<stage>.md` (derive prefix from stage, e.g., `spec` → `01`, `plan` → `02`, `tasks` → `06`)
     - Input artifact: the previous stage's output inside the feature directory (e.g., `spec` reads `00-intake.md`, `plan` reads `01-spec.md`, `tasks` reads `02-plan.md`)
   - Derive the output artifact path from stage (e.g., `spec` → `01-spec.md`).
   - Store resolved paths in shell variables.
   - Document the naming convention in a comment block inside the script.
   - **Output:** Variables holding repo-relative paths for all resolved files.
   - **Verification:** Add an echo/debug mode or inspect variables manually for the `spec` stage.

3. **Add fail-fast input validation**
   - Validate that the feature directory exists on disk.
   - Validate that the input artifact exists and is non-empty.
   - Validate that the skill prompt, subagent prompt, and template files all exist.
   - Exit with a descriptive error message naming the specific missing file and non-zero status.
   - All validation must complete before any Claude Code invocation.
   - **Output:** Script exits early with clear, actionable errors when preconditions are unmet.
   - **Verification:** Remove each required file in turn; confirm the script names the missing file and exits non-zero without invoking Claude.

4. **Assemble the stage bundle prompt file**
   - Create the `.runtime/` directory inside the feature directory if absent.
   - Generate `<feature-dir>/.runtime/<stage>.claude-prompt.txt`.
   - The prompt file must contain:
     - A task preamble telling the consumer which stage to execute and where to write the output artifact.
     - Ordered references to the four instruction sources (skill, subagent, template, input artifact) as numbered items.
     - Behavioral constraints: read the referenced files, produce exactly one markdown document, write to the correct output path, preserve markdown clarity, do not modify other files, do not ask follow-up questions, capture ambiguity inside the artifact.
   - Use repo-root-relative paths (prefixed with `./`) so Claude Code resolves them from the working directory.
   - **Output:** A self-contained prompt file at `.runtime/<stage>.claude-prompt.txt`.
   - **Verification:** Inspect the generated file; confirm all four path references are correct and constraints are present.

5. **Invoke Claude Code CLI in non-interactive mode**
   - Call the `claude` CLI, passing the assembled prompt file content as input.
   - Set the working directory for the CLI invocation to the repository root so relative paths resolve correctly.
   - Use non-interactive flags (e.g., `--print` or `--dangerously-skip-permissions` as appropriate for headless execution).
   - Capture and propagate the CLI exit code as the script's exit code.
   - **Output:** Claude Code executes and writes the output artifact into the feature directory.
   - **Verification:** Run end-to-end for one stage and confirm the output artifact appears.

6. **End-to-end validation: feature 005, spec stage**
   - Run `scripts/consume-stage-with-claude.sh features/005-claude-spec-consumer spec`.
   - Verify `01-spec.md` is created inside the feature directory.
   - Confirm all section headings from `templates/01-spec.md` are present in the generated spec.
   - Confirm no files other than `01-spec.md` (and `.runtime/` contents) were created or modified.
   - **Output:** Passing manual validation for the primary use case.

7. **Cross-feature portability validation**
   - Run the script against a different feature directory with a valid intake file.
   - Confirm the script derives all paths from arguments — no coupling to feature 005.
   - **Output:** Evidence that the script is feature-directory-agnostic (AC-6).

8. **Precondition failure validation**
   - Run with a feature directory missing the intake file; verify descriptive error, non-zero exit, no Claude invocation.
   - Rename a prompt-layer file; verify the same fail-fast behavior naming the specific missing file.
   - **Output:** Confirmed fail-fast behavior on all missing-input scenarios.

## Dependencies

- Task 1 → Task 2 (script skeleton must exist before adding path resolution).
- Task 2 → Task 3 (paths must be resolved before they can be validated).
- Task 3 → Task 4 (inputs must be validated before assembling the bundle).
- Task 4 → Task 5 (bundle must exist before CLI invocation).
- Tasks 1–5 → Tasks 6, 7, 8 (full script must be functional before validation).
- Tasks 6, 7, 8 are independent of each other.

## Parallelizable Work

- Tasks 6, 7, and 8 (all validation tasks) can run in parallel once the implementation tasks (1–5) are complete.
- Within Task 2, the four path-resolution mappings are logically independent but belong in the same script section — no benefit to splitting them into separate tasks.

## Validation Notes

- Task 6 is the primary acceptance gate — it proves the consumer loop works end-to-end.
- Task 7 guards against hardcoded paths, which is an explicit acceptance criterion (AC-6).
- Task 8 guards against silent failures where the script would invoke Claude Code with incomplete context.
- Structural completeness (all template headings present in the output) is checked in Task 6. Semantic quality is out of scope per the spec's non-goals — the operator is the quality gate.
- The script intentionally does not update `state.json` or advance the pipeline state machine. Artifact isolation in Task 6 confirms this.
- CLI flag stability is a known risk. Document the tested `claude` CLI version in the script or a companion note so future breakage is diagnosable.
- The stage-name-to-path mapping (Task 2) must be extended when new stages are added. The mapping table is the single place to update.

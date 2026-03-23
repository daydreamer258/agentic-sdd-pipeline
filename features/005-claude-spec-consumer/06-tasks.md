# Tasks

## Task List

1. **Create script skeleton with argument parsing and usage output**
   - Create `scripts/consume-stage-with-claude.sh`.
   - Accept two positional arguments: `<feature-dir>` and `<stage>`.
   - Print a usage message and exit non-zero if arguments are missing.
   - Make the script executable (`chmod +x`).
   - **Output:** A runnable script that exits cleanly with usage text when called without arguments.

2. **Implement stage-name-to-path resolution**
   - Map the `<stage>` argument to its four prompt-layer paths:
     - Skill prompt: `skills/sdd-<stage>/SKILL.md`
     - Subagent prompt: `subagents/<role>.md` (derive `<role>` from stage, e.g., `spec` → `spec-writer`)
     - Template: `templates/<NN>-<stage>.md` (derive `<NN>` from stage, e.g., `spec` → `01`)
     - Input artifact: the previous stage's output inside the feature directory (e.g., `spec` → `00-intake.md`)
   - Store resolved paths in shell variables for downstream use.
   - Document the naming convention in a comment block inside the script.
   - **Output:** Variables holding resolved absolute-or-repo-relative paths for all four files.

3. **Add fail-fast input validation**
   - Validate that the feature directory exists.
   - Validate that the input artifact (e.g., `00-intake.md`) exists and is non-empty.
   - Validate that the skill prompt, subagent prompt, and template files all exist.
   - Exit with a descriptive error message and non-zero status on any missing file.
   - Validation must run entirely before any Claude Code invocation.
   - **Output:** Script exits early with clear errors when preconditions are unmet.

4. **Assemble the stage bundle prompt file**
   - Create the `.runtime/` directory inside the feature directory if it does not exist.
   - Generate `<feature-dir>/.runtime/<stage>.claude-prompt.txt`.
   - The prompt file must contain:
     - A task description telling Claude Code which stage to execute and where to write the output.
     - Ordered references to the four instruction sources (skill, subagent, template, input artifact).
     - Behavioral constraints: read referenced files, produce exactly one markdown document, write to the correct path, preserve markdown clarity, do not modify other files, do not ask follow-up questions.
   - Use repo-root-relative paths in the prompt file.
   - **Output:** A self-contained prompt file at the expected `.runtime/` location.

5. **Invoke Claude Code CLI with the prompt file**
   - Call the `claude` CLI, passing the assembled prompt file content as input.
   - Ensure the working directory for the CLI invocation is the repository root.
   - Capture the exit code and propagate it from the script.
   - **Output:** Claude Code executes and writes the output artifact (e.g., `01-spec.md`) into the feature directory.

6. **End-to-end validation: feature 005 spec stage**
   - Run `scripts/consume-stage-with-claude.sh features/005-claude-spec-consumer spec`.
   - Verify `01-spec.md` is created inside the feature directory.
   - Confirm all section headers from `templates/01-spec.md` are present in the generated spec.
   - Confirm no files other than `01-spec.md` (and `.runtime/` contents) were created or modified.
   - **Output:** Passing manual validation for the primary use case.

7. **Cross-feature validation**
   - Run the script against a different feature directory (e.g., `features/003-feature-summary-cli`) to confirm paths are derived from arguments, not hardcoded.
   - **Output:** The script works for any feature directory with a valid intake file.

8. **Precondition failure validation**
   - Run the script with a missing intake file and verify it exits with a clear error without invoking Claude Code.
   - Run the script with a missing prompt-layer file (e.g., delete or rename a skill prompt temporarily) and verify the same behavior.
   - **Output:** Confirmed fail-fast behavior on missing inputs.

## Dependencies

- Task 1 must complete before Tasks 2–5 (script must exist).
- Task 2 must complete before Task 3 (paths must be resolved before validation).
- Task 3 must complete before Task 4 (validation before bundle assembly).
- Task 4 must complete before Task 5 (bundle must exist before CLI invocation).
- Tasks 6, 7, and 8 depend on Tasks 1–5 (full script must be functional).
- Tasks 6, 7, and 8 are independent of each other.

## Parallelizable Work

- Tasks 6, 7, and 8 (all validation tasks) can run in parallel once the script is complete.
- Within Task 2, the four path-resolution mappings can be developed and tested independently, though they live in the same script section.

## Validation Notes

- Task 6 is the primary acceptance gate — it proves the consumer loop works end-to-end for the target feature.
- Task 7 guards against hardcoded paths, which is an explicit acceptance criterion.
- Task 8 guards against silent failures where the script would invoke Claude Code with incomplete context.
- Structural completeness of the generated artifact (all template sections present) is checked in Task 6 but semantic quality review is out of scope per the spec's non-goals.
- The script intentionally does not update `state.json` or advance the pipeline — this is validated by the artifact isolation check in Task 6.

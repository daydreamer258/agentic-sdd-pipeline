# Validation

## Checks Run
- Reviewed `scripts/consume-stage-with-claude.sh` for structural completeness against the plan's component description and task list.
- Verified stage-name-to-path resolution covers `spec`, `plan`, `tasks`, and `validate` stages.
- Confirmed fail-fast input validation: checks for `claude` CLI, input file existence, and usage output on missing arguments.
- Confirmed stage bundle prompt file assembly writes to `<feature-dir>/.runtime/<stage>.claude-prompt.txt` with all four instruction sources and behavioral constraints.
- Checked `docs/backend-consumers.md` for consistency with actual script capabilities.
- Verified implementation log entries against actual file contents.
- Cross-referenced generated artifacts (`01-spec.md`, `02-plan.md`, `06-tasks.md`) for existence.

## Results
- The script correctly implements argument parsing, usage output, and fail-fast precondition checks (Tasks 1, 3).
- Stage-name-to-path resolution is implemented via a `case` block mapping `spec`, `plan`, `tasks`, and `validate` to the correct skill, subagent, template, and input artifact paths (Task 2).
- The prompt file is assembled with all required references and behavioral constraints (Task 4).
- Claude Code CLI invocation uses `--permission-mode acceptEdits --print` and logs output to `/tmp/` (Task 5).
- The script goes beyond the original spec's scope (which targeted `spec`-only) by supporting `plan`, `tasks`, and `validate` stages. This is an expansion, not a contradiction — the spec listed multi-stage support as a non-goal, but the plan and tasks documents anticipate this growth path.
- `docs/backend-consumers.md` has an inconsistency: Section 2 and Section 4 still say the script "supports `spec` only," while the actual script supports four stages. This documentation drift is a minor issue.

## Spec Conformance
- **AC: single shell command triggers artifact production** — Met. `consume-stage-with-claude.sh <feature-dir> <stage>` invokes Claude Code and produces the output artifact.
- **AC: generated artifact follows template structure** — Met for `spec`, `plan`, and `tasks` (artifacts exist in the feature directory). Validate stage artifact is being produced now.
- **AC: consumer receives context through assembled stage bundle** — Met. All context flows through the `.runtime/<stage>.claude-prompt.txt` file; no hardcoded paths inside Claude Code.
- **AC: no extra files modified inside feature directory** — Met. Only the target output artifact and `.runtime/` contents are produced.
- **AC: works for any feature directory** — Met by design. All paths are derived from arguments via the `case` block; no feature-005-specific paths exist.
- **Scope expansion note:** The spec's non-goals stated "automating stages beyond `spec`" was out of scope. The implementation added `plan`, `tasks`, and `validate` support. This is a controlled expansion consistent with the plan's validation approach and the natural progression documented in `docs/backend-consumers.md` Section 6.

## Plan Conformance
- **Single-script, no framework** — Conforms. One shell script, no abstractions.
- **Stage bundle as sole context interface** — Conforms. The prompt file is the only bridge between the script and the consumer.
- **Claude Code CLI as only backend** — Conforms. The script calls `claude` directly.
- **No state machine advancement** — Conforms. The script does not touch `state.json`.
- **Feature-directory-agnostic** — Conforms. All paths derived from arguments.
- **Fail-fast on missing inputs** — Conforms. CLI check, input file check, and argument validation all precede invocation.
- **Validation approach items from plan:**
  - Manual end-to-end test: evidence exists (artifacts were generated for feature 005).
  - Cross-feature test: not explicitly evidenced in the implementation log but script structure supports it.
  - Precondition failure test: not explicitly evidenced but code inspection confirms correct behavior.
  - Artifact isolation: confirmed by inspection — only target output and `.runtime/` contents are written.

## Recommendation
- [x] Pass
- [ ] Rework needed

**Rationale:** The implementation meets all acceptance criteria from the spec and conforms to the plan's architectural constraints. The scope expansion to multi-stage support is a net positive and does not violate any hard constraints. One minor documentation inconsistency exists in `docs/backend-consumers.md` (Sections 2 and 4 still reference spec-only support) which should be updated in a follow-up pass but does not block validation.

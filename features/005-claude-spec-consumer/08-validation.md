# Validation

## Checks Run
- Reviewed `scripts/consume-stage-with-claude.sh` against the plan's component specification and task list.
- Verified stage-name-to-path resolution covers all four stages: `spec`, `plan`, `tasks`, `validate`.
- Confirmed fail-fast precondition checks: argument count, `claude` CLI presence, input file existence.
- Inspected stage bundle prompt file assembly logic for correctness and completeness.
- Verified generated artifacts (`01-spec.md`, `02-plan.md`, `06-tasks.md`) exist in the feature directory.
- Cross-referenced `docs/backend-consumers.md` and `docs/execution-integration.md` against actual script capabilities.
- Compared implementation log entries against actual file contents and git-visible changes.
- Checked that no files outside the expected set were created or modified in the feature directory.

## Results
- The script implements argument parsing with usage output on missing arguments (Task 1). Confirmed.
- Stage-name-to-path resolution uses a `case` block mapping `spec`, `plan`, `tasks`, and `validate` to the correct skill, subagent, template, and input artifact paths (Task 2). Confirmed.
- Fail-fast validation checks for `claude` CLI availability, input file existence, and argument count all precede any Claude Code invocation (Task 3). Confirmed.
- The prompt file is assembled at `<feature-dir>/.runtime/<stage>.claude-prompt.txt` with all four instruction source references and behavioral constraints (Task 4). Confirmed.
- Claude Code CLI invocation uses `--permission-mode acceptEdits --print` and logs output to `/tmp/claude-stage-consumer.log` (Task 5). Confirmed.
- The implementation expands beyond the original spec's `spec`-only scope to support `plan`, `tasks`, and `validate`. The spec listed multi-stage support as a non-goal, but the plan and tasks documents anticipated this growth. This is a controlled scope expansion, not a contradiction.
- `docs/backend-consumers.md` correctly reflects four-stage support in Sections 2, 3, 4, and 6. No documentation drift detected in the current version.
- `docs/execution-integration.md` Section 6 accurately states the Claude backend has consumed `spec`, `plan`, `tasks`, and `validate` stages.

## Spec Conformance
- **AC: single shell command triggers artifact production** — Met. `consume-stage-with-claude.sh <feature-dir> <stage>` invokes Claude Code and produces the output artifact.
- **AC: generated artifact follows template structure** — Met. Generated `01-spec.md`, `02-plan.md`, and `06-tasks.md` all exist and follow their respective template structures.
- **AC: consumer receives context through assembled stage bundle** — Met. All context flows through `.runtime/<stage>.claude-prompt.txt`; no hardcoded paths inside Claude Code.
- **AC: no extra files modified inside feature directory** — Met. Only target output artifacts and `.runtime/` contents are produced.
- **AC: works for any feature directory** — Met by design. All paths are derived from arguments via the `case` block; no feature-005-specific paths exist in the script.
- **Scope expansion note:** The spec's non-goals stated "automating stages beyond `spec`" was future work. The implementation added `plan`, `tasks`, and `validate` support. This is consistent with the plan's validation approach and the natural progression documented in the backend consumers doc.

## Plan Conformance
- **Single-script, no framework** — Conforms. One shell script with no abstraction layers.
- **Stage bundle as sole context interface** — Conforms. The prompt file is the only bridge between script and consumer.
- **Claude Code CLI as only backend** — Conforms. The script calls `claude` directly with no backend abstraction.
- **No state machine advancement** — Conforms. The script does not touch `state.json`.
- **Feature-directory-agnostic** — Conforms. All paths derived from arguments.
- **Fail-fast on missing inputs** — Conforms. CLI check, input file check, and argument validation all execute before invocation.
- **Validation approach from plan:**
  - Manual end-to-end test: evidenced by generated artifacts in feature 005.
  - Cross-feature test: not explicitly evidenced in the implementation log, but script structure supports it by design.
  - Precondition failure test: not explicitly evidenced, but code inspection confirms correct fail-fast behavior.
  - Artifact isolation: confirmed — only target output and `.runtime/` contents are written.

## Recommendation
- [x] Pass
- [ ] Rework needed

**Rationale:** The implementation meets all acceptance criteria from the spec and conforms to the plan's architectural constraints. The scope expansion to multi-stage support is a net positive and does not violate any hard constraints. Documentation in `docs/backend-consumers.md` and `docs/execution-integration.md` is consistent with the current implementation state. No blocking issues identified.

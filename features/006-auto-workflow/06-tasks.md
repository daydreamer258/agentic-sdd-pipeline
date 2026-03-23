# Tasks

## Task List

1. **T1 — Remove duplicate stage-loop block in `auto-workflow.sh`**
   Delete lines 130-136 which are an exact copy of lines 122-128 (the stage loop body and completion message). Verify the script still runs the loop exactly once.
   - File: `scripts/auto-workflow.sh`
   - Scope: delete ~7 lines, no logic changes.
   - Done when: only one copy of the stage loop exists and `sh -n scripts/auto-workflow.sh` passes.

2. **T2 — Verify `set -eu` and exit-code discipline**
   Confirm `set -eu` is present at the top of `auto-workflow.sh`. Audit every failure path (invalid mode, bad stage name, reversed range, missing feature dir) to ensure each exits non-zero with a descriptive message.
   - File: `scripts/auto-workflow.sh`
   - Scope: read-and-verify; fix any paths that silently succeed or lack an error message.
   - Done when: every error branch exits non-zero and prints a message identifying the failure.

3. **T3 — Validate `expected_artifact_for_stage()` completeness**
   Confirm the function maps every stage in the hardcoded stage list (`intake spec plan tasks implement validate`) to its correct artifact filename. Cross-check against `consume-stage-with-claude.sh`'s equivalent mapping to ensure consistency.
   - Files: `scripts/auto-workflow.sh`, `scripts/consume-stage-with-claude.sh`
   - Scope: comparison review; fix any mismatches.
   - Done when: both scripts agree on artifact filenames for all six stages.

4. **T4 — Document `implement` stage limitation in usage output**
   Add a note to the script's usage/help text explaining that the `implement` stage has no automated consumer and will fail if included in a range. Clarify that `full` mode defaults to `spec` through `tasks` to avoid this gap.
   - File: `scripts/auto-workflow.sh`
   - Scope: edit the usage function; no logic changes.
   - Done when: running the script with no args (or `--help`) shows the `implement` caveat.

5. **T5 — Smoke test: full mode**
   Run `auto-workflow.sh <feature-dir> full` on a test feature with a valid `request.txt`. Verify artifacts `00-intake.md` through `06-tasks.md` are produced in order and contain plausible content.
   - Prereq: T1, T2 complete (script is clean).
   - Scope: manual execution and visual inspection.
   - Done when: all expected artifacts exist and are non-empty.

6. **T6 — Smoke test: single mode**
   Run `auto-workflow.sh <feature-dir> single spec` on a feature with an existing `00-intake.md`. Verify only `01-spec.md` is produced or updated.
   - Prereq: T1, T2 complete.
   - Done when: `01-spec.md` is created/updated and no other artifacts are modified.

7. **T7 — Smoke test: range mode**
   Run `auto-workflow.sh <feature-dir> range spec plan` on a feature with an existing `00-intake.md`. Verify `01-spec.md` and `02-plan.md` are produced in order.
   - Prereq: T1, T2 complete.
   - Done when: both artifacts exist and are non-empty; no other artifacts are modified.

8. **T8 — Smoke test: error cases**
   Run each of the following and confirm non-zero exit + clear error message:
   - Invalid stage name (e.g., `single bogus`)
   - Reversed range (e.g., `range plan spec`)
   - Missing feature directory
   - Missing required input artifact (e.g., delete `00-intake.md` then run `single spec`)
   - Prereq: T1, T2 complete.
   - Done when: all four cases exit non-zero with a message identifying the problem.

9. **T9 — Update `docs/auto-workflow.md` with final usage and caveats**
   Ensure the user-facing documentation reflects the implemented modes, the `implement` stage limitation, and the overwrite-on-rerun behavior. Keep it concise.
   - File: `docs/auto-workflow.md`
   - Prereq: T4 complete (usage text is final).
   - Done when: docs match the script's actual behavior and help text.

## Dependencies

- **T1 → T5, T6, T7, T8**: The duplicate-loop fix must land before smoke tests, otherwise the loop executes twice.
- **T2 → T5, T6, T7, T8**: Exit-code discipline must be verified before testing error cases.
- **T3 → T5**: Artifact mapping must be consistent before full-mode verification.
- **T4 → T9**: Usage text must be finalized before docs are updated.
- T1, T2, T3, T4 are independent of each other and can be done in any order.

## Parallelizable Work

- T1, T2, T3, T4 can all proceed in parallel (independent code review / edit tasks).
- T5, T6, T7, T8 can proceed in parallel once their prerequisites are met (independent smoke tests).
- T9 is sequential after T4 (docs depend on finalized usage text).

## Validation Notes

- Smoke tests (T5-T8) are manual. They require a working `claude` CLI and a test feature directory with a valid `request.txt`.
- T3 is a cross-file consistency check — the two artifact mappings should be compared side by side, not just reviewed in isolation.
- The duplicate-line fix (T1) is the highest-risk change since it alters control flow. Verify with `sh -n` (syntax check) and at least one full-mode run before considering it done.
- No automated test suite exists for these shell scripts; validation relies on the manual smoke tests defined above.

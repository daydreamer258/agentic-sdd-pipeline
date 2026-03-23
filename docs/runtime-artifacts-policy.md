# Runtime Artifacts Policy

## 1. Purpose

This document proposes a policy for `.runtime/` artifacts generated during workflow execution.

Examples include:

- stage bundles (`<stage>.bundle.md`)
- backend prompt handoff files (`<stage>.claude-prompt.txt`)
- future execution logs or backend adapter artifacts

---

## 2. Why this matters

As the system becomes more automated, `.runtime/` will grow quickly.
Without a policy, the repository will drift between:

- useful execution evidence
- noisy temporary files
- accidental local-only state

---

## 3. Recommended policy

### Recommendation: **Version representative workflow evidence, not every ephemeral runtime artifact**

This is a middle path between versioning everything and versioning nothing.

#### Keep in Git when they are meaningful
Version `.runtime/` files when they serve as:

- evidence of a milestone
- examples of execution bundles
- documentation of how a feature was actually handed to a backend
- representative artifacts for successful pilot runs

Examples:
- `.runtime/spec.bundle.md`
- `.runtime/plan.bundle.md`
- `.runtime/tasks.bundle.md`
- `.runtime/validate.bundle.md`

#### Usually do NOT keep in Git when they are purely ephemeral
Do not version runtime files that are mainly backend-specific transient prompts or temporary execution data unless they are needed as part of a milestone record.

Examples:
- `.runtime/*.tmp`
- intermediate logs
- repeated generated prompt handoff files when they add no extra explanatory value

---

## 4. Policy for this repository right now

Given the current stage of the project, the repository should:

### Keep
- representative `.bundle.md` files for pilot features
- any `.runtime/` artifact needed to explain or audit a milestone

### Prefer not to keep long-term
- backend-specific prompt handoff files such as `.claude-prompt.txt` unless they are temporarily useful during early development

### Reason
Right now the project is still proving workflow design.
So some extra evidence is acceptable.
Later, the repo should become stricter and keep only the artifacts with ongoing explanatory value.

---

## 5. Proposed near-term cleanup rule

For upcoming commits:

- keep `*.bundle.md` for milestone features
- evaluate `*.claude-prompt.txt` case by case
- do not allow arbitrary temp files into `.runtime/`

---

## 6. Future evolution

If the workflow becomes more automated, consider:

- ignoring most `.runtime/` files by default
- explicitly allowlisting milestone bundles
- generating execution summaries into stable docs rather than storing all raw prompt handoff files

---

## 7. Summary

Recommended policy:

> Treat `.runtime/` as a source of execution evidence, but version selectively.

For the current maturity level of this repo, that means:

- keep representative stage bundles
- be cautious about backend-specific prompt files
- avoid turning `.runtime/` into a dump of all transient execution artifacts

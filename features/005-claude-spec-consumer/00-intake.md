# Intake

## Request Summary
Create a tiny pilot to prove that the runtime can hand a stage to a real backend consumer. Specifically, automate the `spec` stage with Claude Code so that it reads `00-intake.md` and produces `01-spec.md`.

## Why It Matters
The repository already has runtime wiring, prompt files, and stage bundles, but it still lacks a real execution path where a backend consumes stage context and writes an artifact. Proving the `spec` stage works will validate the first backend integration step.

## Constraints
- Keep the feature small and focused on the `spec` stage only.
- Use local Claude Code CLI as the first backend.
- Do not try to automate all stages at once.

## Unknowns / Questions
- How much of the stage context must be passed explicitly versus inferred from the files?
- Whether the consumer should auto-complete artifacts immediately can remain a later decision.

## Initial Success Definition
A user can run a script against a feature directory and the `spec` stage, and Claude Code will produce `01-spec.md` from `00-intake.md` using the repository's prompt layer.

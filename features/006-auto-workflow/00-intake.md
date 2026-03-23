# Intake

## Request Summary
Add an automated workflow runner that can support both full workflow execution and stage-scoped execution. The runner should chain existing stage preparation, backend consumption, and artifact completion into one command.

## Why It Matters
The repository already supports stage-level automation, but the user still has to manually advance each step. Adding an auto workflow runner is the next meaningful step toward a truly agentic workflow.

## Constraints
- Keep the design lightweight and coherent with the existing repository.
- Reuse existing scripts instead of introducing a parallel orchestration system.
- Support full flow and partial flow modes.

## Unknowns / Questions
- `intake` is not yet backend-consumed, so full automation may need to start at `spec` by default.
- `implement` is not yet automated, so the early-stage default flow should avoid pretending this exists.

## Initial Success Definition
A single command can run a full early-stage workflow (`spec -> plan -> tasks`) automatically, and can also run a single stage or stage range on demand.

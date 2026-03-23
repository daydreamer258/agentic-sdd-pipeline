# Retrospective

## What went well

- The lightweight SDD workflow successfully carried a real feature from intake through validation.
- The repository's artifact model was sufficient to support a full early-stage loop: intake, spec, plan, tasks, implementation log, validation.
- Runtime wiring, stage handlers, state tracking, and stage bundles all proved useful in practice rather than only in theory.
- Claude Code CLI was able to act as a real backend consumer for `spec`, `plan`, `tasks`, and `validate`.
- The prompt layer (Skills + Subagent role files) was good enough to guide artifact generation without requiring major redesign during the run.

## What was awkward

- The workflow is still partially manual: after backend generation, artifact completion must still be recorded separately.
- The backend consumer still contains stage-specific mapping logic, even though stage bundles now exist.
- Documentation drift occurred while capabilities were expanding quickly; docs lagged behind runtime reality.
- Feature folders that were created or modified outside the normal init path revealed state metadata gaps.

## Root causes

### Process / workflow causes
- The system evolved quickly across multiple layers (runtime, prompts, backend execution), so docs and code changed faster than the repo's consistency checks.
- The repo does not yet have a formal retrospective step wired into the execution flow.

### Runtime causes
- `complete-artifact.sh` is still a separate step rather than being integrated into successful backend execution.
- Backend consumers are not yet bundle-native; they still know too much about specific stage-to-file mappings.

### Documentation causes
- Repeated incremental edits led to drift in `README.md` and `docs/backend-consumers.md`.
- There is no doc consistency gate yet.

## Most important lessons

1. The lightweight SDD system is viable: the early text-centric part of the loop can already be automated.
2. Runtime + prompt layer + backend consumer is the correct architecture, but the handoff still needs tighter automation.
3. State and artifact handling must be treated as first-class workflow infrastructure, not as an afterthought.
4. Documentation drift becomes a real problem as soon as the system starts working quickly.

## Recommended changes

### High priority
- Add automatic `complete-artifact` after successful backend generation.
- Introduce a lightweight chained execution mode so a request can move through multiple stages automatically.
- Reduce stage-specific duplication inside backend consumers by relying more directly on stage bundles.

### Medium priority
- Add a `.runtime/` policy and decide what should be versioned.
- Add a retrospective trigger or checklist to the workflow.
- Add a doc consistency review step whenever backend capability expands.

### Lower priority
- Consider a backend adapter abstraction once multiple backends are realistic.
- Revisit implementation-stage automation only after early-stage chaining is stable.

## Decision proposal

The next major capability should be:

> Add chained execution support so a request can automatically move through the early text-centric SDD stages (`intake -> spec -> plan -> tasks -> validate`) using the runtime, prompt layer, and backend consumer together.

That will turn the system from a manually stepped workflow into a more truly agentic pipeline.

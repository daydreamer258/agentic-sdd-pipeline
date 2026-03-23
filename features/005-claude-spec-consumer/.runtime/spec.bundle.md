# Stage Bundle

## Metadata
- feature_id: 005
- feature_slug: claude-spec-consumer
- feature_title: claude-spec-consumer
- feature_dir: ./features/005-claude-spec-consumer
- current_stage: spec
- requested_stage: spec
- next_stage: plan
- current_status: ready_for_skill

## Goal
Turn intake into a behavior-oriented spec.

## Read
./features/005-claude-spec-consumer/00-intake.md; /root/.openclaw/workspace/repos/agentic-sdd-pipeline/templates/01-spec.md

## Write
./features/005-claude-spec-consumer/01-spec.md

## Skill Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/skills/sdd-spec/SKILL.md

## Subagent Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/subagents/spec-writer.md

## Suggested Execution
1. Read the listed artifacts.
2. Follow the stage Skill if available.
3. Follow the subagent role prompt if available.
4. Produce or update the expected output artifact(s).
5. Run ./scripts/complete-artifact.sh "./features/005-claude-spec-consumer" <artifact> after writing the target artifact.

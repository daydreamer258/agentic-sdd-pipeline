# Stage Bundle

## Metadata
- feature_id: 005
- feature_slug: claude-spec-consumer
- feature_title: claude-spec-consumer
- feature_dir: ./features/005-claude-spec-consumer
- current_stage: tasks
- requested_stage: tasks
- next_stage: implement
- current_status: ready_for_skill

## Goal
Decompose the plan into executable tasks.

## Read
./features/005-claude-spec-consumer/01-spec.md; ./features/005-claude-spec-consumer/02-plan.md; /root/.openclaw/workspace/repos/agentic-sdd-pipeline/templates/06-tasks.md

## Write
./features/005-claude-spec-consumer/06-tasks.md

## Skill Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/skills/sdd-tasks/SKILL.md

## Subagent Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/subagents/task-decomposer.md

## Suggested Execution
1. Read the listed artifacts.
2. Follow the stage Skill if available.
3. Follow the subagent role prompt if available.
4. Produce or update the expected output artifact(s).
5. Run ./scripts/complete-artifact.sh "./features/005-claude-spec-consumer" <artifact> after writing the target artifact.

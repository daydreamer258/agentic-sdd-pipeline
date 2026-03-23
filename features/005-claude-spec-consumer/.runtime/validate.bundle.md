# Stage Bundle

## Metadata
- feature_id: 005
- feature_slug: claude-spec-consumer
- feature_title: claude-spec-consumer
- feature_dir: ./features/005-claude-spec-consumer
- current_stage: validate
- requested_stage: validate
- next_stage: done
- current_status: ready_for_skill

## Goal
Validate implementation against runtime outcomes and upstream artifacts.

## Read
./features/005-claude-spec-consumer/01-spec.md; ./features/005-claude-spec-consumer/02-plan.md; ./features/005-claude-spec-consumer/06-tasks.md; ./features/005-claude-spec-consumer/07-implementation-log.md; changed files/test outputs

## Write
./features/005-claude-spec-consumer/08-validation.md

## Skill Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/skills/sdd-validate/SKILL.md

## Subagent Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/subagents/validator.md

## Suggested Execution
1. Read the listed artifacts.
2. Follow the stage Skill if available.
3. Follow the subagent role prompt if available.
4. Produce or update the expected output artifact(s).
5. Run ./scripts/complete-artifact.sh "./features/005-claude-spec-consumer" <artifact> after writing the target artifact.

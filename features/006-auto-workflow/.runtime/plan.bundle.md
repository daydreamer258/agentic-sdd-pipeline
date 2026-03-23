# Stage Bundle

## Metadata
- feature_id: 006
- feature_slug: auto-workflow
- feature_title: auto-workflow
- feature_dir: ./features/006-auto-workflow
- current_stage: plan
- requested_stage: plan
- next_stage: tasks
- current_status: ready_for_skill

## Goal
Translate the spec into a technical implementation plan.

## Read
./features/006-auto-workflow/01-spec.md; /root/.openclaw/workspace/repos/agentic-sdd-pipeline/templates/02-plan.md

## Write
./features/006-auto-workflow/02-plan.md

## Skill Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/skills/sdd-plan/SKILL.md

## Subagent Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/subagents/planner.md

## Suggested Execution
1. Read the listed artifacts.
2. Follow the stage Skill if available.
3. Follow the subagent role prompt if available.
4. Produce or update the expected output artifact(s).
5. Run ./scripts/complete-artifact.sh "./features/006-auto-workflow" <artifact> after writing the target artifact.

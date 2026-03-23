# Stage Bundle

## Metadata
- feature_id: 006
- feature_slug: auto-workflow
- feature_title: auto-workflow
- feature_dir: ./features/006-auto-workflow
- current_stage: intake
- requested_stage: intake
- next_stage: spec
- current_status: ready_for_skill

## Goal
Convert the raw request into a structured intake artifact.

## Read
raw request context; templates/00-intake.md

## Write
./features/006-auto-workflow/00-intake.md

## Skill Prompt
/root/.openclaw/workspace/repos/agentic-sdd-pipeline/skills/sdd-intake/SKILL.md

## Subagent Prompt
n/a

## Suggested Execution
1. Read the listed artifacts.
2. Follow the stage Skill if available.
3. Follow the subagent role prompt if available.
4. Produce or update the expected output artifact(s).
5. Run ./scripts/complete-artifact.sh "./features/006-auto-workflow" <artifact> after writing the target artifact.

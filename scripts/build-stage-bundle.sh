#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <stage>" >&2
  exit 1
fi

FEATURE_DIR="$1"
STAGE="$2"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
STATE_FILE="$FEATURE_DIR/state.json"
BUNDLE_DIR="$FEATURE_DIR/.runtime"
BUNDLE_FILE="$BUNDLE_DIR/$STAGE.bundle.md"
. "$ROOT_DIR/scripts/state-lib.sh"

mkdir -p "$BUNDLE_DIR"

FEATURE_BASENAME=$(basename "$FEATURE_DIR")
DERIVED_ID=$(printf '%s' "$FEATURE_BASENAME" | cut -d'-' -f1)
DERIVED_SLUG=$(printf '%s' "$FEATURE_BASENAME" | cut -d'-' -f2-)

FEATURE_ID=$(state_get "$STATE_FILE" feature_id)
FEATURE_SLUG=$(state_get "$STATE_FILE" feature_slug)
FEATURE_TITLE=$(state_get "$STATE_FILE" feature_title)
CURRENT_STAGE=$(state_get "$STATE_FILE" current_stage)
NEXT_STAGE=$(state_get "$STATE_FILE" next_stage)
STATUS=$(state_get "$STATE_FILE" status)

FEATURE_ID=${FEATURE_ID:-$DERIVED_ID}
FEATURE_SLUG=${FEATURE_SLUG:-$DERIVED_SLUG}
FEATURE_TITLE=${FEATURE_TITLE:-$DERIVED_SLUG}
CURRENT_STAGE=${CURRENT_STAGE:-$STAGE}
NEXT_STAGE=${NEXT_STAGE:-unknown}
STATUS=${STATUS:-unknown}

SKILL_FILE=""
SUBAGENT_FILE=""
READ_ARTIFACTS=""
WRITE_ARTIFACTS=""
GOAL=""

case "$STAGE" in
  intake)
    SKILL_FILE="$ROOT_DIR/skills/sdd-intake/SKILL.md"
    READ_ARTIFACTS="raw request context; templates/00-intake.md"
    WRITE_ARTIFACTS="$FEATURE_DIR/00-intake.md"
    GOAL="Convert the raw request into a structured intake artifact."
    ;;
  spec)
    SKILL_FILE="$ROOT_DIR/skills/sdd-spec/SKILL.md"
    SUBAGENT_FILE="$ROOT_DIR/subagents/spec-writer.md"
    READ_ARTIFACTS="$FEATURE_DIR/00-intake.md; $ROOT_DIR/templates/01-spec.md"
    WRITE_ARTIFACTS="$FEATURE_DIR/01-spec.md"
    GOAL="Turn intake into a behavior-oriented spec."
    ;;
  plan)
    SKILL_FILE="$ROOT_DIR/skills/sdd-plan/SKILL.md"
    SUBAGENT_FILE="$ROOT_DIR/subagents/planner.md"
    READ_ARTIFACTS="$FEATURE_DIR/01-spec.md; $ROOT_DIR/templates/02-plan.md"
    WRITE_ARTIFACTS="$FEATURE_DIR/02-plan.md"
    GOAL="Translate the spec into a technical implementation plan."
    ;;
  tasks)
    SKILL_FILE="$ROOT_DIR/skills/sdd-tasks/SKILL.md"
    SUBAGENT_FILE="$ROOT_DIR/subagents/task-decomposer.md"
    READ_ARTIFACTS="$FEATURE_DIR/01-spec.md; $FEATURE_DIR/02-plan.md; $ROOT_DIR/templates/06-tasks.md"
    WRITE_ARTIFACTS="$FEATURE_DIR/06-tasks.md"
    GOAL="Decompose the plan into executable tasks."
    ;;
  implement)
    READ_ARTIFACTS="$FEATURE_DIR/01-spec.md; $FEATURE_DIR/02-plan.md; $FEATURE_DIR/06-tasks.md"
    WRITE_ARTIFACTS="code changes; $FEATURE_DIR/07-implementation-log.md"
    GOAL="Implement the bounded task set without scope drift."
    ;;
  validate)
    SKILL_FILE="$ROOT_DIR/skills/sdd-validate/SKILL.md"
    SUBAGENT_FILE="$ROOT_DIR/subagents/validator.md"
    READ_ARTIFACTS="$FEATURE_DIR/01-spec.md; $FEATURE_DIR/02-plan.md; $FEATURE_DIR/06-tasks.md; $FEATURE_DIR/07-implementation-log.md; changed files/test outputs"
    WRITE_ARTIFACTS="$FEATURE_DIR/08-validation.md"
    GOAL="Validate implementation against runtime outcomes and upstream artifacts."
    ;;
  *)
    echo "unknown stage: $STAGE" >&2
    exit 2
    ;;
esac

cat > "$BUNDLE_FILE" <<EOF
# Stage Bundle

## Metadata
- feature_id: $FEATURE_ID
- feature_slug: $FEATURE_SLUG
- feature_title: $FEATURE_TITLE
- feature_dir: $FEATURE_DIR
- current_stage: $CURRENT_STAGE
- requested_stage: $STAGE
- next_stage: $NEXT_STAGE
- current_status: $STATUS

## Goal
$GOAL

## Read
$READ_ARTIFACTS

## Write
$WRITE_ARTIFACTS

## Skill Prompt
$(if [ -n "$SKILL_FILE" ]; then echo "$SKILL_FILE"; else echo "n/a"; fi)

## Subagent Prompt
$(if [ -n "$SUBAGENT_FILE" ]; then echo "$SUBAGENT_FILE"; else echo "n/a"; fi)

## Suggested Execution
1. Read the listed artifacts.
2. Follow the stage Skill if available.
3. Follow the subagent role prompt if available.
4. Produce or update the expected output artifact(s).
5. Run ./scripts/complete-artifact.sh "$FEATURE_DIR" <artifact> after writing the target artifact.
EOF

echo "$BUNDLE_FILE"

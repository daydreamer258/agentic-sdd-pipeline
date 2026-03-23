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
. "$ROOT_DIR/scripts/state-lib.sh"

if [ ! -d "$FEATURE_DIR" ]; then
  echo "feature dir does not exist: $FEATURE_DIR" >&2
  exit 2
fi

run_hook_if_exists() {
  HOOK_PATH="$1"
  shift || true
  if [ -x "$HOOK_PATH" ]; then
    "$HOOK_PATH" "$@"
  fi
}

FEATURE_ID=$(state_get "$STATE_FILE" feature_id)
FEATURE_SLUG=$(state_get "$STATE_FILE" feature_slug)
FEATURE_TITLE=$(state_get "$STATE_FILE" feature_title)
LAST_ARTIFACT=$(state_get "$STATE_FILE" last_artifact)

case "$STAGE" in
  intake)
    NEXT_STAGE="spec"
    STATUS="ready_for_skill"
    LAST_TARGET="00-intake.md"
    ;;
  spec|plan|tasks|implement|validate)
    run_hook_if_exists "$ROOT_DIR/hooks/before_stage_transition.sh" "$FEATURE_DIR" "$STAGE"
    case "$STAGE" in
      spec) NEXT_STAGE="plan"; STATUS="ready_for_skill"; LAST_TARGET="01-spec.md" ;;
      plan) NEXT_STAGE="tasks"; STATUS="ready_for_skill"; LAST_TARGET="02-plan.md" ;;
      tasks) NEXT_STAGE="implement"; STATUS="ready_for_skill"; LAST_TARGET="06-tasks.md" ;;
      implement)
        run_hook_if_exists "$ROOT_DIR/hooks/before_implement.sh" "$FEATURE_DIR"
        NEXT_STAGE="validate"; STATUS="ready_for_execution"; LAST_TARGET="07-implementation-log.md"
        ;;
      validate) NEXT_STAGE="done"; STATUS="ready_for_skill"; LAST_TARGET="08-validation.md" ;;
    esac
    ;;
  *)
    echo "unknown stage: $STAGE" >&2
    exit 3
    ;;
esac

state_write "$STATE_FILE" \
  "$FEATURE_ID" \
  "$FEATURE_SLUG" \
  "$FEATURE_TITLE" \
  "$STAGE" \
  "$STATUS" \
  "${LAST_ARTIFACT:-$LAST_TARGET}" \
  "$NEXT_STAGE" \
  "$(state_now)" \
  "pending" \
  "false"

echo "Stage prepared: $STAGE"
HANDLER="$ROOT_DIR/runtime/handlers/$STAGE.sh"
if [ -x "$HANDLER" ]; then
  "$HANDLER" "$FEATURE_DIR"
else
  echo "No handler found for stage: $STAGE"
fi

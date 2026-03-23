#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <artifact-path>" >&2
  exit 1
fi

FEATURE_DIR="$1"
ARTIFACT_PATH="$2"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
STATE_FILE="$FEATURE_DIR/state.json"
. "$ROOT_DIR/scripts/state-lib.sh"

if [ ! -f "$FEATURE_DIR/$ARTIFACT_PATH" ]; then
  echo "artifact does not exist: $FEATURE_DIR/$ARTIFACT_PATH" >&2
  exit 2
fi

if [ -x "$ROOT_DIR/hooks/after_artifact_write.sh" ]; then
  "$ROOT_DIR/hooks/after_artifact_write.sh" "$FEATURE_DIR" "$ARTIFACT_PATH"
fi

FEATURE_ID=$(state_get "$STATE_FILE" feature_id)
FEATURE_SLUG=$(state_get "$STATE_FILE" feature_slug)
FEATURE_TITLE=$(state_get "$STATE_FILE" feature_title)
CURRENT_STAGE=$(state_get "$STATE_FILE" current_stage)
NEXT_STAGE=$(next_stage_for_artifact "$ARTIFACT_PATH")
VALIDATION_RESULT=$(state_get "$STATE_FILE" validation_result)
NEEDS_REVIEW=$(state_get "$STATE_FILE" needs_review)
FEATURE_ID=${FEATURE_ID:-$(feature_derive_id "$FEATURE_DIR")}
FEATURE_SLUG=${FEATURE_SLUG:-$(feature_derive_slug "$FEATURE_DIR")}
FEATURE_TITLE=${FEATURE_TITLE:-$FEATURE_SLUG}
CURRENT_STAGE=${CURRENT_STAGE:-unknown}
VALIDATION_RESULT=${VALIDATION_RESULT:-pending}
NEEDS_REVIEW=${NEEDS_REVIEW:-false}

state_write "$STATE_FILE" \
  "$FEATURE_ID" \
  "$FEATURE_SLUG" \
  "$FEATURE_TITLE" \
  "$CURRENT_STAGE" \
  "artifact_written" \
  "$ARTIFACT_PATH" \
  "$NEXT_STAGE" \
  "$(state_now)" \
  "${VALIDATION_RESULT:-pending}" \
  "${NEEDS_REVIEW:-false}"

echo "Recorded artifact completion: $ARTIFACT_PATH"

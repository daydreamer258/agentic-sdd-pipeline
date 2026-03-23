#!/usr/bin/env sh
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <feature-dir>" >&2
  exit 1
fi

FEATURE_DIR="$1"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
VALIDATION_FILE="$FEATURE_DIR/08-validation.md"
STATE_FILE="$FEATURE_DIR/state.json"
. "$ROOT_DIR/scripts/state-lib.sh"

if [ ! -f "$VALIDATION_FILE" ]; then
  echo "validation file missing" >&2
  exit 2
fi

FEATURE_ID=$(state_get "$STATE_FILE" feature_id)
FEATURE_SLUG=$(state_get "$STATE_FILE" feature_slug)
FEATURE_TITLE=$(state_get "$STATE_FILE" feature_title)
CURRENT_STAGE=$(state_get "$STATE_FILE" current_stage)
LAST_ARTIFACT=$(state_get "$STATE_FILE" last_artifact)

if grep -q '\- \[x\] Pass' "$VALIDATION_FILE"; then
  VALIDATION_RESULT="pass"
  STATUS="validated"
  NEEDS_REVIEW="false"
elif grep -q '\- \[x\] Rework needed' "$VALIDATION_FILE"; then
  VALIDATION_RESULT="rework"
  STATUS="validation_failed"
  NEEDS_REVIEW="true"
else
  VALIDATION_RESULT="unknown"
  STATUS="validation_recorded"
  NEEDS_REVIEW="true"
fi

state_write "$STATE_FILE" \
  "$FEATURE_ID" \
  "$FEATURE_SLUG" \
  "$FEATURE_TITLE" \
  "$CURRENT_STAGE" \
  "$STATUS" \
  "${LAST_ARTIFACT:-08-validation.md}" \
  "done" \
  "$(state_now)" \
  "$VALIDATION_RESULT" \
  "$NEEDS_REVIEW"

echo "Validation completed for $FEATURE_DIR"

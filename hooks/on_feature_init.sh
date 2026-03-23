#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-id> <feature-slug> [title]" >&2
  exit 1
fi

FEATURE_ID="$1"
FEATURE_SLUG="$2"
FEATURE_TITLE="${3:-$2}"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
FEATURE_DIR="$ROOT_DIR/features/${FEATURE_ID}-${FEATURE_SLUG}"
TEMPLATE_DIR="$ROOT_DIR/templates"
. "$ROOT_DIR/scripts/state-lib.sh"

mkdir -p "$FEATURE_DIR"
cp "$TEMPLATE_DIR/00-intake.md" "$FEATURE_DIR/00-intake.md"
cp "$TEMPLATE_DIR/01-spec.md" "$FEATURE_DIR/01-spec.md"
cp "$TEMPLATE_DIR/02-plan.md" "$FEATURE_DIR/02-plan.md"
cp "$TEMPLATE_DIR/06-tasks.md" "$FEATURE_DIR/06-tasks.md"
cp "$TEMPLATE_DIR/07-implementation-log.md" "$FEATURE_DIR/07-implementation-log.md"
cp "$TEMPLATE_DIR/08-validation.md" "$FEATURE_DIR/08-validation.md"

state_write "$FEATURE_DIR/state.json" \
  "$FEATURE_ID" \
  "$FEATURE_SLUG" \
  "$FEATURE_TITLE" \
  "intake" \
  "initialized" \
  "" \
  "spec" \
  "$(state_now)" \
  "pending" \
  "false"

echo "Initialized feature folder: $FEATURE_DIR"

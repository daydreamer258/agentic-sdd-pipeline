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

if [ ! -f "$FEATURE_DIR/$ARTIFACT_PATH" ]; then
  echo "artifact does not exist: $FEATURE_DIR/$ARTIFACT_PATH" >&2
  exit 2
fi

if [ -x "$ROOT_DIR/hooks/after_artifact_write.sh" ]; then
  "$ROOT_DIR/hooks/after_artifact_write.sh" "$FEATURE_DIR" "$ARTIFACT_PATH"
fi

CURRENT_STAGE="unknown"
STATUS="artifact_written"
if [ -f "$STATE_FILE" ]; then
  CURRENT_STAGE=$(grep -o '"current_stage": "[^"]*"' "$STATE_FILE" | head -n1 | cut -d'"' -f4 || true)
fi

cat > "$STATE_FILE" <<EOF
{
  "current_stage": "$CURRENT_STAGE",
  "status": "$STATUS",
  "last_artifact": "$ARTIFACT_PATH"
}
EOF

echo "Recorded artifact completion: $ARTIFACT_PATH"

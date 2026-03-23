#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <risk>" >&2
  exit 1
fi

FEATURE_DIR="$1"
RISK="$2"
OUT_FILE="$FEATURE_DIR/implement-checkpoint.md"
FEATURE_BASENAME=$(basename "$FEATURE_DIR")

cat > "$OUT_FILE" <<EOF
# Implement Checkpoint

- feature: $FEATURE_BASENAME
- stage: implement
- risk: $RISK

## Suggested action
$(if [ "$RISK" = "medium" ]; then echo '- continue-with-caution'; else echo '- stop'; fi)

## Notes
Automatic implement was stopped because the current risk policy does not allow silent continuation for this risk level.
Review the current tasks, plan, and spec before proceeding.
EOF

echo "$OUT_FILE"

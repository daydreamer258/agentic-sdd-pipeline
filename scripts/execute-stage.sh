#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <stage>" >&2
  exit 1
fi

FEATURE_DIR="$1"
STAGE="$2"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

"$ROOT_DIR/scripts/run-stage.sh" "$FEATURE_DIR" "$STAGE"

echo
cat <<EOF
Next action:
- Execute the stage performer (skill/subagent/orchestrator) for '$STAGE'
- Write/update the expected artifact
- Then run: ./scripts/complete-artifact.sh "$FEATURE_DIR" <artifact>
EOF

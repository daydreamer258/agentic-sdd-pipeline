#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <artifact-path>" >&2
  exit 1
fi

FEATURE_DIR="$1"
ARTIFACT_PATH="$2"

echo "Artifact written: $ARTIFACT_PATH"
if [ -f "$FEATURE_DIR/state.json" ]; then
  echo "State file present: $FEATURE_DIR/state.json"
fi

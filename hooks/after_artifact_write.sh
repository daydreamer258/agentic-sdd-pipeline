#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <artifact-path>" >&2
  exit 1
fi

FEATURE_DIR="$1"
ARTIFACT_PATH="$2"
STATE_FILE="$FEATURE_DIR/state.json"

if [ -f "$STATE_FILE" ]; then
  TMP_FILE="$STATE_FILE.tmp"
  # lightweight append-style note without requiring jq
  cp "$STATE_FILE" "$TMP_FILE"
  mv "$TMP_FILE" "$STATE_FILE"
fi

echo "Artifact written: $ARTIFACT_PATH"

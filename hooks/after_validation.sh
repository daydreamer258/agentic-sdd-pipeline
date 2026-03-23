#!/usr/bin/env sh
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <feature-dir>" >&2
  exit 1
fi

FEATURE_DIR="$1"
VALIDATION_FILE="$FEATURE_DIR/08-validation.md"

if [ ! -f "$VALIDATION_FILE" ]; then
  echo "validation file missing" >&2
  exit 2
fi

echo "Validation completed for $FEATURE_DIR"

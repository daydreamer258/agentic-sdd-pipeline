#!/usr/bin/env sh
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <feature-dir>" >&2
  exit 1
fi

FEATURE_DIR="$1"

for f in 01-spec.md 02-plan.md 06-tasks.md; do
  if [ ! -f "$FEATURE_DIR/$f" ]; then
    echo "cannot implement: missing $f" >&2
    exit 2
  fi
done

echo "Implementation prerequisites satisfied"

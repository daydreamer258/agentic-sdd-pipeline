#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <to-stage>" >&2
  exit 1
fi

FEATURE_DIR="$1"
TO_STAGE="$2"

require_file() {
  if [ ! -f "$FEATURE_DIR/$1" ]; then
    echo "missing required artifact: $1" >&2
    exit 2
  fi
}

case "$TO_STAGE" in
  spec)
    require_file "00-intake.md"
    ;;
  plan)
    require_file "01-spec.md"
    ;;
  tasks)
    require_file "01-spec.md"
    require_file "02-plan.md"
    ;;
  implement)
    require_file "01-spec.md"
    require_file "02-plan.md"
    require_file "06-tasks.md"
    ;;
  validate)
    require_file "01-spec.md"
    require_file "02-plan.md"
    require_file "06-tasks.md"
    require_file "07-implementation-log.md"
    ;;
  *)
    echo "unknown target stage: $TO_STAGE" >&2
    exit 3
    ;;
esac

echo "Stage transition allowed: $TO_STAGE"

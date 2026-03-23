#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <mode> [args...]" >&2
  echo "modes:" >&2
  echo "  full [start-stage] [end-stage]" >&2
  echo "  single <stage>" >&2
  echo "  range <start-stage> <end-stage>" >&2
  exit 1
fi

FEATURE_DIR="$1"
MODE="$2"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
. "$ROOT_DIR/scripts/state-lib.sh"

STAGES="intake spec plan tasks implement validate"

stage_exists() {
  TARGET="$1"
  for s in $STAGES; do
    [ "$s" = "$TARGET" ] && return 0
  done
  return 1
}

stage_order() {
  TARGET="$1"
  IDX=1
  for s in $STAGES; do
    if [ "$s" = "$TARGET" ]; then
      echo "$IDX"
      return 0
    fi
    IDX=$((IDX + 1))
  done
  return 1
}

expected_artifact_for_stage() {
  case "$1" in
    intake) echo "00-intake.md" ;;
    spec) echo "01-spec.md" ;;
    plan) echo "02-plan.md" ;;
    tasks) echo "06-tasks.md" ;;
    implement) echo "07-implementation-log.md" ;;
    validate) echo "08-validation.md" ;;
    *) return 1 ;;
  esac
}

consume_stage() {
  STAGE="$1"
  case "$STAGE" in
    spec|plan|tasks|validate)
      "$ROOT_DIR/scripts/consume-stage-with-claude.sh" "$FEATURE_DIR" "$STAGE"
      ;;
    *)
      echo "No automated consumer configured for stage: $STAGE" >&2
      return 2
      ;;
  esac
}

run_stage_once() {
  STAGE="$1"
  ARTIFACT=$(expected_artifact_for_stage "$STAGE")

  "$ROOT_DIR/scripts/execute-stage.sh" "$FEATURE_DIR" "$STAGE"

  if [ "$STAGE" = "intake" ]; then
    echo "Auto workflow does not synthesize intake content yet. Expecting existing or manually prepared: $FEATURE_DIR/$ARTIFACT"
  else
    consume_stage "$STAGE"
  fi

  if [ ! -f "$FEATURE_DIR/$ARTIFACT" ]; then
    echo "expected artifact missing after stage '$STAGE': $FEATURE_DIR/$ARTIFACT" >&2
    exit 3
  fi

  "$ROOT_DIR/scripts/complete-artifact.sh" "$FEATURE_DIR" "$ARTIFACT"

  if [ "$STAGE" = "validate" ] && [ -x "$ROOT_DIR/hooks/after_validation.sh" ]; then
    "$ROOT_DIR/hooks/after_validation.sh" "$FEATURE_DIR"
  fi
}

resolve_full_defaults() {
  START_STAGE="${1:-spec}"
  END_STAGE="${2:-tasks}"
  echo "$START_STAGE $END_STAGE"
}

case "$MODE" in
  full)
    set -- $(resolve_full_defaults "${3:-}" "${4:-}")
    START_STAGE="$1"
    END_STAGE="$2"
    ;;
  single)
    [ $# -ge 3 ] || { echo "single mode requires <stage>" >&2; exit 1; }
    START_STAGE="$3"
    END_STAGE="$3"
    ;;
  range)
    [ $# -ge 4 ] || { echo "range mode requires <start-stage> <end-stage>" >&2; exit 1; }
    START_STAGE="$3"
    END_STAGE="$4"
    ;;
  *)
    echo "unknown mode: $MODE" >&2
    exit 1
    ;;
esac

stage_exists "$START_STAGE" || { echo "unknown start stage: $START_STAGE" >&2; exit 1; }
stage_exists "$END_STAGE" || { echo "unknown end stage: $END_STAGE" >&2; exit 1; }

START_ORDER=$(stage_order "$START_STAGE")
END_ORDER=$(stage_order "$END_STAGE")
[ "$START_ORDER" -le "$END_ORDER" ] || { echo "start stage must be before or equal to end stage" >&2; exit 1; }

IDX=1
for STAGE in $STAGES; do
  if [ "$IDX" -ge "$START_ORDER" ] && [ "$IDX" -le "$END_ORDER" ]; then
    run_stage_once "$STAGE"
  fi
  IDX=$((IDX + 1))
done

echo "Auto workflow completed: $FEATURE_DIR ($START_STAGE -> $END_STAGE)"

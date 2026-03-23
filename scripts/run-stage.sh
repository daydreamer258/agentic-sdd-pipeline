#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <stage>" >&2
  exit 1
fi

FEATURE_DIR="$1"
STAGE="$2"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
STATE_FILE="$FEATURE_DIR/state.json"

if [ ! -d "$FEATURE_DIR" ]; then
  echo "feature dir does not exist: $FEATURE_DIR" >&2
  exit 2
fi

run_hook_if_exists() {
  HOOK_PATH="$1"
  shift || true
  if [ -x "$HOOK_PATH" ]; then
    "$HOOK_PATH" "$@"
  fi
}

set_stage() {
  NEW_STAGE="$1"
  STATUS="$2"
  LAST_ARTIFACT="${3:-}"
  cat > "$STATE_FILE" <<EOF
{
  "current_stage": "$NEW_STAGE",
  "status": "$STATUS",
  "last_artifact": "$LAST_ARTIFACT"
}
EOF
}

case "$STAGE" in
  intake)
    set_stage "intake" "ready_for_skill" "00-intake.md"
    echo "Stage prepared: intake"
    echo "Expected skill: sdd-intake"
    echo "Expected output: 00-intake.md"
    ;;
  spec)
    run_hook_if_exists "$ROOT_DIR/hooks/before_stage_transition.sh" "$FEATURE_DIR" spec
    set_stage "spec" "ready_for_skill" "01-spec.md"
    echo "Stage prepared: spec"
    echo "Expected skill: sdd-spec"
    echo "Suggested subagent: spec-writer"
    echo "Expected output: 01-spec.md"
    ;;
  plan)
    run_hook_if_exists "$ROOT_DIR/hooks/before_stage_transition.sh" "$FEATURE_DIR" plan
    set_stage "plan" "ready_for_skill" "02-plan.md"
    echo "Stage prepared: plan"
    echo "Expected skill: sdd-plan"
    echo "Suggested subagent: planner"
    echo "Expected output: 02-plan.md"
    ;;
  tasks)
    run_hook_if_exists "$ROOT_DIR/hooks/before_stage_transition.sh" "$FEATURE_DIR" tasks
    set_stage "tasks" "ready_for_skill" "06-tasks.md"
    echo "Stage prepared: tasks"
    echo "Expected skill: sdd-tasks"
    echo "Suggested subagent: task-decomposer"
    echo "Expected output: 06-tasks.md"
    ;;
  implement)
    run_hook_if_exists "$ROOT_DIR/hooks/before_stage_transition.sh" "$FEATURE_DIR" implement
    run_hook_if_exists "$ROOT_DIR/hooks/before_implement.sh" "$FEATURE_DIR"
    set_stage "implement" "ready_for_execution" "07-implementation-log.md"
    echo "Stage prepared: implement"
    echo "Expected performer: orchestrator or bounded implementer"
    echo "Expected output: code changes + 07-implementation-log.md"
    ;;
  validate)
    run_hook_if_exists "$ROOT_DIR/hooks/before_stage_transition.sh" "$FEATURE_DIR" validate
    set_stage "validate" "ready_for_skill" "08-validation.md"
    echo "Stage prepared: validate"
    echo "Expected skill: sdd-validate"
    echo "Suggested subagent: validator"
    echo "Expected output: 08-validation.md"
    ;;
  *)
    echo "unknown stage: $STAGE" >&2
    exit 3
    ;;
esac

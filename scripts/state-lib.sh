#!/usr/bin/env sh

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

state_get() {
  FILE="$1"
  KEY="$2"
  if [ ! -f "$FILE" ]; then
    return 0
  fi
  grep -o '"'"$KEY"'": "[^"]*"' "$FILE" 2>/dev/null | head -n1 | cut -d'"' -f4 || true
}

feature_derive_id() {
  BASENAME=$(basename "$1")
  printf '%s' "$BASENAME" | cut -d'-' -f1
}

feature_derive_slug() {
  BASENAME=$(basename "$1")
  printf '%s' "$BASENAME" | cut -d'-' -f2-
}

state_write() {
  FILE="$1"
  FEATURE_ID="${2:-}"
  FEATURE_SLUG="${3:-}"
  FEATURE_TITLE="${4:-}"
  CURRENT_STAGE="${5:-}"
  STATUS="${6:-}"
  LAST_ARTIFACT="${7:-}"
  NEXT_STAGE="${8:-}"
  LAST_UPDATED_AT="${9:-}"
  VALIDATION_RESULT="${10:-}"
  NEEDS_REVIEW="${11:-}"

  mkdir -p "$(dirname "$FILE")"
  cat > "$FILE" <<EOF
{
  "feature_id": "$(json_escape "$FEATURE_ID")",
  "feature_slug": "$(json_escape "$FEATURE_SLUG")",
  "feature_title": "$(json_escape "$FEATURE_TITLE")",
  "current_stage": "$(json_escape "$CURRENT_STAGE")",
  "status": "$(json_escape "$STATUS")",
  "last_artifact": "$(json_escape "$LAST_ARTIFACT")",
  "next_stage": "$(json_escape "$NEXT_STAGE")",
  "last_updated_at": "$(json_escape "$LAST_UPDATED_AT")",
  "validation_result": "$(json_escape "$VALIDATION_RESULT")",
  "needs_review": "$(json_escape "$NEEDS_REVIEW")"
}
EOF
}

state_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

next_stage_for_artifact() {
  ARTIFACT="$1"
  case "$ARTIFACT" in
    00-intake.md) echo "spec" ;;
    01-spec.md) echo "plan" ;;
    02-plan.md) echo "tasks" ;;
    06-tasks.md) echo "implement" ;;
    07-implementation-log.md) echo "validate" ;;
    08-validation.md) echo "done" ;;
    *) echo "unknown" ;;
  esac
}

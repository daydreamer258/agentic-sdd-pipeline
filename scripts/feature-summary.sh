#!/usr/bin/env sh
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <feature-dir>" >&2
  exit 1
fi

FEATURE_DIR="$1"
STATE_FILE="$FEATURE_DIR/state.json"

if [ ! -d "$FEATURE_DIR" ]; then
  echo "feature dir does not exist: $FEATURE_DIR" >&2
  exit 2
fi

extract_json_value() {
  KEY="$1"
  FILE="$2"
  if [ ! -f "$FILE" ]; then
    echo "n/a"
    return 0
  fi
  VALUE=$(grep -o '"'"$KEY"'": "[^"]*"' "$FILE" 2>/dev/null | head -n1 | cut -d'"' -f4 || true)
  if [ -n "$VALUE" ]; then
    echo "$VALUE"
  else
    echo "n/a"
  fi
}

print_artifact_status() {
  FILE_NAME="$1"
  if [ -f "$FEATURE_DIR/$FILE_NAME" ]; then
    printf '  [x] %s\n' "$FILE_NAME"
  else
    printf '  [ ] %s\n' "$FILE_NAME"
  fi
}

CURRENT_STAGE=$(extract_json_value current_stage "$STATE_FILE")
STATUS=$(extract_json_value status "$STATE_FILE")
LAST_ARTIFACT=$(extract_json_value last_artifact "$STATE_FILE")

printf 'Feature Summary\n'
printf '===============\n'
printf 'Path: %s\n' "$FEATURE_DIR"
printf 'Current stage: %s\n' "$CURRENT_STAGE"
printf 'Status: %s\n' "$STATUS"
printf 'Last artifact: %s\n' "$LAST_ARTIFACT"
printf '\nCore artifacts:\n'
print_artifact_status "00-intake.md"
print_artifact_status "01-spec.md"
print_artifact_status "02-plan.md"
print_artifact_status "06-tasks.md"
print_artifact_status "07-implementation-log.md"
print_artifact_status "08-validation.md"

if [ ! -f "$STATE_FILE" ]; then
  printf '\nNote: state.json is missing; summary is based on file presence only.\n'
fi

exit 0

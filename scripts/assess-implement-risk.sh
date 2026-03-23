#!/usr/bin/env sh
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <feature-dir>" >&2
  exit 1
fi

FEATURE_DIR="$1"
SPEC_FILE="$FEATURE_DIR/01-spec.md"
PLAN_FILE="$FEATURE_DIR/02-plan.md"
TASKS_FILE="$FEATURE_DIR/06-tasks.md"

for f in "$SPEC_FILE" "$PLAN_FILE" "$TASKS_FILE"; do
  if [ ! -f "$f" ]; then
    echo "missing required file for risk assessment: $f" >&2
    exit 2
  fi
done

TEXT=$(cat "$SPEC_FILE" "$PLAN_FILE" "$TASKS_FILE")

contains() {
  printf '%s' "$TEXT" | grep -Eqi "$1"
}

REASONS=""
RISK="low"

if contains 'delete|remove file|drop table|migration|database schema|lockfile|package-lock|pnpm-lock|yarn.lock|ci|deploy|infra|auth|permission|payment|secret|credential'; then
  RISK="high"
  REASONS="matched high-risk keywords"
elif contains 'refactor|multiple modules|cross-directory|existing logic|modify existing module|multi-file'; then
  RISK="medium"
  REASONS="matched medium-risk keywords"
else
  RISK="low"
  REASONS="no high- or medium-risk keywords detected"
fi

printf 'risk=%s\n' "$RISK"
printf 'reason=%s\n' "$REASONS"

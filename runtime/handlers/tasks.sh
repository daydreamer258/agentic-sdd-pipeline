#!/usr/bin/env sh
set -eu

FEATURE_DIR="$1"
echo "Handler ready: tasks"
echo "Use skill: sdd-tasks"
echo "Suggested subagent: task-decomposer"
echo "Read: $FEATURE_DIR/01-spec.md and $FEATURE_DIR/02-plan.md"
echo "Write: $FEATURE_DIR/06-tasks.md"

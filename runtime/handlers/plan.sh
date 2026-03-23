#!/usr/bin/env sh
set -eu

FEATURE_DIR="$1"
echo "Handler ready: plan"
echo "Use skill: sdd-plan"
echo "Suggested subagent: planner"
echo "Read: $FEATURE_DIR/01-spec.md"
echo "Write: $FEATURE_DIR/02-plan.md"

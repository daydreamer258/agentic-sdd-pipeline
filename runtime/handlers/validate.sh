#!/usr/bin/env sh
set -eu

FEATURE_DIR="$1"
echo "Handler ready: validate"
echo "Use skill: sdd-validate"
echo "Suggested subagent: validator"
echo "Read: $FEATURE_DIR/01-spec.md $FEATURE_DIR/02-plan.md $FEATURE_DIR/06-tasks.md $FEATURE_DIR/07-implementation-log.md"
echo "Write: $FEATURE_DIR/08-validation.md"

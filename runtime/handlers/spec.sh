#!/usr/bin/env sh
set -eu

FEATURE_DIR="$1"
echo "Handler ready: spec"
echo "Use skill: sdd-spec"
echo "Suggested subagent: spec-writer"
echo "Read: $FEATURE_DIR/00-intake.md"
echo "Write: $FEATURE_DIR/01-spec.md"

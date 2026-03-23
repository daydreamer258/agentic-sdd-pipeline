#!/usr/bin/env sh
set -eu

FEATURE_DIR="$1"
echo "Handler ready: intake"
echo "Read raw request context and write: $FEATURE_DIR/00-intake.md"

#!/usr/bin/env sh
set -eu

FEATURE_DIR="$1"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
BUNDLE_FILE=$("$ROOT_DIR/scripts/build-stage-bundle.sh" "$FEATURE_DIR" implement)
echo "Handler ready: implement"
echo "Stage bundle: $BUNDLE_FILE"

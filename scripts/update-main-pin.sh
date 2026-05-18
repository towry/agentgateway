#!/usr/bin/env bash
# Refresh main-pin to the latest commit on the fork's main branch
# (which is fast-forwarded from upstream/main).
#
# Usage:
#   scripts/update-main-pin.sh                 # use origin/main HEAD
#   scripts/update-main-pin.sh <ref-or-sha>    # explicit ref

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PIN_FILE="$REPO_ROOT/main-pin"
WORKTREE="$REPO_ROOT/agentgateway-main"

if [[ ! -d "$WORKTREE/.git" && ! -f "$WORKTREE/.git" ]]; then
  echo "error: expected main worktree at $WORKTREE" >&2
  exit 1
fi

REF="${1:-origin/main}"

git -C "$WORKTREE" fetch origin main --quiet
SHA=$(git -C "$WORKTREE" rev-parse "$REF")

if [[ ${#SHA} -ne 40 ]]; then
  echo "error: ref $REF did not resolve to a full SHA" >&2
  exit 1
fi

printf '%s\n' "$SHA" > "$PIN_FILE"
echo "main-pin updated to $SHA"

#!/bin/bash
# SessionStart (cloud only): copy the public dev repo next to this repo, read-only, so /cycle-start and the
# architect can read the dev code and skills. Local sessions already have the sibling folder, so this exits early.
[ "$CLAUDE_CODE_REMOTE" = "true" ] || exit 0
PLAN="$CLAUDE_PROJECT_DIR"
DEV_NAME="$(basename "$PLAN" | sed -E 's/-plan$/-dev/')"
DEV="$(dirname "$PLAN")/$DEV_NAME"
SLUG="$(git -C "$PLAN" remote get-url origin 2>/dev/null | sed -E 's#\.git$##; s#.*[/:]([^/:]+)/([^/:]+)$#\1/\2#; s#-plan$#-dev#')"
URL="${DEV_GIT_BASE:-https://github.com}/$SLUG"
if [ -d "$DEV/.git" ]; then
  git -C "$DEV" fetch -q --depth 1 origin >/dev/null 2>&1 && git -C "$DEV" reset -q --hard FETCH_HEAD >/dev/null 2>&1
else
  GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 "$URL" "$DEV" >/dev/null 2>&1
fi
if [ -f "$DEV/CLAUDE.md" ]; then
  echo "Dev project: read-only copy of $DEV_NAME (default branch) at $DEV. Read it; never edit it."
else
  echo "Dev project not loaded: could not get $URL into $DEV. Tell the user before reviewing dev code."
fi
exit 0

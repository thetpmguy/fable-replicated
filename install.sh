#!/usr/bin/env sh
# Install the fable-style skill into ~/.claude/skills so Claude Code discovers
# it in every project.
#
# From a clone:   ./install.sh
# Without a clone: curl -fsSL https://raw.githubusercontent.com/thetpmguy/fable-replicated/main/install.sh | sh
#
# Override the target with CLAUDE_SKILLS_DIR, e.g. a single project:
#   CLAUDE_SKILLS_DIR=/path/to/project/.claude/skills ./install.sh

set -eu

REPO="thetpmguy/fable-replicated"
BRANCH="${FABLE_BRANCH:-main}"
SKILL="fable-style"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$DEST"

# Path to this script's directory, if we're running from a checkout.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd || true)
LOCAL_SKILL="${SCRIPT_DIR:+$SCRIPT_DIR/.claude/skills/$SKILL}"

if [ -n "${LOCAL_SKILL:-}" ] && [ -d "$LOCAL_SKILL" ]; then
  echo "Installing $SKILL from local checkout to $DEST/$SKILL"
  rm -rf "$DEST/$SKILL"
  cp -R "$LOCAL_SKILL" "$DEST/$SKILL"
else
  echo "Downloading $SKILL from $REPO@$BRANCH to $DEST/$SKILL"
  TMP=$(mktemp -d)
  trap 'rm -rf "$TMP"' EXIT
  URL="https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH"
  curl -fsSL "$URL" | tar -xz -C "$TMP"
  SRC=$(find "$TMP" -type d -path "*/.claude/skills/$SKILL" | head -n1)
  if [ -z "$SRC" ]; then
    echo "Error: could not find .claude/skills/$SKILL in the downloaded archive." >&2
    echo "If the repo is private, clone it and run ./install.sh instead." >&2
    exit 1
  fi
  rm -rf "$DEST/$SKILL"
  cp -R "$SRC" "$DEST/$SKILL"
fi

echo "Done. Installed:"
find "$DEST/$SKILL" -type f | sort
echo
echo "Claude Code will now discover '$SKILL' in projects using $DEST."

#!/usr/bin/env bash
# Symlink every skill in this repo into an agent skills directory.
#
# Usage:
#   ./scripts/link-skills.sh [target-skills-dir]
#
# Default target is ~/.claude/skills. Pass another directory to target a
# different agent, e.g. ~/.pi/agent/skills or a project's .agents/skills.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:-$HOME/.claude/skills}"

mkdir -p "$TARGET"

linked=0
skipped=0

while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  name="$(basename "$skill_dir")"
  link="$TARGET/$name"

  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "skip   $name (target exists and is not a symlink)"
    skipped=$((skipped + 1))
    continue
  fi

  ln -sfn "$skill_dir" "$link"
  echo "linked $name -> $skill_dir"
  linked=$((linked + 1))
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' | sort)

echo
echo "linked $linked, skipped $skipped into $TARGET"

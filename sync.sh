#!/usr/bin/env bash
set -euo pipefail

# Sync shared Claude Code framework files into a target project.
# Usage: ./sync.sh /path/to/project
#
# Copies shared files (rules, agents, skills, settings) into the project's .claude/ directory.
# Does NOT overwrite project-specific files (memory.md, protected-files.md, etc.)

if [ -z "${1:-}" ]; then
  echo "Usage: ./sync.sh <target-project-path>"
  echo "Example: ./sync.sh ~/Projects/NOTAR"
  exit 1
fi

TARGET="$1/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$1" ]; then
  echo "Error: Target directory '$1' does not exist"
  exit 1
fi

# Create directories
mkdir -p "$TARGET/rules" "$TARGET/agents" "$TARGET/memory"
mkdir -p "$TARGET/skills/commit" "$TARGET/skills/plan" "$TARGET/skills/test"
mkdir -p "$TARGET/skills/check" "$TARGET/skills/status"

echo "Syncing shared files to $TARGET ..."

# Shared rules
cp "$SCRIPT_DIR/rules/workflow.md" "$TARGET/rules/workflow.md"
echo "  rules/workflow.md"

# Shared agents
for agent in memory-updater planner reviewer researcher; do
  cp "$SCRIPT_DIR/agents/$agent.md" "$TARGET/agents/$agent.md"
  echo "  agents/$agent.md"
done

# Shared skills
for skill in commit plan test check status; do
  cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$TARGET/skills/$skill/SKILL.md"
  echo "  skills/$skill/SKILL.md"
done

# Settings (hooks)
cp "$SCRIPT_DIR/settings.json" "$TARGET/settings.json"
echo "  settings.json"

# Do NOT copy templates or project-specific files
echo ""
echo "Done. Shared files synced."
echo ""
echo "Project-specific files NOT touched:"
echo "  rules/memory.md"
echo "  rules/protected-files.md"
echo "  memory/*.md"
echo "  CLAUDE.local.md"
echo ""
echo "If these don't exist yet, run: ./init.sh $1"

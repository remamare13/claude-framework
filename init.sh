#!/usr/bin/env bash
set -euo pipefail

# Initialize a new project with the full Claude Code framework.
# Usage: ./init.sh /path/to/project
#
# 1. Copies all shared files (same as sync.sh)
# 2. Creates project-specific files from templates (only if they don't exist)

if [ -z "${1:-}" ]; then
  echo "Usage: ./init.sh <target-project-path>"
  echo "Example: ./init.sh ~/Projects/MY-NEW-PROJECT"
  exit 1
fi

TARGET="$1/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$1" ]; then
  echo "Error: Target directory '$1' does not exist"
  exit 1
fi

# First, sync shared files
echo "=== Phase 1: Syncing shared files ==="
"$SCRIPT_DIR/sync.sh" "$1"

# Then, create project-specific files from templates (only if missing)
echo "=== Phase 2: Creating project-specific files from templates ==="

create_from_template() {
  local template="$1"
  local target="$2"
  if [ ! -f "$target" ]; then
    cp "$template" "$target"
    echo "  Created: $target"
  else
    echo "  Exists (skipped): $target"
  fi
}

mkdir -p "$TARGET/rules" "$TARGET/memory"

create_from_template "$SCRIPT_DIR/templates/memory.md.template" "$TARGET/rules/memory.md"
create_from_template "$SCRIPT_DIR/templates/protected-files.md.template" "$TARGET/rules/protected-files.md"
create_from_template "$SCRIPT_DIR/templates/CLAUDE.local.md.template" "$TARGET/CLAUDE.local.md"
create_from_template "$SCRIPT_DIR/templates/architecture.md.template" "$TARGET/memory/architecture.md"
create_from_template "$SCRIPT_DIR/templates/dependencies.md.template" "$TARGET/memory/dependencies.md"
create_from_template "$SCRIPT_DIR/templates/module-status.md.template" "$TARGET/memory/module-status.md"

echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Edit .claude/rules/memory.md — fill in project state"
echo "  2. Edit .claude/rules/protected-files.md — list your protected files"
echo "  3. Edit .claude/CLAUDE.local.md — set your preferences"
echo "  4. Edit .claude/memory/architecture.md — document your architecture"
echo "  5. Edit .claude/memory/dependencies.md — map critical dependencies"
echo "  6. Add 'Workflow Discipline' and 'Memory System' sections to your CLAUDE.md"

#!/bin/bash
# Agentic Sprint Kit — Bootstrap Script
#
# Usage: ./bootstrap.sh [target-directory]
#
# Copies the kit into a target directory and initializes it for development.
# If no target is specified, sets up in the current directory.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || mkdir -p "$TARGET_DIR" && cd "$TARGET_DIR" && pwd)"

echo "=== Agentic Sprint Kit ==="
echo "Setting up in: $TARGET_DIR"
echo ""

# Copy template files (don't overwrite existing files)
copy_if_missing() {
  local src="$1"
  local dest="$2"
  if [ ! -f "$dest" ]; then
    cp "$src" "$dest"
    echo "  Created: $(basename "$dest")"
  else
    echo "  Skipped: $(basename "$dest") (already exists)"
  fi
}

# Copy directory recursively (don't overwrite existing files)
copy_dir() {
  local src_dir="$1"
  local dest_dir="$2"
  mkdir -p "$dest_dir"
  for f in "$src_dir"/*; do
    [ -e "$f" ] || continue
    local base="$(basename "$f")"
    if [ -d "$f" ]; then
      copy_dir "$f" "$dest_dir/$base"
    else
      copy_if_missing "$f" "$dest_dir/$base"
    fi
  done
}

# Create directories
mkdir -p "$TARGET_DIR/docs"
mkdir -p "$TARGET_DIR/agent_docs"
mkdir -p "$TARGET_DIR/.claude/skills"

# Copy core files
copy_if_missing "$SCRIPT_DIR/PROMPT.md" "$TARGET_DIR/PROMPT.md"
copy_if_missing "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
copy_if_missing "$SCRIPT_DIR/BEST_PRACTICES.md" "$TARGET_DIR/BEST_PRACTICES.md"

# Copy agent_docs
copy_dir "$SCRIPT_DIR/agent_docs" "$TARGET_DIR/agent_docs"

# Copy doc templates
for f in "$SCRIPT_DIR/docs/"*.md; do
  [ -f "$f" ] && copy_if_missing "$f" "$TARGET_DIR/docs/$(basename "$f")"
done

# Copy skills
copy_dir "$SCRIPT_DIR/.claude/skills" "$TARGET_DIR/.claude/skills"

# Copy settings.json
copy_if_missing "$SCRIPT_DIR/.claude/settings.json" "$TARGET_DIR/.claude/settings.json"

# Initialize git if needed
if [ ! -d "$TARGET_DIR/.git" ]; then
  cd "$TARGET_DIR" && git init -q
  echo "  Initialized git repository"
fi

# Create .gitignore if missing
if [ ! -f "$TARGET_DIR/.gitignore" ]; then
  cat > "$TARGET_DIR/.gitignore" << 'GITIGNORE'
node_modules/
.env
.env.local
dist/
build/
__pycache__/
*.pyc
.DS_Store
*.log
coverage/
.next/
.claude/settings.local.json
GITIGNORE
  echo "  Created: .gitignore"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit PROMPT.md with your project description"
echo "  2. Run: claude"
echo "  3. Answer the clarifying questions (at most 10)"
echo "  4. Let it build"
echo ""
echo "Or use 'ccn' to do all of this with a single one-liner."
echo ""

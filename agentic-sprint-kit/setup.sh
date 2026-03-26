#!/usr/bin/env bash
set -euo pipefail

# Agentic Sprint Kit — Mac/Linux Installer
#
# Installs the kit to ~/.agentic-sprint-kit/ and adds the `ccn` shell function
# to your shell RC file (~/.zshrc or ~/.bashrc).
#
# After running this, you can use:
#   ccn            — create a new project from a one-sentence description
#   ccn --redo     — rebuild the project in the current directory
#   ccn --redo /path/to/project — rebuild a project at a specific path
#
# Safe to re-run — updates the installed copy without touching existing projects.
# Does NOT modify the ccn function if it already exists (remove the block to update).

INSTALL_DIR="$HOME/.agentic-sprint-kit"
KIT_SRC="$(cd "$(dirname "$0")" && pwd)"

# ── Prerequisites ──────────────────────────────────────────────────────────────

echo "Checking prerequisites..."

if ! command -v git &>/dev/null; then
  echo "Error: git is not installed. Install it first."
  exit 1
fi

if ! command -v claude &>/dev/null; then
  echo "Error: claude CLI is not installed."
  echo "  Install it from https://claude.com/claude-code"
  exit 1
fi

echo "  git ✓"
echo "  claude ✓"

# ── Install kit ────────────────────────────────────────────────────────────────

echo ""
echo "Installing kit to $INSTALL_DIR ..."

mkdir -p "$INSTALL_DIR"
rsync -a --delete \
  --exclude='.DS_Store' \
  --exclude='setup.sh' \
  --exclude='setup.ps1' \
  "$KIT_SRC/" "$INSTALL_DIR/"

echo "  Kit copied ✓"

# ── Determine shell config file ───────────────────────────────────────────────

if [[ "${SHELL:-}" == *zsh ]]; then
  SHELL_RC="$HOME/.zshrc"
elif [[ "${SHELL:-}" == *bash ]]; then
  SHELL_RC="$HOME/.bashrc"
else
  # Default to .bashrc on Linux, .zshrc on Mac
  if [[ "$(uname)" == "Darwin" ]]; then
    SHELL_RC="$HOME/.zshrc"
  else
    SHELL_RC="$HOME/.bashrc"
  fi
fi

touch "$SHELL_RC"

# ── Add ccn function (only if not already present) ─────────────────────────────

if grep -q '# >>> agentic-sprint-kit ccn >>>' "$SHELL_RC" 2>/dev/null; then
  echo "  ccn function already in $SHELL_RC — skipping (run setup again after removing the block to update)"
  echo ""
  echo "  To update the ccn function, remove the block between"
  echo "  '# >>> agentic-sprint-kit ccn >>>' and '# <<< agentic-sprint-kit ccn <<<'"
  echo "  in $SHELL_RC, then re-run this script."
else
  cat >> "$SHELL_RC" << 'SHELL_FUNC'

# >>> agentic-sprint-kit ccn >>>
# Create new agentic project from a one-liner
ccn() {
  local kit_src="$HOME/.agentic-sprint-kit"

  # --- HELP ---
  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    cat << 'HELPTEXT'
CCN(1)                    Agentic Sprint Kit                    CCN(1)

NAME
    ccn — create and build software projects autonomously with AI agents

SYNOPSIS
    ccn
    ccn --redo [path]
    ccn --help | -h
    ccn --version | -v

DESCRIPTION
    ccn bootstraps a new project directory with the Agentic Sprint Kit,
    then launches Claude Code in auto-mode to build the entire project
    autonomously. You describe what you want in one sentence, answer up
    to 10 clarifying questions, and the system handles everything else:
    specs, code, tests, and QA.

COMMANDS
    ccn
        Create a new project. Prompts for a project name, copies the kit,
        initializes git, and launches Claude Code. You'll be asked for a
        one-sentence description, then up to 10 clarifying questions.
        After that, all phases run autonomously.

    ccn --redo [path]
        Rebuild an existing project. Analyzes the project at [path] (or
        current directory if omitted), creates redo_<name>/ as a sibling,
        and launches Claude Code in redo mode. Parallel agents audit the
        original project's architecture, UX, and test quality, then build
        an improved version.

    ccn --help, -h
        Show this help text.

    ccn --version, -v
        Show the installed kit version.

BUILD PHASES (auto-chained, no manual intervention)
    Phase 0     Intake — ask up to 10 clarifying questions (only pause)
    Phase 1     Spec generation — architecture, data model, contracts, flows
    Phase 1.5   Product validation — magic moment, first experience, sprints
    Phase 2     Scaffold — project skeleton, typed contracts, stubs
    Phase 2.5   Test generation — all tests from acceptance criteria
    Phase 3     Sprint execution — parallel agents in worktrees (loops)
    Phase 4     QA — end-to-end verification + product review + STATUS.md

SKILLS (invoked automatically by the orchestrator)
    /kit-intake         Phase 0: clarifying questions (new projects)
    /kit-redo-intake    Phase 0: audit + rebuild (redo mode)
    /kit-spec           Phase 1: generate all spec documents
    /kit-validate       Phase 1.5: product validation
    /kit-scaffold       Phase 2: project skeleton
    /kit-tests          Phase 2.5: generate tests
    /kit-sprint         Phase 3: sprint execution (repeats)
    /kit-qa             Phase 4: QA and final report
    /kit-sm             ScrumMaster background agent
    /kit-status         Check project progress anytime
    /remote-trainer     Run ML training on remote GPU via SSH

AGENT ROLES
    ScrumMaster     Keeps agents productive, resolves blockers, decides
    Product         Ensures product meets user objectives
    Architect       System boundaries, tech stack, data flow
    Frontend        UI components, user flows, client-side logic
    Backend         API endpoints, server logic, database ops
    Engine          Domain-specific logic (ML, game engine, etc.)
    Test            Write and maintain tests across all layers
    Review          Post-sprint quality and spec-drift review

FILES
    ~/.agentic-sprint-kit/      Global kit installation
    PROMPT.md                   Project description (you fill this in)
    CLAUDE.md                   Orchestration guide (lean, 97 lines)
    BEST_PRACTICES.md           Research-backed patterns and rationale
    agent_docs/                 Agent reference docs (loaded on demand)
    .claude/skills/             Phase skills and utilities
    docs/                       Spec templates (populated during build)

ENVIRONMENT
    CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
        Enable parallel agent teams (optional, improves speed)

EXAMPLES
    # Create a new project
    ccn
    > Project name: my-saas-app
    > "A SaaS dashboard that tracks customer health scores"
    > (answers 10 questions, then autonomous build begins)

    # Rebuild an existing project
    cd ~/projects/my-app && ccn --redo

    # Rebuild a project from anywhere
    ccn --redo ~/projects/my-app

SEE ALSO
    Project README: ~/.agentic-sprint-kit/README.md
    Best practices: ~/.agentic-sprint-kit/BEST_PRACTICES.md

HELPTEXT
    return 0
  fi

  # --- VERSION ---
  if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    local version_file="$kit_src/VERSION"
    if [ -f "$version_file" ]; then
      echo "ccn (Agentic Sprint Kit) $(cat "$version_file")"
    else
      echo "ccn (Agentic Sprint Kit) 1.0.0"
    fi
    return 0
  fi

  if [ ! -d "$kit_src" ]; then
    echo "Error: agentic-sprint-kit not found at $kit_src"
    echo "  Re-run the installer: cd <kit-repo> && ./setup.sh"
    return 1
  fi

  # --- REDO MODE ---
  if [ "$1" = "--redo" ]; then
    local source_dir="${2:-.}"
    source_dir="$(cd "$source_dir" && pwd)"
    local folder_name="$(basename "$source_dir")"
    local project_dir="$(dirname "$source_dir")/redo_${folder_name}"

    if [ -d "$project_dir" ]; then
      echo "Error: $project_dir already exists. Remove it first."
      return 1
    fi

    # Create and populate the redo project with the kit (exclude PROMPT.md — it'll be generated)
    mkdir -p "$project_dir"
    rsync -a \
      --exclude='.DS_Store' \
      --exclude='bootstrap.sh' \
      --exclude='README.md' \
      --exclude='PROMPT.md' \
      "$kit_src/" "$project_dir/"

    # Create .gitignore
    cat > "$project_dir/.gitignore" << 'GITIGNORE'
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

    # Write redo marker so the orchestrator knows the original project path
    cat > "$project_dir/.redo" << EOF
ORIGINAL_PROJECT=$source_dir
FOLDER_NAME=$folder_name
CREATED=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

    cd "$project_dir" && git init -q

    echo ""
    echo "=== Redo: $folder_name ==="
    echo "  Original: $source_dir"
    echo "  New:      $project_dir"
    echo ""

    claude --enable-auto-mode \
      "You are running the Agentic Sprint Kit in REDO MODE. Read CLAUDE.md to understand the full workflow — specifically the Redo Mode section. The original project to analyze is at: $source_dir (folder name: $folder_name). This new project directory is the redo workspace. Your first step: read .claude/skills/kit-redo-intake/SKILL.md and follow its instructions. Spawn parallel agents to deeply audit the original project's code, architecture, product/UX, and test quality. Then generate docs/REDO_ANALYSIS.md with your findings and a complete PROMPT.md for the improved version. Present your analysis summary to the user and ask up to 10 clarifying questions (direction confirmation first, reuse decisions last). After they answer, proceed autonomously through ALL remaining phases without stopping: generate specs (per .claude/skills/kit-spec/SKILL.md), validate product alignment (per .claude/skills/kit-validate/SKILL.md), scaffold the project (per .claude/skills/kit-scaffold/SKILL.md), generate tests (per .claude/skills/kit-tests/SKILL.md), execute all sprints (per .claude/skills/kit-sprint/SKILL.md repeating until done), and run QA (per .claude/skills/kit-qa/SKILL.md). At the start of Phase 2, spawn the ScrumMaster agent in the background (per .claude/skills/kit-sm/SKILL.md with run_in_background:true). The SM also has access to the original project for reference. The agent team should decide whether to start from scratch or selectively reuse code from the original — document this decision in docs/DECISION_LOG.md. Do not stop to ask the user to run commands between phases."

    return
  fi

  # --- NEW PROJECT MODE ---
  # Prompt for project name
  echo "Project name (lowercase, dashes ok):"
  read -r project_name
  if [ -z "$project_name" ]; then
    echo "Error: project name required"
    return 1
  fi

  local project_dir="$(pwd)/$project_name"
  if [ -d "$project_dir" ]; then
    echo "Error: $project_dir already exists"
    return 1
  fi

  # Create and populate (exclude kit meta-files and .DS_Store)
  mkdir -p "$project_dir"
  rsync -a \
    --exclude='.DS_Store' \
    --exclude='bootstrap.sh' \
    --exclude='README.md' \
    "$kit_src/" "$project_dir/"

  # Create .gitignore
  cat > "$project_dir/.gitignore" << 'GITIGNORE'
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

  cd "$project_dir" && git init -q

  echo ""
  echo "=== Created $project_dir ==="
  echo "  Kit: CLAUDE.md, agent_docs/, .claude/skills/, .claude/settings.json"
  echo "  Docs: docs/ templates"
  echo "  Skills: /kit-intake, /kit-spec, /kit-validate, /kit-scaffold, /kit-tests, /kit-sprint, /kit-qa, /kit-sm, /kit-status"
  echo ""

  # Launch claude with auto-mode
  claude --enable-auto-mode \
    "You are starting a brand new project using the Agentic Sprint Kit. Read CLAUDE.md to understand the full workflow. Your first step: ask the user for a one-sentence description of what they want to build. Once they give you that sentence, expand it into a well-structured PROMPT.md (filling all 10 sections thoughtfully from their idea — infer what you can, leave sections blank if you truly cannot guess). Then ask the user up to 10 clarifying questions following the priorities in .claude/skills/kit-intake/SKILL.md (user/product questions first, technical questions last). After they answer, proceed autonomously through ALL remaining phases without stopping: generate specs (per .claude/skills/kit-spec/SKILL.md), validate product alignment (per .claude/skills/kit-validate/SKILL.md), scaffold the project (per .claude/skills/kit-scaffold/SKILL.md), generate tests (per .claude/skills/kit-tests/SKILL.md), execute all sprints (per .claude/skills/kit-sprint/SKILL.md repeating until done), and run QA (per .claude/skills/kit-qa/SKILL.md). At the start of Phase 2, spawn the ScrumMaster agent in the background (per .claude/skills/kit-sm/SKILL.md with run_in_background:true) — it monitors all activity, resolves blockers, answers open questions, and makes decisions to keep every agent productive. Do not stop to ask the user to run commands between phases."
}
# <<< agentic-sprint-kit ccn <<<
SHELL_FUNC

  echo "  ccn function added to $SHELL_RC ✓"
fi

# ── Done ───────────────────────────────────────────────────────────────────────

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  Agentic Sprint Kit installed successfully!"
echo ""
echo "  Restart your terminal or run:  source $SHELL_RC"
echo ""
echo "  Usage:"
echo "    ccn          — create a new project (in current directory)"
echo "    ccn --redo   — rebuild the project in the current directory"
echo "════════════════════════════════════════════════════════════"

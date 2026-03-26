# Agentic Sprint Kit — Windows (PowerShell) Installer
#
# Installs the kit to %USERPROFILE%\.agentic-sprint-kit\ and adds the `ccn`
# function to your PowerShell profile ($PROFILE).
#
# After running this, you can use:
#   ccn            — create a new project from a one-sentence description
#   ccn -Redo      — rebuild the project in the current directory
#   ccn -Redo -Path C:\path\to\project — rebuild a project at a specific path
#
# Safe to re-run — updates the installed copy without touching existing projects.

$ErrorActionPreference = "Stop"

$InstallDir = Join-Path $env:USERPROFILE ".agentic-sprint-kit"
$KitSrc = Split-Path -Parent $MyInvocation.MyCommand.Path

# ── Prerequisites ──────────────────────────────────────────────────────────────

Write-Host "Checking prerequisites..."

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Error: git is not installed. Install it first." -ForegroundColor Red
    exit 1
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "Error: claude CLI is not installed." -ForegroundColor Red
    Write-Host "  Install it from https://claude.com/claude-code"
    exit 1
}

Write-Host "  git OK" -ForegroundColor Green
Write-Host "  claude OK" -ForegroundColor Green

# ── Install kit ────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Installing kit to $InstallDir ..."

if (Test-Path $InstallDir) {
    Remove-Item -Recurse -Force $InstallDir
}

Copy-Item -Recurse -Force $KitSrc $InstallDir

# Remove installer scripts from the installed copy
Remove-Item -Force (Join-Path $InstallDir "setup.sh") -ErrorAction SilentlyContinue
Remove-Item -Force (Join-Path $InstallDir "setup.ps1") -ErrorAction SilentlyContinue
# Remove .DS_Store files
Get-ChildItem -Path $InstallDir -Filter ".DS_Store" -Recurse -Force | Remove-Item -Force

Write-Host "  Kit copied OK" -ForegroundColor Green

# ── Create ccn.ps1 script ─────────────────────────────────────────────────────

$CcnScript = Join-Path $InstallDir "ccn.ps1"

$CcnContent = @'
# Agentic Sprint Kit — ccn command (PowerShell)
param(
    [switch]$Redo,
    [string]$Path = "."
)

$KitSrc = Join-Path $env:USERPROFILE ".agentic-sprint-kit"

if (-not (Test-Path $KitSrc)) {
    Write-Host "Error: agentic-sprint-kit not found at $KitSrc" -ForegroundColor Red
    Write-Host "  Re-run the installer: cd <kit-repo>; .\setup.ps1"
    return
}

$GitignoreContent = @"
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
"@

if ($Redo) {
    # --- REDO MODE ---
    $SourceDir = (Resolve-Path $Path).Path
    $FolderName = Split-Path -Leaf $SourceDir
    $ParentDir = Split-Path -Parent $SourceDir
    $ProjectDir = Join-Path $ParentDir "redo_$FolderName"

    if (Test-Path $ProjectDir) {
        Write-Host "Error: $ProjectDir already exists. Remove it first." -ForegroundColor Red
        return
    }

    New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null

    # Copy kit excluding PROMPT.md, bootstrap.sh, README.md
    Get-ChildItem -Path $KitSrc -Exclude "PROMPT.md","bootstrap.sh","README.md",".DS_Store","ccn.ps1" |
        Copy-Item -Destination $ProjectDir -Recurse -Force

    $GitignoreContent | Set-Content -Path (Join-Path $ProjectDir ".gitignore") -Encoding UTF8

    # Write redo marker
    $RedoMarker = @"
ORIGINAL_PROJECT=$SourceDir
FOLDER_NAME=$FolderName
CREATED=$((Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ"))
"@
    $RedoMarker | Set-Content -Path (Join-Path $ProjectDir ".redo") -Encoding UTF8

    Set-Location $ProjectDir
    git init -q

    Write-Host ""
    Write-Host "=== Redo: $FolderName ==="
    Write-Host "  Original: $SourceDir"
    Write-Host "  New:      $ProjectDir"
    Write-Host ""

    claude --enable-auto-mode "You are running the Agentic Sprint Kit in REDO MODE. Read CLAUDE.md to understand the full workflow — specifically the Redo Mode section. The original project to analyze is at: $SourceDir (folder name: $FolderName). This new project directory is the redo workspace. Your first step: read .claude/skills/kit-redo-intake/SKILL.md and follow its instructions. Spawn parallel agents to deeply audit the original project's code, architecture, product/UX, and test quality. Then generate docs/REDO_ANALYSIS.md with your findings and a complete PROMPT.md for the improved version. Present your analysis summary to the user and ask up to 10 clarifying questions (direction confirmation first, reuse decisions last). After they answer, proceed autonomously through ALL remaining phases without stopping: generate specs (per .claude/skills/kit-spec/SKILL.md), validate product alignment (per .claude/skills/kit-validate/SKILL.md), scaffold the project (per .claude/skills/kit-scaffold/SKILL.md), generate tests (per .claude/skills/kit-tests/SKILL.md), execute all sprints (per .claude/skills/kit-sprint/SKILL.md repeating until done), and run QA (per .claude/skills/kit-qa/SKILL.md). At the start of Phase 2, spawn the ScrumMaster agent in the background (per .claude/skills/kit-sm/SKILL.md with run_in_background:true). The SM also has access to the original project for reference. The agent team should decide whether to start from scratch or selectively reuse code from the original — document this decision in docs/DECISION_LOG.md. Do not stop to ask the user to run commands between phases."
    return
}

# --- NEW PROJECT MODE ---
$ProjectName = Read-Host "Project name (lowercase, dashes ok)"
if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    Write-Host "Error: project name required" -ForegroundColor Red
    return
}

$ProjectDir = Join-Path (Get-Location) $ProjectName
if (Test-Path $ProjectDir) {
    Write-Host "Error: $ProjectDir already exists" -ForegroundColor Red
    return
}

New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null

# Copy kit excluding meta-files
Get-ChildItem -Path $KitSrc -Exclude "bootstrap.sh","README.md",".DS_Store","ccn.ps1" |
    Copy-Item -Destination $ProjectDir -Recurse -Force

$GitignoreContent | Set-Content -Path (Join-Path $ProjectDir ".gitignore") -Encoding UTF8

Set-Location $ProjectDir
git init -q

Write-Host ""
Write-Host "=== Created $ProjectDir ==="
Write-Host "  Kit: CLAUDE.md, agent_docs/, .claude/skills/, .claude/settings.json"
Write-Host "  Docs: docs/ templates"
Write-Host "  Skills: /kit-intake, /kit-spec, /kit-validate, /kit-scaffold, /kit-tests, /kit-sprint, /kit-qa, /kit-sm, /kit-status"
Write-Host ""

claude --enable-auto-mode "You are starting a brand new project using the Agentic Sprint Kit. Read CLAUDE.md to understand the full workflow. Your first step: ask the user for a one-sentence description of what they want to build. Once they give you that sentence, expand it into a well-structured PROMPT.md (filling all 10 sections thoughtfully from their idea — infer what you can, leave sections blank if you truly cannot guess). Then ask the user up to 10 clarifying questions following the priorities in .claude/skills/kit-intake/SKILL.md (user/product questions first, technical questions last). After they answer, proceed autonomously through ALL remaining phases without stopping: generate specs (per .claude/skills/kit-spec/SKILL.md), validate product alignment (per .claude/skills/kit-validate/SKILL.md), scaffold the project (per .claude/skills/kit-scaffold/SKILL.md), generate tests (per .claude/skills/kit-tests/SKILL.md), execute all sprints (per .claude/skills/kit-sprint/SKILL.md repeating until done), and run QA (per .claude/skills/kit-qa/SKILL.md). At the start of Phase 2, spawn the ScrumMaster agent in the background (per .claude/skills/kit-sm/SKILL.md with run_in_background:true) — it monitors all activity, resolves blockers, answers open questions, and makes decisions to keep every agent productive. Do not stop to ask the user to run commands between phases."
'@

$CcnContent | Set-Content -Path $CcnScript -Encoding UTF8

Write-Host "  ccn.ps1 created OK" -ForegroundColor Green

# ── Add ccn function to PowerShell profile ─────────────────────────────────────

$ProfilePath = $PROFILE
$ProfileDir = Split-Path -Parent $ProfilePath

if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
}

if (-not (Test-Path $ProfilePath)) {
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
}

$Marker = "# >>> agentic-sprint-kit ccn >>>"
$ProfileContent = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue

if ($ProfileContent -and $ProfileContent.Contains($Marker)) {
    Write-Host "  ccn function already in $ProfilePath — skipping" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  To update, remove the block between"
    Write-Host "  '# >>> agentic-sprint-kit ccn >>>' and '# <<< agentic-sprint-kit ccn <<<'"
    Write-Host "  in $ProfilePath, then re-run this script."
} else {
    $FunctionBlock = @"

# >>> agentic-sprint-kit ccn >>>
function ccn {
    param([switch]`$Redo, [string]`$Path = ".")
    if (`$Redo) {
        & "`$env:USERPROFILE\.agentic-sprint-kit\ccn.ps1" -Redo -Path `$Path
    } else {
        & "`$env:USERPROFILE\.agentic-sprint-kit\ccn.ps1"
    }
}
# <<< agentic-sprint-kit ccn <<<
"@
    Add-Content -Path $ProfilePath -Value $FunctionBlock
    Write-Host "  ccn function added to $ProfilePath OK" -ForegroundColor Green
}

# ── Done ───────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "================================================================"
Write-Host "  Agentic Sprint Kit installed successfully!"
Write-Host ""
Write-Host "  Restart your terminal or run:  . `$PROFILE"
Write-Host ""
Write-Host "  Usage:"
Write-Host "    ccn          — create a new project (in current directory)"
Write-Host "    ccn -Redo    — rebuild the project in the current directory"
Write-Host "================================================================"

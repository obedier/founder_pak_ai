# Agentic Sprint Kit

Autonomous multi-agent software development. Describe what you want in one sentence,
answer up to 10 questions, and the system builds the entire product — specs, code,
tests, and QA — without further human input.

## Setup (one-time)

### Mac / Linux

```bash
git clone <repo-url> agentic-sprint-kit
cd agentic-sprint-kit
./setup.sh
```

### Windows (PowerShell)

```powershell
git clone <repo-url> agentic-sprint-kit
cd agentic-sprint-kit
.\setup.ps1
```

The installer:
1. Copies the kit to `~/.agentic-sprint-kit/` (the global install location)
2. Adds the `ccn` command to your shell (zsh, bash, or PowerShell)
3. Is idempotent — safe to re-run to update the installed copy

Restart your terminal (or `source ~/.zshrc`) after setup.

## Usage

### Create a new project

```bash
ccn
```

1. Prompts for a project name
2. Copies the kit into `./<project-name>/`
3. Initializes git
4. Launches Claude Code — asks you to describe what you want in one sentence
5. Expands your sentence into a full `PROMPT.md`
6. Asks up to 10 clarifying questions
7. Builds the entire project autonomously (specs -> code -> tests -> QA)

### Rebuild an existing project (`--redo`)

```bash
cd ~/projects/my-app
ccn --redo
```

Or from anywhere:

```bash
ccn --redo ~/projects/my-app
```

1. Creates `redo_my-app/` as a sibling directory
2. Spawns parallel agents to audit the original project (architecture, UX, test quality)
3. Generates `docs/REDO_ANALYSIS.md` (what works, what's broken, reuse recommendation)
4. Generates a new `PROMPT.md` for the improved version
5. Asks up to 10 clarifying questions (direction confirmation, reuse decisions)
6. Builds the improved version through all phases autonomously

The agent team decides whether to start from scratch, selectively reuse code, or
heavily fork the original — and documents the decision with rationale.

### Manual setup (without `ccn`)

```bash
cp -r ~/.agentic-sprint-kit/ my-new-project/
cd my-new-project && git init
# Edit PROMPT.md with your project description
claude
```

## How It Works

### Phases

After you answer the intake questions, all remaining phases chain automatically.

| Phase | Skill | What Happens |
|-------|-------|-------------|
| 0 | `/kit-intake` | Read PROMPT.md, ask up to 10 questions (only human pause) |
| 0 (redo) | `/kit-redo-intake` | Audit existing project, generate improved PROMPT.md, ask questions |
| 1 | `/kit-spec` | Generate all specs: architecture, data model, contracts, user flows |
| 1.5 | `/kit-validate` | Product validation: magic moment, first experience, sprint priority |
| 2 | `/kit-scaffold` | Project skeleton with typed contracts, stubs, test infrastructure |
| 2.5 | `/kit-tests` | Generate ALL tests from WHEN-THEN-SHALL acceptance criteria |
| 3 | `/kit-sprint` | Execute sprints with parallel agents (repeats until all done) |
| 4 | `/kit-qa` | Technical QA + product-lens review + STATUS.md |

### ScrumMaster Agent

A background agent runs from Phase 2 onward. It has full project context and
authority to make any decision except changing product direction. It monitors
for blockers, resolves open questions, fixes stalled work, and keeps all agents
productive.

### Agent Roles

| Role | Mission |
|------|---------|
| ScrumMaster | Keep agents productive, resolve blockers, make decisions |
| Product Agent | Ensure product meets user objectives, not just technical requirements |
| Architect Agent | System boundaries, tech stack, data flow, contracts |
| Frontend Agent | UI components, user flows, client-side logic |
| Backend Agent | API endpoints, server logic, database operations |
| Engine Agent | Domain-specific logic (chess engine, ML pipeline, etc.) |
| Test Agent | Write and maintain tests across all layers |
| Review Agent | Post-sprint quality and spec-drift review |

Not every project uses all roles — the orchestrator activates roles based on scope.

## What's In The Box

```
PROMPT.md                          # You fill this in (or ccn generates it)
CLAUDE.md                          # Orchestration doc — modes, phases, rules
BEST_PRACTICES.md                  # Research-backed patterns and rationale

agent_docs/                        # Agent reference docs (loaded on demand)
  agent-roles.md                   # All roles including ScrumMaster
  guardrails.md                    # Hard rules for all agents
  coordination.md                  # Parallelization, worktrees, self-healing
  source-of-truth.md               # Priority hierarchy for conflicts

docs/                              # Spec templates (populated in Phase 1)
  DECISION_LOG.md                  # Agent decisions with rationale
  OPEN_QUESTIONS.md                # Unresolved questions
  STATUS.md                        # Final QA status report

.claude/
  settings.json                    # Quality gate hooks
  skills/                          # Phase skills + utilities
    kit-intake/                    # Phase 0: clarifying questions
    kit-redo-intake/               # Phase 0 (redo): audit + rebuild
    kit-spec/                      # Phase 1: generate specs
    kit-validate/                  # Phase 1.5: product validation
    kit-scaffold/                  # Phase 2: project skeleton
    kit-tests/                     # Phase 2.5: generate tests
    kit-sprint/                    # Phase 3: parallel sprint execution
    kit-qa/                        # Phase 4: end-to-end QA
    kit-sm/                        # ScrumMaster background agent
    kit-status/                    # Check project status anytime
    remote-trainer/                # Run ML jobs on remote GPU machine

setup.sh                           # Mac/Linux installer
setup.ps1                          # Windows installer
bootstrap.sh                       # Manual project bootstrapper
```

## Skills Reference

### Build Skills (auto-chained by orchestrator)

| Skill | When to use |
|-------|-------------|
| `/kit-intake` | Automatic — Phase 0 for new projects |
| `/kit-redo-intake` | Automatic — Phase 0 for `--redo` rebuilds |
| `/kit-spec` | Automatic — Phase 1 |
| `/kit-validate` | Automatic — Phase 1.5 |
| `/kit-scaffold` | Automatic — Phase 2 |
| `/kit-tests` | Automatic — Phase 2.5 |
| `/kit-sprint` | Automatic — Phase 3 (loops until done) |
| `/kit-qa` | Automatic — Phase 4 |

### Utility Skills

| Skill | When to use |
|-------|-------------|
| `/kit-status` | Check project progress anytime during or after a build |
| `/kit-sm` | ScrumMaster — spawned automatically as background agent |
| `/remote-trainer` | Run ML training jobs (LoRA, Whisper, fine-tuning) on a remote GPU machine via SSH |

## Redo Mode Details

Redo mode (`ccn --redo`) is for when you have an existing project that needs a
better version — same product, better execution.

### What happens

1. **Audit** — Three parallel agents analyze the original project:
   - Architecture & code quality audit
   - Product & UX audit
   - Test & quality audit

2. **Analysis** — `docs/REDO_ANALYSIS.md` is generated with:
   - What works well (preserve or improve)
   - What's broken or missing
   - What should change and why
   - Reuse recommendation (start fresh vs. selective reuse vs. heavy fork)

3. **PROMPT.md** — A complete PROMPT.md is generated from the analysis,
   describing the improved version

4. **Clarifying questions** — Up to 10 questions focused on:
   - Direction confirmation (keep scope? expand? reduce?)
   - Quality bar (polished production vs. better prototype?)
   - Reuse decisions (agree with the recommendation?)

5. **Build** — All remaining phases run identically to a new project

### Redo rules

- **Better, not different** — improve execution, not direction
- **Preserve what works** — don't rebuild working code for no reason
- **Fix root causes** — change architecture, not just symptoms
- **Document the delta** — `REDO_ANALYSIS.md` shows what changed and why

## Remote Trainer Skill

The `/remote-trainer` skill lets agents run ML training jobs on a dedicated
GPU machine over SSH. Designed for single-GPU fine-tuning (LoRA, QLoRA, Whisper).

### Quick reference

```bash
# Health check
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python -c \"import torch; print(torch.cuda.get_device_name(0))\""'

# Upload dataset
scp -r ./my-data ob-trainer:'C:\trainer\data\my-project'

# Run training
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python C:\trainer\scripts\train.py --args"'

# Check logs
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content -Tail 100"'

# Download results
scp -r ob-trainer:'C:\trainer\runs\my-project\checkpoint-best' ./output/
```

See `.claude/skills/remote-trainer/SKILL.md` for complete documentation including
workflow templates, VRAM budget table, and troubleshooting.

## What Makes This Different

### Product-first, not code-first
- PROMPT.md asks about the user's pain, the magic moment, and the return loop
  BEFORE asking about tech stack
- Phase 1.5 validates that specs serve user objectives before any code is written
- Sprint review checks "can a user complete this flow?" not just "do tests pass?"
- QA includes a product-lens review: "would the described user actually use this?"

### Fully autonomous after 10 questions
- The only human interaction is answering intake questions
- Phases chain automatically — no manual invocations
- Self-healing build loops fix test failures (max 3 attempts before flagging)
- Ambiguity gets flagged in OPEN_QUESTIONS.md, not guessed at

### Spec-driven with drift detection
- Specs are written before code; code implements specs, never the reverse
- WHEN-THEN-SHALL acceptance criteria map directly to auto-generated tests
- Post-sprint drift detection catches contract divergence

### Rebuild-aware
- `--redo` mode analyzes existing projects and builds improved versions
- Agent team decides reuse strategy based on code quality analysis
- Preserves what works, fixes what doesn't

## Customization

- **Tech stack**: PROMPT.md section 10, or leave blank for auto-selection
- **Guardrails**: `agent_docs/guardrails.md` (defaults) + `docs/GUARDRAILS.md` (project-specific)
- **Agent roles**: `agent_docs/agent-roles.md` — add/remove/customize
- **Hooks**: `.claude/settings.json` — add project-specific quality gates
- **Skills**: `.claude/skills/*/SKILL.md` — customize any phase workflow

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI installed
- Git
- For parallel agents: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (optional)
- For remote training: SSH access to a GPU machine (see `/remote-trainer` skill)

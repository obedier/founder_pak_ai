# Agentic Sprint Kit

**Autonomous multi-agent software development for Claude Code.**

Describe what you want in one sentence, answer up to 10 questions, and the system
builds the entire product — specs, code, tests, and QA — without further human input.

## What It Does

```
You: "A meal planning app that generates weekly grocery lists"

  --> 10 clarifying questions (only human interaction)
    --> Specs: architecture, data model, API contracts, user flows
      --> Product validation: magic moment, first experience, sprint priority
        --> Scaffold: typed stubs, schema, test infrastructure
          --> Tests: all acceptance criteria as skipped tests
            --> Sprints: parallel agents build features in worktrees
              --> QA: technical + product-lens review
                --> STATUS.md (GREEN / YELLOW / RED)
```

One command. One sentence. One set of questions. Everything else is autonomous.

## Quick Start

```bash
# Install (one-time)
cd agentic-sprint-kit
./setup.sh            # Mac/Linux
# .\setup.ps1         # Windows

# Restart terminal, then:
ccn                   # Create a new project
ccn --redo            # Rebuild an existing project
ccn --help            # Full man page
```

## Key Capabilities

| Capability | Description |
|-----------|-------------|
| **8 build phases** | Intake, specs, validation, scaffold, tests, sprints, QA — all auto-chained |
| **10 agent roles** | ScrumMaster, Product, Architect, Backend, Frontend, Data, Test, AI/ML, DevOps, Review |
| **ScrumMaster agent** | Background agent with full authority to unblock, decide, and keep work moving |
| **Spec-first development** | 9 spec documents generated before any code. Code implements specs, never the reverse |
| **Contract-driven parallelism** | Backend and frontend implement against the same typed API contracts independently |
| **WHEN-THEN-SHALL testing** | Acceptance criteria become tests before implementation (spec-driven TDD) |
| **Self-healing loops** | Test failures trigger repair agents (max 3 attempts before escalation) |
| **Redo mode** | Audit an existing project with parallel agents, then rebuild an improved version |
| **Product validation** | Phase 1.5 checks magic moment, first experience, return loop before coding starts |
| **Remote ML training** | Run LoRA/Whisper fine-tuning on a dedicated GPU machine via SSH |

## Architecture Overview

```
PROMPT.md (your intent)
     |
     v
Phase 0: Intake ──────────────────── 10 clarifying questions
     |
     v
Phase 1: Specs ────────────────────── 9 documents in docs/
     |                                  PRODUCT_BRIEF, ARCHITECTURE,
     |                                  DATA_MODEL, API_CONTRACTS,
     v                                  USER_FLOWS, SPRINT_PLAN, ...
Phase 1.5: Product Validation ─────── Magic moment? First experience?
     |
     v
Phase 2: Scaffold ─────────────────── Buildable project with stubs
     |        \
     |         ScrumMaster agent ───── Background: monitors, unblocks, decides
     v
Phase 2.5: Tests ──────────────────── All tests from acceptance criteria
     |
     v
Phase 3: Sprints ──────────────────── Parallel agents in worktrees
     |    (loops)                       Self-healing on failure
     v
Phase 4: QA ───────────────────────── Technical + product-lens review
     |
     v
STATUS.md (GREEN / YELLOW / RED)
```

## How Agents Coordinate

- **Contracts first**: `API_CONTRACTS.md` is the handshake between backend and frontend
- **Worktree isolation**: Each agent works in its own git worktree
- **Claim before touching**: Agents declare file ownership before starting
- **Source-of-truth hierarchy**: PROMPT.md > guardrails > specs > code
- **ScrumMaster decides**: Any conflict that doesn't change product direction

## Build Phases

### Phase 0 — Intake

The only phase requiring human input. Reads PROMPT.md and asks up to 10 clarifying
questions, prioritized: user/product questions first, technical questions last.

For redo mode, three parallel agents audit the original project (architecture, UX,
tests) before generating questions.

### Phase 1 — Specification

Generates 9 documents in `docs/` before any code is written:

| Document | Purpose |
|----------|---------|
| `PRODUCT_BRIEF.md` | Problem, users, flows, success criteria, scope |
| `ARCHITECTURE.md` | System diagram (Mermaid), tech stack, data flow |
| `DATA_MODEL.md` | Entities, relationships (Mermaid ER), constraints |
| `API_CONTRACTS.md` | Every endpoint with TypeScript interfaces |
| `USER_FLOWS.md` | Step-by-step flows with WHEN-THEN-SHALL criteria |
| `SPRINT_PLAN.md` | Sprint breakdown with dependencies |
| `AGENT_ROLES.md` | Team composition and file ownership |
| `GUARDRAILS.md` | Project-specific rules |
| `TEST_STRATEGY.md` | Test plan and coverage strategy |

### Phase 1.5 — Product Validation

Catches misalignment before coding:
- Does Sprint 1 deliver visible user value or just backend plumbing?
- How many steps to first value? (Target: under 3 interactions)
- Is the return/retention loop built into the architecture?
- Are sprints ordered by user value, not technical convenience?

### Phase 2 — Scaffold

Creates a buildable project: typed interfaces from contracts, database schema from
data model, stub endpoints returning contract-shaped responses, test infrastructure.
The ScrumMaster background agent spawns here.

### Phase 2.5 — Test Generation

Every WHEN-THEN-SHALL acceptance criterion becomes a test, marked as **skipped** and
tagged by sprint. The suite passes (all skipped). Sprint execution un-skips tests
and implements until they pass.

### Phase 3 — Sprint Execution

For each sprint:
1. Un-skip this sprint's tests
2. Spawn parallel agents in isolated worktrees
3. Integrate and merge
4. Self-healing loop on failures (max 3 attempts)
5. Sprint review (technical + user-outcome checks)
6. Repeat until all sprints complete

### Phase 4 — QA

Technical QA (tests, contracts, security, code quality, edge cases) plus a
product-lens review: walk through as a new user, verify success criteria can be
demonstrated, test the return loop, apply the "would I use this?" test.

Outputs `docs/STATUS.md` with overall GREEN / YELLOW / RED status.

## Agent Roles

| Role | Mission |
|------|---------|
| **ScrumMaster** | Background agent: unblocks, decides, keeps work moving |
| **Product** | Ensures product meets user objectives, not just technical requirements |
| **Architect** | System boundaries, tech stack, data flow, contracts |
| **Backend** | API endpoints, server logic, database operations |
| **Frontend** | UI components, user flows, client-side logic |
| **Data** | Database schema, migrations, seed data |
| **Test** | Tests across all layers |
| **AI/ML** | LLM calls, embeddings, classifiers (optional) |
| **DevOps** | CI/CD, deployment, environment (optional) |
| **Review** | Post-sprint quality and spec-drift review |

Not every project uses all roles — the orchestrator activates what's needed.

## Redo Mode

`ccn --redo` rebuilds an existing project. Same product, better execution.

1. **Audit** — Three parallel agents analyze architecture, UX, and test quality
2. **Analysis** — `docs/REDO_ANALYSIS.md`: what works, what's broken, reuse recommendation
3. **PROMPT.md** — Generated for the improved version
4. **Questions** — Direction confirmation, quality bar, reuse decisions
5. **Build** — All phases run identically to a new project

The agent team decides: start fresh, selectively reuse, or heavily fork — and
documents the rationale in `docs/DECISION_LOG.md`.

## Project Structure

```
agentic-sprint-kit/
  CLAUDE.md                  # Orchestration (modes, phases, rules)
  PROMPT.md                  # Project description template (10 sections)
  BEST_PRACTICES.md          # Research-backed patterns
  VERSION                    # Kit version (1.0.0)

  agent_docs/                # Agent reference (loaded on demand)
    agent-roles.md           # 10 roles with missions and boundaries
    guardrails.md            # Hard rules for all agents
    coordination.md          # Parallelization, worktrees, self-healing
    source-of-truth.md       # Conflict resolution hierarchy

  docs/                      # Templates (populated during build)
    DECISION_LOG.md          # Agent decisions with rationale
    OPEN_QUESTIONS.md        # Flagged ambiguity (SM resolves)
    STATUS.md                # Final QA report

  .claude/
    settings.json            # Quality gate hooks (auto-format)
    skills/                  # 11 skills
      kit-intake/            # Phase 0: clarifying questions
      kit-redo-intake/       # Phase 0 (redo): audit + rebuild
      kit-spec/              # Phase 1: generate 9 spec documents
      kit-validate/          # Phase 1.5: product validation
      kit-scaffold/          # Phase 2: project skeleton
      kit-tests/             # Phase 2.5: generate all tests
      kit-sprint/            # Phase 3: parallel sprint execution
      kit-qa/                # Phase 4: QA + STATUS.md
      kit-sm/                # ScrumMaster background agent
      kit-status/            # Check progress anytime
      remote-trainer/        # ML training on remote GPU

  setup.sh                   # Mac/Linux installer
  setup.ps1                  # Windows installer
  bootstrap.sh               # Manual bootstrapper
```

## Customization

| What | Where |
|------|-------|
| Tech stack | PROMPT.md section 10 (or leave blank for auto-selection) |
| Agent rules | `agent_docs/guardrails.md` (defaults) + `docs/GUARDRAILS.md` (project-specific) |
| Agent roles | `agent_docs/agent-roles.md` — add, remove, customize |
| Quality hooks | `.claude/settings.json` — auto-format, lint gates, spec protection |
| Phase workflows | `.claude/skills/*/SKILL.md` — customize any phase |
| Coordination | `agent_docs/coordination.md` — parallelization, team size, self-healing |

## Design Principles

- **Product-first**: PROMPT.md asks about user pain and magic moment before tech stack
- **Spec-driven**: Specs before code. Code implements specs, never the reverse
- **Progressive disclosure**: Lean CLAUDE.md (~97 lines) routes to detailed docs on demand
- **Autonomous after intake**: Phases chain, self-healing loops fix failures, SM resolves blockers
- **Contract-driven parallelism**: Backend and frontend implement against shared typed interfaces
- **Deterministic quality gates**: Hooks enforce formatting and protection regardless of LLM decisions

## CLI Reference

```
ccn                   Create a new project
ccn --redo [path]     Rebuild an existing project
ccn --help | -h       Full man page (phases, skills, roles, files, examples)
ccn --version | -v    Show installed version
```

## Full Documentation

The complete reference (1,015 lines) is in **[agentic-sprint-kit/README.md](./agentic-sprint-kit/README.md)**, covering:

- Installation and setup (Mac, Linux, Windows)
- All 8 build phases with detailed descriptions
- PROMPT.md reference (all 10 sections with examples)
- Agent coordination, source-of-truth hierarchy, guardrails
- Redo mode workflow and reuse strategies
- Spec document relationships and acceptance criteria format
- Quality gates, hooks, and drift detection
- Self-healing build loops
- Remote ML trainer (VRAM budget, workflow templates)
- Troubleshooting

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI
- Git
- Optional: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` for parallel agents
- Optional: SSH access to GPU machine for `/remote-trainer`

## License

MIT

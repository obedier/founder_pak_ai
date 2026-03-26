# Agentic Sprint Kit

**Autonomous multi-agent software development for Claude Code.**

Describe what you want in one sentence, answer up to 10 questions, and the system
builds the entire product — specs, code, tests, and QA — without further human input.

## Origin

This project started as the development workflow for [AiPay Home](./ORIGINAL_PROMPT.md),
an agentic shopping assistant. The prompt asked: *"Design a workflow where multiple
coding agents can work effectively in parallel with minimal confusion, strong context
sharing, and clean handoffs."*

The workflow that emerged — agent roles, source-of-truth hierarchies, spec-first
development, contract-driven parallelism, self-healing build loops — turned out to
be general-purpose. So we extracted it into a reusable kit that works for **any**
software project.

The AiPay founder pack documents (`product-overview.md`, `system-architecture.md`,
etc.) remain in this repo as the original context that shaped the kit's design.

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
    settings.json            # Quality gate hooks
    skills/                  # 11 phase skills
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

## Full Documentation

The complete reference (1,015 lines) lives in **[agentic-sprint-kit/README.md](./agentic-sprint-kit/README.md)** and covers:

- Installation and setup (Mac, Linux, Windows)
- Usage (`ccn`, `ccn --redo`, manual setup)
- All 8 build phases with detailed descriptions
- Agent roles, ScrumMaster authority, coordination patterns
- Source-of-truth hierarchy and guardrails
- PROMPT.md reference (all 10 sections with examples)
- Redo mode workflow and reuse strategies
- Spec documents and their relationships
- Quality gates, hooks, and drift detection
- Self-healing build loops
- Remote ML trainer (VRAM budget, workflow templates)
- Customization guide (stack, roles, hooks, phases)
- Design principles
- CLI reference (`ccn --help`)
- Troubleshooting

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI
- Git
- Optional: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` for parallel agents
- Optional: SSH access to GPU machine for `/remote-trainer`

## Context Documents

These documents are the original AiPay Home founder pack that inspired the kit's design:

| Document | What It Is |
|----------|-----------|
| [ORIGINAL_PROMPT.md](./ORIGINAL_PROMPT.md) | The prompt that started it all |
| [FounderPackage.md](./FounderPackage.md) | PRFAQ and founder package |
| [product-overview.md](./product-overview.md) | Product thesis and core promise |
| [system-architecture.md](./system-architecture.md) | System design |
| [data-model.yaml](./data-model.yaml) | Entity definitions |
| [user-flows.md.md](./user-flows.md.md) | User journeys |
| [mvp-sprint-plan.md](./mvp-sprint-plan.md) | Sprint breakdown |
| [trust-and-policy-engine.md](./trust-and-policy-engine.md) | Trust model design |
| [growth-and-launch.md.md](./growth-and-launch.md.md) | Go-to-market |
| [PRD](./PRD) | Product requirements |

## License

MIT

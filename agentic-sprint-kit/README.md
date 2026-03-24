# Agentic Sprint Kit

Drop-in template for building software autonomously with AI agents.
Optimized for meeting user/business objectives, not just writing code.

## What This Is

A folder you copy into any new project. Fill in `PROMPT.md` with what you want
the USER to experience, run `claude`, answer up to 10 questions, and the system
autonomously builds the entire product — from specs through tested code — with
a product validation step that ensures the result solves the actual problem.

## Quick Start

```bash
# Option A: Use ccn (creates project, copies kit, launches Claude)
ccn
# Enter a project name, then describe what you want to build in one sentence

# Option B: Manual setup
cp -r agentic-sprint-kit/ my-new-project/
cd my-new-project && git init
# Edit PROMPT.md, then run: claude
```

## What's In The Box

```
PROMPT.md                      # You fill this in (user objectives first, tech last)
CLAUDE.md                      # Lean orchestration doc (55 lines)
BEST_PRACTICES.md              # Research-backed patterns and rationale
agent_docs/                    # Agent reference docs (progressive disclosure)
  agent-roles.md               # 9 roles including Product Agent
  guardrails.md                # Hard rules for all agents
  coordination.md              # Parallelization, worktrees, self-healing
  source-of-truth.md           # Priority hierarchy for conflicts
docs/                          # Spec templates (populated in Phase 1)
.claude/
  settings.json                # Quality gate hooks (auto-format, file protection)
  skills/                      # 8 phase skills (slash commands)
    kit-intake/                # Phase 0: clarifying questions
    kit-spec/                  # Phase 1: generate specs
    kit-validate/              # Phase 1.5: product validation
    kit-scaffold/              # Phase 2: project skeleton
    kit-tests/                 # Phase 2.5: generate all tests
    kit-sprint/                # Phase 3: parallel sprint execution
    kit-qa/                    # Phase 4: end-to-end QA + product review
    kit-status/                # Check project status anytime
```

## Phases (auto-chain after intake)

| Phase | Skill | What Happens |
|-------|-------|-------------|
| 0 | `/kit-intake` | Read PROMPT.md, ask up to 10 questions (only human pause) |
| 1 | `/kit-spec` | Generate all specs: architecture, data model, contracts, flows |
| 1.5 | `/kit-validate` | **Product validation**: magic moment, first experience, sprint priority |
| 2 | `/kit-scaffold` | Project skeleton with typed contracts, stubs, schema |
| 2.5 | `/kit-tests` | Generate ALL tests from WHEN-THEN-SHALL acceptance criteria |
| 3 | `/kit-sprint` | Execute sprints with parallel agents (repeats until done) |
| 4 | `/kit-qa` | Technical QA + product-lens review + STATUS.md |

After you answer the intake questions, **all remaining phases run automatically**.

## What Makes This Different

### Product-first, not code-first
- PROMPT.md asks about the user's pain, the magic moment, and the return loop
  BEFORE asking about tech stack
- Phase 1.5 validates that specs serve user objectives before any code is written
- Sprint review checks "can a user complete this flow?" not just "do tests pass?"
- QA includes a product-lens review: "would the described user actually use this?"

### Fully autonomous after 10 questions
- The only human interaction is answering intake questions
- Phases chain automatically — no manual `/kit-next` invocations
- Self-healing build loops fix test failures (max 3 attempts before flagging)
- Ambiguity gets flagged in OPEN_QUESTIONS.md, not guessed at

### Spec-driven with drift detection
- Specs are written before code; code implements specs, never the reverse
- WHEN-THEN-SHALL acceptance criteria map directly to auto-generated tests
- Post-sprint drift detection catches contract divergence
- Product Agent validates user-outcome alignment, not just technical correctness

## Key Design Decisions

- **Progressive disclosure**: CLAUDE.md is 55 lines. Details live in `agent_docs/`
  and `.claude/skills/`, loaded only when needed (under 80-line threshold).
- **Deterministic quality gates**: Auto-formatting and file protection via Claude Code
  hooks — enforced regardless of what the LLM decides.
- **Worktree isolation**: Each agent works in its own git worktree. No shared file edits.
- **Contract-driven parallelism**: Backend and frontend implement against the same
  typed API contracts. No direct negotiation.

## Customization

- **Tech stack**: PROMPT.md section 10, or leave blank for auto-selection
- **Guardrails**: `agent_docs/guardrails.md` (defaults) + `docs/GUARDRAILS.md` (project-specific)
- **Agent roles**: `agent_docs/agent-roles.md` — add/remove/customize
- **Hooks**: `.claude/settings.json` — add project-specific quality gates
- **Skills**: `.claude/skills/*/SKILL.md` — customize any phase workflow

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI installed
- Git initialized in the project directory
- For parallel agents: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (optional)

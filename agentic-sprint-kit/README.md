# Agentic Sprint Kit

Autonomous multi-agent software development. Describe what you want in one sentence,
answer up to 10 questions, and the system builds the entire product — specs, code,
tests, and QA — without further human input.

**Version**: 1.0.0

---

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
  - [Create a New Project](#create-a-new-project)
  - [Rebuild an Existing Project](#rebuild-an-existing-project-redo-mode)
  - [Manual Setup](#manual-setup-without-ccn)
  - [Check Project Status](#check-project-status)
- [How It Works](#how-it-works)
  - [Build Phases](#build-phases)
  - [Phase 0 — Intake](#phase-0--intake)
  - [Phase 1 — Specification](#phase-1--specification)
  - [Phase 1.5 — Product Validation](#phase-15--product-validation)
  - [Phase 2 — Scaffold](#phase-2--scaffold)
  - [Phase 2.5 — Test Generation](#phase-25--test-generation)
  - [Phase 3 — Sprint Execution](#phase-3--sprint-execution)
  - [Phase 4 — QA](#phase-4--qa)
- [Architecture](#architecture)
  - [Agent Roles](#agent-roles)
  - [ScrumMaster Agent](#scrummaster-agent)
  - [Agent Coordination](#agent-coordination)
  - [Source of Truth Hierarchy](#source-of-truth-hierarchy)
  - [Guardrails](#guardrails)
  - [Self-Healing Build Loops](#self-healing-build-loops)
- [PROMPT.md Reference](#promptmd-reference)
- [Redo Mode](#redo-mode)
- [Spec Documents](#spec-documents)
- [Quality Gates & Hooks](#quality-gates--hooks)
- [Skills Reference](#skills-reference)
- [Remote Trainer Skill](#remote-trainer-skill)
- [Project Structure](#project-structure)
- [Customization](#customization)
- [Design Principles](#design-principles)
- [CLI Reference](#cli-reference)
- [Requirements](#requirements)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
# Install (one-time)
git clone https://github.com/obedier/founder_pak_ai.git
cd founder_pak_ai/agentic-sprint-kit
./setup.sh            # Mac/Linux
# .\setup.ps1         # Windows PowerShell

# Restart your terminal, then:
ccn
# Enter a project name, describe what you want, answer questions, watch it build.
```

---

## Installation

### Mac / Linux

```bash
git clone https://github.com/obedier/founder_pak_ai.git
cd founder_pak_ai/agentic-sprint-kit
./setup.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/obedier/founder_pak_ai.git
cd founder_pak_ai\agentic-sprint-kit
.\setup.ps1
```

### What the installer does

1. Copies the kit to `~/.agentic-sprint-kit/` (global install location)
2. Adds the `ccn` shell function to your RC file (`~/.zshrc`, `~/.bashrc`, or `$PROFILE`)
3. Is idempotent — safe to re-run to update the installed copy

After installation, restart your terminal or run `source ~/.zshrc` (Mac/Linux).

### Prerequisites

| Requirement | Notes |
|-------------|-------|
| [Claude Code CLI](https://claude.com/claude-code) | Core dependency — the AI engine |
| Git | Version control |
| Node.js / Python | For auto-formatting hooks (optional) |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` | Enables parallel agent teams (optional, improves speed) |

---

## Usage

### Create a new project

```bash
ccn
```

What happens:

1. Prompts for a project name (lowercase, dashes OK)
2. Creates `./<project-name>/` with the full kit
3. Initializes git
4. Launches Claude Code in auto-mode
5. Asks you to describe what you want in **one sentence**
6. Expands your sentence into a complete `PROMPT.md` (10 sections)
7. Asks up to **10 clarifying questions** (the only human interaction)
8. Builds the entire project autonomously:
   - Generates specs (architecture, data model, contracts, flows)
   - Validates product alignment (magic moment, first experience)
   - Scaffolds the project (types, stubs, schema)
   - Generates all tests from acceptance criteria
   - Executes sprints with parallel agents
   - Runs end-to-end QA with product-lens review

### Rebuild an existing project (redo mode)

```bash
# From inside the project
cd ~/projects/my-app
ccn --redo

# Or from anywhere
ccn --redo ~/projects/my-app
```

Creates `redo_my-app/` as a sibling directory. See [Redo Mode](#redo-mode) for details.

### Manual setup (without `ccn`)

```bash
cp -r ~/.agentic-sprint-kit/ my-new-project/
cd my-new-project && git init
# Edit PROMPT.md with your project description
claude
```

### Check project status

During or after a build, run `/kit-status` inside Claude Code to see:
- Current phase and sprint progress
- Test results (passing, failing, skipped)
- Open questions and recent decisions

---

## How It Works

### Build Phases

After you answer the intake questions, **all remaining phases chain automatically** with zero human intervention.

```
Phase 0        Phase 1       Phase 1.5       Phase 2        Phase 2.5
Intake    -->  Specs    -->  Validation  --> Scaffold  -->  Tests
(human)        (docs/)       (product)       (code)         (test files)
                                                |
                                                v
                                          ScrumMaster agent
                                          spawns (background)
                                                |
                                                v
                                           Phase 3          Phase 4
                                           Sprints    -->   QA
                                           (loops)          (STATUS.md)
```

| Phase | Skill | What Happens | Output |
|-------|-------|-------------|--------|
| 0 | `/kit-intake` | Read PROMPT.md, ask up to 10 questions | Clarified requirements |
| 0 (redo) | `/kit-redo-intake` | Audit existing project, generate improved PROMPT.md | REDO_ANALYSIS.md + PROMPT.md |
| 1 | `/kit-spec` | Generate all specification documents | 9 docs in `docs/` |
| 1.5 | `/kit-validate` | Validate specs serve user objectives | Validation report |
| 2 | `/kit-scaffold` | Project skeleton with typed contracts | Buildable project |
| 2.5 | `/kit-tests` | Generate ALL tests from acceptance criteria | Test files (skipped) |
| 3 | `/kit-sprint` | Execute sprints with parallel agents | Working features |
| 4 | `/kit-qa` | End-to-end QA + product review | STATUS.md |

---

### Phase 0 — Intake

**Skill**: `/kit-intake` (new projects) or `/kit-redo-intake` (rebuilds)

The only phase requiring human input. The system reads `PROMPT.md` and identifies gaps using a priority system:

**Priority 1 — User & Product** (asked first):
- Target user specificity — who exactly is this for?
- Magic moment concreteness — what happens in the first 60 seconds?
- Measurable success criteria — how do we know it works?
- First flow clarity — what does the user do first?
- What alternative exists today?
- What triggers churn?
- How clear is the return loop?

**Priority 2 — Scope & Constraints**:
- Contradictory requirements
- Scope boundaries (what's explicitly OUT)
- Missing non-negotiables
- Privacy / security / compliance considerations

**Priority 3 — Technical** (asked last):
- Auth and permission model
- Integration points with external services
- Data persistence requirements
- Scale expectations

Questions are numbered, each with a brief note on why it matters. After you answer, all remaining phases run without stopping.

---

### Phase 1 — Specification

**Skill**: `/kit-spec`

Generates **9 specification documents** in `docs/` — no application code is written in this phase.

| Document | What It Contains |
|----------|-----------------|
| `PRODUCT_BRIEF.md` | Problem statement, target users, core flows, success criteria, scope boundaries |
| `ARCHITECTURE.md` | System diagram (Mermaid), service boundaries, tech stack with rationale, data flow, integration points |
| `DATA_MODEL.md` | Entities with fields and types, relationships (Mermaid ER diagram), indexes, constraints |
| `API_CONTRACTS.md` | Every endpoint: method, path, TypeScript request/response interfaces, error responses, auth requirements |
| `USER_FLOWS.md` | Step-by-step flows with screens, user actions, system behavior, error states, **WHEN-THEN-SHALL** acceptance criteria per step |
| `SPRINT_PLAN.md` | Sprint 0 (foundation) + Sprint 1-N ordered by dependency, with goals, stories, deliverables, parallelization notes |
| `AGENT_ROLES.md` | Which agents this project needs, their missions, owned files, sprint assignments |
| `GUARDRAILS.md` | Default rules + project-specific rules |
| `TEST_STRATEGY.md` | Unit/integration/e2e scope, acceptance criteria mapping, test data strategy |

Phase completes with a summary: entity count, endpoint count, sprint count, flow count, and team size.

---

### Phase 1.5 — Product Validation

**Skill**: `/kit-validate`

A dedicated product validation step that catches misalignment **before any code is written**. Runs 6 checks:

1. **Magic Moment Audit** — Does the first user flow deliver the magic moment from PROMPT.md? Does Sprint 1 deliver visible user value or just backend plumbing?

2. **Success Criteria Traceability** — For each success criterion in PROMPT.md, is there a user flow exercising it? At least one test? Can it be demoed?

3. **First Experience Design** — How many steps to value? Target: core value in under 3 interactions. Unnecessary friction identified and cut.

4. **Return Loop Validation** — Is the retention mechanism built into the architecture? Does the data model support habit loops? Or is it build-and-forget?

5. **Sprint Priority Check** — Sprints ordered by user value, not technical convenience? Each sprint delivers visible user value?

6. **Competitive Sanity Check** — If competitors are listed, is the differentiation visible in the first flow or buried?

Validation findings are prepended to `docs/PRODUCT_BRIEF.md`. Specs are fixed before proceeding.

---

### Phase 2 — Scaffold

**Skill**: `/kit-scaffold`

Creates a **buildable project skeleton** where every endpoint returns typed stubs. After this phase, the project compiles, type-checks, and all stubs respond correctly.

What gets created:

- **Project structure** per ARCHITECTURE.md (`src/`, `tests/unit/`, `tests/integration/`, `tests/e2e/`, `scripts/`)
- **Package configuration** (package.json / pyproject.toml / go.mod) with core dependencies
- **Shared types** from API_CONTRACTS.md — typed interfaces for all request/response bodies, entities, enums, error shapes
- **Database schema** from DATA_MODEL.md — migration files for all entities, seed script with test data
- **API stubs** — every endpoint returns hardcoded responses matching contract shapes with correct HTTP status codes
- **Test scaffolding** — test runner configured, one example test per category, runner verified

The ScrumMaster background agent also spawns at the start of this phase.

---

### Phase 2.5 — Test Generation

**Skill**: `/kit-tests`

Generates **all tests before implementation** using spec-driven TDD. Tests are derived directly from WHEN-THEN-SHALL acceptance criteria in `docs/USER_FLOWS.md`.

How it works:

1. Every WHEN-THEN-SHALL block in USER_FLOWS.md becomes a test
2. Tests are categorized: API behavior → integration, UI flow → e2e, business logic → unit, edge cases → unit/integration
3. Each test sets up the WHEN condition and asserts THEN/SHALL expectations
4. **All tests are marked SKIPPED** with a comment noting which sprint should un-skip them
5. Contract compliance tests are generated for every endpoint (response shape, error shape, auth)
6. Tests are tagged by sprint (`// Sprint 1: ...`)

The test suite **passes** at this point because all real tests are skipped. This gives agents a clear target: un-skip a sprint's tests, then implement until they pass.

---

### Phase 3 — Sprint Execution

**Skill**: `/kit-sprint` (loops until all sprints complete)

Each sprint follows this cycle:

```
Read SPRINT_PLAN.md
  --> Un-skip this sprint's tests
    --> Decompose into parallel tasks
      --> Spawn agents in worktrees
        --> Parallel execution
          --> Integration (merge all)
            --> Self-healing loop (if tests fail)
              --> Sprint review
                --> Next sprint (or Phase 4)
```

**Agent spawning**: Each task gets an agent with:
- Role and mission
- Relevant specs only (not all docs)
- Contracts and types to implement against
- Acceptance criteria and tests to pass
- Owned files (no overlap between agents)
- Worktree isolation

**Parallel groups**:
- **Group A** (parallel): Backend agent + Frontend agent + Test agent
- **Group B** (sequential after A): Integration testing + Review

**Sprint review** checks both technical and user-outcome criteria:
- Technical: deliverables exist, tests pass, no guardrail violations, contracts match, no extra endpoints, no TODOs
- User-outcome: can user complete flows end-to-end? visible value delivered? matches magic moment? unnecessary friction?

Each completed sprint is tagged `sprint-N-complete` in git.

---

### Phase 4 — QA

**Skill**: `/kit-qa`

Final verification with both technical and product-lens review.

**Technical QA**:
- Full test suite results (total, passed, failed, skipped)
- Walk through every WHEN-THEN-SHALL criterion (PASS / FAIL / PARTIAL)
- Contract compliance for every endpoint
- Security check (hardcoded secrets, SQL injection, XSS, missing validation, overly permissive CORS)
- Code readability audit (naming, dead code, complexity, consistency)
- Edge case review (empty/invalid input, service failures, concurrency, scale)

**Product-Lens Review**:
- **First experience**: Walk through as a new user, count steps before value, does the magic moment happen?
- **Success criteria**: For each criterion in PROMPT.md, mark DEMONSTRATED / PARTIAL / NOT MET
- **User flows**: Run each flow end-to-end as a real user, note breaks, confusion, disappointments
- **Return/retention**: Is the habit loop functional? Would a user come back?
- **"Would I use this?"** test: If you were the target user, does this solve your pain?

**Output**: `docs/STATUS.md` with overall status (GREEN / YELLOW / RED), completed sprints, what works, objectives met, first experience analysis, return mechanism status, biggest gap, known issues, and recommended next steps.

---

## Architecture

### Agent Roles

The kit defines 10 agent roles. Not every project uses all of them — the orchestrator activates roles based on project scope.

| Role | Mission | Outputs |
|------|---------|---------|
| **ScrumMaster** | Keep agents productive, resolve blockers, make decisions | DECISION_LOG.md entries, OPEN_QUESTIONS.md resolutions |
| **Product Agent** | Ensure product meets user objectives, not just technical requirements | Validation report, user-lens reviews |
| **Architect Agent** | System boundaries, tech stack, data flow, contracts | ARCHITECTURE.md, DATA_MODEL.md, API_CONTRACTS.md |
| **Backend Agent** | API endpoints, server logic, database operations | Route handlers, services, data access |
| **Frontend Agent** | UI components, user flows, client-side logic | Components, pages, client-side state |
| **Data Agent** | Database schema, migrations, seed data | Migration files, seed scripts |
| **Test Agent** | Write and maintain tests across all layers | Test files across unit/integration/e2e |
| **AI/ML Agent** | LLM calls, embeddings, classifiers (optional) | AI service interfaces, prompts |
| **DevOps Agent** | CI/CD, deployment, environment setup (optional) | Pipeline config, deploy scripts |
| **Review Agent** | Post-sprint quality and spec-drift review (read-only) | Review findings, drift reports |

---

### ScrumMaster Agent

The ScrumMaster (SM) is a **background agent** that runs from Phase 2 through Phase 4 completion. It has full project context and **authority to make any decision except changing product direction**.

**What the SM monitors continuously**:

1. **OPEN_QUESTIONS.md** — Resolves questions agents flagged instead of guessing. Biases toward action.
2. **Stalled work** — Detects lack of git progress, diagnoses root cause, fixes code, restructures tasks.
3. **Scope creep** — Compares work against PROMPT.md, cuts features not in spec, simplifies over-engineering.
4. **Conflicting work** — Detects overlapping file edits, reassigns ownership, resolves contradictory architectural choices.
5. **Test health** — Reads failures when self-healing is exhausted (3 attempts), diagnoses root cause, fixes or restructures.
6. **Decision quality** — Reviews DECISION_LOG.md entries for conflicts with PROMPT.md or guardrails.

**Decision-making framework**:
1. Check source-of-truth hierarchy
2. Prefer: faster to magic moment > keeps sprint moving > simpler > easier to change later
3. Always document in DECISION_LOG.md with what, why, and what it unblocks

**SM cannot change**: Product definition (PROMPT.md sections 1-4), non-negotiable requirements, user answers.

**SM escalates to user when**: Decision would change the product/user/success criteria, a non-negotiable can't be met, external dependency needs human action, or 3 approaches have been tried and none work.

---

### Agent Coordination

Agents avoid stepping on each other through several mechanisms:

**Preventing conflicts**:
1. **Contracts first** — `API_CONTRACTS.md` is the handshake. Backend and frontend both implement against it independently.
2. **Worktree isolation** — Each agent works in its own git worktree. No shared file edits during a sprint.
3. **Claim before touching** — Agents declare file/module ownership before starting work.
4. **Merge through orchestrator** — The lead agent handles integration and runs full-suite tests.
5. **Spec > code** — To change a contract, update the spec first, then the code.

**Sharing context**:
- Agents read CLAUDE.md, relevant specs, and guardrails
- Agents do **not** share conversation history
- Orchestrator passes minimal relevant context when spawning
- Agents append to DECISION_LOG.md and OPEN_QUESTIONS.md
- ScrumMaster has full context and monitors everything

**Parallelization rules**:
- **Can run in parallel**: Backend + Frontend, multiple independent features, DevOps + tests
- **Must be sequential**: Specs → Contracts → Schema → Backend services → Integration tests → Core features

---

### Source of Truth Hierarchy

When specs or requirements conflict, this priority order resolves disputes:

| Priority | Document | Role |
|----------|----------|------|
| 1 (highest) | PROMPT.md + clarifying answers | User's intent is supreme |
| 2 | guardrails.md + GUARDRAILS.md | Hard rules that cannot be violated |
| 3 | PRODUCT_BRIEF.md | Synthesized product specification |
| 4 | API_CONTRACTS.md | Typed interfaces between services |
| 5 | DATA_MODEL.md | Entity definitions and relationships |
| 6 | ARCHITECTURE.md | System design decisions |
| 7 | SPRINT_PLAN.md | Execution plan |
| 8 (lowest) | Code | Implementation — change code to match specs, not the reverse |

**Key rules**:
- Code doesn't match contract? Change the code, not the contract.
- Contract needs changing? Update the spec first, then notify dependent agents.
- Agents disagree? SM decides using the hierarchy.
- SM unsure? Escalate to user (only for direction-level decisions).

---

### Guardrails

Default rules that apply to **all agents** in every project. Project-specific rules are added in `docs/GUARDRAILS.md` during Phase 1.

**Never do**:
- Invent features not in spec
- Skip error handling on external boundaries
- Store secrets in code
- Use `any` types at service boundaries
- Bypass validation or policy checks
- Commit non-type-checking code
- Create files without reason
- Add dependencies without documenting
- Edit the same file as another agent in a sprint
- Change a contract without updating the spec first

**Always do**:
- Match API contract shapes exactly
- Write tests for acceptance criteria
- Log architectural decisions in DECISION_LOG.md
- Flag ambiguity in OPEN_QUESTIONS.md (never guess)
- Use clear, descriptive names
- Keep functions small and focused
- Handle errors at system boundaries
- Make state transitions explicit
- Run tests before marking a task done
- Declare file ownership before starting work

**When to stop and flag** (write to OPEN_QUESTIONS.md):
- Requirements seem contradictory
- Technical choices have major tradeoffs
- Scope expands beyond PROMPT.md
- External dependencies are unavailable
- Security implications arise

---

### Self-Healing Build Loops

When tests fail after a sprint:

1. **Spawn repair agent** with the failure output
2. Agent reads errors, diagnoses root cause, commits a fix
3. Re-run tests
4. **Max 3 attempts** — if still failing, the ScrumMaster takes over
5. SM diagnoses, fixes, or restructures tasks
6. If SM can't resolve, escalates to OPEN_QUESTIONS.md for human attention

This prevents infinite loops while still automating most failure recovery.

---

## PROMPT.md Reference

PROMPT.md is the **most important file** in the kit. It captures what you want the product to do, who it's for, and how success is measured. All specs, code, and tests trace back to this file.

### The 10 Sections

| # | Section | Purpose | Example |
|---|---------|---------|---------|
| 1 | **What are you building?** | 2-5 sentence pitch | "A meal planning app that generates weekly grocery lists based on dietary preferences and budget constraints." |
| 2 | **Who is the user and what's their pain?** | User persona and problem | "Busy parents who spend 2+ hours/week planning meals and still end up with food waste." |
| 3 | **What does the magic moment feel like?** | First 60 seconds of experience | "User enters 3 dietary preferences and budget, sees a beautiful weekly plan with a one-tap grocery list in under 30 seconds." |
| 4 | **What does success look like?** | 3-5 measurable outcomes | "User generates a plan in under 60 seconds. Grocery list matches meals exactly. User comes back next week." |
| 5 | **What are the primary user flows?** | 2-4 step-by-step flows | "Flow 1: Onboarding — set preferences, see first plan. Flow 2: Weekly planning — adjust plan, export list." |
| 6 | **What makes them come back?** | Retention/habit loop | "Weekly push notification on Sunday: 'Your new meal plan is ready.' Previous plans saved for easy repeat." |
| 7 | **What's out of scope for v1?** | Aggressive scope cutting | "No social features, no restaurant integration, no meal prep videos, no multi-household support." |
| 8 | **Non-negotiable requirements** | Hard constraints | "Must work offline. No user data sent to third parties. Must support vegetarian, vegan, gluten-free." |
| 9 | **Existing context** | Links to designs, APIs, etc. | "Competitor: Mealime. Design mockups in /designs/. Use Spoonacular API for recipes." |
| 10 | **Technical preferences** | Stack preferences (optional) | "React Native frontend, Node.js backend, PostgreSQL, deploy to Railway." |

### Tips for writing PROMPT.md

- **Sections 1-4 are sacred** — agents cannot change these. Be specific.
- **Section 7 matters as much as section 5** — aggressive scope cutting prevents feature creep.
- **Leave section 10 blank** if you don't care — the system will choose sensible defaults.
- **User experience over implementation** — describe what the user sees and feels, not how to code it.
- When using `ccn`, you provide a one-sentence description and the system generates the full PROMPT.md for you. You can then refine it during the clarifying questions.

---

## Redo Mode

Redo mode (`ccn --redo`) is for when you have an existing project that needs a **better version** — same product, better execution.

### How it works

```
Original project                Redo project (redo_<name>/)
     |                                    |
     v                                    v
 3 parallel audit agents          REDO_ANALYSIS.md generated
 (architecture, UX, tests)        PROMPT.md generated
     |                                    |
     v                                    v
 Analysis complete               Up to 10 clarifying questions
                                          |
                                          v
                                 Phases 1-4 run normally
                                 (same as new project)
```

### Step by step

1. **Audit** — Three parallel agents analyze the original project:
   - **Architecture & Code Audit**: module structure, tech stack, data model, API surface, code quality, anti-patterns, what's worth preserving
   - **Product & UX Audit**: user flows, first experience, value proposition, UX friction, accessibility, error handling
   - **Test & Quality Audit**: test coverage, hardcoded values, security issues, build/deploy setup, outdated dependencies

2. **Analysis** — `docs/REDO_ANALYSIS.md` is generated with:
   - Original project summary (what, tech stack, LOC, test coverage)
   - What works well (preserve or improve)
   - What's broken or missing
   - What should change and why
   - Reuse recommendation: **start fresh** / **selective reuse** / **heavy fork**

3. **PROMPT.md** — A complete PROMPT.md is generated describing the improved version, informed by the audit

4. **Clarifying questions** — Up to 10 questions focused on:
   - Direction confirmation (keep scope? expand? reduce?)
   - Quality bar (polished production vs. better prototype?)
   - Reuse decisions (agree with the recommendation?)

5. **Build** — All remaining phases (1-4) run identically to a new project

### Redo rules

- **Better, not different** — The goal is an improved version of the same product, not a new product
- **Respect original intent** — The original project's purpose is sacred. Improve execution, not direction
- **Preserve what works** — Don't rebuild working code just because you can. Justify every change
- **Fix root causes** — If the original has problems, fix the architecture, not just symptoms
- **Document the delta** — `docs/REDO_ANALYSIS.md` clearly shows what changed and why

### Reuse strategies

The agent team decides the reuse strategy based on code quality analysis:

| Strategy | When Used |
|----------|-----------|
| **Start fresh** | Original code quality is too low to salvage, or architecture needs fundamental rethinking |
| **Selective reuse** | Some modules are high quality (copy them), others need rewriting |
| **Heavy fork** | Most code is good, needs targeted refactoring and bug fixes |

The decision is documented in `docs/DECISION_LOG.md` with full rationale.

---

## Spec Documents

During Phase 1, nine specification documents are generated in `docs/`. These are the **source of truth** for all implementation.

### Document relationships

```
PROMPT.md (user intent)
    |
    v
PRODUCT_BRIEF.md (synthesized spec)
    |
    +---> ARCHITECTURE.md (system design)
    |         |
    |         +---> DATA_MODEL.md (entities, schema)
    |         |
    |         +---> API_CONTRACTS.md (typed interfaces)
    |
    +---> USER_FLOWS.md (step-by-step with acceptance criteria)
    |         |
    |         +---> TEST_STRATEGY.md (test plan)
    |
    +---> SPRINT_PLAN.md (execution order)
    |
    +---> AGENT_ROLES.md (team composition)
    |
    +---> GUARDRAILS.md (project-specific rules)
```

### Acceptance Criteria Format

All acceptance criteria use the **WHEN-THEN-SHALL** format:

```
WHEN a user submits a valid registration form
THEN the system SHALL create a new user account
AND the system SHALL send a verification email
AND the system SHALL redirect to the welcome page
```

These criteria map directly to auto-generated tests in Phase 2.5. Each test sets up the WHEN condition and asserts the THEN/SHALL expectations.

### Living documents

During sprints, agents may update specs — but only following the rules:
- Update the spec **first**, then the code
- Log changes in DECISION_LOG.md
- Notify dependent agents

---

## Quality Gates & Hooks

The kit uses Claude Code hooks for **deterministic quality enforcement** — rules that apply regardless of what the LLM decides.

### Configured hooks

**PostToolUse** (on Write/Edit):
- Auto-formats TypeScript/JavaScript files with Prettier
- Auto-formats Python files with Black
- Runs silently; continues if formatter is unavailable

### Additional hooks you can add

In `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "your-format-command",
        "description": "Auto-format on save"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "command": "bash -c 'if echo \"$CLAUDE_FILE_PATH\" | grep -qE \"docs/(PRODUCT_BRIEF|ARCHITECTURE|API_CONTRACTS)\\.md$\"; then echo \"BLOCKED: Spec files are frozen after Phase 1.5\" >&2; exit 1; fi'",
        "description": "Protect frozen spec files"
      }
    ]
  }
}
```

### Spec drift detection

After every sprint, the review step checks:
- All endpoints in API_CONTRACTS.md exist in code
- Response shapes match contract interfaces
- All acceptance criteria have corresponding tests
- Entities match DATA_MODEL.md schema
- No features exist that aren't in spec (feature creep)

---

## Skills Reference

Skills are phase-specific instruction files under `.claude/skills/`. The orchestrator reads them sequentially; you don't need to invoke them manually.

### Build Skills (auto-chained)

| Skill | Phase | Description |
|-------|-------|-------------|
| `/kit-intake` | 0 | Read PROMPT.md, identify gaps, ask up to 10 prioritized clarifying questions |
| `/kit-redo-intake` | 0 (redo) | Audit existing project with 3 parallel agents, generate REDO_ANALYSIS.md and improved PROMPT.md |
| `/kit-spec` | 1 | Generate 9 specification documents from PROMPT.md and answers |
| `/kit-validate` | 1.5 | Run 6 product validation checks, fix specs before coding |
| `/kit-scaffold` | 2 | Create buildable project with types, stubs, schema, test infrastructure |
| `/kit-tests` | 2.5 | Generate all tests from WHEN-THEN-SHALL criteria, mark as skipped by sprint |
| `/kit-sprint` | 3 | Execute next sprint: un-skip tests, spawn parallel agents, integrate, self-heal, review |
| `/kit-qa` | 4 | Technical QA + product-lens review, generate STATUS.md |

### Utility Skills

| Skill | Description |
|-------|-------------|
| `/kit-status` | Check project progress anytime (sprints, tests, open questions, recent decisions) |
| `/kit-sm` | ScrumMaster background agent — spawned automatically at Phase 2 |
| `/remote-trainer` | Run ML training jobs on remote GPU via SSH (see below) |

---

## Remote Trainer Skill

The `/remote-trainer` skill lets agents run ML training jobs on a dedicated GPU machine over SSH. Designed for single-GPU fine-tuning.

### Machine specs

| Property | Value |
|----------|-------|
| SSH alias | `ob-trainer` |
| GPU | NVIDIA RTX 4090 (24GB VRAM) |
| CPU | Intel i9-13900KF |
| RAM | 96GB |
| OS | Windows 11 |
| Python | 3.11 (in venv at `C:\trainer\venv`) |

### VRAM budget

| Model Size | Full Fine-Tune | LoRA (16-bit) | QLoRA (4-bit) |
|------------|---------------|---------------|---------------|
| 1-3B | Yes | Yes | Yes |
| 7B | No | Tight (bs=1-2) | Yes (bs=4-8) |
| 13B | No | No | Tight (bs=1-2) |
| 30B+ | No | No | No |

### Quick reference

```bash
# Health check
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 \
  -Command "python -c \"import torch; print(torch.cuda.get_device_name(0))\""'

# Upload dataset
scp -r ./my-data ob-trainer:'C:\trainer\data\my-project'

# Run training
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 \
  -Command "python C:\trainer\scripts\train.py --args"'

# Check logs
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\logs | \
  Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content -Tail 100"'

# Download results
scp -r ob-trainer:'C:\trainer\runs\my-project\checkpoint-best' ./output/
```

### Supported workflows

- **LoRA / QLoRA fine-tuning** (PEFT, 4-bit quantization for 7B+ models)
- **Whisper fine-tuning** (speech recognition)
- **Custom Python training scripts**
- **Dataset and code transfer** (Mac <-> remote)
- **Training monitoring and log reading**
- **Checkpoint and model retrieval**

See `.claude/skills/remote-trainer/SKILL.md` for complete workflow templates, best practices, and troubleshooting.

---

## Project Structure

```
<project-name>/
|
|-- PROMPT.md                          # Your project description (10 sections)
|-- CLAUDE.md                          # Orchestration guide (modes, phases, rules)
|-- BEST_PRACTICES.md                  # Research-backed patterns and rationale
|-- VERSION                            # Kit version number
|
|-- agent_docs/                        # Agent reference docs (loaded on demand)
|   |-- agent-roles.md                 # 10 roles: SM, Product, Architect, Backend, Frontend,
|   |                                  #   Data, Test, AI/ML, DevOps, Review
|   |-- guardrails.md                  # Hard rules for all agents (never do / always do)
|   |-- coordination.md                # Parallelization, worktrees, conflict prevention,
|   |                                  #   self-healing, agent teams config
|   +-- source-of-truth.md             # Priority hierarchy for resolving conflicts
|
|-- docs/                              # Spec templates (populated during build)
|   |-- DECISION_LOG.md                # Agent decisions with date, context, alternatives
|   |-- OPEN_QUESTIONS.md              # Unresolved questions (SM monitors and resolves)
|   |-- STATUS.md                      # Final QA report (GREEN/YELLOW/RED)
|   |                                  # Phase 1 generates:
|   |-- PRODUCT_BRIEF.md               #   Synthesized product spec
|   |-- ARCHITECTURE.md                #   System design + Mermaid diagrams
|   |-- DATA_MODEL.md                  #   Entities, relationships, schema
|   |-- API_CONTRACTS.md               #   Typed endpoint interfaces
|   |-- USER_FLOWS.md                  #   Flows with WHEN-THEN-SHALL criteria
|   |-- SPRINT_PLAN.md                 #   Sprint breakdown with dependencies
|   |-- AGENT_ROLES.md                 #   Project-specific agent assignments
|   |-- GUARDRAILS.md                  #   Project-specific rules
|   +-- TEST_STRATEGY.md              #   Test plan and coverage strategy
|
|-- .claude/
|   |-- settings.json                  # Quality gate hooks (auto-format)
|   +-- skills/                        # Phase skills (instruction files)
|       |-- kit-intake/SKILL.md        # Phase 0: clarifying questions
|       |-- kit-redo-intake/SKILL.md   # Phase 0 (redo): audit + rebuild
|       |-- kit-spec/SKILL.md          # Phase 1: generate specs
|       |-- kit-validate/SKILL.md      # Phase 1.5: product validation
|       |-- kit-scaffold/SKILL.md      # Phase 2: project skeleton
|       |-- kit-tests/SKILL.md         # Phase 2.5: generate tests
|       |-- kit-sprint/SKILL.md        # Phase 3: sprint execution
|       |-- kit-qa/SKILL.md            # Phase 4: QA + STATUS.md
|       |-- kit-sm/SKILL.md            # ScrumMaster background agent
|       |-- kit-status/SKILL.md        # Check progress anytime
|       +-- remote-trainer/SKILL.md    # ML training on remote GPU
|
|-- setup.sh                           # Mac/Linux installer
|-- setup.ps1                          # Windows installer
+-- bootstrap.sh                       # Manual project bootstrapper
```

---

## Customization

### Tech stack

Set in PROMPT.md section 10, or leave blank for auto-selection. The system chooses defaults based on project type:
- Web app: React/Next.js + Node.js + PostgreSQL
- API: Node.js/Express or Python/FastAPI
- ML: Python + PyTorch

### Guardrails

Two levels:
- `agent_docs/guardrails.md` — defaults that apply to all projects
- `docs/GUARDRAILS.md` — project-specific rules generated in Phase 1

Edit `agent_docs/guardrails.md` to change defaults globally.

### Agent roles

Edit `agent_docs/agent-roles.md` to add, remove, or customize roles. The orchestrator activates only the roles each project needs.

### Quality hooks

Edit `.claude/settings.json` to add project-specific hooks:
- **PostToolUse** (Write|Edit): auto-format, lint
- **PreToolUse** (Write): protect spec files, block certain paths
- **WorktreeCreate**: provision per-worktree databases
- **WorktreeRemove**: tear down per-worktree environments

### Phase workflows

Each `.claude/skills/*/SKILL.md` file can be customized to change how a phase works. For example:
- Change the number of clarifying questions (default: 10)
- Add additional spec documents to Phase 1
- Modify sprint review criteria
- Add custom QA checks

### Coordination patterns

Edit `agent_docs/coordination.md` to change:
- Parallelization strategy
- Agent team size (default: 3-5 per sprint)
- Self-healing attempt cap (default: 3)
- Worktree isolation rules

---

## Design Principles

### Product-first, not code-first

PROMPT.md asks about the user's pain, the magic moment, and the return loop **before** asking about tech stack. Phase 1.5 validates that specs serve user objectives before any code is written. Sprint reviews check "can a user complete this flow?" not just "do tests pass?" QA includes a product-lens review: "would the described user actually use this?"

### Spec-driven development

Specifications are written before code. Code implements specs, never the reverse. The WHEN-THEN-SHALL acceptance criteria map directly to auto-generated tests. Post-sprint drift detection catches contract divergence. If code doesn't match a contract, the code changes — not the contract.

### Progressive disclosure

CLAUDE.md is a lean ~97-line routing document. It tells agents **how to find** instructions, not all instructions themselves. Details live in:
- `agent_docs/` — reference docs loaded on demand
- `.claude/skills/` — phase-specific workflows
- `docs/` — spec files generated during build

This prevents instruction cutoff in large contexts.

### Fully autonomous after intake

The only human interaction is answering up to 10 clarifying questions. After that:
- Phases chain automatically
- Self-healing loops fix test failures
- ScrumMaster resolves blockers and open questions
- Ambiguity gets flagged in OPEN_QUESTIONS.md, never guessed at

### Contract-driven parallelism

`API_CONTRACTS.md` is the handshake between backend and frontend. Both implement against the same typed interfaces independently, in parallel, in isolated worktrees. No direct negotiation needed.

### Deterministic quality gates

Claude Code hooks enforce formatting, linting, and file protection regardless of what the LLM decides. This separates "rules the model should follow" from "rules the system enforces."

---

## CLI Reference

```
ccn --help       Full man page
ccn --version    Show installed version
ccn              Create a new project
ccn --redo       Rebuild project in current directory
ccn --redo PATH  Rebuild project at PATH
```

Run `ccn --help` for the complete reference including all phases, skills, agent roles, files, environment variables, and examples.

---

## Requirements

| Requirement | Required | Notes |
|-------------|----------|-------|
| [Claude Code CLI](https://claude.com/claude-code) | Yes | The AI engine that powers everything |
| Git | Yes | Version control, worktree isolation |
| Node.js | Recommended | For Prettier auto-formatting hook |
| Python | Recommended | For Black auto-formatting hook |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` | No | Enables parallel agent teams for faster builds |
| SSH access to GPU machine | No | Only needed for `/remote-trainer` skill |

---

## Troubleshooting

### `ccn: command not found`

Restart your terminal or run `source ~/.zshrc` (Mac) / `source ~/.bashrc` (Linux) / `. $PROFILE` (PowerShell).

### Kit not found at `~/.agentic-sprint-kit`

Re-run the installer:
```bash
cd path/to/founder_pak_ai/agentic-sprint-kit
./setup.sh
```

### Phases stop between steps

Make sure Claude Code is running with `--enable-auto-mode` (the `ccn` command does this automatically). If running manually, launch with:
```bash
claude --enable-auto-mode
```

### Tests fail and self-healing loops exhaust

Check `docs/OPEN_QUESTIONS.md` — the ScrumMaster will have escalated the issue there. Common causes:
- Missing environment variables (check `.env.example`)
- Database not running (check scaffold phase output)
- External API dependency unavailable

### Agents conflict on file edits

This shouldn't happen if coordination.md rules are followed. If it does:
1. Check `docs/AGENT_ROLES.md` for file ownership
2. Ensure agents are using worktree isolation
3. The ScrumMaster should detect and resolve this automatically

### Formatting hooks fail silently

Hooks are configured to continue on failure (`|| true`). If you want strict enforcement:
1. Install Prettier: `npm install -g prettier`
2. Install Black: `pip install black`
3. Or edit `.claude/settings.json` to remove `|| true`

### Updating the kit

Re-run the installer to update the global copy:
```bash
cd path/to/founder_pak_ai/agentic-sprint-kit
./setup.sh
```

Note: This updates `~/.agentic-sprint-kit/` but does **not** update the `ccn` function if it already exists in your shell RC. To update the function, remove the block between `# >>> agentic-sprint-kit ccn >>>` and `# <<< agentic-sprint-kit ccn <<<` in your RC file, then re-run the installer.

---

## License

MIT

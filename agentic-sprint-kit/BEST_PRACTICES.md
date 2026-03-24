# Agentic Sprint Kit — Best Practices

Research-backed patterns for autonomous multi-agent software development.
Updated March 2026.

---

## 1. Progressive Disclosure in CLAUDE.md

**Problem**: Claude starts ignoring instructions in CLAUDE.md files over ~80 lines.
Our original was 278 lines.

**Solution**: CLAUDE.md should be a lean routing document (~60 lines) that tells
Claude *how to find* instructions, not all the instructions themselves.

**Pattern**:
- CLAUDE.md: project identity, phase workflow, where to find details
- `agent_docs/agent-roles.md`: role definitions, boundaries, handoffs
- `agent_docs/guardrails.md`: hard rules, code style
- `agent_docs/coordination.md`: parallelization, isolation, merge strategy
- `agent_docs/source-of-truth.md`: priority hierarchy for conflict resolution
- `.claude/skills/`: phase-specific workflow instructions (invocable as /commands)

**Source**: HumanLayer benchmark, Anthropic best practices, community consensus.

---

## 2. Hooks for Deterministic Quality Gates

**Problem**: LLM instructions can be ignored. Formatting, linting, and test
requirements must be enforced deterministically.

**Solution**: Claude Code hooks fire on lifecycle events regardless of what
the LLM decides to do. Use them for rules that must never be broken.

**Hooks to ship in the kit**:

| Hook | Event | Purpose |
|------|-------|---------|
| Auto-format | `PostToolUse` (Write/Edit) | Run formatter after every file change |
| Lint gate | `PostToolUse` (Write/Edit) | Run linter, surface errors to agent |
| Protect specs | `PreToolUse` (Write/Edit) | Block writes to PROMPT.md and frozen specs |
| Test on complete | `PostToolUse` (Bash matching test/build) | Verify tests pass after runs |

**Configuration levels**:
- `~/.claude/settings.json` — global (user's machine)
- `.claude/settings.json` — project (shipped with kit, committed to git)
- `.claude/settings.local.json` — local overrides (gitignored)

**Source**: Claude Code hooks guide, Pixelmojo CI/CD patterns.

---

## 3. Worktree Isolation for Parallel Agents

**Problem**: Multiple agents editing the same working directory causes conflicts.
Manual branch management is error-prone.

**Solution**: Use Claude Code's built-in `--worktree` flag. Each agent gets an
isolated copy of the repo at `.claude/worktrees/<name>/`.

**Patterns**:
- Spawn agents with `isolation: worktree` in subagent frontmatter
- Use `WorktreeCreate` hooks to provision per-worktree databases and `.env.local`
- Use `WorktreeRemove` hooks to clean up isolated resources
- Auto-cleanup: worktrees with no changes are deleted on session end

**Best practice**: 3-5 agents maximum per sprint. Each agent owns distinct files.
No two agents edit the same file.

**Source**: Claude Code docs, Damian Galarza (database isolation), Rick Hightower.

---

## 4. Test-First from Acceptance Criteria

**Problem**: Traditional TDD (red-green-refactor one test at a time) is inefficient
for AI agents. Agents work better with a batch of tests to satisfy.

**Solution**: Generate ALL tests from acceptance criteria BEFORE implementation.
Agents implement until all tests pass. This is "Spec-Driven TDD."

**Acceptance criteria format — WHEN-THEN-SHALL**:
```
WHEN a user submits a login form with valid credentials
THEN the system SHALL return a 200 response with a session token
AND SHALL set an httpOnly cookie
```

Each criterion maps to one or more test cases. Tests are generated in Phase 2.5
(after scaffold, before sprint execution). Implementation makes tests pass.

**Drift detection**: After each sprint, verify:
- Every endpoint in API_CONTRACTS.md exists in code
- Response shapes match contract types
- All acceptance criteria have passing tests

**Source**: Latent Space (Anita TDD), Augment Code SDD guide, GitHub spec-kit.

---

## 5. Claude Code Skills (Slash Commands)

**Problem**: Workflow files in `.claude/workflows/` are passive — agents must
know to read them. Skills are invocable as `/commands`.

**Solution**: Convert each phase workflow into a Claude Code skill under
`.claude/skills/`. Each skill has frontmatter that controls tool access
and provides a description.

**Skills to ship**:
- `/kit-intake` — Phase 0: read PROMPT.md, ask clarifying questions
- `/kit-spec` — Phase 1: generate all spec documents
- `/kit-scaffold` — Phase 2: create project skeleton with typed stubs
- `/kit-tests` — Phase 2.5: generate all tests from acceptance criteria
- `/kit-sprint` — Phase 3: execute next sprint with parallel agents
- `/kit-qa` — Phase 4: end-to-end QA and status report
- `/kit-status` — Show current project status and sprint progress

**Skill structure**:
```
.claude/skills/
  kit-intake/
    SKILL.md          # Frontmatter + instructions (<500 lines)
  kit-spec/
    SKILL.md
  ...
```

**Source**: AI SDLC Scaffold (GitHub), Anthropic skill authoring best practices.

---

## 6. Agent Teams (vs. Subagents)

**Problem**: Subagents only report results back to the caller. They can't
coordinate with each other or share a task list.

**Solution**: Agent teams (experimental, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`)
enable multiple Claude Code instances that share a task list, claim work
independently, and message each other directly.

**When to use teams vs. subagents**:
- **Subagents**: independent, isolated tasks (research, single-file edits)
- **Agent teams**: collaborative work requiring discussion (debugging with
  competing hypotheses, cross-layer features, parallel code review)

**Best practices**:
- 3-5 teammates per sprint
- 5-6 tasks per teammate
- Each teammate owns distinct files/modules
- Use `TaskCompleted` hooks (exit code 2 = reject) for quality gates
- Start with read-only tasks before parallel implementation

**Source**: Claude Code agent teams docs, Anthropic 2026 trends report.

---

## 7. Environment Isolation with Worktree Hooks

**Problem**: Git worktrees isolate code but not databases, env vars, or
external services. Parallel agents can still collide on shared state.

**Solution**: Use `WorktreeCreate` and `WorktreeRemove` lifecycle hooks to
provision and tear down per-worktree environments.

**Hook template** (WorktreeCreate):
```bash
#!/bin/bash
# Derive unique DB name from branch
DB_NAME="app_$(echo $BRANCH | tr '-' '_')"
createdb "$DB_NAME"
echo "DATABASE_URL=postgres://localhost/$DB_NAME" > .env.local
npm run db:migrate
```

**Hook template** (WorktreeRemove):
```bash
#!/bin/bash
DB_NAME="app_$(echo $BRANCH | tr '-' '_')"
dropdb --if-exists "$DB_NAME"
```

**Source**: Damian Galarza (extending worktrees for database isolation).

---

## 8. Spec Drift Detection

**Problem**: As agents implement features, code can drift from specs.
Contracts say one thing; code does another.

**Solution**: Add a drift detection step to every sprint review.

**What to check**:
- Every route in API_CONTRACTS.md exists as an implemented endpoint
- Response types in code match contract type definitions
- Every acceptance criterion in USER_FLOWS.md has a corresponding test
- Every entity in DATA_MODEL.md has a corresponding schema/migration
- No endpoints exist that aren't in the contract (feature creep)

**When to run**: After every sprint, before marking it complete.
The Review Agent owns this step.

**Source**: Augment Code SDD guide, Martin Fowler (SDD tools analysis).

---

## 9. Auto Mode over Skip Permissions

**Problem**: `--dangerously-skip-permissions` bypasses ALL safety checks.
This is a sledgehammer when you need a scalpel.

**Solution**: `--enable-auto-mode` (March 2026 research preview) lets Claude
autonomously handle permission requests with judgment, rather than
blanket bypass.

**When to use each**:
- `--enable-auto-mode`: sandboxed environments, development machines
- `--dangerously-skip-permissions`: CI/CD pipelines, fully isolated containers
- Neither: production systems, shared infrastructure

**Source**: Claude Code auto mode announcement, StartupHub.

---

## 10. Self-Healing Build Loops

**Problem**: When tests fail after a sprint, manual debugging wastes time
and breaks the autonomous flow.

**Solution**: After test failures, automatically spawn a repair agent that
reads failure logs, diagnoses the issue, and attempts a fix. Cap at
3 attempts before flagging for human attention.

**Pattern (Pipeline Doctor)**:
1. Tests fail after sprint integration
2. Repair agent reads test output and error traces
3. Agent diagnoses: transient vs. permanent failure
4. Agent commits fix to sprint branch
5. Re-run tests
6. If still failing after 3 attempts, add to OPEN_QUESTIONS.md and
   flag in STATUS.md as needing human attention

**Source**: GitHub Agentic Workflows, Nx Cloud, Dagger, Semaphore.

---

## Summary: What We Ship in the Kit

| Improvement | Implementation |
|---|---|
| Progressive disclosure | Lean CLAUDE.md + agent_docs/ reference files |
| Quality gate hooks | .claude/settings.json with PostToolUse/PreToolUse hooks |
| Worktree isolation | Worktree config + WorktreeCreate/Remove hook templates |
| Test-first development | Phase 2.5 skill + WHEN-THEN-SHALL templates |
| Skills (slash commands) | .claude/skills/ with 7 phase skills |
| Agent teams guidance | agent_docs/coordination.md with teams config |
| Environment isolation | Hook templates for per-worktree DB/env provisioning |
| Spec drift detection | Review step in sprint-execution skill |
| Auto mode | Updated ccn function + documentation |
| Self-healing loops | Repair step in sprint-execution skill |

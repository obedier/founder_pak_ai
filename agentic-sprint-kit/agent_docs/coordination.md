# Agent Coordination

## How Agents Avoid Stepping on Each Other

1. **Contracts first**: API_CONTRACTS.md is the handshake. Backend and frontend
   never negotiate directly — both implement against the contract.
2. **Worktree isolation**: Each agent works in its own worktree (`isolation: worktree`).
   No two agents edit the same working directory.
3. **Claim before touching**: Agents declare which files/modules they own for
   the current sprint. No overlapping ownership.
4. **Merge through orchestrator**: The lead agent handles integration, conflict
   resolution, and full-suite test runs.
5. **Spec > code**: If an agent needs to change a contract, it must update
   the spec first and notify dependent agents.

## How Agents Share Context

- All agents read `CLAUDE.md` and relevant spec files from `/docs/`
- All agents read `agent_docs/guardrails.md`
- Agents do NOT share conversation history
- The orchestrator passes only the minimal relevant context when spawning agents
- Agents append to `docs/DECISION_LOG.md` and `docs/OPEN_QUESTIONS.md` as
  shared communication channels
- The **ScrumMaster (SM)** agent runs in the background with full project context.
  When an agent is stuck, it should write to OPEN_QUESTIONS.md. The SM will
  detect the issue, make a decision, write the resolution, and update
  DECISION_LOG.md — keeping the blocked agent moving.

## ScrumMaster Decision Authority

The SM can resolve ANY blocker except changing product direction:
- Architectural decisions (which pattern, which library, which approach)
- Dependency ordering (what to build first when dependencies are unclear)
- Spec ambiguity (what the spec means when it's unclear)
- Test failures (diagnose and fix, or restructure the sprint)
- Agent conflicts (which agent's approach wins)
- Scope questions (is this in or out of MVP? SM decides per PROMPT.md)

The SM CANNOT change:
- What the product is or who it's for (PROMPT.md sections 1-4)
- Non-negotiable requirements (PROMPT.md section 8)
- User answers from the intake phase

## Parallelization Strategy

### Can run in parallel (after contracts exist)
- Backend API implementation + Frontend UI implementation
- Database migrations + Test scaffolding
- Multiple independent features/endpoints
- DevOps/CI setup + Application code

### Must be sequential
- Spec generation -> before any code
- Shared types/contracts -> before backend or frontend
- Database schema -> before backend services
- Backend services -> before integration tests
- Core features -> before features that depend on them

## Agent Teams Configuration

For collaborative work, use Claude Code agent teams:

```
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

- 3-5 teammates per sprint, 5-6 tasks per teammate
- Each teammate owns distinct files/modules — no overlapping edits
- `TaskCompleted` hook with exit code 2 rejects incomplete work
- Start with read-only tasks (review, research) before parallel implementation
- Use adversarial investigation (competing hypotheses) for debugging

## Worktree Environment Isolation

When agents need isolated databases or env vars, use worktree lifecycle hooks:

**WorktreeCreate** — provision per-worktree resources:
```bash
#!/bin/bash
DB_NAME="app_$(echo $BRANCH | tr '-' '_')"
createdb "$DB_NAME" 2>/dev/null
echo "DATABASE_URL=postgres://localhost/$DB_NAME" > .env.local
npm run db:migrate 2>/dev/null
```

**WorktreeRemove** — clean up:
```bash
#!/bin/bash
DB_NAME="app_$(echo $BRANCH | tr '-' '_')"
dropdb --if-exists "$DB_NAME"
```

## Self-Healing Build Loop

When tests fail after sprint integration:
1. Repair agent reads test output and error traces
2. Agent diagnoses: transient vs. permanent failure
3. Agent commits fix to sprint branch
4. Re-run tests
5. Cap at 3 attempts. After that, flag in OPEN_QUESTIONS.md and STATUS.md

---
description: "Phase 3: Execute the next sprint with parallel agents in isolated worktrees"
---

# Kit Sprint (Phase 3)

Execute the next incomplete sprint from docs/SPRINT_PLAN.md.

## Pre-Sprint Checklist
- [ ] Previous sprint complete and merged (or this is Sprint 0)
- [ ] Test suite passes (no failures — skipped tests are fine)
- [ ] Sprint dependencies are met
- [ ] Relevant spec sections are clear

## Steps

### 1. Identify next sprint
Read docs/SPRINT_PLAN.md. Find the first sprint not marked complete.

### 2. Un-skip this sprint's tests
Find all tests tagged for this sprint (e.g., `Sprint 1:` in describe blocks).
Change `.skip` to active (remove `it.skip` → `it`, `describe.skip` → `describe`).
These tests define what this sprint must make pass.

### 3. Task decomposition
Break the sprint into independent, parallelizable tasks. Each task needs:
- Description and acceptance criteria
- Which agent role owns it (read `agent_docs/agent-roles.md`)
- Input specs it depends on
- Output files it will create/modify
- Which tests it should make pass (the un-skipped ones)

### 4. Spawn agents
Read `agent_docs/coordination.md` for isolation and team rules.
For each task, spawn an agent with:
- Role and mission
- ONLY the relevant spec sections (not everything)
- The contracts/types it implements against
- The acceptance criteria and tests it must pass
- The files it owns (no overlap with other agents)
- Instructions to use `isolation: worktree`

### 5. Parallel execution
Group A (parallel): backend + frontend + test agents
Group B (sequential, after A): integration testing + review

### 6. Integration
After agents complete:
1. Merge all worktrees/branches into sprint branch
2. Resolve conflicts (prefer spec-aligned version)
3. Run full test suite

### 7. Self-healing loop (if tests fail)
1. Spawn repair agent with test failure output
2. Agent reads errors, diagnoses, commits fix
3. Re-run tests
4. Max 3 attempts. After that, the SM agent (running in background) will
   detect the stall and intervene — diagnosing the root cause, making
   decisions, and either fixing the issue or restructuring the sprint.
   If the SM cannot resolve it, it escalates to docs/OPEN_QUESTIONS.md
   with what was tried and what decision is needed.

### 8. Sprint review

**Technical checks** (read `agent_docs/guardrails.md`):
- [ ] All sprint deliverables exist
- [ ] All sprint acceptance criteria pass
- [ ] No guardrail violations
- [ ] API responses match contract shapes (drift detection)
- [ ] Every acceptance criterion has a passing test
- [ ] No endpoints exist that aren't in the contract
- [ ] Code is readable, follows project patterns
- [ ] No TODOs or placeholder code

**User-outcome checks** (read PROMPT.md sections 3, 4, 6):
- [ ] Can a user actually complete the sprint's user flows end-to-end?
- [ ] Does the sprint deliver visible value a user would notice?
- [ ] Does the experience match the magic moment described in PROMPT.md?
- [ ] Are there unnecessary friction points (extra clicks, loading, config)?
- [ ] Do success criteria from PROMPT.md section 4 get closer to provable?
- [ ] If this sprint completes a user flow — walk through it as a user would.
      Does it feel right, or just pass tests?

### 9. Sprint completion
- Mark sprint complete in docs/SPRINT_PLAN.md
- Update docs/DECISION_LOG.md
- Resolve any OPEN_QUESTIONS.md items answered during sprint
- Commit and tag: `sprint-N-complete`

## Completion
If more sprints remain, loop back to step 1 and execute the next sprint.
If all sprints are done, proceed to Phase 4 (QA).

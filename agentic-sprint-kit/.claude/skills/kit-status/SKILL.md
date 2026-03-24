---
description: "Show current project status: completed sprints, next steps, open questions"
allowed-tools: ["Read", "Glob", "Grep", "Bash(npm test:*)"]
---

# Kit Status

Show the current state of the project.

## Steps

1. Read docs/SPRINT_PLAN.md — which sprints are complete, which is next
2. Read docs/STATUS.md (if exists) — last QA results
3. Read docs/OPEN_QUESTIONS.md — any unresolved items
4. Read docs/DECISION_LOG.md — recent decisions
5. Count tests: run `npm test -- --passWithNoTests 2>&1 | tail -5` or equivalent
6. Check git log for recent activity

## Output Format

```
## Project Status

**Current phase**: [Phase N — description]
**Sprints**: [X of Y complete]
**Tests**: [N passing, N failing, N pending]
**Open questions**: [N unresolved]

### Completed
- Sprint 0: Foundation [complete]
- Sprint 1: [name] [complete]

### Next Up
- Sprint N: [name] — [brief description]

### Needs Attention
- [Any OPEN_QUESTIONS.md items]
- [Any STATUS.md issues]

### Recent Decisions
- [Last 3 entries from DECISION_LOG.md]
```

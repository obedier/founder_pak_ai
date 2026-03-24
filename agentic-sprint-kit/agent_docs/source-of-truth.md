# Source of Truth Hierarchy

When agents encounter conflicts, this is the priority order:

1. **PROMPT.md + clarifying answers** — the user's intent is supreme
2. **agent_docs/guardrails.md + docs/GUARDRAILS.md** — hard rules
3. **docs/PRODUCT_BRIEF.md** — synthesized product spec
4. **docs/API_CONTRACTS.md** — typed interface contracts
5. **docs/DATA_MODEL.md** — entity definitions
6. **docs/ARCHITECTURE.md** — system design decisions
7. **docs/SPRINT_PLAN.md** — execution plan
8. **Code** — implementation (lowest priority; change code to match specs, never the reverse)

## Conflict Resolution Rules

- If specs conflict with each other: the SM decides and documents in DECISION_LOG.md
- If specs conflict with PROMPT.md: PROMPT.md wins, update the spec
- If code doesn't match contract: change code, not the contract
- If a contract needs changing: update the spec first, notify dependent agents
- If agents disagree: the SM decides based on this hierarchy
- If the SM is unsure: it escalates to the user (direction-level issues only)
- The SM has authority to resolve any conflict that doesn't change product direction

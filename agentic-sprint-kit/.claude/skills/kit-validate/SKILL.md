---
description: "Phase 1.5: Validate that specs actually serve the user's objectives, not just technical requirements"
allowed-tools: ["Read", "Glob", "Grep", "Write", "Edit"]
---

# Kit Validate (Phase 1.5 — Product Validation)

Before writing any code, verify that the specs will produce a product that
meets the user's actual objectives — not just a technically correct system.

Read `agent_docs/agent-roles.md` (Product Agent section) for the full checklist.

## Inputs
- PROMPT.md (especially sections 2, 3, 4, 5, 6)
- All docs/ specs from Phase 1

## Checks

### 1. Magic Moment Audit
Read PROMPT.md section 3 ("What does the magic moment feel like?").
Then read docs/USER_FLOWS.md and docs/SPRINT_PLAN.md.

- Does the FIRST user flow in USER_FLOWS.md deliver this magic moment?
- Does Sprint 1 (the first implementation sprint after foundations) deliver
  something the user can experience and react to?
- Or does Sprint 1 deliver only invisible backend work that no user would notice?

**If Sprint 1 doesn't deliver visible user value**: restructure the sprint plan.
The user should be able to experience the core value proposition by the end of
Sprint 1, even if it's rough. Technical foundations (auth, DB, CI) can be Sprint 0
but user-facing magic cannot wait until Sprint 3+.

### 2. Success Criteria Traceability
Read PROMPT.md section 4 ("What does success look like?").
For each success criterion:

- Is there a user flow in USER_FLOWS.md that exercises this outcome?
- Is there at least one acceptance criterion that would prove this outcome?
- Could you demo this criterion to the user and have them confirm "yes, that's what I meant"?

**If a success criterion has no corresponding flow or test**: add it.

### 3. First Experience Design
The first 60 seconds of a new user's experience determines whether they stay.

- What is the very first screen/output the user sees?
- How many steps before they get value?
- Is there unnecessary friction (signup forms, configuration, loading) before value?
- Could the first experience be shortened?

**Target**: User experiences core value in under 3 interactions. If the current
flow requires more, simplify.

### 4. Return Loop Validation
Read PROMPT.md section 6 ("What makes them come back?").

- Is the return trigger built into the architecture?
- Is there a data model entity that supports the habit loop?
- Is there a notification, reminder, or state change that drives re-engagement?
- Or is this a build-and-forget tool with no retention mechanism?

**If section 6 was filled in but no retention mechanism exists in specs**: flag it.

### 5. Sprint Priority Check
Review docs/SPRINT_PLAN.md against PROMPT.md:

- Are sprints ordered by user value, not technical convenience?
- Does each sprint deliver something a user would notice?
- Is the most important user flow fully functional by the earliest possible sprint?
- Are "nice to have" features correctly pushed to later sprints?

### 6. Competitive Sanity Check
If PROMPT.md section 9 lists competitors or alternatives:

- Does the product offer a clearly better experience for the stated pain?
- Is the differentiation visible in the first user flow, or buried in later features?

## Output
Write a brief product validation report at the top of docs/PRODUCT_BRIEF.md
(prepend, don't replace) with:

```
## Product Validation (Phase 1.5)

**Magic moment**: [1 sentence — what the user feels and when]
**First value in**: [N interactions/screens/steps]
**Sprint delivering first user value**: Sprint [N]
**Success criteria coverage**: [N of M criteria have matching flows and tests]
**Return mechanism**: [present/missing — brief description]
**Issues found**: [list, or "none"]
```

If issues were found, fix the specs (USER_FLOWS.md, SPRINT_PLAN.md, etc.) before proceeding.

## Completion
Proceed to Phase 2 (scaffold).

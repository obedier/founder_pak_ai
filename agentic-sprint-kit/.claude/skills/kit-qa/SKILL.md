---
description: "Phase 4: End-to-end QA verification and final status report"
---

# Kit QA (Phase 4)

Verify the entire product works end-to-end and generate a final status report.

## Steps

### 1. Full test suite
Run all tests: unit, integration, e2e.
Record: total, passed, failed, skipped.

### 2. Acceptance criteria audit
For each user flow in docs/USER_FLOWS.md:
- Walk through every step
- Verify each WHEN-THEN-SHALL criterion
- Mark: PASS / FAIL / PARTIAL

### 3. Contract compliance
For each endpoint in docs/API_CONTRACTS.md:
- Verify response shape matches contract
- Verify error responses match contract
- Verify auth requirements are enforced

### 4. Security check
Scan for:
- Hardcoded secrets or credentials
- SQL injection vectors
- XSS vulnerabilities (if frontend)
- Missing input validation at boundaries
- Overly permissive CORS or auth

### 5. Code readability audit
- Function names describe what they do
- No dead code or unused imports
- No overly complex functions (>50 lines warrants review)
- Consistent patterns across modules
- No magic numbers or strings

### 6. Edge case review
For each major flow:
- Empty input, invalid input
- External service down
- Concurrent requests
- Scale boundaries

### 7. Product-lens review
Re-read PROMPT.md sections 2, 3, 4, 5, 6. Then evaluate the built product:

**First experience**:
- Walk through the product as a brand new user
- Count the steps before first value delivery
- Does the magic moment from PROMPT.md section 3 actually happen?
- Is there unnecessary friction before value?

**Success criteria audit**:
- For each success criterion in PROMPT.md section 4:
  - Can you demonstrate it working in the built product?
  - Mark: DEMONSTRATED / PARTIAL / NOT MET

**User flows end-to-end**:
- Run through each flow from PROMPT.md section 5 as a real user would
- Note any point where the experience breaks, confuses, or disappoints
- Note any point where the user would give up

**Return/retention**:
- If PROMPT.md section 6 describes a return loop, is it functional?
- Would a user have a reason to come back?

**The "would I use this?" test**:
- If you were the user described in PROMPT.md section 2, would this solve your pain?
- What's the single biggest gap between what was requested and what was built?

### 8. Generate docs/STATUS.md
Write the final status report:
- Overall status: GREEN / YELLOW / RED
- Completed sprints with dates
- What works (with acceptance criteria status)
- **User objectives met**: for each PROMPT.md section 4 criterion, DEMONSTRATED / PARTIAL / NOT MET
- **First experience**: steps to first value, magic moment delivered? (yes/no)
- **Return mechanism**: functional? (yes/no/not applicable)
- **Biggest gap**: the single most important thing between what was requested and what was built
- Known incomplete items
- Known issues/bugs
- Items needing human attention
- Test results summary
- Recommended next steps

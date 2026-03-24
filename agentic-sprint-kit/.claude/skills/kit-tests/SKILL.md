---
description: "Phase 2.5: Generate ALL tests from acceptance criteria before implementation"
---

# Kit Tests (Phase 2.5)

Generate all tests from acceptance criteria BEFORE implementation begins.
Agents will implement code to make these tests pass during sprints.

## Acceptance Criteria Format

All acceptance criteria in docs/USER_FLOWS.md use WHEN-THEN-SHALL format:

```
WHEN a user submits a login form with valid credentials
THEN the system SHALL return a 200 response with a session token
AND SHALL set an httpOnly cookie

WHEN a user submits a login form with invalid credentials
THEN the system SHALL return a 401 response
AND SHALL NOT set any cookies
AND SHALL increment the failed login counter
```

## Steps

### 1. Read all acceptance criteria
From docs/USER_FLOWS.md, extract every WHEN-THEN-SHALL block.

### 2. Map criteria to test types
Per docs/TEST_STRATEGY.md:
- API behavior criteria -> integration tests
- UI flow criteria -> e2e tests (if applicable)
- Business logic criteria -> unit tests
- Error/edge case criteria -> unit or integration tests

### 3. Generate test files
For each criterion, generate a test that:
- Sets up the WHEN condition
- Asserts the THEN/SHALL expectations
- Uses descriptive test names matching the criterion text
- **Mark as SKIPPED** (e.g., `it.skip`, `@pytest.mark.skip`, `t.Skip()`)
  with a comment noting which sprint should un-skip and implement it

### 4. Generate contract compliance tests
For each endpoint in docs/API_CONTRACTS.md:
- Test that response shape matches the contract type
- Test error responses match contract error shapes
- Test auth requirements are enforced
- Mark as SKIPPED with sprint assignment

### 5. Tag tests by sprint
Add a comment or describe block grouping tests by which sprint should make them pass:
```
// Sprint 1: Onboarding
describe.skip('Sprint 1: User can sign up', () => { ... })

// Sprint 2: Core feature
describe.skip('Sprint 2: User can create a widget', () => { ... })
```

### 6. Verify test infrastructure
- All test files are syntactically valid
- Test runner discovers all tests
- Test suite PASSES (all real tests pass, skipped tests are reported as skipped)
- Zero failures, zero errors

## Output
- Total test count (skipped + active)
- Tests per sprint (which sprint un-skips which tests)
- Any criteria that couldn't be cleanly mapped to tests (add to OPEN_QUESTIONS.md)

## Completion
Proceed to Phase 3 (execute first sprint).

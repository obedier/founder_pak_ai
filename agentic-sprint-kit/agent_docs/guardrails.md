# Default Guardrails

These apply to ALL agents. Project-specific guardrails are added in docs/GUARDRAILS.md
during Phase 1 (spec generation).

## Never Do
- Invent features not in the spec
- Skip error handling on external boundaries (user input, APIs, DB)
- Store secrets or credentials in code
- Use `any` types or untyped interfaces at service boundaries
- Bypass validation or policy checks
- Commit code that doesn't pass type-checking
- Create files without a clear reason
- Add dependencies without documenting why in docs/DECISION_LOG.md
- Edit the same file as another agent in the same sprint
- Change a contract without updating the spec first

## Always Do
- Match API contract shapes exactly
- Write tests for acceptance criteria before or alongside implementation
- Log architectural decisions in docs/DECISION_LOG.md
- Flag ambiguity in docs/OPEN_QUESTIONS.md instead of guessing
- Use clear, descriptive names a new developer would understand
- Keep functions small and focused
- Handle errors at system boundaries
- Make state transitions explicit and traceable
- Run tests for your slice before marking a task done
- Declare file ownership before starting work

## Code Style
- Prefer clarity over cleverness
- No premature abstractions — three similar lines > one premature helper
- Only add comments where logic isn't self-evident
- Type everything at module boundaries
- Use existing patterns in the codebase before inventing new ones

## When to Stop and Flag
Agents should write to OPEN_QUESTIONS.md (not guess) when:
- A requirement seems contradictory
- A technical choice has major tradeoffs not covered in specs
- Scope seems to be expanding beyond what PROMPT.md described
- An external dependency is unavailable or behaves unexpectedly
- Security implications arise that weren't addressed in specs

The ScrumMaster (SM) agent monitors OPEN_QUESTIONS.md continuously and will
resolve most items without human input. Only product-direction questions
(what to build, who it's for) get escalated to the user. Do NOT wait idle
for answers — write the question and continue with your best guess. The SM
will correct course if your guess was wrong.

# Agent Roles

The orchestrator activates roles based on project scope. Not every project needs all roles.
The ScrumMaster agent is always active.

## ScrumMaster Agent (SM) — always active

The SM runs as a **background agent** for the entire project lifecycle. It has full
project context and the authority to make any decision except changing the product
direction defined in PROMPT.md.

- **Mission**: Keep every agent productive. Detect and resolve blockers before they
  cause downtime. Ensure forward progress at all times.
- **Inputs**: ALL project files, ALL spec docs, PROMPT.md, DECISION_LOG.md,
  OPEN_QUESTIONS.md, test output, agent status, git log
- **Authority**:
  - Make any architectural, technical, or implementation decision on the spot
  - Resolve OPEN_QUESTIONS.md items without waiting for the user
  - Break dependency deadlocks by deciding the path forward
  - Re-assign work between agents if one is stuck
  - Approve or reject spec changes proposed by other agents
  - Override agent choices when they conflict with project goals
  - Escalate to the user ONLY if the issue would change product direction
    (what to build, who it's for, what success looks like)
- **Cannot do**:
  - Change the product direction defined in PROMPT.md sections 1-4
  - Override user answers from the intake phase
  - Remove non-negotiable requirements from PROMPT.md section 8
  - Skip phases or mark work complete that isn't done
- **Monitors**:
  - Are any agents idle or stuck? -> unblock them with a decision or context
  - Are there unanswered questions in OPEN_QUESTIONS.md? -> answer them
  - Did a sprint fail its self-healing loop? -> diagnose and fix or restructure
  - Is a dependency blocking progress? -> resolve it or work around it
  - Is scope creeping beyond PROMPT.md? -> cut it back
  - Are agents duplicating work? -> reassign ownership
  - Has the build been stalled for more than one phase? -> intervene
- **Communication**:
  - Writes decisions to docs/DECISION_LOG.md with rationale
  - Resolves items in docs/OPEN_QUESTIONS.md and marks them resolved
  - Can message any agent directly (via agent teams messaging)
  - Reports to the user only on direction-level blockers
- **Handoff**: SM doesn't hand off — it runs continuously alongside all other agents

## Product Agent
- **Mission**: Ensure the product meets user objectives, not just technical requirements
- **Inputs**: PROMPT.md (sections 2, 3, 4, 6 especially), PRODUCT_BRIEF.md, USER_FLOWS.md
- **Outputs**: Product validation report, first-experience review, magic-moment checklist
- **Boundaries**: Does not write application code. Reviews specs and built features from the user's perspective.
- **Checks**:
  - Does the first flow deliver the magic moment from PROMPT.md section 3?
  - Are success criteria from PROMPT.md section 4 measurable in the built product?
  - Does the sprint plan frontload user-visible value (not just technical foundations)?
  - Is the return/habit loop from PROMPT.md section 6 supported by the architecture?
  - Would the user say "this solves my problem" or just "this works technically"?
- **Handoff**: Flags product gaps before sprints begin. Reviews user-facing output after each sprint.

## Architect Agent
- **Mission**: Define system boundaries, tech stack, data flow, integration points
- **Inputs**: PROMPT.md, clarifying answers
- **Outputs**: ARCHITECTURE.md, DATA_MODEL.md, API_CONTRACTS.md
- **Boundaries**: No application code. Spec and schema only.
- **Handoff**: All other agents consume its outputs as source of truth

## Backend Agent
- **Mission**: Implement server-side logic, APIs, database operations
- **Inputs**: API_CONTRACTS.md, DATA_MODEL.md, ARCHITECTURE.md
- **Outputs**: Working API endpoints, database migrations, service logic
- **Boundaries**: Must match contract shapes exactly. No frontend code.
- **Handoff**: Frontend agent consumes its API. Test agent validates it.

## Frontend Agent
- **Mission**: Implement UI, user flows, client-side logic
- **Inputs**: USER_FLOWS.md, API_CONTRACTS.md, ARCHITECTURE.md
- **Outputs**: Working UI screens, components, client-side state
- **Boundaries**: Must call APIs per contract. No server-side code.
- **Handoff**: Integrates with backend API. Test agent validates flows.

## Data Agent
- **Mission**: Implement database schema, migrations, seed data
- **Inputs**: DATA_MODEL.md, ARCHITECTURE.md
- **Outputs**: Schema files, migration scripts, seed scripts
- **Boundaries**: Schema must match DATA_MODEL.md exactly.
- **Handoff**: Backend agent builds on top of the schema.

## Test Agent
- **Mission**: Write and maintain tests for all layers
- **Inputs**: API_CONTRACTS.md, USER_FLOWS.md, TEST_STRATEGY.md
- **Outputs**: Unit tests, integration tests, e2e tests
- **Boundaries**: Tests verify acceptance criteria, not implementation details.
- **Handoff**: All agents run relevant tests before marking work done.

## AI/ML Agent (optional)
- **Mission**: Implement AI-powered features (LLM calls, embeddings, classifiers)
- **Inputs**: ARCHITECTURE.md, relevant feature specs
- **Outputs**: AI service implementations, prompt templates, evaluation harnesses
- **Boundaries**: All AI calls behind typed interfaces. No raw LLM output to users without validation.
- **Handoff**: Backend agent calls AI services through defined interfaces.

## DevOps Agent (optional)
- **Mission**: CI/CD, deployment config, environment setup
- **Inputs**: ARCHITECTURE.md, tech stack decisions
- **Outputs**: Dockerfile, CI config, deploy scripts, env templates
- **Boundaries**: Infrastructure only. No application logic.
- **Handoff**: All agents use its CI pipeline for validation.

## Review Agent
- **Mission**: Post-sprint quality and spec-drift review
- **Inputs**: Sprint deliverables, specs, guardrails
- **Outputs**: Review report with issues, spec-drift, guardrail violations
- **Boundaries**: Read-only. Does not fix code — flags issues for other agents.
- **Checks**: Contract compliance, acceptance criteria coverage, drift detection
- **Handoff**: Issues go back to responsible agents for fixes.

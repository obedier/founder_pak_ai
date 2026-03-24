---
description: "Phase 1: Generate all specification documents from PROMPT.md and clarifying answers"
---

# Kit Spec Generation (Phase 1)

Read PROMPT.md and the clarifying answers from the conversation. Generate all spec
documents in `/docs/`. Do NOT write application code in this phase.

## Documents to Generate

### 1. docs/PRODUCT_BRIEF.md
- Problem statement (2-3 sentences)
- Target users
- Core flows (summary)
- Success criteria (measurable)
- Non-negotiables
- Scope boundaries (in/out)

### 2. docs/ARCHITECTURE.md
- High-level architecture diagram (mermaid)
- Service/module boundaries
- Tech stack with rationale
- Data flow for primary use cases (mermaid sequence diagrams)
- Integration points
- Key architectural decisions

### 3. docs/DATA_MODEL.md
- Entity name, fields, types
- Relationships (mermaid ER diagram)
- Indexes and constraints
- Modeling notes and rationale

### 4. docs/API_CONTRACTS.md
For every endpoint: method, path, description, request body (TypeScript interface
or JSON schema), response body, error responses, auth requirements.

### 5. docs/USER_FLOWS.md
For each user flow: step-by-step description, screen/view per step, user actions,
system behavior, error states. Each step gets acceptance criteria in WHEN-THEN-SHALL format:

```
WHEN [precondition or user action]
THEN the system SHALL [expected behavior]
AND SHALL [additional expected behavior]
```

### 6. docs/SPRINT_PLAN.md
- Sprint 0: Foundation (repo, types, schema, stubs, test scaffolding)
- Sprint 1-N: Feature sprints in dependency order
- Each sprint: goals, user stories, deliverables, frontend/backend/test tasks
- Mark parallelization opportunities

### 7. docs/AGENT_ROLES.md
Which agents this project needs. Read `agent_docs/agent-roles.md` for role definitions.
For each active role: mission, owned files, sprint assignments.

### 8. docs/GUARDRAILS.md
Start with defaults from `agent_docs/guardrails.md`, add project-specific rules:
domain constraints, security requirements, performance requirements, accessibility, compliance.

### 9. docs/TEST_STRATEGY.md
- Unit/integration/e2e scope and tools
- Acceptance criteria mapping (which tests verify which criteria)
- Test data strategy

## Rules
- Every spec must trace to PROMPT.md or clarifying answers
- Do NOT invent features — add to docs/OPEN_QUESTIONS.md instead
- Include mermaid diagrams for architecture and data relationships
- API contracts must include typed interfaces for all request/response bodies

## Completion
Present a brief summary: entity count, endpoint count, sprint count, flow count, agent team size.
Then proceed to Phase 1.5 (product validation).

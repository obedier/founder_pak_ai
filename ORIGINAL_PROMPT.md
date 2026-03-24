You are my lead AI product engineer and agent-orchestrator for this project.

We are building AiPay Home, an agentic shopping assistant / convenience OS that learns household preferences, follows explicit policies, compares across trusted stores, and progressively earns the right to take shopping off the user’s plate.

Before writing code, read and internalize the markdown docs in:

/founder_pack/
- product-overview.md
- user-flows.md
- system-architecture.md
- data-model.md
- api-spec.md
- trust-and-policy-engine.md
- mvp-sprint-plan.md
- growth-and-launch.md

Your job is NOT to jump straight into coding. Your first job is to create an **agent-optimized development workflow** for building this product with high autonomy and strong guardrails.

## Goals
Design a workflow where multiple coding agents can work effectively in parallel with minimal confusion, strong context sharing, and clean handoffs. The workflow should be optimized for:
- fast iteration
- modular execution
- minimal rework
- clear contracts between components
- strong documentation
- safe autonomous coding
- easy human review
- maintaining product intent from the docs above

## What I want you to do first
1. Read all the docs above carefully.
2. Synthesize the product into a concise internal development brief.
3. Propose the best repo structure for agentic development.
4. Propose a multi-agent workflow with clearly defined agent roles.
5. Define the artifacts each agent should produce before and after coding.
6. Define how agents should share context and avoid stepping on each other.
7. Define a recommended execution order for implementation.
8. Create the initial project-management and documentation scaffolding in the repo.

## Deliverables I want first
Create these files before writing application code:

- /README.md
- /.cursorrules
- /docs/DEV_WORKFLOW.md
- /docs/ARCHITECTURE_SUMMARY.md
- /docs/IMPLEMENTATION_PLAN.md
- /docs/AGENT_ROLES.md
- /docs/REPO_STRUCTURE.md
- /docs/DECISION_LOG.md
- /docs/OPEN_QUESTIONS.md
- /docs/SPRINT_01.md

## Workflow requirements
Your proposed agentic workflow should include at minimum:

### 1. Agent roles
Define specialized agents such as:
- Product/PRD Interpreter
- Tech Lead / Architect
- Frontend App Builder
- Backend Services Builder
- Data Model / DB Builder
- API Contract Owner
- AI / Decisioning Engineer
- QA / Test Engineer
- DevOps / Tooling Engineer
- Documentation / Integrator Agent

For each role, define:
- mission
- inputs
- outputs
- boundaries
- handoff expectations

### 2. Source-of-truth rules
Create a clear hierarchy of truth. For example:
1. founder docs in /founder_pack
2. architecture summary
3. API contracts
4. implementation plan
5. code

Make sure agents know when they can decide, when they must document assumptions, and when they must stop and flag ambiguity.

### 3. Build order
Recommend the ideal implementation sequence for this product, likely something like:
- repo and tooling foundation
- shared types and schemas
- data model
- backend service scaffolding
- API contracts
- frontend shell
- onboarding flow
- household context
- basket flow
- merchant comparison
- delegated purchase flow
- trust engine
- autopilot controls
- natural language tasks

But refine this based on the docs.

### 4. Parallelization strategy
Show what can be built in parallel versus what must be sequential.
Example:
- frontend can scaffold UI against mock contracts
- backend can implement service skeletons
- API contract owner can define interfaces first
- AI decisioning agent should wait until policy/trust models are stable

### 5. Guardrails
Define rules so agents do not:
- invent product behavior not supported by docs
- bypass policy evaluation
- treat trust as global instead of category-specific
- skip rationale generation
- hardcode retailer assumptions that should be abstracted behind connectors
- build autopilot in unsafe ways

### 6. Review loop
Define how work should be reviewed:
- every major task should produce a short summary
- every architectural decision should be added to DECISION_LOG.md
- every unresolved ambiguity should be added to OPEN_QUESTIONS.md
- every completed slice should update IMPLEMENTATION_PLAN.md

## Implementation style
Bias toward:
- modular architecture
- typed contracts
- simple, extensible foundations
- developer-friendly documentation
- testable boundaries
- no overengineering in v1
- visible support for explainability, trust, and policy controls

## Important constraints
- Do not build a generic shopping chatbot.
- Do not make AiPay Home a retailer.
- Treat trust + policy + rationale as first-class from day one.
- All merchant integrations must be abstracted behind connector interfaces.
- Keep the MVP tightly aligned to household replenishment and delegated buying.

## Output format
Start by giving me:
1. a concise synthesis of the product
2. the proposed multi-agent workflow
3. the proposed repo structure
4. the file plan
5. the implementation sequence

Then create the documentation files listed above.

Do not start app code until the workflow and scaffolding are in place.
/aipay_founder_pack/02-system-architecture.md
# AiPay Home — System Architecture

## Architecture Overview

AiPay Home should be built as a set of services centered around trust, memory, policy, merchant routing, and execution.

The system must support:

- user identity and household context
- preference memory
- product normalization
- merchant comparison
- policy evaluation
- trust scoring
- task orchestration
- delegated authorization
- post-purchase recovery
- analytics and experimentation

## Architectural Principles

1. Every purchase decision must pass through policy evaluation.
2. Trust must be category-specific.
3. Every meaningful user and system action should be evented.
4. Merchant and rail integrations should live behind connectors.
5. All purchase states should support explainability and reversibility modeling.
6. The AI layer should recommend and orchestrate, not bypass control systems.

## High-Level Services

### 1. Identity and Auth Service
Responsibilities:
- user accounts
- household membership
- session management
- device trust
- authentication flows

### 2. Preference Memory Service
Responsibilities:
- store purchase history
- infer brand preferences
- infer merchant preferences
- track rebuys, skips, edits, returns
- serve preference context to task engine

### 3. Household Graph Service
Responsibilities:
- represent household members
- store roles and relationships
- store shared preferences and constraints
- track kid size ladders
- track household-level policies

### 4. Product Normalization Service
Responsibilities:
- map equivalent items across merchants
- normalize brand, variant, size, and pack count
- identify substitutions
- maintain product family relationships

### 5. Commerce Intelligence Service
Responsibilities:
- compare merchants
- compare prices
- compare delivery ETA
- compare seller and return quality
- expose ranked purchase options

### 6. Policy Engine
Responsibilities:
- evaluate spending rules
- evaluate merchant allow/block rules
- evaluate category permissions
- evaluate substitution rules
- determine approval requirements

This service is mandatory in all decision and execution flows.

### 7. Confidence Engine
Responsibilities:
- score recommendation confidence
- score delegation readiness
- score autopilot readiness
- produce confidence band outputs for the orchestration engine

### 8. Orchestration Engine
Responsibilities:
- task planning
- intent classification
- purchase plan generation
- clarification question generation
- merchant routing
- approval workflow
- purchase execution orchestration
- notification and recovery workflow initiation

### 9. Wallet and Authorization Service
Responsibilities:
- manage tokenized payment references
- store delegated authority scopes
- manage approval state transitions
- maintain transaction logs
- expose authorization auditability

### 10. Recovery Service
Responsibilities:
- cancel workflows
- modify workflows
- exchange and return initiation
- error handling
- feedback capture
- trust downgrade triggers

### 11. Analytics and Experimentation Service
Responsibilities:
- funnel instrumentation
- retention metrics
- trust metrics
- merchant quality metrics
- experimentation and feature flag analysis

## Suggested Technical Stack

### Frontend
- iOS: Swift if premium native UX is top priority
- or React Native if cross-platform speed is more important
- Web admin/ops console: React / Next.js

### Backend
- API and services: TypeScript/Node or Python
- Database: Postgres
- Event bus: Kafka or lighter queue/event infrastructure initially
- Vector memory: Postgres with pgvector or equivalent
- Observability: Datadog or OpenTelemetry stack
- Feature flags: LaunchDarkly or internal service

## Service Interaction Model

### Example: delegated basket purchase
1. user submits task
2. orchestration engine classifies intent
3. memory service and household graph provide context
4. policy engine evaluates allowed behavior
5. commerce intelligence compares merchant options
6. confidence engine scores whether recommendation, clarification, or execution is appropriate
7. orchestration engine prepares response or purchase plan
8. wallet service handles approval and authorization
9. recovery service monitors post-purchase state
10. analytics service records all key events

## Connector Layer

All merchant, rail, and delivery integrations should be abstracted behind a connector interface.

Suggested connector capabilities:
- catalog lookup
- price lookup
- availability lookup
- delivery ETA lookup
- cart creation
- checkout execution
- order status retrieval
- cancel support
- return support

This allows:
- easier retailer replacement
- easier testing
- cleaner orchestration logic
- safer expansion across rails

## AI Layer Design

The AI layer should include:

### Intent parser
Turns natural language tasks into structured tasks.

### Planner
Breaks tasks into subtasks like:
- clarify
- compare
- route
- approve
- execute

### Explanation generator
Produces human-readable rationales for:
- product choice
- merchant choice
- substitution
- autopilot actions

### Retrieval layer
Pulls from:
- memory service
- household graph
- policy engine outputs
- merchant comparison outputs

### Trust-aware decision wrapper
No model output should directly trigger execution without policy and confidence gates.

## Event-Driven Backbone

Every meaningful state change should be recorded as an event.

Examples:
- onboarding_completed
- household_updated
- basket_rebuilt
- recommendation_accepted
- recommendation_edited
- recommendation_rejected
- order_submitted
- order_canceled
- order_returned
- autopilot_enabled
- autopilot_purchase_completed
- trust_level_changed

## Non-Functional Requirements

### Reliability
- purchase flows must be resilient to connector failures
- idempotency required for execution endpoints
- retriable background processing where safe

### Security
- tokenized payment references only
- strict authorization checks
- audit trails for all purchase and policy actions
- encryption at rest and in transit

### Explainability
- user-facing rationale required for all major system choices
- internal decision trace should be preserved for debugging and support

### Scalability
- merchant comparison service and orchestration engine should scale independently
- event processing should support analytics and trust updates asynchronously

### Observability
- latency tracing on task and execution flows
- per-connector failure monitoring
- trust score anomaly monitoring
- autopilot error and reversal monitoring
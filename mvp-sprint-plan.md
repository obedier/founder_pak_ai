/aipay_founder_pack/06-mvp-sprint-plan.md
# AiPay Home — MVP Sprint Plan

## MVP Goal

Build an MVP that proves users will trust AiPay Home with repeated household shopping tasks and return weekly.

## MVP Success Criteria

- user completes first useful shopping action in first session or within 24 hours
- user completes first delegated purchase
- order rationale is visible
- at least one category becomes eligible for autopilot
- user can review and control post-purchase actions
- early users return weekly

## Sprint 0 — Foundations

### Goals
- establish repository structure
- select mobile stack
- define backend service boundaries
- set up database, auth, analytics, feature flags, and CI/CD
- define event taxonomy

### Deliverables
- repo layout
- environment strategy
- app shell with navigation scaffold
- backend API skeleton
- Postgres schema v1
- event schema v1
- analytics and observability foundations

### Tasks
- create repos and shared package structure
- define shared types
- configure auth skeleton
- configure Postgres
- configure metrics and logs
- configure design system foundation
- set up feature flags

## Sprint 1 — Onboarding and Household Context

### Goals
- user can sign up
- user can create household
- user can define starter rules
- app can show initial household profile

### User stories
- as a user, I can sign up and create a household
- as a user, I can set preferred merchants and blocked brands
- as a user, I can set price versus speed preference
- as a user, I can define categories that should never auto-buy

### Deliverables
- onboarding screens
- household profile UI
- starter policy persistence
- settings screen basics

### Backend tasks
- implement user and household endpoints
- implement policy endpoints
- create core models: User, Household, Policy, MerchantPreference

## Sprint 2 — Rebuild Essentials Basket v1

### Goals
- user can seed and confirm common household staples
- system can generate a proposed basket
- basket can be edited

### User stories
- as a user, I can confirm likely staples
- as a user, I can change quantity, brand, or size
- as a user, I can see a proposed basket ready for comparison

### Deliverables
- staple setup flow
- basket builder UI
- line-item editing
- rationale placeholder on line items

### Backend tasks
- create Task, Basket, BasketItem, ProductPreference models
- implement basket generation endpoint
- implement basic rationale generation stub

## Sprint 3 — Merchant Comparison v1

### Goals
- compare supported merchants or rails
- rank by price, speed, and trust
- present recommendation clearly

### User stories
- as a user, I can compare basket options
- as a user, I can choose cheapest, balanced, or fastest
- as a user, I can understand why one option is recommended

### Deliverables
- merchant comparison screen
- ranking logic v1
- explanation UI

### Backend tasks
- create MerchantProfile and ProductOffer models
- implement merchant ranking service
- implement comparison endpoint
- normalize delivery ETA and fees

## Sprint 4 — Delegated Purchase Flow v1

### Goals
- user can approve a proposed purchase plan
- system can execute or simulate execution via connector layer
- orders are stored and visible

### User stories
- as a user, I can approve a basket and buy
- as a user, I can see order history and status
- as a user, I can inspect why the merchant was chosen

### Deliverables
- purchase approval flow
- order history screen
- order detail screen
- wallet placeholder UI

### Backend tasks
- create Order, OrderItem, PaymentMethodRef, AuthorizationScope models
- implement order execution endpoint
- implement order history endpoints
- persist rationale with orders

## Sprint 5 — Trust and Autopilot v1

### Goals
- track trust-affecting outcomes
- compute category trust score
- allow one category to be enabled for autopilot

### User stories
- as a user, I can see which categories are eligible for autopilot
- as a user, I can enable autopilot in an eligible category
- as a user, I can review recent autopilot actions

### Deliverables
- autopilot dashboard
- trust ladder UI
- category enable/disable flow

### Backend tasks
- create TrustProfile and TrustLedgerEvent models
- implement trust scoring service
- implement autopilot eligibility endpoint
- implement autopilot settings endpoint

## Sprint 6 — Notification, Cancel Window, and Recovery v1

### Goals
- notify user of autopilot actions
- allow cancellation when possible
- capture feedback and trust downgrade

### User stories
- as a user, I can cancel an autopilot purchase within the allowed window
- as a user, I can report a bad choice
- as a user, I can tighten autonomy after a mistake

### Deliverables
- push or in-app notifications
- cancel flow
- feedback flow
- visible recovery states in order history

### Backend tasks
- implement notification hooks
- implement cancel endpoint
- implement trust downgrade behavior
- add recovery state machine to order lifecycle

## Sprint 7 — One-Sentence Task Input v1

### Goals
- support natural-language task creation
- classify tasks into Explore, Delegate, or Auto candidate
- ask only missing questions

### User stories
- as a user, I can type “buy me a new phone”
- as a user, I get a concise recommendation or one smart follow-up question
- as a user, I do not need to fill long forms

### Deliverables
- task composer
- task classification flow
- clarification question UX
- recommendation summary screen

### Backend tasks
- implement intent parser
- implement confidence engine v1
- implement clarification generator
- implement recommendation composer

## Suggested Sequence After MVP

### Sprint 8+
- richer household collaboration
- additional merchant rails
- better receipt/context import
- advanced return workflows
- better autopilot trigger logic
- experiment framework for activation and trust tuning

## Engineering Notes

### Non-negotiables
- every execution path must run through policy evaluation
- trust must remain category-specific
- rationale must be visible in all recommendation and order surfaces
- merchant integrations must go through connector abstraction
- event logging must be comprehensive from day one

### Definition of Done for MVP
A user can:
- onboard
- define household context
- rebuild a basket
- compare options
- approve a purchase
- see order history and rationale
- enable autopilot for at least one category
- cancel or give feedback on an autopilot-generated purchase when allowed
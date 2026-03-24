# AiPay Home Founder Pack

## 1. PRFAQ

### Press Release

**FOR IMMEDIATE RELEASE**

# Introducing AiPay Home: the AI that learns your household and gradually takes shopping off your plate

Today we’re introducing **AiPay Home**, a new kind of shopping assistant built for real life. Instead of acting like another storefront, AiPay Home works across the stores families already use and trust. It learns preferences, follows rules, compares price and speed, and helps people go from **“I need this”** to **“it’s handled.”**

AiPay Home starts by helping users explore and compare products. As it learns what a household likes, it can take on more responsibility: rebuilding weekly essentials, restocking staples, and eventually automating narrow categories where confidence is high and control is clear.

People do not want more shopping apps. They want less shopping. AiPay Home is built to reduce cognitive load, not add to it.

AiPay Home is designed around a progressive trust model:
- **Explore** when you’re unsure
- **Delegate** when you want help
- **Automate** when the system has earned the right

AiPay Home does not replace retailers. It helps users shop the stores they already trust, just with better memory, better comparisons, and better execution.

At launch, AiPay Home focuses on household replenishment and delegated buying for common shopping tasks. Over time, it will expand into a broader convenience operating system for commerce.

**Shopping disappears. Control stays with you.**

### FAQ

#### Q: Is AiPay Home a retailer?
No. AiPay Home does not own inventory or act as merchant of record. It orchestrates shopping across existing merchants and delivery rails.

#### Q: How is this different from retailer apps or general AI assistants?
AiPay Home is household-native, memory-driven, policy-controlled, and designed for progressive autonomy across multiple stores. It is not a one-shot search tool and not a single-retailer experience.

#### Q: Will it buy things without permission?
Only in narrow categories where the user has explicitly allowed automation and the system has earned enough trust. Every autonomous purchase is policy-bounded and comes with notification and post-purchase controls.

#### Q: How does it know what I like?
From connected purchase history, saved preferences, approvals, edits, rebuys, skips, returns, and direct rules set by the user.

#### Q: What if it gets something wrong?
The app includes cancel, modify, swap, return, and feedback controls. Wrong decisions reduce trust level and tighten future autonomy.

#### Q: Why start with household goods?
Because frequency builds trust. Staples and replenishment create repeat loops that help the system learn quickly and prove value.

#### Q: How does the company make money?
Likely a hybrid:
- Subscription for premium household autopilot
- Transaction / checkout economics where available
- Retailer / merchant lead value where aligned
- Future wallet / authorization infrastructure

---

## 2. Board / Investor Deck Outline

### Slide 1 — Title
**AiPay Home**
Shopping disappears. Control stays with you.

### Slide 2 — The Problem
Household shopping is fragmented, repetitive, cognitively expensive, and poorly automated.

Users repeatedly:
- compare the same items across multiple stores
- rebuy staples manually
- forget things
- balance price vs speed vs quality each time
- carry invisible household cognitive load

### Slide 3 — Why Now
Agentic commerce infrastructure is maturing, but the household experience is still wide open.

Market timing tailwinds:
- AI-native buying flows are becoming real
- delegated payment and trust controls are becoming first-class
- consumers are increasingly comfortable with AI help, but not yet with uncontrolled autonomy
- retailers and delivery rails are unevenly open, creating room for a convenience OS layer

### Slide 4 — The Insight
The winning product will not be “an AI shopping chatbot.”

It will be a **trust and execution layer** that knows:
- when to recommend
- when to ask
- when to act
- when to stop
- when to undo

### Slide 5 — Product
AiPay Home is a convenience OS for shopping.

It learns how a household buys, follows explicit rules, compares across trusted stores, and progressively earns the right to take shopping off the user’s plate.

### Slide 6 — Product Modes
**Explore** — help me discover and compare

**Delegate** — do most of the shopping work for me

**Auto** — proactively buy within trust and policy boundaries

### Slide 7 — The Launch Wedge
**Household operator + recurring household shopping**

Why this wedge:
- high frequency
- obvious pain
- repeatable data loop
- fast trust compounding
- referral-friendly outcome

### Slide 8 — Magic Loop
The first 10 minutes must prove:
- it knows me
- it saves me effort
- it makes smart decisions
- it earns more power over time

### Slide 9 — Core Product Experience
Examples:
- rebuild my essentials basket
- restock this week’s basics
- buy from one sentence
- autopilot paper goods / pet food / pantry basics

### Slide 10 — Moat
The moat is not chat UI.

The moat is:
- preference memory
- household graph
- trust ledger
- policy engine
- merchant routing
- wallet / delegated authorization
- post-purchase recovery

### Slide 11 — Go-To-Market
Positioning:
**Get your household brain back.**

Growth wedge:
- first basket magic
- repeated weekly relief
- autopilot unlocks
- spouse / household invites
- creator-led demos

### Slide 12 — Business Model
Potential monetization:
- subscription for premium autopilot
- transaction economics where rails permit
- partner value from routed high-intent demand
- future infrastructure / wallet economics

### Slide 13 — Roadmap
- Phase 1: rebuild household + delegated staples
- Phase 2: trust scoring + repeated reorders
- Phase 3: narrow autopilot
- Phase 4: platform / API layer

### Slide 14 — Why We Win
We are owning the most strategic emerging layer in commerce:
**the trust and execution layer between user intent and merchant fulfillment**

### Slide 15 — Ask / Next Milestones
- ship MVP
- validate first-session magic
- validate weekly repeat use
- prove at least one category reaches trusted autopilot
- expand rails and policy depth

---

## 3. Engineering-Ready Sprint Plan

## 3.1 Product Goal
Build an MVP that proves users will trust AiPay Home with repeated household shopping tasks and come back weekly.

## 3.2 MVP Success Criteria
- user completes first useful shopping action in first session or within 24 hours
- user completes first delegated purchase
- at least one category can be unlocked for autopilot
- order rationale and controls are visible and trusted
- early users return weekly for household shopping tasks

## 3.3 Sprint 0 — Foundations
### Goals
- establish repo structure
- choose mobile stack
- define backend service boundaries
- set up auth, database, analytics, feature flags, CI/CD
- define event taxonomy

### Deliverables
- mono-repo or service repo layout
- environment strategy
- auth skeleton
- Postgres schema v1
- event schema v1
- app shell with navigation skeleton
- backend API skeleton

### Technical tasks
- create core repos
- define shared types and contracts
- configure Postgres
- configure analytics events
- configure feature flags
- configure observability
- set up design system foundations

## 3.4 Sprint 1 — Onboarding and Household Context
### Goals
- user can create account
- user can enter basic household profile
- user can set preferences and starter rules
- app can render household overview

### User stories
- as a user, I can sign up and create a household
- as a user, I can set preferred merchants and blocked brands
- as a user, I can set price vs speed preferences
- as a user, I can define categories that should never auto-buy

### Deliverables
- onboarding screens
- household profile screens
- starter policy model
- settings persistence

### API / backend tasks
- create `User`, `Household`, `Policy`, `MerchantPreference` models
- implement auth endpoints
- implement household create/update endpoints
- implement starter policy endpoints

## 3.5 Sprint 2 — Rebuild Essentials Basket v1
### Goals
- user can manually seed household staples
- system can generate a basket from seeded items
- basket can be reviewed and edited

### User stories
- as a user, I can confirm common staples
- as a user, I can edit pack size / quantity / brand preference
- as a user, I can see a proposed household basket

### Deliverables
- staple detection / seeding flow
- basket builder UI
- line-item editing UX
- rationale stub for each item

### API / backend tasks
- create `ProductPreference`, `Task`, `Basket`, `BasketItem` entities
- implement basket generation endpoint
- implement rationale generation endpoint stub

## 3.6 Sprint 3 — Merchant Comparison v1
### Goals
- compare supported merchants / rails for basket fulfillment
- rank by price, speed, and trust
- present recommendation with explanation

### User stories
- as a user, I can compare basket fulfillment options
- as a user, I can choose cheapest, balanced, or fastest
- as a user, I can understand why the system recommends one route

### Deliverables
- merchant comparison screen
- ranking logic v1
- merchant explanation UI

### API / backend tasks
- create `MerchantProfile` and `Offer` models
- implement merchant ranking service
- implement comparison endpoint
- normalize delivery ETA and fees

## 3.7 Sprint 4 — Delegated Purchase Flow v1
### Goals
- user can approve a proposed basket or task
- system can execute or simulate execution through a connector layer
- order history is stored

### User stories
- as a user, I can approve a purchase plan
- as a user, I can see order details and status
- as a user, I can review why a merchant was chosen

### Deliverables
- purchase approval flow
- order history screen
- order detail screen
- wallet / payment method placeholder UI

### API / backend tasks
- create `Order`, `OrderItem`, `PaymentMethodRef`, `AuthorizationScope` entities
- implement purchase orchestration endpoint
- implement order history endpoints
- implement order rationale persistence

## 3.8 Sprint 5 — Trust and Autopilot v1
### Goals
- system tracks acceptance / edits / cancellations
- category trust score updates over time
- one category can be enabled for autopilot

### User stories
- as a user, I can see which categories are eligible for autopilot
- as a user, I can enable autopilot for an eligible category
- as a user, I can see recent autopilot actions and their outcome

### Deliverables
- autopilot dashboard
- trust ladder UI
- trust change event handling
- autopilot category toggle flow

### API / backend tasks
- create `TrustLedgerEvent` model
- implement trust scoring service
- implement autopilot eligibility endpoint
- implement autopilot settings endpoint

## 3.9 Sprint 6 — Notification, Cancel Window, and Recovery v1
### Goals
- user gets notified of autopilot actions
- user can cancel or modify within allowed window
- recovery state is visible in order history

### User stories
- as a user, I can cancel an autopilot purchase within the allowed window
- as a user, I can provide feedback on a bad choice
- as a user, I can tighten autonomy after a mistake

### Deliverables
- push / in-app notifications
- cancel action flow
- feedback / issue reporting flow
- trust downgrade behavior

### API / backend tasks
- implement notification service hooks
- implement cancel / modify endpoints
- implement trust downgrade logic
- add recovery state machine to orders

## 3.10 Sprint 7 — One-Sentence Task Input v1
### Goals
- user can create a task from natural language
- system can classify task into Explore / Delegate / Auto candidate
- system can ask only missing questions

### User stories
- as a user, I can say “buy me a new phone” or “restock paper towels”
- as a user, I receive a concise recommendation or follow-up question
- as a user, I do not have to manually fill long forms

### Deliverables
- task input composer
- task classification flow
- clarification prompt UX
- recommendation summary screen

### API / backend tasks
- task parser / intent classifier
- confidence engine v1
- clarification question generator
- recommendation composer

---

## 4. API Contract Draft

### `POST /auth/signup`
Create user and household.

### `POST /households`
Create household profile.

### `PATCH /households/:id`
Update household settings.

### `POST /policies`
Create or update starter policy.

### `GET /households/:id/recommendations/staples`
Return likely or configured household staples.

### `POST /tasks/basket/rebuild`
Generate household essentials basket.

### `GET /tasks/:id/comparisons`
Return merchant comparison results.

### `POST /orders/approve`
Approve and execute proposed purchase.

### `GET /orders`
List orders.

### `GET /orders/:id`
Get order details and rationale.

### `POST /autopilot/categories/:category/enable`
Enable autopilot for category.

### `POST /autopilot/orders/:id/cancel`
Cancel autopilot order when allowed.

### `POST /tasks/natural-language`
Create task from natural language input.

---

## 5. Event Schema Draft

### `onboarding_completed`
```json
{
  "user_id": "",
  "household_id": "",
  "connected_sources": [],
  "timestamp": ""
}
```

### `basket_rebuilt`
```json
{
  "user_id": "",
  "household_id": "",
  "basket_id": "",
  "item_count": 0,
  "timestamp": ""
}
```

### `recommendation_accepted`
```json
{
  "user_id": "",
  "task_id": "",
  "category": "",
  "merchant_id": "",
  "timestamp": ""
}
```

### `autopilot_purchase_completed`
```json
{
  "user_id": "",
  "order_id": "",
  "category": "",
  "merchant_id": "",
  "total": 0,
  "timestamp": ""
}
```

### `trust_level_changed`
```json
{
  "user_id": "",
  "category": "",
  "old_level": "",
  "new_level": "",
  "reason": "",
  "timestamp": ""
}
```

---

## 6. Coding-Agent Handoff Notes

### Core implementation priorities
1. Build the trust and policy backbone first.
2. Keep all autonomy category-specific.
3. Make rationale generation visible in every decision surface.
4. Use a connector abstraction for merchant / rail integrations.
5. Store every important decision and outcome as an event.
6. Design all purchase flows with reversibility states.

### Non-negotiables
- never execute without policy evaluation
- never treat trust as global across all categories
- always give users a visible explanation for recommendations and autopilot actions
- make cancel / modify / feedback controls first-class
- optimize for first-session magic and weekly repeat usage

### Initial implementation sequence
- app shell + auth
- household + policy models
- basket rebuild flow
- merchant comparison service
- delegated purchase flow
- trust engine
- autopilot controls
- natural language task input

### Definition of done for MVP
- a user can onboard, define household context, rebuild a basket, compare options, approve a purchase, and later enable autopilot for at least one household category with visible controls and rationale

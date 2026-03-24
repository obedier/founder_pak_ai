
```text
/aipay_founder_pack/05-trust-and-policy-engine.md
# AiPay Home — Trust and Policy Engine

## Overview

Trust and policy are the core control systems of AiPay Home.

The product should never behave as though AI confidence alone is enough. Execution authority must depend on both:

- what the system believes
- what the user has allowed

This document defines the trust ladder, policy model, decisioning logic, and operational guardrails.

## Core Principles

1. Trust is category-specific.
2. Trust is earned through outcomes.
3. Trust can decline faster than it rises.
4. Policy always overrides confidence.
5. Autopilot is a privilege, not a default.
6. Every autonomous action must be explainable and recoverable where possible.

## Trust Ladder

Trust should be tracked by category.

### L0 — No autonomy
System may store memory but should not make actionable recommendations beyond generic help.

### L1 — Recommend only
System can recommend products or merchants but should not build or submit carts without explicit user action.

### L2 — Build cart
System can prepare proposed carts or purchase plans, but approval is still required.

### L3 — Buy with approval
System can prepare and present a near-complete purchase and proceed only after explicit approval.

### L4 — Buy unless stopped
System may execute inside policy and then notify user with a cancel window.

### L5 — Proactive buy within policy
System may proactively purchase in narrow, trusted categories with explicit user opt-in and visible controls.

## Trust Inputs

Trust score should be influenced by:

- recommendation acceptance rate
- recommendation edit rate
- cancellation rate
- return rate
- explicit positive or negative feedback
- repeat consistency in category
- category volatility or risk
- merchant outcome quality
- price deviation from usual acceptable range

## Trust Increases

Examples of trust-positive outcomes:
- user accepts recommendation without edits
- user approves repeated item choice multiple times
- user keeps autopilot purchases unchanged
- user leaves positive feedback
- user does not return or complain about category purchases

## Trust Decreases

Examples of trust-negative outcomes:
- user cancels purchase
- user edits before approval
- user returns item
- user reports wrong merchant, wrong brand, wrong size, too expensive, or too slow
- merchant error materially harms user experience

## Trust Score Implementation Suggestion

Trust score can be numeric internally and bucketed into visible trust levels.

Example:
- 0–19 => L0
- 20–39 => L1
- 40–59 => L2
- 60–79 => L3
- 80–94 => L4
- 95–100 => L5

This mapping should be tunable.

## Policy Model

Policies should define what the system is allowed to do.

### Policy scopes
Support:
- global household default
- category-specific
- product-family-specific
- merchant-specific

### Policy dimensions
Policies may govern:
- max spend per item
- max spend per category
- monthly category spend cap
- approval required or not
- autopilot allowed or not
- allowed merchants
- blocked merchants
- allowed brands
- blocked brands
- substitution strictness
- delivery urgency preferences
- seller-type restrictions
- return-window minimums

## Example Policies

### Example 1
For pantry staples, optimize for lowest delivered total.

### Example 2
Never buy electronics over $500 without asking.

### Example 3
Do not use third-party sellers with poor return policies.

### Example 4
Do not auto-buy apparel.

### Example 5
Only allow autopilot for paper goods and pet food.

## Policy Evaluation

Every recommendation or execution attempt should run through policy evaluation.

### Input
- household context
- category
- product choice
- merchant choice
- spend amount
- seller type
- substitution details
- autopilot request state

### Output
- allowed
- allowed with approval
- blocked
- blocked pending clarification

### Policy examples in practice

If the system wants to buy paper towels:
- category allowed
- spend below threshold
- merchant preferred
- product family acceptable
- confidence high
=> allowed with stop window if user enabled autopilot

If the system wants to buy a laptop:
- category high-risk
- spend exceeds max
- autopilot not allowed
=> blocked, requires approval or explore flow

## Confidence Versus Trust

Confidence and trust are related but not the same.

### Confidence answers:
How likely is it that this is the right recommendation?

### Trust answers:
Has the system earned the right to act in this category for this household?

### Example
The system can be highly confident that a product is a good match but still not be allowed to buy it automatically because trust level or policy scope is insufficient.

## Decision Matrix

Use both policy and trust.

### Case 1
High confidence + low trust + permissive policy
=> recommend or propose, do not auto-buy

### Case 2
High confidence + high trust + restrictive policy
=> still blocked or approval-required

### Case 3
High confidence + high trust + permissive policy
=> approval flow or autopilot depending on trust level and approval mode

### Case 4
Low confidence + high trust + permissive policy
=> ask clarifying question or downgrade to recommendation

## Confidence Bands

Suggested confidence interpretation:
- 0–39 recommend only
- 40–64 ask one or more clarifying questions
- 65–84 propose a purchase plan
- 85–94 execute with stop window if policy and trust permit
- 95+ proactive buy if policy, trust, and authorization all permit

## Authorization Modes

Autopilot should support explicit authorization modes.

### always_require_approval
System may propose, but never submit without explicit approval.

### allow_stop_window
System may submit within policy, then notify user and allow cancellation within an allowed window.

### full_autopilot
System may submit within a narrow category scope with post-purchase controls.

This mode should be extremely limited and only available after repeated success plus explicit opt-in.

## Required Guardrails

1. Never carry trust from one category to another without separate evidence.
2. Never execute without policy evaluation.
3. Never hide why a purchase was made.
4. Never allow autopilot in blocked categories.
5. Always log the decision inputs that led to execution.
6. Always expose cancel or return state if available.

## Trust Recovery

When the system makes a mistake:
- capture explicit feedback
- reduce trust score in category
- optionally lower visible trust level
- tighten approval mode if needed
- surface learning in future rationales

Example:
You told me this was the wrong brand. I’ll require approval again for this category until I rebuild trust.

## Recommended Internal Audit Trail

For every major recommendation or execution, preserve:
- task input
- retrieved memory
- relevant policies
- trust state
- confidence score
- merchant ranking outputs
- rationale shown to user
- final action taken

This is important for:
- debugging
- support
- analytics
- user trust
- future learning

## UX Recommendations

Users should see trust as progress, not as a hidden score.

Good visible UX:
- category trust ladders
- unlock prompts
- spend boundaries
- recent autopilot wins
- clear downgrade after mistakes

Avoid:
- mysterious invisible automation
- global trust badges
- generic “AI confidence” language with no practical meaning
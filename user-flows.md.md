/aipay_founder_pack/01-user-flows.md
# AiPay Home — User Flows

## Information Architecture

Primary navigation:

- Home
- Tasks
- Orders
- Household
- Autopilot
- Wallet
- Settings

## Flow 1: Onboarding

### Goal
Get the user to first magic as fast as possible.

### Step 1: Hero screen
Headline:
Get your household brain back.

Subhead:
Connect your stores and we’ll rebuild how your home shops.

Primary CTA:
Get Started

### Step 2: Connect context
Supported inputs may include:
- email receipts
- retailer accounts
- payment method
- shipping address

System goal:
gather enough context to infer shopping behavior and preferences.

### Step 3: Set priorities
Prompt user to choose a default optimization style:
- cheapest
- balanced
- fastest

### Step 4: Starter rules
Prompt user to define initial boundaries:
- categories never allowed for auto-buy
- approval threshold
- preferred merchants
- blocked brands
- substitution comfort level

### Step 5: Household map
Show inferred or configured outputs:
- top repeat items
- top stores
- likely recurring categories
- recommended first action

Primary CTA:
Rebuild My Essentials Basket

### Onboarding success criteria
- user finishes setup in a few minutes
- user sees immediate value
- user begins first shopping action in-session

## Flow 2: Rebuild Household Basket

### Goal
Create the first magical proof that the system understands the household.

### Step 1: Detect common purchases
System surfaces likely household staples based on connected data or user seeding.

Examples:
- paper towels
- dish soap
- detergent
- cereal
- pet food

### Step 2: Confirm or edit staples
User can:
- keep item
- remove item
- change brand
- change pack size
- change quantity

### Step 3: Compare fulfillment options
System generates basket options and compares by:
- lowest delivered cost
- fastest arrival
- best trust and return profile

### Step 4: Explain recommendation
Each merchant route and major substitution should have a clear rationale.

Examples:
- chose Walmart because it arrives today and is 8 percent cheaper
- skipped third-party seller because your policy blocks weak return policies

### Step 5: Approve and buy
User reviews and approves purchase plan.

### Step 6: Trust unlock prompt
After success:
You’ve approved 5 household basics. Want me to watch these and reorder when needed?

## Flow 3: One-Sentence Delegated Purchase

### Goal
Deliver a high-wow experience from a natural-language intent.

### Example input
Buy me a new phone.

### System tasks
- identify category and intent
- retrieve relevant memory
- infer likely ecosystem preference
- infer budget range
- infer merchant and seller constraints
- infer urgency
- assess confidence
- ask at most 1 to 2 missing questions if necessary

### Example response
I found the most likely right fit based on your previous devices and usual budget. I recommend X from Y because it matches your preferred storage, arrives fastest, and avoids third-party sellers. I need one answer: do you want the same storage size or move up?

### Flow outcomes
- immediate recommendation
- minimal follow-up question
- approval and execution
- or fallback to explore if confidence is too low

## Flow 4: Autopilot Purchase

### Goal
Allow safe proactive buying in narrow categories where trust is earned.

### Trigger
System predicts likely need or detects restock threshold.

### Pre-execution checks
- trust level high enough for category
- policy allows automation
- spend within bounds
- merchant allowed
- price not anomalous
- reversibility acceptable

### Action
System executes purchase.

### Notification
Include:
- what was bought
- why it was bought
- where it was bought
- total price
- cancel window
- next-time feedback options

Example:
Bought paper towels from Walmart. Arrives tomorrow. You have 20 minutes to cancel.

### User controls
- cancel
- switch merchant
- choose cheaper option next time
- disable autopilot for this category
- report wrong choice

## Flow 5: Orders and Recovery

### Goal
Provide transparency and control after purchase.

### Orders screen
Display:
- order status
- merchant
- rationale summary
- cancelable until timestamp
- reversible/return status
- modify, return, and feedback actions

### Recovery states
- pending
- cancelable
- reversible
- irreversible

### Core recovery actions
- cancel purchase
- modify purchase
- swap variant
- request return or exchange
- mark as bad recommendation

## Flow 6: Household Management

### Goal
Store shared context for better shopping decisions.

### Household screen should support
- members
- roles
- brand preferences
- dietary or allergy rules
- kid sizes
- preferred stores
- blocked stores
- common staples

### Future collaboration
Later versions may support:
- shared approvals
- spouse/partner invites
- delegated approver roles

## Flow 7: Autopilot Management

### Goal
Make autonomy visible, bounded, and adjustable.

### Autopilot screen should show
- category trust ladder
- enabled categories
- recommended categories to unlock
- max spend rules
- stop window defaults
- recent autopilot performance

### User actions
- enable autopilot for category
- disable autopilot for category
- lower spend threshold
- require approval again
- inspect recent autonomous purchases

## Flow 8: Wallet and Authorization

### Goal
Make payment and delegated authorization understandable.

### Wallet screen should show
- payment methods
- shipping addresses
- merchant authorization scopes
- recent transaction log
- approval history
- spend limits

### User actions
- add payment method
- remove payment method
- change default payment method
- set category-specific spending rules
- view authorization and transaction audit history
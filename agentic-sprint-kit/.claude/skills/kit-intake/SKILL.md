---
description: "Phase 0: Read PROMPT.md and ask up to 10 clarifying questions"
---

# Kit Intake (Phase 0)

## Steps

1. Read `PROMPT.md` in the project root.
2. Read any files linked in section 9 (Existing context).
3. Identify gaps — prioritize in this order:

### Priority 1: User & product gaps (ask these first)
- Is the target user specific enough to design for? ("busy parents" > "people")
- Is the magic moment concrete? Can you picture what the screen looks like?
- Are success criteria measurable user outcomes, not features?
  ("user completes X in Y minutes" not "has a dashboard")
- Is the first user flow clear enough to build without guessing?
- What does the user do TODAY without this product? (the alternative)
- What would make the user stop using this and go back to the old way?
- Is the return/habit loop clear, or is this a one-shot tool?

### Priority 2: Scope & constraint gaps
- Contradictory requirements
- Ambiguous scope boundaries (what's in vs. out?)
- Missing non-negotiable constraints that would change the design
- Privacy, security, or compliance requirements not mentioned

### Priority 3: Technical gaps (ask only if essential)
- Missing auth/permission model (if the product has users)
- Integration points that aren't specified
- Data ownership or persistence requirements unclear
- Scale expectations that would change the architecture

4. Generate **at most 10** clarifying questions.
   - Lead with user/product questions (Priority 1)
   - Only include technical questions if they'd change the product experience
   - Each question should include a brief note on why it matters
5. Present questions numbered. Wait for answers.
6. Once answered, proceed to Phase 1 (spec generation) and continue through all
   remaining phases without stopping. Do NOT ask follow-up questions.
   If something is still ambiguous, it goes in docs/OPEN_QUESTIONS.md later.

## Output Format

```
Based on your PROMPT.md, I have [N] clarifying questions before I begin:

1. [Question — why it matters]
2. [Question — why it matters]
...

Answer these and I'll build the entire project autonomously from here.
```

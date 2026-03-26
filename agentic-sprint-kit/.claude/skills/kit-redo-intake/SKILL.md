---
description: "Phase 0 (Redo): Analyze existing project and generate PROMPT.md for a better rebuild"
---

# Kit Redo Intake (Phase 0 — Redo Mode)

You are rebuilding an existing project from scratch (or selectively reusing parts).
Your job is to deeply understand what exists, identify what's good, what's broken,
and what's missing — then produce a PROMPT.md that drives a better version.

## Inputs

The current working directory contains an existing project. You have access to
everything: source code, docs, config, tests, git history, dependencies.

## Steps

### 1. Deep Project Audit

Use agents to analyze the project in parallel:

**Agent 1: Architecture & Code Audit**
- Read all source files, understand the module structure
- Identify the tech stack, frameworks, dependencies
- Map the data model and API surface
- Note code quality issues, anti-patterns, dead code
- Identify what's well-built and worth preserving vs. what needs rework

**Agent 2: Product & UX Audit**
- Identify what the product does (user flows, features)
- Find the entry point and trace the first user experience
- Identify the target user and core value proposition
- Note UX friction, missing flows, confusing interactions
- Check for accessibility, responsive design, error handling

**Agent 3: Test & Quality Audit**
- Run existing tests (if any) and note results
- Check test coverage and what's untested
- Look for hardcoded values, security issues, missing validation
- Review build/deploy setup
- Check for outdated dependencies

### 2. Generate Analysis Report

Write `docs/REDO_ANALYSIS.md` in the NEW project directory with:

```markdown
# Redo Analysis

## Original Project Summary
- What it is (1-2 sentences)
- Tech stack
- Lines of code / file count
- Test coverage (if measurable)

## What Works Well (preserve or improve)
- [Feature/component] — why it's good
- ...

## What's Broken or Missing
- [Issue] — impact on user experience
- ...

## What Should Change
- [Architectural change] — why
- [UX change] — why
- [Tech stack change, if any] — why
- ...

## Reuse Recommendation
- **Start from scratch**: [yes/no]
- **Reuse these files/modules**: [list, or "none"]
- **Rationale**: [1-2 sentences]
```

### 3. Generate PROMPT.md

Based on your analysis, write a complete `PROMPT.md` in the NEW project directory
that describes the IMPROVED version. Fill all 10 sections:

1. **What are you building** — same product, but call out what's better
2. **Target user and pain** — inferred from the original
3. **Magic moment** — what should the first 60 seconds feel like
4. **Success criteria** — measurable, addressing gaps found in the audit
5. **User flows** — refined versions of what exists, plus any missing flows
6. **Return/habit loop** — inferred or flagged as missing
7. **Out of scope** — be aggressive about cutting scope to match original intent
8. **Non-negotiable requirements** — inferred from original constraints
9. **Existing context** — point to `docs/REDO_ANALYSIS.md` and list files worth reusing
10. **Tech preferences** — same stack unless the audit found a compelling reason to change

### 4. Ask Clarifying Questions

Present the analysis summary and PROMPT.md to the user, then ask up to 10
clarifying questions focused on:

**Priority 1: Direction confirmation**
- "The original app does X. Should the redo keep the same scope, or expand/reduce?"
- "I found these UX issues: [list]. Which matter most to fix?"
- "The current tech stack is [X]. Any reason to change it?"

**Priority 2: Quality bar**
- "Should this be a polished production app or a better prototype?"
- "Any features from the original that should be dropped entirely?"

**Priority 3: Reuse decisions**
- "I recommend [reusing/not reusing] the existing [code/assets]. Agree?"
- Only ask if the reuse decision is genuinely ambiguous

### 5. Set Up the New Project

The new project directory should already exist at `redo_<original_folder_name>/`
(created by the orchestrator before this phase runs). After the user answers:

- Finalize PROMPT.md with their answers
- Copy any files marked for reuse from the original project
- Proceed to Phase 1 (spec generation) in the new project directory

## Output Format

```
I've analyzed the existing project. Here's what I found:

**What it is**: [1 sentence]
**Tech stack**: [list]
**What works**: [2-3 bullet points]
**What needs fixing**: [2-3 bullet points]
**Reuse recommendation**: [start fresh / reuse X, Y, Z]

I've generated a PROMPT.md for the improved version. [N] questions before I rebuild:

1. [Question — why it matters]
2. [Question — why it matters]
...

Answer these and I'll build the improved version autonomously from here.
```

## Key Principles

- **Don't just copy** — understand WHY the original was built the way it was
- **Preserve what's good** — don't rebuild working things just because you can
- **Fix root causes** — if the original has problems, fix the architecture, not just symptoms
- **Same product, better execution** — this is a redo, not a redesign (unless user says otherwise)
- **The user knows best** — your analysis informs, but the user decides what to keep/change

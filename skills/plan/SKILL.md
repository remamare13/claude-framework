---
name: plan
description: Create implementation plan before code changes
user_invocable: true
---

# /plan — Think Before You Code

MANDATORY for tasks touching >3 files or adding new functionality.

## Arguments
- `$ARGUMENTS` — description of what needs to be done

## Steps

1. **Spawn planner agent** with task description
2. **Present plan** in plain language to user:
   - Files to change/create
   - Protected files involved
   - Downstream impact
   - Risk level
   - Step-by-step with test checkpoints
3. **Write regression test** (if modifying existing functionality) — BEFORE any changes
4. **Wait for approval** — do NOT start until user confirms
5. **Execute** — follow plan step by step, test after each step
6. **If something unexpected** — STOP, update plan, ask user

## Rules
- NEVER skip for tasks >3 files
- NEVER start coding before plan is approved
- Plans must include test checkpoints
- Maximum 10 steps per plan
- If plan changes mid-execution, update it before continuing

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
2. **Check dependency map** — read `.claude/memory/dependencies.md` for critical paths (if exists)
3. **Present plan** in plain language to user:
   - Files to change/create
   - Protected files involved (check `.claude/rules/protected-files.md` if exists)
   - Downstream impact (which files import the changed files)
   - Risk level (Low/Medium/High)
   - Step-by-step with test checkpoints
4. **Write regression test** (if modifying existing functionality) — BEFORE any changes
5. **Wait for approval** — do NOT start until user confirms
6. **Execute** — follow plan step by step, test after each step
7. **If something unexpected** — STOP, update plan, ask user

## Rules
- NEVER skip for tasks >3 files
- NEVER start coding before plan is approved
- Plans must include test checkpoints
- Maximum 10 steps per plan
- If plan changes mid-execution, update it before continuing

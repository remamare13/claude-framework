---
name: status
description: System state report — tests, git, config, server health
user_invocable: true
---

# /status — Full System State Report

## Steps

1. **Memory** — read `.claude/rules/memory.md` for state + known issues
2. **Git** — `git status --short`, `git log --oneline -5`, uncommitted count
3. **Tests** — `npm test`, pass/fail counts
4. **Server** — `curl -s localhost:$PORT/health` (only if already running)
5. **Modules** — list modules in `src/modules/` (if exists) and their state
6. **Dependencies** — read `.claude/memory/dependencies.md` for critical paths (if exists)
7. **Module status** — read `.claude/memory/module-status.md` for module tracking (if exists)
8. **System state** — read `SYSTEM_STATE.md` for last snapshot (if exists)
9. **Work plan** — read `WORK_PLAN.md` for current priorities (if exists)

## Output
Structured report with sections: state, git, tests, server, modules, dependencies, current work.

## Rules
- Read PORT from CLAUDE.md, don't hardcode
- Don't start server just for this check
- Flag critical issues prominently
- If optional files don't exist, skip those sections silently

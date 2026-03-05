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
5. **Modules** — list modules in `src/modules/` and their state
6. **Work plan** — read `WORK_PLAN.md` for current priorities

## Output
Structured report with sections: state, git, tests, server, modules, current work.

## Rules
- Read PORT from CLAUDE.md, don't hardcode
- Don't start server just for this check
- Flag critical issues prominently

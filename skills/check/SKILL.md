---
name: check
description: Quick health check — tests, server, git status (no agents, under 30s)
user_invocable: true
---

# /check — Quick Health Check

Fast check. No agents. Just the facts.

## Steps
1. `npm test` — pass/fail count
2. `curl -s --max-time 3 http://localhost:$PORT/health` — up/down
3. `git status --short | wc -l` + `git log --oneline -1`
4. Known issues from `.claude/rules/memory.md`

## Output
One-line verdict: "All good" or "Issues found — {details}"

## Rules
- No agents, no file modifications, under 30 seconds

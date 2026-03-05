---
name: test
description: Run tests and verify server health
user_invocable: true
---

# /test — Test Runner + Health Check

## Arguments
- `$ARGUMENTS` — optional: "unit", "integration", "all" (default), "boot", or specific file

## Steps

1. **Run tests** — `npm test` (or specific subset)
2. **Parse results** — total, passed, failed, skipped from node:test TAP output
3. **Boot check** (for "all" and "boot")
   - `node server.js &` → wait 3s → `curl -s --max-time 3 localhost:$PORT/health` → kill
   - Report: boots OK / fails
4. **Present results** — pass/fail, boot status, failure details
5. **Suggest fixes** for failures (read test + source files)

## Rules
- ALWAYS kill background server after boot check
- Read PORT from CLAUDE.md, don't hardcode
- Explain failures in plain language — user is not a developer

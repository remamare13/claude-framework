---
name: commit
description: Smart git commit with test validation, review, and auto-documentation
user_invocable: true
---

# /commit — Smart Commit Pipeline

## Arguments
- `$ARGUMENTS` — optional: commit message and/or flags
  - `--quick` — skip reviewer and doc agents (for <3 files)
  - `--full` — include boot check, system-documenter, spec report
  - No flag — auto-detect: <3 files = quick, 3+ = default (with reviewer)

## Modes

### --quick (small changes)
test → commit → memory-updater → tag → done

### default (3+ files)
test → reviewer → commit → memory-updater → tag → done

### --full (major changes)
test → boot check → reviewer → commit → memory-updater + system-documenter + spec-updater (parallel) → tag → done

## Steps

### Phase 1: Pre-commit

1. **Check staged changes**
   - `git status --short`
   - If nothing staged → show unstaged, ask what to stage
   - Never `git add -A` or `git add .` — specific files only
   - Count files → auto-detect mode

2. **Determine prefix**
   - Ask user if not obvious: `[CD]`, `[Donna]`, `[Marko]`
   - Project may configure prefixes in CLAUDE.md

3. **Run tests** — `npm test`
   - Fail → STOP, show failures, do NOT commit

4. **Boot check** (--full only)
   - `node server.js &` → wait 3s → `curl -s --max-time 3 localhost:$PORT/health` → kill
   - Fail → STOP

5. **Review** (default + --full)
   - Spawn `reviewer` agent on staged diff
   - HIGH issues → WARN user, ask to continue or fix
   - LOW/MEDIUM → note but continue

### Phase 2: Commit

6. **Commit message** — `{prefix} {type}: {description}`
7. **Create commit** — heredoc format, Co-Authored-By line
8. **Verify** — `git log --oneline -1` + `npm test`

### Phase 3: Auto-documentation

9. **Memory update** (ALL modes) — spawn `memory-updater`
10. **System state** (--full) — spawn `system-documenter` if available
11. **Spec report** (--full) — spawn `spec-updater` if available (REPORT only, ask before writing)

### Phase 4: Restart Services

12. **Restart project services** — if `scripts/restart.sh` exists, run it
    - This restarts the project server and any dependent services (e.g., OpenClaw gateway)
    - Wait for health checks to confirm services are UP
    - If restart fails → WARN user but continue (non-blocking)
    - If `scripts/restart.sh` does NOT exist → skip this phase silently

### Phase 5: Finalize

13. **Commit doc changes** — `[auto] Update memory and docs`
14. **Breakpoint tag** — `git tag stable-$(date +%Y%m%d-%H%M%S)`
15. **Summary + ask to push**

## Rules
- NEVER commit .env, data/, credentials, key files
- NEVER `git add -A` or `git add .`
- ALWAYS test before commit
- NEVER push without user confirmation

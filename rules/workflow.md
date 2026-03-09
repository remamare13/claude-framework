# Workflow Discipline — MANDATORY

These rules apply to EVERY coding session. No exceptions.

## Before ANY Change

1. **Run `npm test`** — if tests fail, fix them FIRST before doing anything else
2. **Read before writing** — never edit a file you haven't read in this session
3. **Check protected files** — see `rules/protected-files.md`. If your change touches a protected file, ASK the user first
4. **Check downstream deps** — before modifying a file, `grep -r "from.*filename" src/` to find importers

## During Changes

5. **One logical change at a time** — change → test → commit → next change
6. **Max 5 files between test runs** — after touching 5 files, STOP and run `npm test`
7. **Use /plan for big tasks** — anything touching >3 files or adding new functionality needs a plan first
8. **Never modify a file you haven't read in this session**

## After ANY Change

9. **Run `npm test` again** — confirm nothing broke
10. **Boot check for structural changes** — if you changed server.js, core/, or bridge/:
    `node server.js &` → `curl -s --max-time 3 http://localhost:$PORT/health` → kill
11. **Use /commit** — not raw git commit. /commit runs the full pipeline

## When Things Break

12. **Tests fail after your change → REVERT first** — `git checkout -- <files>`, then think about a different approach
13. **Server won't boot → check git diff** — identify what changed, revert to last known good state
14. **Multiple things broken → STOP** — ask the user before continuing

## Communication

15. **User is not a developer** — explain what you're doing and why in simple terms
16. **Ask before destructive actions** — deleting files, dropping tables, force-pushing
17. **Report status after each change** — "Changed X, tests pass, ready for next step"

## Hook Profiles

Hooks run in one of three profiles, controlled by `HOOK_PROFILE` env var (default: `standard`):

| Profile | Commit prefix check | Secrets guard | git add -A block | JS syntax check | Use when |
|---------|-------------------|---------------|-----------------|----------------|----------|
| `minimal` | Skipped | Active | Active | Active | Autonomous/night worker (`-p` flag) |
| `standard` | Active | Active | Active | Active | Normal interactive sessions |
| `strict` | Active | Active | Active | Active | Security-sensitive work (future) |

Set profile: `HOOK_PROFILE=minimal claude -p "task..."` or in settings.json env.

Security hooks (secrets, git add -A) are **always active** in all profiles — they cannot be disabled.

## After Compaction

When context is compacted, a SessionStart hook fires a reminder. After compaction:
1. Re-read `WORK_PLAN.md` (or equivalent) to restore task context
2. Check `git log --oneline -5` to see what was done before compaction
3. Check `git status` for any uncommitted changes
4. Continue where you left off — do not restart the task

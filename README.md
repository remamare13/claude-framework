# Claude Code Framework

Shared Claude Code infrastructure for consistent AI-assisted development across projects.

## What This Is

A standardized `.claude/` setup providing:
- **Workflow rules** — test before/after, read before write, dependency checking
- **Security rules** — no secrets to frontend, no PII in logs, parameterized queries, auth enforcement
- **Agents** — memory-updater, planner, reviewer, researcher, system-documenter, spec-updater
- **Skills** — /commit, /plan, /test, /check, /status
- **Hooks** — prevent accidental secret commits, enforce commit prefixes
- **Templates** — skeletons for project-specific files (memory, protected files, etc.)

## Quick Start

### New project
```bash
./init.sh /path/to/your/project
```

### Existing project (sync shared files)
```bash
./sync.sh /path/to/your/project
```

## Structure

```
claude-framework/
├── rules/
│   ├── workflow.md              ← Development discipline rules
│   └── security.md             ← Security rules (secrets, PII, frontend, DB)
├── agents/
│   ├── memory-updater.md        ← Auto-update memory after commits
│   ├── planner.md               ← Plan before coding
│   ├── reviewer.md              ← Code review
│   ├── researcher.md            ← Deep codebase + web research
│   ├── system-documenter.md     ← Generate SYSTEM_STATE.md snapshots
│   └── spec-updater.md          ← Keep docs/specs in sync with code
├── skills/
│   ├── commit/SKILL.md          ← Test → review → commit → memory update
│   ├── plan/SKILL.md            ← Create plan before changes
│   ├── test/SKILL.md            ← Run tests + boot check
│   ├── check/SKILL.md           ← Quick health check (no agents)
│   └── status/SKILL.md          ← Full system state report
├── settings.json                ← Security hooks
├── templates/                   ← Skeletons for project-specific files
│   ├── memory.md.template
│   ├── protected-files.md.template
│   ├── CLAUDE.local.md.template
│   ├── architecture.md.template
│   ├── dependencies.md.template
│   └── module-status.md.template
├── sync.sh                      ← Sync shared files to a project
└── init.sh                      ← Initialize new project with full setup
```

## What's Shared vs Project-Specific

| Shared (from this repo) | Project-Specific (stays in project) |
|--------------------------|--------------------------------------|
| `rules/workflow.md` | `rules/memory.md` — project state |
| `agents/*.md` | `rules/protected-files.md` — protected file list |
| `skills/*/SKILL.md` | `memory/*.md` — architecture, deps, modules |
| `settings.json` | `CLAUDE.local.md` — user preferences |
| | Domain-specific rules (e.g., `rules/openclaw.md`) |

## Skills

| Skill | Purpose | Speed |
|-------|---------|-------|
| `/commit` | Test → review → commit → memory update → tag | 30-60s |
| `/commit --quick` | Test → commit → memory update (small changes) | 15s |
| `/commit --full` | + boot check, system-documenter, spec-updater, tag | 2-3min |
| `/plan` | Create implementation plan before coding | 30s |
| `/test` | Run tests + server boot check | 15s |
| `/check` | Quick health: tests, server, git (no agents) | 10s |
| `/status` | Full system state report | 30s |

## Design Principles

1. **Everything in the project folder** — no `~/.claude/` dependencies
2. **Rules auto-load** — `.claude/rules/*.md` is always in context
3. **Memory persists** — `rules/memory.md` survives across sessions
4. **Test always** — before and after every change
5. **Plan first** — `/plan` before tasks >3 files
6. **Protected files** — explicit list of files that must not change without approval
7. **User is not a developer** — explain clearly, ask before destructive actions

## Projects Using This Framework

- NOTAR — Notary AI assistant
- ODVETNIK — Attorney AI assistant

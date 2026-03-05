---
name: AS
description: Set up a new OpenClaw agent with proper workspace, context injection, and gateway config
user_invocable: true
---

# /AS — Agent Setup for OpenClaw

Create or fix an OpenClaw agent with correct workspace structure, gateway config, and context injection.

## Arguments
- `$ARGUMENTS` — agent name and role description (e.g., "worker-pisrs — searches PISRS legislation database")

## Critical Knowledge: How OpenClaw Agents Work

### Context Injection
OpenClaw gateway auto-injects **only 2 files** into a sub-agent's system prompt:
- **AGENTS.md** — identity, instructions, rules, communication patterns
- **TOOLS.md** — available tools table

Other files (SOUL.md, IDENTITY.md, INSTRUCTIONS.md) are **NOT auto-injected**. They exist only for documentation. The agent can `read` them from workspace, but they won't be in the system prompt.

**This means:** ALL essential operational content MUST be in AGENTS.md. If it's not in AGENTS.md or TOOLS.md, the agent won't see it unless it explicitly reads a file.

### Workspace Path
The `workspace` field in `gateway-config.json` MUST point to the directory containing AGENTS.md and TOOLS.md. If the workspace directory is empty or missing these files, the agent runs with NO context.

### sessions_spawn (dispatching to sub-agents)
```json
{
  "task": "Description of what to do",
  "agentId": "worker-name",
  "label": "Short label for logs",
  "runTimeoutSeconds": 120
}
```
Returns immediately (non-blocking): `{status: "accepted", runId, childSessionKey}`

### Announce (result delivery)
When a sub-agent finishes, the gateway automatically delivers its result to the parent agent's chat as an internal context message containing Status, Result, and stats. No polling needed.

### Spawn Depth
- `agents.defaults.subagents.maxSpawnDepth` controls how deep agents can spawn
- Default: 1 (main can spawn workers, workers cannot spawn further)
- Set to 2 for coordinator patterns (main -> coordinator -> workers)

### allowAgents
Per-agent whitelist in `agents.list[].subagents.allowAgents` controls which agents can be spawned. Use `["*"]` for coordinators that need to spawn any agent.

## Steps

### 1. Determine agent type

| Type | AGENTS.md Focus | Spawns sub-agents? | Example |
|------|----------------|--------------------|---------|
| **Worker** | Domain expertise, step-by-step pipeline, iron rules | No | worker-pisrs, worker-email |
| **Coordinator** | Dispatch logic, result synthesis, worker management | Yes | research-coordinator |
| **Personal** | User preferences, communication style | Maybe | dona-nina, dona-luka |

### 2. Create agent directory

```
openclaw/agents/{agent-name}/
  AGENTS.md    ← AUTO-INJECTED (required, main operational file)
  TOOLS.md     ← AUTO-INJECTED (required, tool reference)
  IDENTITY.md  ← Documentation only (NOT injected)
  SOUL.md      ← Documentation only (NOT injected)
  INSTRUCTIONS.md ← Documentation only (NOT injected)
```

### 3. Write AGENTS.md

Use the appropriate template below.

**For workers:**
```markdown
# {agent-name} — Operating Manual

## Identity
You are **{agent-name}**, the [role description] for [organization].
You [do X]. You do NOT [do Y] — that's other workers' job.

## How to Process Requests

### Step 1: Parse the Task
[What to extract from the task description]

### Step 2: Execute
[Step-by-step instructions using available tools]

### Step 3: Format Results
[Expected output format with examples]

### Step 4: Respond
[What to include in the response]

## Tool Reference
[Input/output examples for each exec tool]

## Iron Rules
1. [Scope constraint — what you ONLY do]
2. [Source attribution — always include links/references]
3. [No fabrication — never invent data]
4. [Tool priority — exec tools first, browser as fallback]
5. [Language — respond in [language] for [content type]]

## Error Handling
- Tool fails: [retry strategy]
- Source down: [report explicitly]
- No results: [say so, don't invent]

## Communication
- Receive tasks from [parent] via sessions_spawn
- Return results via announce (automatic)
```

**For coordinators:**
```markdown
# {agent-name} — Operating Manual

## Identity
You are **{agent-name}**, the [role] for [organization].
You are a COORDINATOR — you do NOT [do the work] yourself.
You dispatch to workers, collect results, and synthesize.

## Your Workers
| Worker | Source | What They Do |
|--------|--------|-------------|
| worker-x | [source] | [description] |
| worker-y | [source] | [description] |

## How to Process Requests

### Step 1: Analyze the Query
[What to identify from the incoming request]

### Step 2: Dispatch Workers
Spawn workers in PARALLEL using sessions_spawn.
[Task format for each worker]
Use runTimeoutSeconds: 120 for all workers.

### Step 3: Collect Results
Wait for announce messages from workers.
If a worker times out: synthesize from available results.
If all workers time out: report failure.

### Step 4: Synthesize
[Output format template]

### Step 5: Return
Your synthesized report is delivered via announce.

## Iron Rules
1. NEVER do the work yourself — dispatch to workers.
2. ALWAYS dispatch to ALL relevant workers.
3. [Additional domain-specific rules]

## Communication
- [Parent] -> you: Requests
- You -> workers: sessions_spawn tasks
- Workers -> you: Results via announce
- You -> [parent]: Synthesized report via announce
```

### 4. Write TOOLS.md

```markdown
# {agent-name} — Available Tools

## Exec Tools (primary)
| Tool | Command | Description |
|------|---------|-------------|
| [name] | `exec {script}.js '{"param": "..."}'` | [what it does] |

## External Tools (fallback only)
| Tool | Description |
|------|-------------|
| web_search | [when to use] |
| browser | [when to use — fallback only] |

## Workspace Tools
| Tool | Description |
|------|-------------|
| read | Read files from workspace |
| write | Write files to workspace |
| message | Send messages to channels |
```

For coordinators, add dispatch tools:
```markdown
## Dispatch Tools
| Tool | Description |
|------|-------------|
| sessions_spawn | Spawn a worker with a task. Non-blocking. Results via announce. |
| sessions_list | List active sub-agent sessions. |
| sessions_history | Read a sub-agent's transcript. |
```

### 5. Register in gateway-config.json

Add to `agents.list[]`:
```json
{
  "id": "{agent-name}",
  "name": "{Display Name}",
  "workspace": "/absolute/path/to/openclaw/agents/{agent-name}",
  "tools": {
    "allow": ["read", "write", "message", "exec", ...]
  }
}
```

For coordinators, add spawn tools: `"sessions_spawn", "sessions_list", "sessions_history"`
For workers with web access: `"web_search", "web_fetch", "browser"`

If this agent needs to spawn sub-agents:
```json
{
  "id": "{agent-name}",
  "subagents": {
    "allowAgents": ["worker-x", "worker-y"]
  }
}
```

### 6. Register in openclaw.json (if used)

Add to agent roster with tools, skills, phase.

### 7. Update MCP tool allowlists

If your agent calls MCP tools via exec, add the agent name to `allowedAgents` arrays in the relevant `mcp-tools.js` file.

### 8. Update parent agent dispatch

If a coordinator dispatches to this new agent, update the coordinator's:
- AGENTS.md (worker table, dispatch rules)
- SOUL.md (if it has dispatch documentation)

### 9. Verify

Checklist:
- [ ] AGENTS.md exists in agent directory
- [ ] TOOLS.md exists in agent directory
- [ ] Workspace path in gateway-config.json points to agent directory
- [ ] Agent added to gateway-config.json agents.list[]
- [ ] Tools listed in gateway-config match what TOOLS.md documents
- [ ] If coordinator: maxSpawnDepth >= 2 in agents.defaults.subagents
- [ ] If coordinator: allowAgents configured
- [ ] MCP tool allowedAgents updated (if agent uses exec tools)
- [ ] Parent agent dispatch rules updated
- [ ] Gateway restarted after config changes

## Common Mistakes

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| Workspace points to empty directory | Agent runs with NO context | Point workspace to directory with AGENTS.md |
| Essential content in SOUL.md only | Agent never sees it | Put operational content in AGENTS.md |
| Missing TOOLS.md | Agent doesn't know its tools | Create TOOLS.md with tool table |
| maxSpawnDepth: 1 with coordinator pattern | Coordinator's workers can't be spawned | Set maxSpawnDepth: 2 |
| Missing allowedAgents in mcp-tools.js | Agent's exec tool calls are rejected | Add agent to allowedAgents array |
| Workspace path is relative | Gateway can't find directory | Use absolute path |

## Rules
- ALWAYS create both AGENTS.md and TOOLS.md — they are the ONLY auto-injected files
- ALWAYS use absolute paths for workspace in gateway-config.json
- ALWAYS restart the gateway after config changes
- NEVER put essential operational content only in SOUL.md or INSTRUCTIONS.md — it won't be injected
- Test the agent after setup — send a task and verify it has context

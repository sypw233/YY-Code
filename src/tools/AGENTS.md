# Tools Module

## Overview
53 tool implementations. Each tool is a self-contained PascalCase directory registered in `src/tools.ts`.

## Structure
```
tools/
├── AgentTool/          # Most complex tool (14 files, sub-agents, forking)
│   ├── AgentTool.tsx   # Main implementation
│   ├── prompt.ts       # Tool prompt/description
│   ├── UI.tsx          # Ink rendering
│   └── builtInAgents/  # Sub-agent definitions
├── BashTool/           # Security-critical (18 files)
│   ├── BashTool.tsx
│   ├── bashSecurity.ts # Command safety validation
│   ├── bashPermissions.ts
│   └── sedValidation.ts
├── FileEditTool/       # Standard pattern (6 files)
│   ├── FileEditTool.ts
│   ├── prompt.ts
│   ├── UI.tsx
│   ├── utils.ts
│   ├── constants.ts
│   └── types.ts
└── ...                 # 50 more tools
```

## Conventions

### Directory Naming
- PascalCase matching the tool name: `BashTool/`, `FileEditTool/`, `AgentTool/`
- Never use kebab-case for tool directories

### File Pattern
Each tool directory follows this pattern (not all files required):
- `{ToolName}.tsx` or `{ToolName}.ts` — Main implementation, exports the tool definition
- `prompt.ts` — Tool description/prompt shown to the model
- `UI.tsx` — Ink component for rendering tool output in the terminal
- `utils.ts` — Helper functions
- `constants.ts` — Magic numbers, config values
- `types.ts` — TypeScript type definitions

### Registration
All tools are registered in `src/tools.ts`. Tools are conditionally loaded based on feature flags and USER_TYPE. Adding a new tool requires:
1. Create the directory with implementation
2. Import and register in `src/tools.ts`
3. Add feature gate if needed: `feature('FLAG_NAME') && import('./tools/NewTool')`

### Security-Sensitive Tools
These tools require extra care — they can execute arbitrary code or modify the filesystem:
- **BashTool** — Command execution with security validation (`bashSecurity.ts`)
- **PowerShellTool** — Windows PowerShell execution
- **FileEditTool** / **FileWriteTool** — Filesystem modification
- **AgentTool** — Sub-agent spawning (inherits all parent permissions)
- **MCPTool** — External MCP server interaction

When modifying security-sensitive tools, always review the validation logic in the tool's security files.

### Tool vs Command
- **Tools** (`src/tools/`): Model-callable capabilities (Bash, FileEdit, Agent, etc.)
- **Commands** (`src/commands/`): User-invokable slash commands (`/compact`, `/config`, etc.)
- Tools are registered in `src/tools.ts`; commands in `src/commands.ts`

## Where To Look

| Task | Location |
|------|----------|
| Add a new tool | Create `src/tools/NewTool/NewTool.tsx`, register in `src/tools.ts` |
| Modify bash security | `src/tools/BashTool/bashSecurity.ts` |
| Change agent behavior | `src/tools/AgentTool/runAgent.ts`, `src/tools/AgentTool/prompt.ts` |
| Tool type definitions | `src/Tool.ts` |
| Tool registration | `src/tools.ts` |

## Anti-Patterns
- Do NOT add tools without security validation for anything that executes code or modifies files
- Do NOT bypass `bashSecurity.ts` checks — even for "safe" commands
- Do NOT register tools in `src/tools.ts` without proper feature gating
- Tool directories must NOT use kebab-case (use PascalCase to match the tool name)

# Commands Module

## Overview
87 slash command implementations. Each command is a kebab-case directory registered in `src/commands.ts`.

## Structure
```
commands/
├── compact/            # Standard pattern
│   ├── index.ts        # Barrel export
│   └── compact.ts      # Implementation
├── config/             # With UI
│   ├── index.ts
│   └── config.tsx
├── doctor/             # Diagnostic command
│   ├── index.ts
│   └── doctor.tsx
├── install-slack-app/  # Multi-file command
│   ├── index.ts
│   └── ...
├── commit.ts           # Root-level single-file command
├── commit-push-pr.ts   # Root-level single-file command
└── ...                 # 85+ more commands
```

## Conventions

### Directory Naming
- kebab-case: `install-slack-app/`, `init-verifiers/`, `debug-tool-call/`
- Never use PascalCase for command directories

### File Pattern
Each command directory follows this pattern:
- `index.ts` — Barrel export (re-exports from main file)
- `{command-name}.tsx` or `{command-name}.ts` — Main implementation

Single-file commands (like `commit.ts`, `review.ts`) live directly in `src/commands/` without a subdirectory.

### Registration
All commands are registered in `src/commands.ts`. Commands are conditionally loaded based on feature flags and USER_TYPE. Adding a new command requires:
1. Create the directory with `index.ts` barrel
2. Import and register in `src/commands.ts`
3. Add feature gate if needed: `feature('FLAG_NAME') && import('./commands/new-command')`

### Feature-Gated vs Always-On
- **Always-on**: `compact`, `config`, `doctor`, `diff`, `exit`, `help`, `clear`
- **Feature-gated**: `buddy` (`BUDDY`), `proactive` (`PROACTIVE`/`KAIROS`), `bridge` (`BRIDGE_MODE`), `voice` (`VOICE_MODE`), `ultraplan` (`ULTRAPLAN`)
- **Internal-only** (`USER_TYPE === 'ant'`): `teleport`, `bughunter`, `mock-limits`, `ctx_viz`, `break-cache`, `ant-trace`, `good-claude`, `agents-platform`, `autofix-pr`, `debug-tool-call`, `reset-limits`

### Import Ordering (Critical)
Commands in `src/commands.ts` are imported in a specific order. The file has a `biome-ignore-all` directive to prevent auto-reordering. When adding commands:
- Add to the correct section (feature-gated vs always-on)
- Do NOT reorder existing imports
- The `// biome-ignore-all assist/source/organizeImports` comment is load-bearing

## Where To Look

| Task | Location |
|------|----------|
| Add a new command | Create `src/commands/new-command/index.ts`, register in `src/commands.ts` |
| See all command registrations | `src/commands.ts` |
| Command type definitions | `src/commands.ts` (inline types) |
| Feature flag gating | `src/commands.ts` (conditional imports) |
| Git-related commands | `src/commands/commit.ts`, `src/commands/commit-push-pr.ts` |
| Security review | `src/commands/security-review.ts` |

## Anti-Patterns
- Do NOT add commands without feature gating if they use experimental features
- Do NOT reorder imports in `src/commands.ts` — the order is intentional and protected by biome-ignore
- Do NOT use PascalCase for command directory names (use kebab-case)
- Do NOT add "warmup" logic to command initialization
- Commands that execute git must follow the git safety rules in the root AGENTS.md

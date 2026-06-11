# Repository Guidelines

## Project Structure & Module Organization
Core source lives in `src/`. Entry points and CLI wiring are under files such as `src/dev-entry.ts`, `src/main.tsx`, and `src/commands.ts`. Feature code is grouped by area in folders like `src/commands/`, `src/services/`, `src/components/`, `src/tools/`, and `src/utils/`. Restored or compatibility code also appears in `vendor/` and local package shims in `shims/`. There is no dedicated `test/` directory in the restored tree today; treat focused validation near the changed module as the default.

## Build, Test, and Development Commands
Use Bun for local development.

- `bun install`: install dependencies and local shim packages.
- `bun run dev`: start the restored CLI entrypoint interactively.
- `bun run start`: alias for the development entrypoint.
- `bun run version`: verify the CLI boots and prints its version.

If you change TypeScript modules, run the relevant command above and verify the affected flow manually. This repository does not currently expose a first-class `lint` or `test` script in `package.json`.

## Coding Style & Naming Conventions
The codebase is TypeScript-first with ESM imports and `react-jsx`. Match the surrounding file style exactly: many files omit semicolons, use single quotes, and prefer descriptive camelCase for variables and functions, PascalCase for React components and manager classes, and kebab-case for command folders such as `src/commands/install-slack-app/`. Keep imports stable when comments warn against reordering. Prefer small, focused modules over broad utility dumps.

## Testing Guidelines
There is no consolidated automated test suite configured at the repository root yet. For contributor changes, use targeted runtime checks:

- boot the CLI with `bun run dev`
- smoke-test version output with `bun run version`
- exercise the specific command, service, or UI path you changed

When adding tests, place them close to the feature they cover and name them after the module or behavior under test.

## Commit & Pull Request Guidelines
Git history currently starts with a single `first commit`, so no strong conventional pattern is established. Use short, imperative commit subjects, for example `Fix MCP config normalization`. Pull requests should explain the user-visible impact, note restoration-specific tradeoffs, list validation steps, and include screenshots only for TUI/UI changes.

## Restoration Notes
This is a reconstructed source tree, not pristine upstream. Prefer minimal, auditable changes, and document any workaround added because a module was restored with fallbacks or shim behavior.

## Feature Flag System
Three layers of feature gating control what code is active:

1. **Compile-time flags** (`bun:bundle` `feature()` macro): ~83 flags across 196 files. In restored dev workspace these execute at runtime; in production builds, dead code is eliminated. Examples: `feature('KAIROS')`, `feature('BUDDY')`, `feature('COORDINATOR_MODE')`.
2. **User type** (`USER_TYPE` env): `'ant'` (Anthropic internal) unlocks 200+ internal features; `'external'` is the public build.
3. **GrowthBook remote flags**: Runtime A/B tests (e.g., `tengu_kairos`, `tengu_ultraplan_model`). Internal users refresh every 20 min, external every 6 hours.

When adding feature-gated code, use `feature('FLAG_NAME')` from `'bun:bundle'`. Never bypass the flag system with direct env checks for features that should be flag-controlled.

## Build-Time Macros
`globalThis.MACRO` is injected at bundle time. In dev mode, `dev-entry.ts` sets defaults:
- `MACRO.VERSION` → `"999.0.0-restored"` (from package.json)
- `MACRO.BUILD_TIME`, `MACRO.PACKAGE_URL`, etc. → placeholder strings

Never read `MACRO.*` before `dev-entry.ts` runs (initialization ordering constraint).

## Shim Packages
7 local `file:` dependencies in `shims/` replace unavailable native NAPI modules and internal Anthropic packages:
- `color-diff-napi`, `modifiers-napi`, `url-handler-napi` — pure TS stubs
- `@ant/claude-for-chrome-mcp`, `@ant/computer-use-input`, `@ant/computer-use-mcp`, `@ant/computer-use-swift` — internal Anthropic packages

These are stubs; some features (image processing, audio capture) are non-functional without real native binaries.

## Critical Anti-Patterns (DO NOT VIOLATE)

### Initialization Ordering (setup.ts)
```
1. setCwd()           — MUST be first; everything depends on cwd
2. loadHooks()        — MUST be after setCwd(); hooks load from cwd-relative paths
3. getCommands()      — MUST be after loadHooks(); /eject won't be available otherwise
```

### Model Quality Guards (thinking.ts)
- Do NOT change thinking/adaptive-thinking defaults without notifying the model launch DRI
- Do NOT default `thinkingEnabled` to `false` for first-party models — silently degrades quality

### Token Function Misuse (tokens.ts)
- `messageTokenCountFromLastAPIResponse()` returns OUTPUT tokens only
- For threshold comparisons (autocompact, session memory), use `tokenCountWithEstimation()` instead

### Global State (bootstrap/state.ts)
- `// DO NOT ADD MORE STATE HERE - BE JUDICIOUS WITH GLOBAL STATE`
- The State type is the single source of truth for session-wide values

### Startup (sessionStart.ts)
- `// do not add ANY "warmup" logic. It is CRITICAL that you do not add extra work on startup.`

### Transcript Integrity (sessionStorage.ts)
- Progress messages are NOT transcript messages — never persist to JSONL or parentUuid chain
- Including progress messages caused chain forks that orphaned real messages (see #14373, #23537)

### Git Safety (commands/commit.ts)
- NEVER update git config, skip hooks, or use `--amend` unless explicitly requested
- NEVER commit files that likely contain secrets

### Sanitization (utils/sanitization.ts)
- HTML/script sanitization is ALWAYS enabled — never disable (HackerOne #3086545)

## Deprecated Function Patterns
Functions ending in `_DEPRECATED` are tech debt with known replacements:

| Deprecated | Replacement |
|-----------|-------------|
| `getSettings_DEPRECATED()` | `getInitialSettings()` |
| `writeFileSync_DEPRECATED()` | `fs.promises.writeFile` |
| `execSync_DEPRECATED()` | `execa` with `{ shell: true, reject: false }` |
| `splitCommand_DEPRECATED()` | Tree-sitter parser |
| `bashCommandIsSafe_DEPRECATED()` | Tree-sitter based parser |

Prefer the modern replacement for any new code.

## Custom ESLint Rules (Documented, Not Enforced Locally)
The upstream Anthropic build enforces these via custom ESLint rules. They are documented here via `eslint-disable` comments in source:

- `custom-rules/no-sync-fs` — Forbid synchronous filesystem operations
- `custom-rules/no-process-exit` — Forbid direct `process.exit()` calls
- `custom-rules/no-process-env-top-level` — Forbid top-level `process.env` reads
- `custom-rules/no-top-level-side-effects` — Forbid side-effects at module top-level
- `custom-rules/no-lookbehind-regex` — Forbid lookbehind regex (performance)
- `custom-rules/prefer-use-keybindings` — Prefer keybinding hook over raw input

When writing new code, follow these rules even though they are not locally enforced.

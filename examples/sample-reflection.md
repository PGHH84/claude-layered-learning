# Reflection: Last 10 Entries

**Generated**: 2025-01-20 10:15:00
**Entries Analyzed**: 10
**Date Range**: 2025-01-10 to 2025-01-18
**Projects**: my-react-app, cli-tool, data-pipeline

## Summary

Analyzed 10 diary entries spanning 8 days across 3 different projects. Strong patterns emerged around TypeScript preferences, React coding style, testing practices, and error handling approaches.

The user demonstrates consistent preferences for type safety, modern patterns (functional components, custom hooks, composition over inheritance), comprehensive error handling, and testing before commits.

## Patterns Identified

### A. Persistent Preferences (3+ = high confidence)

1. **TypeScript Strict Mode** (8/10 entries)
   - **Observation**: User consistently enables and enforces strict mode across all projects
   - **Confidence**: High
   - **CLAUDE.md rule**: `- TypeScript: always enable strict mode, no 'any' types, explicit return types`

2. **Functional React Components** (7/8 React sessions)
   - **Observation**: Always functional components with hooks, never class components
   - **Confidence**: High
   - **CLAUDE.md rule**: `- React: functional components only, prefer custom hooks for reusable logic`

3. **Explicit Error Handling** (6/10 entries)
   - **Observation**: Errors must be surfaced, not silently caught
   - **Confidence**: High
   - **CLAUDE.md rule**: `- Error handling: try-catch around async ops, never empty catch blocks, surface errors in UI`

4. **Testing Before Commits** (5/10 entries)
   - **Observation**: Always run tests before committing, blocked commit when tests failed
   - **Confidence**: High
   - **CLAUDE.md rule**: `- Always run test suite before committing, never commit with failing tests`

5. **DRY / Code Reuse** (4/10 entries)
   - **Observation**: Extract repeated logic into reusable functions/hooks
   - **Confidence**: Medium
   - **CLAUDE.md rule**: `- Extract repeated logic into functions or custom hooks when used 3+ times`

### B. Design Decisions That Worked

1. **Incremental Development**
   - **What worked**: Building features incrementally with frequent testing
   - **Why**: Caught errors early, easier to debug

2. **Type-First API Design**
   - **What worked**: Defining TypeScript interfaces before implementation
   - **Why**: Clearer contracts, better autocomplete, caught integration issues early

3. **Custom Hooks for Logic Encapsulation**
   - **What worked**: Extracting complex logic into custom hooks (useAuth, useApi, useForm)
   - **Why**: Reusable, testable in isolation, cleaner components

### C. Anti-Patterns to Avoid (2+)

1. **Direct State Mutation** (2/10 entries)
   - **What to do instead**: Use spread operator or array methods that return new references
   - **CLAUDE.md rule**: `- React state: never mutate directly, always create new references`

2. **Using 'any' as a Shortcut** (2/10 entries)
   - **What to do instead**: Use 'unknown' and type guards, or define proper types
   - **CLAUDE.md rule**: `- TypeScript: use 'unknown' or proper types instead of 'any'`

3. **Empty Catch Blocks** (2/10 entries)
   - **What to do instead**: Always log errors and/or surface them to users
   - **CLAUDE.md rule**: `- Never use empty catch blocks, always log and handle errors`

4. **Missing useEffect Dependencies** (2/10 entries)
   - **What to do instead**: Include all dependencies, use ESLint rule
   - **CLAUDE.md rule**: `- React: include all dependencies in useEffect, use exhaustive-deps lint rule`

### D. Efficiency Lessons

1. **Context-first approach over JSONL parsing** for diary entries saves tool calls

### E. Project-Specific Patterns

1. **React State Management** (for React projects)
   - **Target file**: `my-react-app/CLAUDE.md`
   - **Rule to add**: `- Use React Context for global state, useState for local, avoid Redux unless requested`

2. **CLI Tool Structure** (for Node.js CLI projects)
   - **Target file**: `cli-tool/CLAUDE.md`
   - **Rule to add**: `- Use Commander.js for CLI parsing, chalk for colored output, include --help and --version`

## One-Off Observations

- Session 3: User preferred axios over fetch for HTTP requests
- Session 7: User requested progress bars for long-running operations
- Session 8: User mentioned preferring CSS modules over styled-components
- Session 10: User wanted environment variables validated at startup

## Proposed CLAUDE.md Updates

### new GLOBAL rule (for `~/.claude/CLAUDE.md`)

#### Section: TypeScript Standards
- Always enable strict mode in tsconfig.json
- Never use 'any' types — use 'unknown' or define proper types
- Require explicit return types on functions

#### Section: Error Handling
- Wrap async operations in try-catch
- Never use empty catch blocks
- Log errors with context (what failed, relevant IDs)
- Surface user-facing errors in UI

#### Section: Code Quality
- Run test suite before committing, never commit with failing tests
- Extract repeated logic into functions when used 3+ times

### new PROJECT-SPECIFIC rule (for project CLAUDE.md files)

#### Project: my-react-app
**Target file**: `my-react-app/CLAUDE.md`
- Functional components only, never class components
- React Context for global state, useState for local
- Custom hooks for reusable stateful logic
- Never mutate state directly

## Metadata
- **Diary entries analyzed**: 10 entries (2025-01-10 to 2025-01-18)
- **Projects covered**: my-react-app, cli-tool, data-pipeline
- **Challenges documented**: 24
- **Pattern confidence**: 5 high, 1 medium, 1 low
- **Anti-patterns identified**: 4

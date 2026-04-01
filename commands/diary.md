---
description: Create a structured diary entry from the current session
---

# Create Diary Entry

Capture a structured diary entry documenting the current Claude Code session.
This entry is raw material for `/reflect` to mine later for cross-session
patterns. It is not analyzed or routed here.

## Approach: Context-First Strategy

**Primary method (use this first):**
Reflect on the conversation history loaded in this session. You have access to:

- user messages and requests
- your responses and tool invocations
- files you read, edited, or wrote
- errors encountered and solutions applied
- design decisions discussed
- user preferences expressed

**When to use JSONL fallback (rare):**

- session was compacted and context is incomplete
- you need precise statistics such as exact tool counts or timestamps
- the user explicitly requests detailed session analysis

## Runtime Paths

- diary output: `~/.claude/memory/diary/YYYY-MM-DD-<project-slug>-session-N.md`
- project memory that may already exist: `~/.claude/projects/<slug>/memory/MEMORY.md`

## Path-To-Slug Transform

Use this exact transform so `/diary`, `/reflect`, `wrap-up`, and the PreCompact
hook agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. If that repo root contains `/.worktrees/`, strip the `/.worktrees/<name>` suffix and use the parent repo path as the canonical project root.
3. Otherwise, if not inside a git repository, use the canonical absolute working directory.
4. Resolve symlinks before deriving the slug.
5. Replace every `/` in the canonical absolute path with `-`.

## Session Number Source of Truth

Use one source of truth for the session number so `wrap-up` and standalone
`/diary` do not diverge.

- preferred source of truth: `~/.claude/projects/<slug>/memory/MEMORY.md`
- fallback: scan matching diary files for the same project and date only when `MEMORY.md` is missing or uninitialized
- if `wrap-up` already updated `MEMORY.md`, reuse that session number instead of incrementing again
- include a `Session ID` line only when a runtime session identifier is actually available

## Steps

### 1. Create diary entry from context

Review the current conversation and create the diary entry from what happened.
No tool invocations are needed for typical sessions.

### 2. Fallback: Locate session transcript

If context is insufficient, find the transcript using the shared canonical
project root before deriving the transcript directory. Use the canonical path,
not `basename "$(pwd)"`, and keep the worktree-collapse rule.

### 3. Create the diary entry

Use this exact template:

```markdown
# Session Diary Entry

**Date**: YYYY-MM-DD
**Time**: HH:MM:SS
**Project**: <canonical absolute project root path>
**Git Branch**: <branch or n/a>
**Session**: N
**Session ID**: <optional when available>

## Task Summary
...

## Time
- Session timing:
- Sequence or milestones:

## Work Summary
- ...

## Design Decisions Made
- ...

## Actions Taken
- Files created:
- Files edited:
- Commands executed:
- Verification performed:

## Challenges Encountered
- ...

## Solutions Applied
- ...

## User Preferences Observed

### Communication & Workflow
- ...

### Code Quality Preferences
- ...

### Technical Preferences
- ...

## Code Patterns and Decisions
- ...

## Context and Technologies
- ...

## Notes
- ...
```

### 4. Save the diary entry

Write the diary entry to:

- `~/.claude/memory/diary/YYYY-MM-DD-<project-slug>-session-N.md`

The filename must use the shared canonical project-root slug, not the basename
of the current directory.

### 5. Confirm completion

Display:

- the path where the diary was saved
- a brief one-line summary of what was captured

## Data Security

Apply the same PII rules as the project's instruction files. Do not include raw
financial amounts, IBANs, merchant names, or personal identifiers in diary
entries. Use redacted or generic descriptions instead.

## Guidelines

- be factual and specific — include concrete details when available
- capture the "why" behind decisions, not just the "what"
- document user preferences observed, especially around workflow and style
- include failures — what did not work is valuable learning material
- keep it structured — follow the template consistently
- use context first — only parse JSONL when truly necessary
- if context is incomplete, say so instead of inventing details

## Error Handling

- if context seems incomplete, mention what is missing and offer JSONL fallback
- if uncertain about details, document the uncertainty instead of fabricating precision
- if no branch is available, use `n/a`
- if no session identifier is available, omit `Session ID`

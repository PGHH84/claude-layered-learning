---
description: Analyze diary entries to identify cross-session patterns and propose durable updates to repo PROJECT.md and canonical global instructions
---

# Reflect on Diary Entries and Synthesize Insights

Analyze accumulated diary entries to identify recurring patterns across sessions
and projects, then route durable learnings to the canonical local or global
instruction source.

`/reflect`:

- reads diary entries and supporting memory
- identifies repeated patterns, rule violations, contradictions, and one-off observations
- proposes durable promotions to repo `PROJECT.md` or `~/.agents/global/PROJECT.md`
- applies approved durable promotions in the same reflection flow

## Parameters

The user can provide:

- **Date range**: "from YYYY-MM-DD to YYYY-MM-DD" or "last N days"
- **Entry count**: "last N entries" (for example "last 10 entries")
- **Project filter**: "for project [project-path]"
- **Pattern filter**: "related to [keyword]"

Default: analyze **all unprocessed diary entries**.

## Runtime Paths

- diary input: `~/.claude/memory/diary/`
- reflections: `~/.claude/memory/reflections/`
- processed index: `~/.claude/memory/reflections/processed.log`
- project memory: `~/.claude/projects/<slug>/memory/MEMORY.md`
- project operating guidance source: repo `PROJECT.md`
- global operating guidance source: `~/.agents/global/PROJECT.md`
- generated global mirrors: `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`

## Path-To-Slug Transform

Use this exact transform so `/reflect`, `/diary`, `wrap-up`, and the PreCompact
hook agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. If that repo root contains `/.worktrees/`, strip the `/.worktrees/<name>` suffix and use the parent repo path as the canonical project root.
3. Otherwise, if not inside a git repository, use the canonical absolute working directory.
4. Resolve symlinks before deriving the slug.
5. Replace every `/` in the canonical absolute path with `-`.

## Processing Workflow

1. Resolve the filter set and project slug mapping using the shared path-derived slug rule.
2. Load matching diary entries from `~/.claude/memory/diary/`.
3. Skip entries already listed in `processed.log` unless the user explicitly requests reprocessing.
4. Read supporting context relevant to the filtered corpus:
   - recent reflections
   - `~/.claude/memory/reflections/processed.log`
   - project `~/.claude/projects/<slug>/memory/MEMORY.md` when project context is relevant
   - repo `PROJECT.md` when project operating-guidance candidates are being considered
   - canonical global `~/.agents/global/PROJECT.md` when evaluating global promotion candidates
5. Group repeated patterns, explicit rule violations, contradictions, and one-off observations.
6. Carry forward recent one-off observations from prior reflections when the same signal reappears.
7. Prioritize repeated violation of existing guidance over inventing a new rule.
8. Route each repeated learning by scope and destination, strengthening weak existing guidance before proposing a brand-new durable rule.
9. Write the reflection file to `~/.claude/memory/reflections/YYYY-MM-DD-reflection-N.md`.
10. Present proposed durable edits with destination, evidence, and confidence.
11. If the user approves any durable edits, apply them in the same flow.
12. If approved global canonical edits were applied, run `~/.agents/global/sync_global_instructions.sh`.
13. Update `processed.log` only after the user accepts the reflection pass as complete and any approved durable edits for that pass were applied.

## Carry-Forward Rule

- read recent `One-Off Observations` before scoring new patterns
- if a current signal matches a recent one-off observation, count that prior occurrence toward the current confidence threshold
- use carry-forward only for clearly similar signals
- note the carry-forward when it materially affects confidence

## Rule Violation Priority

- check whether diary entries show the agent violating an existing global rule or project rule
- repeated violation of an existing rule is higher priority than inventing a new rule
- if patterns are contradictory, surface the contradiction instead of forcing a confident promotion

## Scope Routing

Use deterministic routing first and judgment only for edge cases.

### Project-Specific Signals

- mentions repo-specific paths, commands, services, architecture, or quirks
- appears only inside one project corpus
- would look out of place in unrelated projects

### Global Signals

- applies to behavior across repositories
- repeats across multiple projects or sessions
- reads like a general operating principle

### Technology-Specific Signals

- technology-specific patterns that recur across multiple projects can become global
- technology-specific patterns limited to one project stay project-specific
- technology choice alone does not force a global destination; repetition and scope still decide

## Confidence Rules

- 1 occurrence: keep as a one-off observation only
- 2 occurrences in one project: project candidate
- 3 or more occurrences, or repetition across projects: global candidate
- repeated violation of an existing rule raises promotion priority

## Signal vs Noise

Treat a pattern as signal when it has durable evidence and future decision value.

Repeated signal examples:

- the same operating-rule lesson appears in two diary entries for one project
- the same cross-project workflow violation appears across multiple sessions
- a technology-specific workflow repeats across multiple projects and reads like reusable guidance

Treat a pattern as noise when it is isolated, temporary, or not durable enough to promote.

Noise examples:

- a one-off workaround tied to a single broken tool invocation
- an abandoned idea that appears once and never returns
- a transient preference that does not materially affect future execution

## Approval Model

No durable edit is automatic until the user approves it.

- auto-write:
  - reflection markdown file
- require approval:
  - repo `PROJECT.md` edits
  - `~/.agents/global/PROJECT.md` edits
  - new skill or hook creation
- auto-run after approved global canonical edits:
  - regenerate `~/.claude/CLAUDE.md`
  - regenerate `~/.codex/AGENTS.md`
- update `processed.log` only after the user accepts the reflection pass as complete and approved actions are resolved

Every proposed promotion must include:

- the proposed learning
- supporting evidence
- confidence
- proposed destination
- the reason for project-specific or global scope

## `processed.log` Semantics

- store processed diary entry identifiers in `~/.claude/memory/reflections/processed.log`
- canonical line format: `<diary-filename> | <processed-date> | <reflection-filename> | accepted`
- reflection acceptance is required before advancing `processed.log`
- approved durable edits must be applied in the same flow before advancing `processed.log`
- declining all durable edits does not block `processed.log` advancement if the user still accepts the reflection as complete
- `include all entries` analyzes both processed and unprocessed entries for the selected scope without deleting prior reflections
- targeted `reprocess` analyzes a named entry or filtered subset again when the user explicitly asks

## Exact Template

```markdown
# Reflection: <scope>

**Generated**: YYYY-MM-DD HH:MM
**Entries Analyzed**: N
**Date Range**: ...
**Projects**: ...

## Summary
...

## Rule Violations Detected
[Omit this section if none.]

1. **Rule**: ...
   - **Frequency**: ...
   - **Violation pattern**: ...
   - **Root Cause**: ...
   - **Impact**: ...
   - **Strengthening action**: ...

## Patterns Identified

### Persistent Preferences
1. ...

### Design Decisions That Worked
1. ...

### Anti-Patterns To Avoid
1. ...

### Project-Specific Patterns
1. ...

## Efficiency Lessons
1. ...

## Notable Mistakes and Learnings
1. ...

## One-Off Observations
- ...

## Proposed Promotions

### Global canonical candidates
- ...

### Project `PROJECT.md` candidates
- ...

### Skill / hook candidates
- ...

## Metadata
- Diary entries analyzed:
- Prior one-offs carried forward:
- Reprocessing requested:
- Processed log status:
- Processed log entries to append:
```

## Completion Summary

At the end, report:

- rule violations detected and strengthened
- reflection filename and location
- pattern count (global vs project-specific)
- whether repo `PROJECT.md` edits were proposed or applied
- whether canonical global edits were proposed or applied
- whether mirror sync ran
- processed.log confirmation

## Error Handling

- no diary entries -> suggest running `/diary` or wrap-up first
- all entries processed -> inform the user and suggest `include all entries`
- filter matches nothing -> show options (remove filter, include processed, try different filter)
- fewer than 3 entries -> proceed but note low pattern confidence
- malformed entries -> skip and document which had issues
- repo `PROJECT.md` read/write failure -> report error but continue with reflection
- canonical global file missing -> still propose the change, note that creation or seeding is required before sync can run

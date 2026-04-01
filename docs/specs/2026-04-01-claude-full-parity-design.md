# Claude Full Parity Design

Parent: [[docs/MOC]]
Related: [[30_Projects/38_Codex-Layered-Learning/Engine/381-Codex-Layered-Learning/docs/specs/2026-03-31-codex-claude-full-parity-design]]

**Date:** 2026-04-01
**Status:** Proposed

## Goal

Align Claude Layered Learning with the approved full-parity architecture now
implemented in the Codex parity branch so both systems converge on:

- the same local operating-guidance model
- the same global durable-guidance model
- the same worktree identity model
- the same reflection application semantics

This pass updates Claude to the same durable-source-of-truth architecture,
not the other way around.

## Why Claude Also Needs Changes

The Codex parity work introduced a new source-of-truth model:

- local operating guidance belongs in repo `PROJECT.md`
- global operating guidance belongs in `~/.agents/global/PROJECT.md`
- runtime mirrors (`AGENTS.md`, `CLAUDE.md`) are generated surfaces, not the
  primary writable source

If Claude keeps writing global durable improvements directly to
`~/.claude/CLAUDE.md`, the two systems will drift again even if the workflow
phases look similar.

## Non-Goals

- changing Claude's diary storage root
- changing Claude's reflection storage root
- removing Claude's command-based `diary` and `reflect` interface
- replacing Claude's PreCompact hook unless needed for parity routing or path
  logic

## Parity Targets

### Local Operating Guidance

For repositories using the triumvirate:

| File | Role | Writable source |
|---|---|---|
| `PROJECT.md` | canonical project operating instructions | yes |
| `CLAUDE.md` | Claude-facing stub/import of `PROJECT.md` | no |
| `AGENTS.md` | generated Codex-facing mirror of `PROJECT.md` | no |

Required Claude changes:

- `wrap-up` must route project-local operating improvements to repo `PROJECT.md`
- `reflect` must route approved project-local operating improvements to repo
  `PROJECT.md`
- Claude should no longer treat repo `CLAUDE.md` as the writable durable source
  in triumvirate repos

### Global Operating Guidance

Introduce one canonical global source shared by Claude and Codex:

- `~/.agents/global/PROJECT.md`

Generated mirrors:

- `~/.claude/CLAUDE.md`
- `~/.codex/AGENTS.md`

Required Claude changes:

- `wrap-up` must route global operating improvements to
  `~/.agents/global/PROJECT.md`
- `reflect` must route approved global operating improvements to
  `~/.agents/global/PROJECT.md`
- neither command nor skill should treat `~/.claude/CLAUDE.md` as the primary
  editable source once the canonical global file exists
- after approved global edits, Claude must trigger the same global sync script

### Worktree Identity

Claude currently derives project identity from simpler path conventions. That
now needs to match the Codex parity rule:

1. resolve repo root with `git rev-parse --show-toplevel`
2. if the repo root contains `/.worktrees/`, strip the `/.worktrees/<name>`
   suffix and use the parent repo path
3. resolve symlinks
4. derive the slug from the canonical project root

Result:

- git worktrees must no longer create separate project-memory identity just
  because the working directory is under `/.worktrees/`

### `wrap-up`

Claude `wrap-up` should keep its current four-phase structure:

1. `Ship It`
2. `Remember It`
3. `Review & Apply`
4. `Diary Capture`

The final push prompt has already been removed from the user's desired Claude
behavior and should stay removed.

Required routing changes in `wrap-up`:

- project operating guidance -> repo `PROJECT.md`
- project memory and stable facts -> existing Claude memory hierarchy where
  still appropriate
- global operating guidance -> `~/.agents/global/PROJECT.md`
- generated mirrors -> sync, never direct-edit

### `reflect`

Claude `reflect` currently proposes and applies CLAUDE.md updates directly.
For parity it should instead:

- read current diary and reflection inputs as before
- analyze patterns with the same current depth and thresholds
- route project operating guidance to repo `PROJECT.md`
- route global operating guidance to `~/.agents/global/PROJECT.md`
- apply approved edits in the same reflection flow
- update `processed.log` only after the reflection pass is accepted and approved
  edits for that pass are resolved

### PreCompact Hook

The hook can remain Claude-specific, but it must honor the updated project
identity model when it derives project paths or session naming.

The hook does not need to write to the canonical global file directly because
global durable promotions are still handled by `wrap-up` and `reflect`.

## Storage Model After This Pass

### Claude-owned runtime memory

- diary: `~/.claude/memory/diary/`
- reflections: `~/.claude/memory/reflections/`
- processed index: `~/.claude/memory/reflections/processed.log`
- hooks, commands, skills: `~/.claude/...`

### Shared durable global guidance

- canonical source: `~/.agents/global/PROJECT.md`
- generated Claude mirror: `~/.claude/CLAUDE.md`
- generated Codex mirror: `~/.codex/AGENTS.md`

### Repo-local operating guidance

- canonical source: repo `PROJECT.md`
- generated/import mirrors: repo `CLAUDE.md`, repo `AGENTS.md`

## Required Documentation Changes

Claude docs currently describe:

- global durable changes going directly to `~/.claude/CLAUDE.md`
- project durable changes going directly to project `CLAUDE.md`
- global/project routing in terms of CLAUDE.md only

They must be updated to describe:

- repo `PROJECT.md` as the local writable source in triumvirate repos
- `~/.agents/global/PROJECT.md` as the global writable source
- generated mirrors as runtime outputs, not primary durable-edit targets

## Required Runtime Changes

### `skills/wrap-up/SKILL.md`

- remove direct global writes to `~/.claude/CLAUDE.md`
- route project operating improvements to repo `PROJECT.md`
- route global operating improvements to `~/.agents/global/PROJECT.md`
- trigger global sync after approved global edits
- preserve no-push behavior

### `commands/reflect.md`

- update promotion model and proposal output so canonical destinations are:
  - repo `PROJECT.md`
  - `~/.agents/global/PROJECT.md`
- retain reflection depth and current analysis quality
- update `processed.log` advancement semantics to match the new full-parity rule

### `commands/diary.md`

- update project identity logic to collapse worktrees to the main repo root
- preserve current diary depth and structure

### `hooks/pre-compact.sh`

- update project-identity derivation if it currently uses worktree-specific
  paths

## Sync Contract

Claude should use the same global sync mechanism as Codex:

- sync script path: `~/.agents/global/sync_global_instructions.sh`
- canonical source: `~/.agents/global/PROJECT.md`
- generated Claude mirror: `~/.claude/CLAUDE.md`

Claude's installer and docs must assume that script exists once the shared
global model is adopted, or must install/copy it if the Claude repo remains
capable of standalone installation.

## Migration Notes

### Existing global `~/.claude/CLAUDE.md`

This file should be treated as the best available seed source for
`~/.agents/global/PROJECT.md` if the canonical file does not exist yet.

### Existing project `CLAUDE.md`

In triumvirate repos, project `CLAUDE.md` should become a stub/import surface,
not the primary writable project durable-guidance source.

### Existing reflections

No reflection migration is required. Only the promotion targets and processed
semantics change.

## Acceptance Criteria

This Claude parity pass is complete only when all of the following are true:

1. Claude `wrap-up` routes project-local operating improvements to repo
   `PROJECT.md`.
2. Claude `reflect` routes approved project-local operating improvements to repo
   `PROJECT.md`.
3. Claude `wrap-up` and `reflect` route approved global operating improvements
   to `~/.agents/global/PROJECT.md`.
4. Claude no longer treats `~/.claude/CLAUDE.md` as the primary writable global
   durable-guidance source once canonical global guidance is in place.
5. Claude worktree runs collapse to the main repo identity before deriving
   project memory paths or diary names.
6. Claude docs and install guidance describe the canonical global file and the
   generated mirror model.
7. The final push prompt remains absent from Claude `wrap-up`.

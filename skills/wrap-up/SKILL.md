---
name: wrap-up
description: Use when user says "wrap up", "close session", "end session",
  "wrap things up", "close out this task", or invokes /wrap-up — runs
  end-of-session checklist for shipping, memory, and self-improvement
---

# Session Wrap-Up

Run four phases in order:

1. `Ship It`
2. `Remember It`
3. `Review & Apply`
4. `Diary Capture`

Present a consolidated report at the end. Do not add a final push prompt.

## Model Selection

Wrap-up is mechanical work. Use the cheapest capable model available.

## Hard Safety Boundaries

- never create repo-local runtime memory folders in working repositories
- never treat generated home-directory mirrors as the editable source of repo-local guidance
- in this public repo, repo `CLAUDE.md` is the local guidance surface
- never edit `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md` directly when a generated mirror path should be used
- never write arbitrary `~/.codex/**` state outside the approved global mirror-sync path
- never auto-apply global canonical edits or new-skill changes without approval
- never do speculative doc edits, speculative file moves, or destructive cleanup

## Runtime Paths

- project memory: `~/.claude/projects/<slug>/memory/MEMORY.md`
- diary output: `~/.claude/memory/diary/`
- reflections: `~/.claude/memory/reflections/`
- project operating guidance source: repo `CLAUDE.md`
- global operating guidance source: `~/.agents/global/PROJECT.md`
- generated global mirrors: `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`
- optional personal extension: `~/.claude/skills/wrap-up/personal.md`

## Path-To-Slug Transform

Use this exact transform so `wrap-up`, `/diary`, `/reflect`, and the
PreCompact hook agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. If that repo root contains `/.worktrees/`, strip the `/.worktrees/<name>` suffix and use the parent repo path as the canonical project root.
3. Otherwise, if not inside a git repository, use the canonical absolute working directory.
4. Resolve symlinks before deriving the slug.
5. Replace every `/` in the canonical absolute path with `-`.

## Phase 1: `Ship It`

### Documentation sync

1. Review the diff in each repo touched during the session.
2. If the change affects project-maintained docs such as README, changelog, setup guides, runbooks, or verification docs, update only the documents directly affected.
3. If no project-maintained docs were directly affected, skip this step.

### Commit

1. Run `git status` in each repo touched during the session.
2. If uncommitted changes exist, use the repo's normal commit path.
3. If no `/commit` skill exists, use normal git commands directly.
4. If the working directory is not inside a git repository, skip commit with `n/a`.

### File placement check

1. If files were created or saved during the session, verify that obvious naming and placement rules were followed.
2. Auto-fix only obvious violations:
   - document-type files created at repo root or code directories that clearly belong in docs
   - files that clearly violate an existing documented convention
3. If file placement conventions are not documented, avoid speculative renames or moves.

### Deploy

1. Check whether the project has a documented deploy script or deploy skill.
2. If one exists, run it.
3. If none exists, skip deploy without asking for a manual deploy path.

### Task cleanup

1. Check the repo's task surface if one exists.
2. Mark completed tasks done and flag stale or orphaned ones.
3. If no task file or documented task surface exists, skip task cleanup and report that no project task surface was found.

## Phase 2: `Remember It`

### Always do first

Update `~/.claude/projects/<slug>/memory/MEMORY.md` with:

- `## Current State`
- `**Last updated:**`
- `**Session:**`
- `**Next steps:**`
- `## Key Notes`

Keep `Current State` to a short 2-5 line snapshot and `Next steps` to a short numbered list.

### Session number source of truth

- preferred source of truth: `~/.claude/projects/<slug>/memory/MEMORY.md`
- fallback: scan matching diary files for the same project and date only when `MEMORY.md` is missing or uninitialized
- `wrap-up` must set or confirm the session number in `MEMORY.md` before triggering `/diary`
- when `wrap-up` invokes `/diary`, both steps must use the same session number instead of incrementing independently

### Personal extensions

Check whether `~/.claude/skills/wrap-up/personal.md` exists.

- if present, follow it as a machine-local instruction file under normal approval and safety rules
- it is an extension point, not an override mechanism
- if absent, continue silently
- if unclear or blocked, report that briefly and continue

If the personal-extension pass materially changes tracked project state, reconcile `MEMORY.md` so it reflects the final post-extension state.

### Memory placement guide

Use this mapping when deciding where learned material belongs:

- current-session state and discovered project facts -> `MEMORY.md`
- project-local operating rules and conventions -> repo `CLAUDE.md`
- scoped file-type or area-specific instructions -> `.claude/rules/`
- private per-project local notes -> `CLAUDE.local.md`
- cross-project behavior rules -> `~/.agents/global/PROJECT.md`
- reusable procedural workflows -> skill or hook candidate

### Approval matrix for this phase

- auto-apply:
  - `MEMORY.md` current-state update
  - repo docs directly affected by session work
  - commit creation when uncommitted changes exist
  - deploy when a documented deploy path exists
  - repo-owned task cleanup
  - repo `CLAUDE.md` updates for local operating improvements
  - `.claude/rules/` updates when the destination is clearly a scoped local rule
  - `CLAUDE.local.md` updates when the destination is clearly private local context
- require approval:
  - `~/.agents/global/PROJECT.md` edits
  - new skill or hook creation

When an approved global canonical edit is applied, run `~/.agents/global/sync_global_instructions.sh` immediately afterward so `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` stay aligned.

## Phase 3: `Review & Apply`

Analyze the current session for self-improvement findings.

Only say `Nothing to improve` when the session was genuinely short or purely informational.

Finding categories:

- `Skill gap`
- `Friction`
- `Knowledge`
- `Automation`

Action types:

- repo doc update
- repo `CLAUDE.md` update
- `.claude/rules/` update
- `CLAUDE.local.md` update
- global `~/.agents/global/PROJECT.md` candidate
- skill or hook candidate
- no action needed

Rules:

- prioritize repeated violation of an existing rule over inventing a new rule
- strengthen existing guidance before proposing a parallel duplicate
- auto-apply only actions allowed by the approval matrix
- present approval-gated items as targeted proposals with destination and rationale
- do not route project-local operating improvements to repo `AGENTS.md` or repo `CLAUDE.md`

Present findings in two sections:

- `Findings (applied)`
- `No action needed`

## Phase 4: `Diary Capture`

After Phases 1-3 are complete, invoke the installed `/diary` command to capture a structured diary entry for this session.

Rules:

- this step always runs
- `wrap-up` must not fold reflection logic into the diary step
- `/diary` still runs when the personal extension is absent
- `/diary` still runs when approval-gated durable changes were declined
- `/diary` still runs when some wrap-up steps were skipped with documented fallback status

## Completion

Session is complete after the diary is captured.

- do not add a final push prompt
- do not push automatically
- the user handles any later git push manually

# Claude Layered Learning

A two-loop self-improvement system for [Claude Code](https://claude.com/claude-code) that learns from your sessions over time and continuously improves project-local and global operating guidance.

## How it works

The system has two learning loops:

**Immediate loop (every session):** the wrap-up skill ships your work, updates project memory, routes local operating guidance to repo `PROJECT.md`, and captures a diary entry.

**Deferred loop (periodic):** the reflect command analyzes accumulated diary entries across sessions and projects, finds recurring patterns, and proposes updates to repo `PROJECT.md` or canonical global `~/.agents/global/PROJECT.md`.

```text
Session work
    |
    v
Wrap-up (immediate loop)
    |-- Phase 1: Ship It (commit, deploy)
    |-- Phase 2: Remember It (update MEMORY.md, route learnings)
    |-- Phase 3: Review & Apply (self-improvement findings)
    |-- Phase 4: Diary Capture (/diary)
    |
    v
/diary (observation layer)
    |-- Raw session capture: decisions, preferences, challenges, solutions
    |-- Saved to ~/.claude/memory/diary/
    |
    v
/reflect (pattern layer, run periodically)
    |-- Cross-session analysis with frequency thresholds
    |-- Routes rules: repo PROJECT.md vs ~/.agents/global/PROJECT.md
    |-- Applies approved durable edits in the same flow
    |-- Syncs generated mirrors after approved global edits
    |
    v
Generated mirrors
    |-- ~/.claude/CLAUDE.md
    |-- ~/.codex/AGENTS.md
```

## What each loop can touch

| Destination | Immediate loop (wrap-up) | Deferred loop (reflect) |
|---|---|---|
| Repo `PROJECT.md` | Yes (auto-apply) | Yes (with approval) |
| Canonical global `~/.agents/global/PROJECT.md` | Yes (with approval) | Yes (with approval) |
| `.claude/rules/` | Yes | No |
| `CLAUDE.local.md` | Yes | No |
| Hooks / Skills | Documents candidates | Documents candidates |
| Project memory `~/.claude/projects/<slug>/memory/MEMORY.md` | Yes | Read only |

## Quickstart

```bash
git clone https://github.com/PGHH84/claude-layered-learning.git
cd claude-layered-learning

# Commands (diary + reflect)
cp commands/*.md ~/.claude/commands/

# Wrap-up skill
mkdir -p ~/.claude/skills/wrap-up
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/

# Memory directories
mkdir -p ~/.claude/memory/diary ~/.claude/memory/reflections

# Shared global canonical instructions and mirror-sync hook
mkdir -p ~/.agents/global
cp scripts/sync_global_instructions.sh ~/.agents/global/sync_global_instructions.sh
cp scripts/check_global_instructions_sync.sh ~/.agents/global/check_global_instructions_sync.sh
chmod +x ~/.agents/global/sync_global_instructions.sh ~/.agents/global/check_global_instructions_sync.sh
```

If `~/.agents/global/PROJECT.md` does not exist yet, seed it from your current global instruction file and run:

```bash
~/.agents/global/sync_global_instructions.sh
```

Then in Claude Code: run `/diary`, `/reflect`, or say "wrap up".

## Usage

**After any session:**

- say "wrap up" to run the full cycle
- or run `/diary` manually to just capture a diary entry

**Periodically (after 5-10 diary entries):**

- run `/reflect` to analyze patterns and propose durable updates

**Reflect options:**

```text
/reflect
/reflect last 20 entries
/reflect from 2026-01-01 to 2026-03-31
/reflect for project ~/Vault/30_Projects/my-project
/reflect related to testing
/reflect include all entries
```

## File structure

```text
commands/
  diary.md
  reflect.md
skills/
  wrap-up/
    SKILL.md
hooks/
  pre-compact.sh
scripts/
  sync_global_instructions.sh
  check_global_instructions_sync.sh
examples/
  sample-diary-entry.md
  sample-reflection.md
```

Live files are installed to `~/.claude/commands/` and `~/.claude/skills/wrap-up/`. Global canonical instructions live in `~/.agents/global/`. This repo contains shareable copies.

## Built on

This project directly reuses and extends work by others. Huge kudos to:

- **[rlancemartin/claude-diary](https://github.com/rlancemartin/claude-diary)** — the original `/diary`, `/reflect`, and PreCompact diary-capture architecture.
- **[PR #3](https://github.com/rlancemartin/claude-diary/pull/3) by [thebenlamm](https://github.com/thebenlamm)** — the original global-vs-project routing concept.
- **[jonathanmalkin/jules](https://github.com/jonathanmalkin/jules)** and his **[Reddit post](https://www.reddit.com/r/ClaudeCode/comments/1r89084/comment/o9sv777/?context=3)** — the wrap-up skill concept that became the immediate learning loop.

## License

MIT License — see [LICENSE](LICENSE).

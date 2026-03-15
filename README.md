# Claude Layered Learning

A two-loop self-improvement system for [Claude Code](https://claude.com/claude-code) that learns from your sessions over time and continuously improves Claude's understanding of your preferences, patterns, and workflows.

## How it works

The system has two learning loops:

**Immediate loop (every session):** The wrap-up skill ships your work, saves facts and corrections to the right memory layer, and captures a diary entry.

**Deferred loop (periodic):** The reflect command analyzes accumulated diary entries across sessions and projects, finds recurring patterns, and proposes CLAUDE.md updates.

```
Session work
    |
    v
Wrap-up (immediate loop)
    |-- Phase 1: Ship It (commit, deploy)
    |-- Phase 2: Remember It (save facts to memory hierarchy)
    |-- Phase 3: Review & Apply (self-improvement findings)
    |-- Phase 4: Diary Capture (invoke /diary)
    |-- Final Step: Push (with confirmation)
    |
    v
/diary (observation layer)
    |-- Standalone command, also triggered by PreCompact hook
    |-- Raw session capture: decisions, preferences, challenges, solutions
    |-- Saved to ~/.claude/memory/diary/
    |
    v
/reflect (pattern layer, run periodically)
    |-- Cross-session analysis with frequency thresholds
    |-- Routes rules: global CLAUDE.md vs project CLAUDE.md
    |-- Checks prior reflections for recurring one-off observations
    |-- Project-level changes auto-apply; global changes require approval
    |
    v
CLAUDE.md loads into every session (retrieval layer)
    --> Behavior change
```

## What each loop can touch

| Destination | Immediate loop (wrap-up) | Deferred loop (reflect) |
|---|---|---|
| Project CLAUDE.md | Yes (auto-apply) | Yes (auto-apply) |
| Global ~/.claude/CLAUDE.md | Yes (with approval) | Yes (with approval) |
| .claude/rules/ | Yes | No |
| Hooks / Skills | Documents specs | No |
| Auto memory | Yes | No |
| CLAUDE.local.md | Yes | No |

## Quickstart

```bash
git clone https://github.com/PGHH84/claude-layered-learning.git
cd claude-layered-learning

# Install commands and skill
cp commands/*.md ~/.claude/commands/
mkdir -p ~/.claude/skills/wrap-up
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/

# Create memory directories
mkdir -p ~/.claude/memory/diary ~/.claude/memory/reflections
```

Then in Claude Code: run `/diary`, `/reflect`, or say "wrap up".

For the full setup (PreCompact hook, troubleshooting, updating, uninstalling), see **[INSTALL.md](INSTALL.md)**.

## Usage

**After any session:**
- Say "wrap up" to run the full cycle (ship, remember, review, diary)
- Or run `/diary` manually to just capture a diary entry

**Periodically (after 5-10 diary entries):**
- Run `/reflect` to analyze patterns and update CLAUDE.md files

**Reflect options:**
```
/reflect                                    # All unprocessed entries
/reflect last 20 entries                    # More entries
/reflect from 2026-01-01 to 2026-03-31     # Date range
/reflect for project ~/Developer/my-app     # Single project
/reflect related to testing                 # Keyword filter
/reflect include all entries                # Re-analyze everything
```

## File structure

```
commands/
  diary.md              # /diary command — standalone session capture
  reflect.md            # /reflect command — cross-session pattern analysis
skills/
  wrap-up/
    SKILL.md            # wrap-up skill — ship, remember, review, diary
hooks/
  pre-compact.sh        # PreCompact hook — auto-diary before compaction
examples/
  sample-diary-entry.md # What a diary entry looks like
  sample-reflection.md  # What a reflection looks like
```

Live files are installed to `~/.claude/commands/` and `~/.claude/skills/wrap-up/`. This repo contains shareable copies.

## Built on

This project directly reuses and extends work by others. Huge kudos to:

- **[rlancemartin/claude-diary](https://github.com/rlancemartin/claude-diary)** — Our `/diary` and `/reflect` commands are forked from this project. The diary template, reflection workflow, processed-entry tracking, PreCompact hook, and the overall observe-reflect-retrieve architecture all originate here. Lance's [blog post](https://rlancemartin.github.io/2025/12/01/claude_diary/) on the Generative Agents paper and CoALA framework is the best explanation of why this approach works.
- **[PR #3](https://github.com/rlancemartin/claude-diary/pull/3) by [thebenlamm](https://github.com/thebenlamm)** — Added the global vs project-specific CLAUDE.md routing with the 3-step decision framework that `/reflect` uses for rule classification. This PR is what makes reflect actually useful across multiple projects.
- **[jonathanmalkin/jules](https://github.com/jonathanmalkin/jules)** and his **[Reddit post](https://www.reddit.com/r/ClaudeCode/comments/1r89084/comment/o9sv777/?context=3)** — The wrap-up skill concept that became our immediate learning loop. The idea of shipping, remembering, and self-reviewing at end-of-session comes directly from jules.

What we added: the two-loop architecture that connects wrap-up (immediate) with diary/reflect (deferred), the memory hierarchy routing in Phase 2, and the self-challenge mechanism in Phase 3.

## License

MIT License — see [LICENSE](LICENSE).

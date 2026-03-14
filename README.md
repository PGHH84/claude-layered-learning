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
    |-- Phase 1: Ship It (commit, push, deploy)
    |-- Phase 2: Remember It (save facts to memory hierarchy)
    |-- Phase 3: Review & Apply (self-improvement findings)
    |-- Phase 4: Diary Capture (invoke /diary)
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

## Installation

### 1. Clone and install commands

```bash
git clone https://github.com/PGHH84/claude-layered-learning.git
cd claude-layered-learning

# Install commands and skill globally
cp commands/*.md ~/.claude/commands/
mkdir -p ~/.claude/skills/wrap-up
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/
```

### 2. Set up the PreCompact hook (recommended)

This automatically captures a diary entry before Claude Code compacts long conversations, preserving context that would otherwise be lost.

```bash
mkdir -p ~/.claude/hooks
cat > ~/.claude/hooks/pre-compact.sh << 'HOOK'
#!/bin/bash
echo "Auto-generating diary entry before compact..."
echo "/diary"
HOOK
chmod +x ~/.claude/hooks/pre-compact.sh
```

Add the hook to `~/.claude/settings.json` (merge into your existing `hooks` section if you have one):

```json
{
  "hooks": {
    "PreCompact": [
      {
        "matcher": "auto",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/pre-compact.sh"
          }
        ]
      },
      {
        "matcher": "manual",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/pre-compact.sh"
          }
        ]
      }
    ]
  }
}
```

### 3. Create memory directories

```bash
mkdir -p ~/.claude/memory/diary ~/.claude/memory/reflections
```

### 4. Verify

```bash
# In Claude Code, try:
/diary
/reflect
# Or say "wrap up" to trigger the wrap-up skill
```

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
examples/
  (sample diary entries and reflections)
```

Live files are installed to `~/.claude/commands/` and `~/.claude/skills/wrap-up/`. This repo contains shareable copies.

## Acknowledgments

This project builds on ideas and code from several sources:

- **[rlancemartin/claude-diary](https://github.com/rlancemartin/claude-diary)** — The diary/reflect pattern that forms the foundation of the deferred learning loop. The [blog post](https://rlancemartin.github.io/2025/12/01/claude_diary/) provides excellent framing around the Generative Agents paper and the CoALA framework.
- **[PR #3](https://github.com/rlancemartin/claude-diary/pull/3) by [thebenlamm](https://github.com/thebenlamm)** — Added the global vs project-specific CLAUDE.md routing with the 3-step decision framework that reflect uses for rule classification.
- **[Reddit post by u/____nobody______](https://www.reddit.com/r/ClaudeCode/comments/1r89084/comment/o9sv777/?context=3)** — The original wrap-up skill concept that inspired the immediate learning loop.

## License

MIT License — see [LICENSE](LICENSE).

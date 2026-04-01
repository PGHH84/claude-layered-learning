# Installation Guide

## Prerequisites

- [Claude Code](https://claude.com/claude-code)
- access to `~/.claude/` and `~/.agents/global/`
- Bash for the hook and sync scripts

## Install

```bash
git clone https://github.com/PGHH84/claude-layered-learning.git
cd claude-layered-learning
cp commands/*.md ~/.claude/commands/
mkdir -p ~/.claude/skills/wrap-up ~/.claude/hooks
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/
cp hooks/pre-compact.sh ~/.claude/hooks/pre-compact.sh
chmod +x ~/.claude/hooks/pre-compact.sh
mkdir -p ~/.agents/global
cp scripts/sync_global_instructions.sh ~/.agents/global/sync_global_instructions.sh
cp scripts/check_global_instructions_sync.sh ~/.agents/global/check_global_instructions_sync.sh
chmod +x ~/.agents/global/sync_global_instructions.sh ~/.agents/global/check_global_instructions_sync.sh
mkdir -p ~/.claude/memory/diary ~/.claude/memory/reflections
```

If `~/.agents/global/PROJECT.md` does not exist yet, seed it from your current global instruction file and run:

```bash
~/.agents/global/sync_global_instructions.sh
```

## Configure PreCompact

Add this to `~/.claude/settings.json`:

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

## Verify

- In Claude Code, run `/diary` and `/reflect`
- In a terminal, run `~/.agents/global/check_global_instructions_sync.sh`

## Update

```bash
git pull
cp commands/*.md ~/.claude/commands/
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/
cp hooks/pre-compact.sh ~/.claude/hooks/pre-compact.sh
cp scripts/sync_global_instructions.sh ~/.agents/global/sync_global_instructions.sh
cp scripts/check_global_instructions_sync.sh ~/.agents/global/check_global_instructions_sync.sh
chmod +x ~/.claude/hooks/pre-compact.sh ~/.agents/global/sync_global_instructions.sh ~/.agents/global/check_global_instructions_sync.sh
```

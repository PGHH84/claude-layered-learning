# Installation Guide

## Prerequisites

- [Claude Code](https://claude.com/claude-code) installed and working
- Access to your `~/.claude` directory
- Access to your shared `~/.agents/global` directory for canonical global instructions

## Install

### 1. Clone the repo

```bash
git clone https://github.com/PGHH84/claude-layered-learning.git
cd claude-layered-learning
```

### 2. Copy commands and skill

```bash
cp commands/*.md ~/.claude/commands/
mkdir -p ~/.claude/skills/wrap-up
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/
```

### 3. Create memory directories

```bash
mkdir -p ~/.claude/memory/diary ~/.claude/memory/reflections
```

### 4. Install the shared global instruction sync hook

```bash
mkdir -p ~/.agents/global
cp scripts/sync_global_instructions.sh ~/.agents/global/sync_global_instructions.sh
cp scripts/check_global_instructions_sync.sh ~/.agents/global/check_global_instructions_sync.sh
chmod +x ~/.agents/global/sync_global_instructions.sh ~/.agents/global/check_global_instructions_sync.sh
```

If `~/.agents/global/PROJECT.md` does not exist yet, seed it from your current
global instruction file and then run:

```bash
~/.agents/global/sync_global_instructions.sh
```

This creates or refreshes the generated runtime mirrors:

- `~/.claude/CLAUDE.md`
- `~/.codex/AGENTS.md`

### 5. Set up the PreCompact hook

```bash
mkdir -p ~/.claude/hooks
cp hooks/pre-compact.sh ~/.claude/hooks/pre-compact.sh
chmod +x ~/.claude/hooks/pre-compact.sh
```

Add to `~/.claude/settings.json`:

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

### 6. Verify

In Claude Code:

```text
/diary
/reflect
```

And from a terminal:

```bash
~/.agents/global/check_global_instructions_sync.sh
```

## Updating

```bash
cd claude-layered-learning
git pull
cp commands/*.md ~/.claude/commands/
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/
cp hooks/pre-compact.sh ~/.claude/hooks/pre-compact.sh
cp scripts/sync_global_instructions.sh ~/.agents/global/sync_global_instructions.sh
cp scripts/check_global_instructions_sync.sh ~/.agents/global/check_global_instructions_sync.sh
chmod +x ~/.claude/hooks/pre-compact.sh ~/.agents/global/sync_global_instructions.sh ~/.agents/global/check_global_instructions_sync.sh
```

## Uninstalling

```bash
rm ~/.claude/commands/diary.md
rm ~/.claude/commands/reflect.md
rm -rf ~/.claude/skills/wrap-up
rm -f ~/.claude/hooks/pre-compact.sh
```

The shared global canonical file and mirrors are preserved. To remove the
shared global hook too:

```bash
rm -f ~/.agents/global/sync_global_instructions.sh ~/.agents/global/check_global_instructions_sync.sh
```

## Troubleshooting

### `/diary` or `/reflect` not recognized

1. Check files exist: `ls ~/.claude/commands/diary.md ~/.claude/commands/reflect.md`
2. Restart Claude Code
3. Verify the files are directly in `~/.claude/commands/`

### Global mirrors drifted

Run:

```bash
~/.agents/global/check_global_instructions_sync.sh
~/.agents/global/sync_global_instructions.sh
```

### PreCompact hook not firing

1. Verify the script is executable: `ls -la ~/.claude/hooks/pre-compact.sh`
2. Check `~/.claude/settings.json` has the `PreCompact` hook configured
3. Restart Claude Code after changing hook configuration

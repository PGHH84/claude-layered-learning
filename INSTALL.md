# Installation Guide

## Prerequisites

- [Claude Code](https://claude.com/claude-code) installed and working
- Access to your `~/.claude` directory

## Install

### 1. Clone the repo

```bash
git clone https://github.com/PGHH84/claude-layered-learning.git
cd claude-layered-learning
```

### 2. Copy commands and skill

```bash
# Commands (diary + reflect)
cp commands/*.md ~/.claude/commands/

# Wrap-up skill
mkdir -p ~/.claude/skills/wrap-up
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/
```

### 3. Create memory directories

```bash
mkdir -p ~/.claude/memory/diary ~/.claude/memory/reflections
```

### 4. Set up the PreCompact hook (recommended)

The PreCompact hook automatically captures a diary entry before Claude Code compacts long conversations. This preserves context that would otherwise be lost during compaction.

**How it works:** The hook runs before compaction starts (while Claude still has full session context). It computes the diary file path in bash (date + project + session number) and outputs explicit Write tool instructions to Claude with the exact path. This reduces Claude's required work to a single Write tool call — echoing `/diary` doesn't work because Claude during compaction doesn't invoke the Skill tool pipeline.

**Step 1: Install the hook script**

```bash
mkdir -p ~/.claude/hooks
cp hooks/pre-compact.sh ~/.claude/hooks/pre-compact.sh
chmod +x ~/.claude/hooks/pre-compact.sh
```

If you cloned without the `hooks/` directory, create the script manually:

```bash
cat > ~/.claude/hooks/pre-compact.sh << 'HOOK'
#!/bin/bash
PROJECT=$(basename "$(pwd)")
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
N=1
while [ -f "$HOME/.claude/memory/diary/${DATE}-${PROJECT}-session-${N}.md" ]; do
  N=$((N+1))
done
DIARY_PATH="$HOME/.claude/memory/diary/${DATE}-${PROJECT}-session-${N}.md"
mkdir -p "$HOME/.claude/memory/diary"
cat <<INSTRUCTIONS
COMPACTION NOTICE: The conversation is about to be compacted. Before generating
your summary, write a diary entry for this session using the Write tool.

Write the diary entry to this exact path: ${DIARY_PATH}

Use the diary template from ~/.claude/commands/diary.md. Work from the conversation
context still loaded — it is fully available now. The diary entry should include:
- Date: ${DATE}, Time: ${TIME}, Project: ${PROJECT}
- Task summary (what the user was trying to accomplish)
- Work summary (what was accomplished, as bullet points)
- Design decisions made and why
- Challenges encountered and solutions applied
- User preferences observed during the session

After writing the diary, proceed with your normal compaction summary.

IMPORTANT: Use the Write tool to create the file at ${DIARY_PATH}. Do not skip
this step — diary entries from compacted sessions are otherwise permanently lost.
INSTRUCTIONS
HOOK
chmod +x ~/.claude/hooks/pre-compact.sh
```

**Step 2: Configure the hook in settings**

Add to `~/.claude/settings.json` (merge into your existing `hooks` section if you have one):

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

- `"auto"` fires when Claude Code auto-compacts (long sessions)
- `"manual"` fires when you run `/compact`

**Alternative:** Use the interactive `/hooks` command in Claude Code to configure.

### 5. Verify

In Claude Code:

```
/diary       # Should create a diary entry
/reflect     # Should analyze diary entries (needs 2+ to find patterns)
```

Or say "wrap up" at the end of a session to run the full cycle.

## Updating

```bash
cd claude-layered-learning
git pull
cp commands/*.md ~/.claude/commands/
cp skills/wrap-up/SKILL.md ~/.claude/skills/wrap-up/
```

## Uninstalling

```bash
rm ~/.claude/commands/diary.md
rm ~/.claude/commands/reflect.md
rm -rf ~/.claude/skills/wrap-up
```

Your diary entries and reflections in `~/.claude/memory/` are preserved. To remove those too:

```bash
rm -rf ~/.claude/memory/diary ~/.claude/memory/reflections
```

To remove the PreCompact hook:
- Delete `~/.claude/hooks/pre-compact.sh`
- Remove the `PreCompact` section from `~/.claude/settings.json`

## Troubleshooting

### `/diary` or `/reflect` not recognized

1. Check files exist: `ls ~/.claude/commands/diary.md ~/.claude/commands/reflect.md`
2. Restart Claude Code
3. If still missing, verify the copy worked — the files must be directly in `~/.claude/commands/`, not in a subdirectory

### "No session file found" when running `/diary`

- `/diary` uses your conversation context by default — this error only appears in JSONL fallback mode
- Make sure you're running `/diary` from within a Claude Code session, not a regular terminal
- Check session files exist: `ls ~/.claude/projects/`

### "No diary entries found" when running `/reflect`

- Run `/diary` first to create some entries
- Check entries exist: `ls ~/.claude/memory/diary/`
- `/reflect` needs at least 1 entry, but patterns emerge at 3+

### PreCompact hook not firing

1. Verify the script is executable: `ls -la ~/.claude/hooks/pre-compact.sh` (should show `-rwxr-xr-x`)
2. Check settings.json has the `PreCompact` hook configured: `grep -A 10 PreCompact ~/.claude/settings.json`
3. The hook only fires on long sessions — for short sessions, use `/diary` manually
4. Restart Claude Code after changing hook configuration

### Permission errors

```bash
chmod 755 ~/.claude/memory
chmod 755 ~/.claude/memory/diary ~/.claude/memory/reflections
```

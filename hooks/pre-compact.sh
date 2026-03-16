#!/bin/bash
# Auto-generate diary entry before Claude Code compacts conversation.
# This hook runs before compact operations (while full context is still available).
#
# Design: We compute the output path here in bash (no Bash tool call needed from Claude)
# and output the full diary template inline. Claude only needs a single Write tool call.
# This bypasses the multi-step limitation of PreCompact hook invocations.

PROJECT=$(basename "$(pwd)")
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)

# Find next available session number
N=1
while [ -f "$HOME/.claude/memory/diary/${DATE}-${PROJECT}-session-${N}.md" ]; do
  N=$((N+1))
done
DIARY_PATH="$HOME/.claude/memory/diary/${DATE}-${PROJECT}-session-${N}.md"

# Ensure diary directory exists
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

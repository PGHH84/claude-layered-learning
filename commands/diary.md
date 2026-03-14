---
description: Create a structured diary entry from the current session
---

# Create Diary Entry

Capture a structured diary entry documenting the current Claude Code session.
This entry is raw material for the `/reflect` command to mine later for
cross-session patterns. It is NOT analyzed or routed — just raw observations.

## Approach: Context-First Strategy

**Primary method (use this first):**
Reflect on the conversation history loaded in this session. You have access to:
- All user messages and requests
- Your responses and tool invocations
- Files you read, edited, or wrote
- Errors encountered and solutions applied
- Design decisions discussed
- User preferences expressed

**When to use JSONL fallback (rare):**
- Session was compacted and context is incomplete
- You need precise statistics (exact tool counts, timestamps)
- User specifically requests detailed session analysis

## Steps

### 1. Create diary entry from context (primary method)

Review the current conversation and create a diary entry based on what
happened. No tool invocations needed for typical sessions. Skip to Step 3.

### 2. Fallback: Locate session transcript (only if context insufficient)

If context is insufficient, find the transcript:

```bash
# Find the most recent session file for this project
# NOTE: Path format includes leading dash: -Users-name-Code-app
SESSION_FILE=$(ls -t ~/.claude/projects/-$(echo "{{ cwd }}" | sed 's/\//-/g')/*.jsonl 2>/dev/null | head -1) && \
if [ -z "$SESSION_FILE" ]; then \
  echo "ERROR: No session file found" && \
  echo "Looking in: ~/.claude/projects/-$(echo "{{ cwd }}" | sed 's/\//-/g')/" && \
  ls -la ~/.claude/projects/ | head -20; \
else \
  echo "FOUND: $SESSION_FILE" && \
  ls -lh "$SESSION_FILE"; \
fi
```

If JSONL is needed for metadata extraction:

```bash
SESSION_FILE="[path-from-above]" && \
echo "=== TOOL COUNTS ===" && \
jq -r 'select(.message.content[]?.name) | .message.content[].name' "$SESSION_FILE" | sort | uniq -c && \
echo "" && \
echo "=== FILES MODIFIED ===" && \
grep -o '"filePath":"[^"]*"' "$SESSION_FILE" | sort -u
```

### 3. Create the diary entry

Based on conversation context (and optional metadata from Step 2), create a
structured markdown diary entry using this template:

```markdown
# Session Diary Entry

**Date**: [YYYY-MM-DD]
**Time**: [HH:MM:SS]
**Session ID**: [uuid from JSONL filename, if available]
**Project**: [project path from working directory]
**Git Branch**: [branch name if available]
**Session**: [session number from MEMORY.md current state, if available]

## Task Summary
[2-3 sentences: What was the user trying to accomplish?]

## Work Summary
[Bullet list of what was accomplished:]
- Features implemented
- Bugs fixed
- Documentation added
- Tests written
- Skills created or modified

## Design Decisions Made
[Key technical decisions and WHY they were made:]
- Architectural choices and rationale
- Technology selections
- Pattern selections

## Actions Taken
[Based on tool usage and file operations:]
- Files created: [list paths]
- Files edited: [list paths]
- Commands executed: [notable git operations, installs, builds]
- Tools used: [summary of tool usage patterns]

## Challenges Encountered
[Based on errors and user corrections:]
- Errors encountered
- Failed approaches
- Debugging steps

## Solutions Applied
[How problems were resolved]

## User Preferences Observed

### Communication & Workflow:
- [Patterns around how user likes to work]

### Code Quality Preferences:
- [Testing requirements, style preferences]

### Technical Preferences:
- [Libraries, patterns, frameworks preferred]

## Code Patterns and Decisions
[Technical patterns used or established]

## Context and Technologies
[Project type, languages, frameworks, tools used]

## Notes
[Any other observations worth capturing for future reflection]
```

### 4. Save the diary entry

```bash
mkdir -p ~/.claude/memory/diary && \
TODAY=$(date +%Y-%m-%d) && \
PROJECT=$(basename "$(pwd)") && \
N=1 && \
while [ -f ~/.claude/memory/diary/${TODAY}-${PROJECT}-session-${N}.md ]; do N=$((N+1)); done && \
echo "Saving to: ~/.claude/memory/diary/${TODAY}-${PROJECT}-session-${N}.md"
```

Use the Write tool to save the diary content to the determined file path.

### 5. Confirm completion

Display:
- Path where diary was saved
- Brief one-line summary of what was captured

## Data Security

Apply the same PII rules as the project's CLAUDE.md. Do not include raw
financial amounts, IBANs, merchant names, or personal identifiers in diary
entries. Use redacted or generic descriptions (e.g., "reclassified 6
government transactions" rather than specific amounts or account numbers).

## Guidelines

- Be factual and specific — include concrete details (file paths, error messages)
- Capture the "why" behind decisions, not just the "what"
- Document ALL user preferences observed, especially around workflow and style
- Include failures — what didn't work is valuable learning material
- Keep it structured — follow the template consistently
- Use context first — only parse JSONL files when truly necessary

## Decision Guide

| Situation | Approach | Reasoning |
|-----------|----------|-----------|
| During active session | **Context only** | All information available, 0 tool calls |
| PreCompact hook trigger | **Context only** | Session still in memory |
| Post-session analysis | **JSONL fallback** | Context no longer available |
| Need exact statistics | **JSONL metadata** | Precise counts unavailable from context |
| User says "create diary" | **Context first** | Assume current session unless specified |

## Error Handling

**Context-based errors:**
- If context seems incomplete, mention what's missing and offer to use JSONL fallback
- If uncertain about details, document with "approximately" or "unclear from context"

**JSONL-based errors:**
- If session file not found, show where you looked (remember: `-Users-...` format with leading dash)
- Check `ls -la ~/.claude/projects/` to help diagnose path issues
- If transcript is malformed, document what you could parse and fall back to context

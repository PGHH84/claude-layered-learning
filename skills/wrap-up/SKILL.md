---
name: wrap-up
description: Use when user says "wrap up", "close session", "end session",
  "wrap things up", "close out this task", or invokes /wrap-up — runs
  end-of-session checklist for shipping, memory, and self-improvement
---

# Session Wrap-Up

Run three phases in order, then capture a diary entry. Each phase is
conversational and inline — no separate documents. Most steps auto-apply;
exceptions are called out explicitly. Present a consolidated report at the end.

## Phase 1: Ship It

**Documentation sync (before commit):**
1. Review the diff in each repo touched during the session
2. If the change affects project-maintained docs (README, changelog, runbooks,
   setup guides), update only the documents directly affected
3. Do not make speculative or unrelated doc edits
4. If no docs are affected, skip this step

**Commit:**
1. Run `git status` in each repo directory that was touched during the session
2. If uncommitted changes exist, invoke the `/commit` skill if available;
   otherwise auto-commit with a descriptive message

**File placement check:**
1. If any files were created or saved during this session:
   - Verify they follow your naming convention
   - Auto-fix naming violations (rename the file)
   - Verify they're in the correct subfolder per your project structure
   - Auto-move misplaced files to their correct location
2. If any document-type files (.md, .docx, .pdf, .xlsx, .pptx) were created
   at the workspace root or in code directories, move them to the docs folder
   if they belong there

**Deploy:**
1. Check if the project has a deploy skill or script
2. If one exists, run it
3. If not, skip deployment entirely — do not ask about manual deployment

**Task cleanup:**
1. Check the task list for in-progress or stale items
2. Mark completed tasks as done, flag orphaned ones

## Phase 2: Remember It

Review what was learned during the session. Decide where each piece of
knowledge belongs in the memory hierarchy.

**Always do first:**
- Update the `Current state` section in MEMORY.md with today's date, the
  session number (increment from previous), and a concise summary of what
  changed and what's open next

**Personal extensions:**
Check if `~/.claude/skills/wrap-up/personal.md` exists. If it does, read it
and execute every step it defines before continuing. Do not skip this.

**Memory placement guide:**
- **Auto memory** (Claude writes for itself) — Debugging insights, patterns
  discovered during the session, project quirks
- **Project CLAUDE.md** — Permanent project-specific rules, conventions,
  commands, architecture decisions that should guide all future sessions
- **`.claude/rules/`** (modular project rules) — Topic-specific instructions
  that apply to certain file types or areas. Use `paths:` frontmatter to scope
  rules to relevant files (e.g., testing rules scoped to `tests/**`)
- **`CLAUDE.local.md`** (private per-project notes) — Personal WIP context,
  local URLs, sandbox credentials, current focus areas that shouldn't be
  committed
- **`@import` references** — When a CLAUDE.md would benefit from referencing
  another file rather than duplicating its content

**Decision framework:**
- Is it a permanent project convention? → Project CLAUDE.md or `.claude/rules/`
- Is it scoped to specific file types? → `.claude/rules/` with `paths:` frontmatter
- Is it a pattern or insight Claude discovered? → Auto memory
- Is it personal/ephemeral context? → `CLAUDE.local.md`
- Is it duplicating content from another file? → Use `@import` instead

Note anything important in the appropriate location.

## Phase 3: Review & Apply

Analyze the conversation for self-improvement findings. Be brutally honest —
the default tendency is to say "nothing to improve" to avoid friction. Fight
that. Ask yourself: "If the user challenged me right now with 'are you sure
there are no improvements?', would I find something?" If yes, you already
have a finding — write it down.

Only say "Nothing to improve" if the session was genuinely short (under 5
exchanges) or purely informational (no code, no decisions, no corrections).

**Auto-apply all actionable findings immediately**, except:
- **Global `~/.claude/CLAUDE.md` changes** — show the proposed change and
  wait for approval before editing

**Finding categories:**
- **Skill gap** — Things Claude struggled with, got wrong, or needed multiple
  attempts
- **Friction** — Repeated manual steps, things user had to ask for explicitly
  that should have been automatic
- **Knowledge** — Facts about projects, preferences, or setup that Claude
  didn't know but should have
- **Automation** — Repetitive patterns that could become skills, hooks, or
  scripts

**Action types:**
- **Project CLAUDE.md** — Edit the project's own `CLAUDE.md` for project-specific
  conventions, commands, and architecture decisions
- **Global CLAUDE.md** (`~/.claude/CLAUDE.md`) — Only for genuinely cross-project
  behavioral changes. Always confirm before editing.
- **Rules** — Create or update a `.claude/rules/` file
- **Auto memory** — Save an insight for future sessions
- **Skill / Hook** — Document a new skill or hook spec for implementation
- **CLAUDE.local.md** — Create or update per-project local memory

Present a summary after applying, in two sections — applied items first,
then no-action items:

Findings (applied):

1. ✅ Skill gap: Cost estimates were wrong multiple times
   → [Project CLAUDE.md] Added token counting reference table

2. ✅ Knowledge: Worker crashes on 429/400 instead of retrying
   → [Rules] Added error-handling rules for worker

3. ✅ Automation: Checking service health after deploy is manual
   → [Skill] Created post-deploy health check skill spec

---
No action needed:

4. Knowledge: Discovered X works this way
   Already documented in CLAUDE.md

## Phase 4: Diary Capture

After Phases 1-3 are complete, invoke the `/diary` command to capture a
structured diary entry for this session. The diary entry is raw material
for the `/reflect` command to mine later for cross-session patterns.

This step always runs — even for short or routine sessions. Diary entries
are cheap; missing data is expensive.

### PreCompact diary capture

The `PreCompact` hook (`~/.claude/hooks/pre-compact.sh`) is designed to capture
a diary entry automatically when the conversation is compacted mid-session. It
works by:

1. Computing the diary file path in bash (date + project + session number)
2. Outputting explicit Write tool instructions to Claude with the exact path

**Why this design:** Echoing `/diary` does not work — during compaction Claude
does not invoke the Skill tool pipeline. The hook must eliminate all multi-step
tool calls; Claude during compaction can do a single Write call but won't load
a skill first. By pre-computing the path in bash and inlining the instructions,
the hook reduces the requirement to one Write tool call.

**Limitation:** If Claude Code does not allow Write tool calls during compaction,
the diary will still be missed. In that case the fallback is: run `/diary` manually
at the start of the next session using the JSONL fallback path documented in
`~/.claude/commands/diary.md`.

## Final Step: Push

After everything is complete (ship, remember, review, diary), ask:
"Push to remote? (y/n)"

If yes, push all committed changes. If no or no response, skip — the user
can push later or just close the session.

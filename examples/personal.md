# Example: personal.md for wrap-up Phase 2

This is a template for `~/.claude/skills/wrap-up/personal.md` — a private file
that extends wrap-up Phase 2 with steps specific to your own workflow.

**How it works:** During Phase 2 (Remember It), the wrap-up skill checks whether
this file exists at `~/.claude/skills/wrap-up/personal.md`. If it does, Claude
reads it and executes every step defined here before continuing. The file never
gets committed to any repo — it lives only on your machine.

Copy this file to `~/.claude/skills/wrap-up/personal.md` and replace the
example steps with your own.

---

## Phase 2 addition: Project status tracker

After updating MEMORY.md, also update your project status file:

1. Read `~/Developer/project-status.md`
2. Find the entry for the current project
   - If no entry exists, add one in the appropriate section (Active / Stable / Archive)
3. Update these fields:
   - **Status**: concise summary of where the project stands now
   - **Last activity**: today's date
   - **Next steps**: what's open or planned next
   - **Backup**: "GitHub (repo-name)" or "Local only — sensitive, never push to GitHub"
4. If the project's activity level has clearly changed, move it to the
   appropriate section

---

## Other ideas for personal extensions

- Post a summary to a private Slack channel or notes app
- Update a personal Notion database with session metadata
- Append to a local time-tracking log
- Run a backup script for sensitive repos

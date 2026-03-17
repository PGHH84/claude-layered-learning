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

## Example: append to a work log

After updating MEMORY.md, append a one-line entry to `~/work-log.md`:

```
## YYYY-MM-DD — [project name]
- [one sentence: what was done]
- Next: [one sentence: what's next]
```

Create the file if it doesn't exist.

---

## Other ideas for personal extensions

- Update a personal task board (Notion, Linear, Trello) with session outcomes
- Post a summary to a private Slack channel or Teams message
- Append to a time-tracking log with estimated hours
- Run a backup script for sensitive local repos
- Send yourself an email summary of what was completed

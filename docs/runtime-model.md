# Claude Runtime Model

Claude Layered Learning uses a two-loop model:

- `wrap up` closes a session and captures durable memory
- `/diary` records a structured session entry
- `/reflect` analyzes repeated patterns across diary entries

Machine-local runtime state lives outside the repo:

- `~/.claude/memory/diary/`
- `~/.claude/memory/reflections/`
- `~/.claude/projects/<slug>/memory/`
- `~/.agents/global/`

The PreCompact hook writes session context into the diary flow before compaction, and shared global guidance is synchronized from `~/.agents/global/PROJECT.md`.

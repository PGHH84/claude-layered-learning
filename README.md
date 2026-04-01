# Claude Layered Learning

Claude Layered Learning is a public distribution repo for a two-loop learning system built around Claude Code. It combines a `wrap up` flow, standalone `/diary` capture, periodic `/reflect` analysis, and a PreCompact hook that helps preserve session context.

## What You Get

- Claude command docs for `/diary` and `/reflect`
- the `wrap-up` skill under [`skills/wrap-up/`](skills/wrap-up)
- the PreCompact hook under [`hooks/`](hooks)
- install guidance in [`INSTALL.md`](INSTALL.md)
- repo-local guidance in [`CLAUDE.md`](CLAUDE.md)

## Runtime Model

The system has two loops:

- `wrap up` closes a session, updates durable project memory, and triggers diary capture
- `/reflect` analyzes accumulated diary entries and proposes durable guidance updates

Machine-local runtime state stays outside the repo:

- Claude memory lives under `~/.claude/`
- shared global guidance lives in `~/.agents/global/PROJECT.md`
- generated mirrors are written to `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`

## Quickstart

```bash
git clone https://github.com/PGHH84/claude-layered-learning.git
cd claude-layered-learning
```

Then follow [`INSTALL.md`](INSTALL.md) to:

- copy the Claude commands
- install the `wrap-up` skill
- install the PreCompact hook
- set up the shared global sync helpers

## Repository Layout

- [`commands/`](commands) contains the public command docs
- [`skills/`](skills) contains the runtime `wrap-up` skill
- [`hooks/`](hooks) contains the PreCompact hook
- [`examples/`](examples) contains shareable sample files
- [`docs/`](docs) contains public reference docs

## Credits

- [rlancemartin/claude-diary](https://github.com/rlancemartin/claude-diary)
- [thebenlamm PR #3](https://github.com/rlancemartin/claude-diary/pull/3)
- [jonathanmalkin/jules](https://github.com/jonathanmalkin/jules)

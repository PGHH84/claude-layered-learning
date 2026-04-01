# Claude Layered Learning

This file is the repo-local guidance surface for the public Claude distribution repo.

## Scope

- Command behavior is documented in [`commands/`](commands).
- The `wrap-up` runtime behavior lives in [`skills/wrap-up/SKILL.md`](skills/wrap-up/SKILL.md).
- The PreCompact hook lives in [`hooks/pre-compact.sh`](hooks/pre-compact.sh).

## Rules

- Keep the repo Claude-focused. Do not add Codex-only runtime files here.
- Do not commit live runtime memory from `~/.claude/`.
- Keep examples redacted and shareable.
- When behavior changes, update [`CHANGELOG.md`](CHANGELOG.md), [`INSTALL.md`](INSTALL.md), and any affected command or skill docs together.
- Prefer generic example paths such as `/Users/example/...` when an absolute path helps explain behavior.

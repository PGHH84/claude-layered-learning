# Changelog

All notable changes to this project will be documented here.

Format: [Semantic Versioning](https://semver.org/) — `MAJOR.MINOR.PATCH`
- **MAJOR**: breaking changes (existing installs stop working)
- **MINOR**: new features, backwards compatible
- **PATCH**: bug fixes, no new features

---

## [1.1.2] - 2026-03-17

### Added
- `examples/personal.md`: template and setup instructions for the personal
  extensions hook. Shows how to create `~/.claude/skills/wrap-up/personal.md`
  with example steps (project status tracker, other workflow ideas).
- Wrap-up skill now points to `examples/personal.md` so users know the feature
  exists and where to find the template.

---

## [1.1.1] - 2026-03-17

### Fixed
- Personal extensions step in wrap-up Phase 2 was marked "optional", which
  allowed Claude to skip it. Changed to "execute every step, do not skip this"
  to ensure the file is always followed when present.

---

## [1.1.0] - 2026-03-17

### Added
- **Personal extensions hook** in wrap-up Phase 2: if
  `~/.claude/skills/wrap-up/personal.md` exists, Claude reads and executes
  every step it defines before continuing. Lets users add personal workflow
  steps (e.g. updating a local project tracker) without forking the skill or
  committing personal config to the repo.

### Changed
- Removed the hardcoded `~/Developer/project-status.md` update step from the
  public wrap-up skill — moved to personal.md pattern instead.

---

## [1.0.2] - 2026-03-17

### Changed
- Cleaned up wrap-up skill for public distribution: removed personal
  project-status.md step that referenced a file specific to one user's setup.

---

## [1.0.1] - 2026-03-16

### Fixed
- **Pre-compact hook was silently broken**: echoing `/diary` to stdout does not
  invoke the Skill tool pipeline during compaction — Claude generates a summary
  in text-only mode and ignores slash commands. Hook now computes the diary
  file path in bash and outputs explicit Write tool instructions with the exact
  path, reducing Claude's required work to a single Write call.
- Updated INSTALL.md to document the corrected hook design and replace the
  inline hook snippet with the working implementation.
- Removed stray blank line from hook script.

---

## [1.0.0] - 2026-03-15

### Initial public release

- **wrap-up skill**: end-of-session checklist covering ship (commit, docs, file
  placement, deploy, task cleanup), remember (MEMORY.md update, memory
  placement guide), review & apply (self-improvement findings), and diary
  capture.
- **diary command**: captures structured session diary entries from conversation
  context. Includes JSONL fallback for post-compaction analysis.
- **reflect command**: analyzes accumulated diary entries across sessions,
  identifies recurring patterns, and proposes CLAUDE.md updates.
- **PreCompact hook**: automatically triggers diary capture before Claude Code
  compacts long conversations.
- **MEMORY.md auto-memory system**: persistent file-based memory with user,
  feedback, project, and reference types.

# Claude Full Parity Implementation Plan

Parent: [[docs/MOC]]
Related: [[2026-04-01-claude-full-parity-design]]

**Goal:** Update Claude Layered Learning to match the approved full-parity
source-of-truth model so Claude and Codex converge on the same local and global
durable-guidance architecture.

**Architecture:** Keep Claude diary and reflection storage under `~/.claude/`,
but route project-local operating guidance through repo `PROJECT.md`, route
global operating guidance through canonical `~/.agents/global/PROJECT.md`, and
use generated mirrors instead of treating `CLAUDE.md` files as the primary
writable durable source in triumvirate repos.

**Tech Stack:** Markdown command and skill files, bash hook/install scripts,
README and installation docs

---

### Task 1: Add the new planning and design layer to the Claude engine

**Files:**
- Add: `docs/MOC.md`
- Add: `docs/specs/2026-04-01-claude-full-parity-design.md`
- Add: `docs/plans/2026-04-01-claude-full-parity-plan.md`
- Modify: `MOC-engine.md`

- [ ] Write the Claude full-parity design spec
- [ ] Write the Claude implementation plan
- [ ] Link the new docs area from `MOC-engine.md`

### Task 2: Update `wrap-up` to the new local/global routing model

**Files:**
- Modify: `skills/wrap-up/SKILL.md`
- Modify: `README.md`
- Modify: `INSTALL.md`

- [ ] Route project-local operating improvements to repo `PROJECT.md`
- [ ] Route global operating improvements to `~/.agents/global/PROJECT.md`
- [ ] Trigger global mirror sync after approved global edits
- [ ] Preserve the no-push behavior
- [ ] Remove stale language that still treats `~/.claude/CLAUDE.md` as the
      primary writable global source

### Task 3: Update `reflect` to the new canonical destination model

**Files:**
- Modify: `commands/reflect.md`
- Modify: `README.md`
- Modify: `INSTALL.md`

- [ ] Change promotion destinations from project/global `CLAUDE.md` to:
  - repo `PROJECT.md`
  - `~/.agents/global/PROJECT.md`
- [ ] Keep current reflection depth and analysis quality
- [ ] Update `processed.log` advancement semantics to require acceptance plus
      approved-edit resolution
- [ ] Update proposal examples so they reference the new canonical destinations

### Task 4: Update `diary` and hook project identity rules

**Files:**
- Modify: `commands/diary.md`
- Modify: `hooks/pre-compact.sh`

- [ ] Collapse git worktree paths to the main repo identity before deriving
      diary file names or project memory paths
- [ ] Preserve current diary structure and fallback behavior

### Task 5: Update installation and standalone-sync assumptions

**Files:**
- Modify: `INSTALL.md`
- Modify any install helper text or instructions in `README.md`

- [ ] Decide whether the Claude repo installs the shared sync script itself or
      assumes it already exists from the Codex/global setup
- [ ] Document canonical global file seeding from existing `~/.claude/CLAUDE.md`
- [ ] Document the generated mirror model explicitly

### Task 6: Verify the Claude docs and runtime contract are internally consistent

**Files:**
- Modify: `README.md`
- Modify: `INSTALL.md`
- Modify: `CHANGELOG.md`

- [ ] Remove stale statements that direct durable edits to project/global
      `CLAUDE.md` in triumvirate and canonical-global flows
- [ ] Add a changelog entry for the parity migration
- [ ] Re-read `README.md`, `INSTALL.md`, `skills/wrap-up/SKILL.md`,
      `commands/reflect.md`, and `commands/diary.md` for consistency

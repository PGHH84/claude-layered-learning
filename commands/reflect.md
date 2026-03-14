---
description: Analyze diary entries to identify cross-session patterns and propose CLAUDE.md updates
---

# Reflect on Diary Entries and Synthesize Insights

Analyze accumulated diary entries to identify recurring patterns across sessions
and projects, then propose updates to CLAUDE.md files. This is the cross-session
pattern recognition step — it sees what single-session wrap-ups cannot.

Reflect ONLY proposes changes to CLAUDE.md files (global and project-level).
It does not touch `.claude/rules/`, hooks, skills, or auto memory — those are
handled by the immediate learning loop in wrap-up.

## Parameters

The user can provide:
- **Date range**: "from YYYY-MM-DD to YYYY-MM-DD" or "last N days"
- **Entry count**: "last N entries" (e.g., "last 10 entries")
- **Project filter**: "for project [project-path]"
- **Pattern filter**: "related to [keyword]" (e.g., "related to testing")

Default: analyze **all unprocessed diary entries**.

## Steps

### 1. Setup and gather entries

```bash
mkdir -p ~/.claude/memory/diary ~/.claude/memory/reflections
```

- Read `~/.claude/memory/reflections/processed.log` (if missing, create it)
- List entries in `~/.claude/memory/diary/` sorted by date (newest first)
- Entries named: `YYYY-MM-DD-[project]-session-N.md`
- Exclude already-processed entries (unless user requests re-analysis)
- Apply any user-specified filters (date range, project, keyword)
- Read each filtered diary entry, extracting from all sections, especially:
  - User Preferences Observed
  - Code Patterns and Decisions
  - Actions Taken
  - Solutions Applied (what works well)
  - Challenges Encountered (what to avoid)
- If a section is missing: skip it (don't fail), note in Metadata
- Read the **One-Off Observations** section from the last 3 reflections in
  `~/.claude/memory/reflections/` (fewer if less exist). If any current
  pattern was previously flagged as a one-off, count those prior occurrences
  toward the frequency threshold. Example: a preference appeared 2x in this
  batch + was a one-off in a prior reflection = 3 occurrences → high confidence.

### 2. Read existing CLAUDE.md files

- Read `~/.claude/CLAUDE.md` for existing global rules
- For each unique project found in diary entries:
  - Check if `[project-path]/CLAUDE.md` exists
  - If it exists, read it for existing project-specific rules
- Before proposing any rule later, check if the same intent already exists in
  the relevant CLAUDE.md, even if worded differently. If a similar rule exists,
  skip it or propose merging the two rather than adding a duplicate

### 3. Analyze for patterns and rule violations

**Frequency analysis**: What preferences/patterns appear in multiple entries?
**Consistency check**: Are preferences consistent or contradictory?
**Context awareness**: Do patterns apply globally or to specific project types?
**Signal vs. noise**: One-off requests vs. recurring patterns

**Rule Violation Detection** (HIGHEST PRIORITY):
- Check if diary entries show violations of EXISTING CLAUDE.md rules
- Look in "Challenges Encountered", "User Preferences Observed" sections
- If user corrected Claude for violating an existing rule → rule needs STRENGTHENING
- Strengthening actions: move to top, add emphasis, make explicit, add override language

**Global vs Project-Specific Classification**:

For each pattern, classify using this decision test (ask in order):

1. Does this rule mention a SPECIFIC codebase? (file paths, service names)
   - YES → PROJECT-SPECIFIC
2. Is this a technology rule?
   - Does user have MULTIPLE projects using this technology?
     - YES → GLOBAL (Technology-Specific section)
     - NO → PROJECT-SPECIFIC
3. Would this rule make sense in a completely different project?
   - YES → GLOBAL
   - NO → PROJECT-SPECIFIC

**GLOBAL examples**:
- "use conventional commits" — applies to all git repos
- "never swallow exceptions silently" — applies to all code
- "bash scripts: log functions MUST output to stderr" — technology rule across projects

**PROJECT-SPECIFIC examples**:
- "WebSocket endpoint is /ws/chat not /socket" — codebase-specific path
- "Use get_screen() for Textual screens" — only one project uses Textual
- "Lambda layer must include zod@3.25.76" — specific to this serverless project

**When in doubt**: if a rule mentions specific file paths, service names, or
custom conventions → PROJECT-SPECIFIC

### 4. Synthesize insights by category

Focus on concise, actionable rules suitable for CLAUDE.md.

**PRIORITY: Rule Violations** (address first)

**A. Persistent Preferences** (2+ occurrences; 3+ = high confidence)
- Commit style, code organization, testing workflows, tool choices

**B. Design Decisions That Worked** — successful approaches worth repeating

**C. Anti-Patterns to Avoid** (2+ occurrences; 3+ = high confidence)

**D. Efficiency Lessons** — workflows, tools, processes that save time

**E. Project-Specific Patterns** — patterns for specific projects (routed to project CLAUDE.md)

### 5. Generate reflection document

Save to `~/.claude/memory/reflections/YYYY-MM-DD-reflection-N.md`

Scope guidance for large analyses (>20 entries):
- Group similar patterns to avoid repetition
- Focus on highest-confidence patterns (3+) first
- Limit detailed examples to 3 per pattern
- Target length: 300-800 lines

Use this exact template:

```markdown
# Reflection: [Date Range or "Last N Entries"]

**Generated**: [YYYY-MM-DD HH:MM:SS]
**Entries Analyzed**: [count]
**Date Range**: [first-date] to [last-date]
**Projects**: [list of projects or "All projects"]

## Summary
[2-3 paragraph overview of key insights]

## CRITICAL: Rule Violations Detected
[ONLY include if violations found. OMIT entirely if none.]

**Rule**: [existing rule that was violated]
**Violation Pattern**: [how it appeared — quote examples]
**Frequency**: [X/Y entries]
**Impact**: [why this is serious — user had to correct multiple times]
**Root Cause**: [why the existing rule failed — too weak, buried in list, ambiguous wording]
**Strengthening Action**: [specific changes]

## Patterns Identified

### A. Persistent Preferences (2+; 3+ = high confidence)
1. **[Preference]** (X/Y entries)
   - **Observation**: [what was preferred]
   - **Confidence**: High/Medium/Low
   - **CLAUDE.md rule**: `- [succinct rule]`

### B. Design Decisions That Worked
1. **[Decision]**
   - **What worked**: [description]
   - **CLAUDE.md rule** (if generalizable): `- [succinct rule]`

### C. Anti-Patterns to Avoid (2+; 3+ = high confidence)
1. **[Anti-pattern]** (X/Y entries)
   - **What to do instead**: [alternative]
   - **CLAUDE.md rule**: `- [avoid X, use Y instead]`

### D. Efficiency Lessons
1. **[Pattern]**
   - **CLAUDE.md rule** (if applicable): `- [succinct rule]`

### E. Project-Specific Patterns
1. **[Pattern]** (for [project path])
   - **Target file**: `[project-path]/CLAUDE.md`
   - **Rule to add**: `- [action]`

## Notable Mistakes and Learnings
- **Mistake**: [what went wrong]
  - **Learning**: [what was learned]
  - **Prevention**: [how to avoid]

## One-Off Observations
- [observations from single sessions — not patterns yet]

## Proposed CLAUDE.md Updates

FORMAT REQUIREMENTS:
- Succinct, non-verbose (CLAUDE.md loads into every session)
- Bullet points, imperative tone
- No explanations — just the rule
- Group related rules together
- Use context markers when needed (e.g., "for Python:", "when testing:", "in React projects:")

**Good example** (succinct, actionable):
```markdown
- git commits: use conventional format (feat:, fix:, refactor:, docs:, test:)
- testing: always run tests before committing, ensure they pass
- error handling: wrap async operations in try-catch; never use empty catch blocks
```

**Bad example** (too verbose):
```markdown
- When you are creating git commits, it's important to follow the conventional
  commit format which includes prefixes like feat: for features, fix: for bug
  fixes, refactor: for code refactoring, docs: for documentation changes, and
  test: for test changes. This helps maintain consistency across the codebase.
```

### new GLOBAL rule (for `~/.claude/CLAUDE.md`)

#### Section: [General Preferences / Code Quality / Git Workflow / etc.]
- [Actionable rule 1]
- [Actionable rule 2]

### new PROJECT-SPECIFIC rule (for project CLAUDE.md files)

#### Project: [project-path]
**Target file**: `[project-path]/CLAUDE.md`
- [Rule specific to this project]

## Metadata
- **Diary entries analyzed**: [list of filenames]
- **Projects covered**: [list]
- **Challenges documented**: [count]
```

### 6. Present proposal and apply updates

**Approval model:**
- **Project CLAUDE.md changes**: auto-apply immediately
- **Global `~/.claude/CLAUDE.md` changes**: present the proposed changes and
  wait for user approval. The user may approve all, some, or none.

**Show the full proposal:**
- Strengthened rules (before/after)
- Global rules to add (require approval)
- Project-specific rules to add (auto-applied)

**After approval, apply in priority order:**

1. **Strengthen violated rules** — edit in place, add emphasis/override language
2. **Add GLOBAL rules to `~/.claude/CLAUDE.md`** — append to appropriate sections
   (create sections if needed), maintain succinct bullet-point format
3. **Add PROJECT-SPECIFIC rules to project CLAUDE.md files**:
   - Only write to project paths mentioned in diary entries
   - Verify the directory exists; never write outside user's workspace
   - If CLAUDE.md exists: find appropriate section (or create "## Learned Patterns"), append
   - If no CLAUDE.md: create with template including "## Learned Patterns"
   - Check for semantic duplicates and conflicts with global rules
   - Flag conflicts for user review instead of auto-adding

**Update processed.log** immediately after applying:
```
[diary-filename] | [YYYY-MM-DD] | [reflection-filename]
```

### 7. Completion summary

- Rule violations detected and strengthened (if any)
- Reflection filename and location
- Pattern count (global vs project-specific)
- Global CLAUDE.md sections updated (with approval status)
- Project CLAUDE.md files updated with rule count
- processed.log confirmation

## Pattern Recognition Principles

1. **Frequency**: 2+ = propose rule; 3+ = high confidence; 1 = document only
2. **Context**: universal → GLOBAL; tech across projects → GLOBAL; single project → PROJECT-SPECIFIC
3. **Consistency**: flag contradictions for user review
4. **Actionability**: only propose rules Claude can follow
5. **Abstraction**: not too specific, not too broad
6. **Succinctness**: one-line bullets, imperative tone, no explanations
7. **Value**: will this rule actually improve future interactions? Skip rules that document the obvious or add noise without changing behavior

### Distinguishing Signal from Noise

**SIGNAL** (add to CLAUDE.md):
- "Always use TypeScript strict mode" (appears in 5 sessions across 3 projects)
- "Run tests before committing" (appears in 6 sessions)
- "Never swallow exceptions silently" (appears in 4 sessions)

**NOISE** (document in One-Off Observations, don't add to CLAUDE.md):
- "Make this button pink" (appears once, specific task)
- "Use dark mode for this demo" (appears once, context-specific)
- "Skip tests this time" (contradicted by usual pattern)

## Handling Already-Processed Entries

**Default**: Skip entries already in `~/.claude/memory/reflections/processed.log`

**Override flags**:
- "include all entries" — re-analyze everything including processed
- "reprocess [filename]" — re-analyze specific entry
- "last N entries including processed" — analyze N most recent, even if processed

**When to suggest re-processing**:
- User significantly changed their workflow
- User wants to validate previous patterns
- User wants to extract different insights from same sessions

## Error Handling

- No diary entries → suggest running `/diary` or wrap-up first
- All entries processed → inform user, suggest "include all entries"
- Filter matches nothing → show options (remove filter, include processed, try different filter)
- Fewer than 3 entries → proceed but note low pattern confidence
- Malformed entries → skip and document which had issues
- CLAUDE.md read/write failure → report error but continue with reflection
- Project directory doesn't exist → skip and report in summary
- Rule conflicts with global → flag for user review, don't auto-add

## Example Usage

```
/reflect                                    # Last 10 unprocessed entries
/reflect last 20 entries                    # More entries
/reflect from 2026-01-01 to 2026-03-31     # Date range
/reflect for project ~/Developer/my-app     # Single project
/reflect related to testing                 # Keyword filter
/reflect include all entries                # Re-analyze everything
/reflect reprocess 2026-03-13-session-1.md  # Re-analyze specific entry
```

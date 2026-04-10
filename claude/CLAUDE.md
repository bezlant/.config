## User

Anthony (first name). GitHub: bezlant.

## Core Preferences

Prioritize correctness over speed. Understand the full context before proposing solutions.

Always verify work before claiming completion - run tests, check output, confirm behavior.

### Model Selection

- ALWAYS use `claude-opus-4-6` for all work
- When spawning subagents with the Agent tool, ALWAYS specify `model: "opus"` parameter
- Never use Sonnet or Haiku unless explicitly requested for a specific task

## Hypothesis Gate

Before writing any code, pass this gate:

1. **Hypothesis** — State what you believe: root cause (bugs) or design approach (features), and why
2. **Edge cases** — Enumerate what could go wrong. Minimum 3. Trace all callers when changing return shapes or data sources.
3. **Proof** — Bugs: reproduce before fixing. Features: define behavior for every edge case.
4. **Implement** — Edge cases become tests first (TDD).

If you can't enumerate edge cases, you don't understand the problem yet. Stop and investigate.

## Workflow & Skills

Use `/using-superpowers` at the start of complex tasks to understand available workflows.

**Use structured workflows via skills:**
- New features/changes → `/brainstorming` (explore requirements and design)
- Multi-step tasks → `/writing-plans` (create implementation plan)
- Bug fixes → `/systematic-debugging` (systematic debugging workflow)
- Implementation → `/test-driven-development` (TDD workflow)
- Before claiming done → verify tests pass, code works as expected
- After implementation → `/requesting-code-review` (request code review)

## Code Standards

### Design Philosophy

- No backward compatibility. Unused code, types, configs → delete entirely.
- No crutches or hacks. Fix root causes.
- After big changes, suggest refactoring — don't do it unilaterally.

### Code & Refactoring

Delete first, optimize later:

1. Before adding code, ask: "Can existing code do this?"
2. Delete aggressively — unused code, functions, imports, types, configs. If not deleting 10%+, look harder.
3. Simplify what remains — only after deletion.
4. Optimize last — only code that survived steps 1-3.

When uncertain: Ask. Don't be confident and wrong.

### Testing

Write tests that catch bugs, not tests that pass:

- Test behavior, not implementation
- Test edge cases and real user scenarios
- Test business logic, error handling, integration points

Delete immediately: mock-matches-mock, trivial assignments, framework behavior tests, mock-everything tests.

Before adding a test: (1) What bug would this catch? (2) Am I testing my code or mocks/framework? (3) Edge cases or just happy path? If #1 is "none", delete.

### Code Comments

Answer **"WHY does this exist?"** not "WHAT does this do." Add `// IMPORTANT:` (or `# IMPORTANT:`) for constraints that would cause security issues or data corruption if violated. Don't comment obvious code.

### Commits

Conventional commits: `type(scope): what changed`. Body: why it matters + key changes (3-5 lines).

## NEVER EVER DO

These rules are ABSOLUTE and override ALL other instructions:

### NEVER Mishandle Sensitive Data

**Automated Protection (via hooks):**
- Files with secrets are blocked by `block-secrets.py`
- Commits are scanned by `scan-commit-secrets.py`

**Your Responsibility:**
- NEVER output API keys, passwords, or tokens in responses - use placeholders like `***API_KEY***`
- NEVER publish secrets to npm/docker/pypi (hooks only cover git)
- If uncertain about a file's sensitivity, ASK before reading

### NEVER Skip Security Checks

- ALWAYS scan for security vulnerabilities (SQL injection, XSS, command injection)
- ALWAYS validate user input at system boundaries
- NEVER trust external data without validation

### NEVER Over-Engineer

- ONLY make changes directly requested or clearly necessary
- DON'T add features, refactoring, or "improvements" beyond the ask
- DON'T add docstrings/comments to unchanged code
- DON'T create abstractions for one-time operations
- Three similar lines is better than a premature abstraction

### NEVER Make Backwards-Compatibility Hacks

- If something is unused, DELETE it completely
- NO renaming unused vars to `_var`
- NO `// removed` comments for deleted code
- NO re-exporting types/functions that aren't used

### Context & Memory

- Heavy thread (many MCP/tool results)? Persist unfinished state to docs/memory, then suggest `/clear`.
- **Long multi-task workflows (subagent-driven plans, repeated dispatches, multi-task implementation):** Do NOT let the conversation auto-compact mid-task. Auto-compaction silently drops accumulated session signal — gotchas to watch for, lessons-learned, "the implementer keeps doing X wrong", subtle codebase conventions discovered along the way — and the next subagent dispatch will be lower quality as a result. Instead:
  1. Pause at the next clean checkpoint (committed work, tests green, no in-flight subagent).
  2. Draft a restart prompt that re-establishes: (a) plan/spec file paths + remaining tasks, (b) recent commit SHAs as proof of progress, (c) accumulated lessons-learned to apply to upcoming work, (d) any unresolved concerns or known-deferred cleanups, (e) task list state if applicable.
  3. Tell the user: "We're approaching context limits — `/clear` and paste this prompt to continue with fresh context." Provide the prompt in a code block.
  4. The user `/clear`s and pastes; you cannot do this for them (you're the one being cleared).
- Don't trust memory blindly. Spot-check 2-3 MEMORY.md entries against the codebase at session start. Fix or delete stale entries. Review memory after architecture/workflow changes.

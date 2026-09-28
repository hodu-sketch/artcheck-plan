# artcheck-plan

Planning and design workspace for artcheck, a 공연·전시 캘린더 website (미술 전시 first, then 뮤지컬 and more). No application code is written here.

- Dev project (read-only from here): the sibling folder `../artcheck-dev`. Locally it is your own checkout. In cloud sessions `.claude/hooks/sync-dev.sh` puts a read-only copy of its default branch there at session start.
- Stack and architecture rules (Spring Modulith modular monolith, module boundaries, no Kafka/Kubernetes until asked, Liquibase, React + Vite) are defined in `../artcheck-dev/CLAUDE.md`. Read that file when designing. Do not restate or change those rules here.
- Design conventions come from the dev project's skills. Read them from the dev folder instead of copying them:
  - modules: `../artcheck-dev/.claude/skills/spring-modulith/SKILL.md`
  - tables: `../artcheck-dev/.claude/skills/postgres-patterns/SKILL.md`, `../artcheck-dev/.claude/skills/jpa-patterns/SKILL.md`
  - REST APIs: `../artcheck-dev/.claude/skills/api-design/SKILL.md`

## Reference design (not decisions)

- `docs/current/reference-design.md` summarizes a draft design written before any cycle (2026-09-28). It is one possibility and may change at any time. Use it as input for proposals, never as a decision. A value becomes a decision only when the user confirms it in a cycle and it is recorded in an ADR or in `module-map.md`, `data-model.md`, `api.md`.
- `docs/current/cycle-plan.md` is the planned order of cycles. `/cycle-start` picks the next slice from it; the scope is fixed there with the user, and the plan may change.

## How we work: small slices, repeated cycles

Do not plan or design the whole product up front. One cycle takes one small feature slice through planning and design, hands it off to the dev project, and the next cycle starts after reviewing what was actually built.

1. `/cycle-start <slice>` — review the previous cycle against the dev code, then fix this cycle's scope
2. `/feature-spec` — requirements and acceptance criteria for this slice only
3. `/screen-flow` — screens and states for this slice only
4. `/design-delta` — only the module, table and API changes this slice needs (uses the `architect` subagent)
5. `/adr <title>` — record each decision as it is made
6. `/cycle-close` — review (`design-reviewer`), update `docs/current/`, write the handoff (`planner`)

Current cycle: none yet. Start with `/cycle-start 00-foundation`.

## Documents

- `docs/backlog.md` — ideas not in any cycle yet
- `docs/current/` — the design as it stands now: `module-map.md`, `data-model.md`, `api.md`, `handoff.md`
- `docs/current/reference-design.md` — the pre-cycle draft design (reference only)
- `docs/current/cycle-plan.md` — the planned cycle order
- `docs/adr/README.md` — ADR index; `docs/adr/NNNN-<slug>.md` — decision records
- `docs/cycles/NN-<slug>/` — `scope.md`, `spec.md`, `flow.md`, `design-delta.md`, `handoff.md`, `retro.md`

The dev project imports `docs/current/handoff.md` from its `CLAUDE.md` (cloud sessions load it through a SessionStart hook instead), so keep that file limited to the current handoff.

## Cloud sessions

- Start a cloud session with this repository only. Adding the dev repository at session start turns off this repository's hooks.
- Work is pushed to the session's own branch. The dev project reads `docs/current/handoff.md` from the default branch, so tell the user to merge the plan branch before starting the dev session.

## Language

- Write everything under `docs/` in Korean.
- Keep identifiers in English: module, package, table, column, endpoint and event names.
- Config files (`CLAUDE.md`, `.claude/`) stay in English.

## Working rules

- Ask the user before deciding. Present choices as proposals (안) with trade-offs; the user decides.
- Review documents in the browser with the `plan-canvas` skill when `ecc-plan-canvas` is installed; otherwise review in the conversation and tell the user the canvas is unavailable.
- Whenever a document gains or changes Mermaid diagrams, show them to the user rendered (canvas, or a rendered HTML page sent with `SendUserFile`), not only as text.
- Use AskUserQuestion for decisions during a cycle; subagents cannot ask the user, so collect answers in the main conversation.
- Verify external facts (APIs, libraries, versions, data sources) against official sources and cite the URL and check date. If it cannot be verified, say so.

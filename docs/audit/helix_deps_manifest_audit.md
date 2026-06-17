# Submodule-Dependency-Manifest (§11.4.31) Debt Audit

**Revision:** 1
**Last modified:** 2026-06-17T05:01:35Z

Per HelixConstitution **§11.4.31 — Submodule-Dependency-Manifest Mandate**: every
owned-by-us submodule MUST ship a machine-readable dependency manifest at the
canonical path `helix-deps.yaml` (or `.json` / `.toml`) at its root, declaring its
own-org Git SSH dependencies.

This audit is **read-only, evidence-backed** (§11.4 anti-bluff, §11.4.6 no-guessing).
Each row below is derived from `test -f <path>/helix-deps.{yaml,json,toml}` against the
live working tree at the timestamp above.

## Scope

- **Source of submodule paths:** `git config -f .gitmodules --get-regexp 'path'`.
- **Excluded (non-contention carve-out — main stream concurrently renaming):**
  `Core`, `Web-Client`, `Desktop-Client`, `Android-Client`, `iOS-Client`,
  `Screensaver`, and `constitution` (constitution submodule itself).
- **Manifest filenames checked:** `helix-deps.yaml`, `helix-deps.json`, `helix-deps.toml`.

## Summary

| Metric | Count |
|---|---|
| Submodules audited (in scope) | **47** |
| WITH manifest | **14** |
| MISSING manifest (the §11.4.31 debt) | **33** |

## Per-submodule audit table

| Submodule | Manifest present? | Manifest file | Declared-deps count |
|---|---|---|---|
| harmony_os_client | NO | — | — |
| aurora_os_client | NO | — | — |
| containers | YES | helix-deps.yaml | 0 (leaf) |
| docs_chain | YES | helix-deps.yaml | 0 (leaf) |
| challenges | YES | helix-deps.yaml | 2 |
| helix_qa | YES | helix-deps.yaml | 8 |
| helix_agent | YES | helix-deps.yaml | 42 |
| panoptic | NO | — | — |
| doc_processor | NO | — | — |
| llm_orchestrator | NO | — | — |
| llm_provider | NO | — | — |
| llms_verifier | YES | helix-deps.yaml | 1 |
| security | YES | helix-deps.yaml | 0 (leaf) |
| vision_engine | YES | helix-deps.yaml | 0 (leaf) |
| dag_orchestrator | YES | helix-deps.yaml | 0 (leaf) |
| agentic | NO | — | — |
| auth | YES | helix-deps.yaml | 0 (leaf) |
| background_tasks | NO | — | — |
| benchmark | NO | — | — |
| concurrency | YES | helix-deps.yaml | 0 (leaf) |
| database | YES | helix-deps.yaml | 0 (leaf) |
| debate_orchestrator | NO | — | — |
| embeddings | NO | — | — |
| event_bus | NO | — | — |
| formatters | NO | — | — |
| helix_memory | NO | — | — |
| helix_specifier | NO | — | — |
| llm_ops | NO | — | — |
| mcp_module | NO | — | — |
| memory | NO | — | — |
| messaging | NO | — | — |
| models | NO | — | — |
| normalize | NO | — | — |
| observability | YES | helix-deps.yaml | 0 (leaf) |
| optimization | NO | — | — |
| planning | NO | — | — |
| plugins | NO | — | — |
| rag | NO | — | — |
| red_team | NO | — | — |
| self_improve | NO | — | — |
| skill_registry | NO | — | — |
| storage | NO | — | — |
| streaming | NO | — | — |
| tool_schema | NO | — | — |
| vector_db | NO | — | — |
| conversation | NO | — | — |
| cache | YES | helix-deps.yaml | 0 (leaf) |

## Debt list — submodules MISSING a `helix-deps.*` manifest (33)

These 33 in-scope own-org submodules carry NO `helix-deps.yaml` / `.json` / `.toml`
at their root and are therefore in violation of §11.4.31 until a manifest is authored:

1. harmony_os_client
2. aurora_os_client
3. panoptic
4. doc_processor
5. llm_orchestrator
6. llm_provider
7. agentic
8. background_tasks
9. benchmark
10. debate_orchestrator
11. embeddings
12. event_bus
13. formatters
14. helix_memory
15. helix_specifier
16. llm_ops
17. mcp_module
18. memory
19. messaging
20. models
21. normalize
22. optimization
23. planning
24. plugins
25. rag
26. red_team
27. self_improve
28. skill_registry
29. storage
30. streaming
31. tool_schema
32. vector_db
33. conversation

**Note (forensic, §11.4.6):** several of these (`agentic`, `auth`-class peers,
`background_tasks`, `models`, etc.) are referenced as declared deps inside
`helix_agent/helix-deps.yaml` (42 declared own-org deps via `go.mod replace`),
so the absence of their OWN manifest is a concrete cross-reconstruction gap — a
consumer cloning `helix_agent` cannot recurse into these peers to learn THEIR
transitive own-org deps (§11.4.31 `transitive_handling.recursive: true`).

## Has-manifest section (14)

The following in-scope submodules satisfy §11.4.31. The declared-deps count is the
count of `- name:` entries under the manifest `deps:` block (`0 (leaf)` = explicit
`deps: []` honest leaf manifest):

| Submodule | Declared-deps count | Notes (from manifest header / deps) |
|---|---|---|
| containers | 0 (leaf) | Leaf Go submodule, `deps: []`. |
| docs_chain | 0 (leaf) | Leaf Go submodule (digital.vasic.docs_chain), `deps: []`. |
| challenges | 2 | `containers` (vasic-digital), `Panoptic` (vasic-digital) — Panoptic flagged as the tracked §11.4.28 nested-own-org violation to flatten. |
| helix_qa | 8 | Challenges, Containers, DocProcessor, LLMOrchestrator, LLMProvider, LLMsVerifier, security, VisionEngine — matches go.mod `replace` block. |
| helix_agent | 42 | `dev.helix.dag` (DagOrchestrator) + 41 `digital.vasic.*` modules via go.mod replace; manifest header notes some `why:` lines are `[inferred]`. |
| llms_verifier | 1 | `Challenges` (vasic-digital) — corrected 2026-06-08 to match actual go.mod replace blocks. |
| security | 0 (leaf) | Leaf Go submodule, `deps: []`. |
| vision_engine | 0 (leaf) | Leaf Go submodule (digital.vasic.visionengine), `deps: []`. |
| dag_orchestrator | 0 (leaf) | Standalone Go module (dev.helix.dag), `deps: []` scaffold. |
| auth | 0 (leaf) | Leaf Go submodule (digital.vasic.auth), `deps: []`. |
| concurrency | 0 (leaf) | Leaf Go submodule, `deps: []`. |
| database | 0 (leaf) | Leaf Go submodule, `deps: []`. |
| observability | 0 (leaf) | Leaf Go submodule, `deps: []`. |
| cache | 0 (leaf) | Leaf Go submodule, `deps: []`. |

## Captured evidence (verbatim command output)

### 1. Manifest presence check (per-submodule, in scope)

```text
MISSING|harmony_os_client|-
MISSING|aurora_os_client|-
HAS|containers|helix-deps.yaml
HAS|docs_chain|helix-deps.yaml
HAS|challenges|helix-deps.yaml
HAS|helix_qa|helix-deps.yaml
HAS|helix_agent|helix-deps.yaml
MISSING|panoptic|-
MISSING|doc_processor|-
MISSING|llm_orchestrator|-
MISSING|llm_provider|-
HAS|llms_verifier|helix-deps.yaml
HAS|security|helix-deps.yaml
HAS|vision_engine|helix-deps.yaml
HAS|dag_orchestrator|helix-deps.yaml
MISSING|agentic|-
HAS|auth|helix-deps.yaml
MISSING|background_tasks|-
MISSING|benchmark|-
HAS|concurrency|helix-deps.yaml
HAS|database|helix-deps.yaml
MISSING|debate_orchestrator|-
MISSING|embeddings|-
MISSING|event_bus|-
MISSING|formatters|-
MISSING|helix_memory|-
MISSING|helix_specifier|-
MISSING|llm_ops|-
MISSING|mcp_module|-
MISSING|memory|-
MISSING|messaging|-
MISSING|models|-
MISSING|normalize|-
HAS|observability|helix-deps.yaml
MISSING|optimization|-
MISSING|planning|-
MISSING|plugins|-
MISSING|rag|-
MISSING|red_team|-
MISSING|self_improve|-
MISSING|skill_registry|-
MISSING|storage|-
MISSING|streaming|-
MISSING|tool_schema|-
MISSING|vector_db|-
MISSING|conversation|-
HAS|cache|helix-deps.yaml
```

### 2. Declared-deps counts (`grep -cE '^\s*-\s*name:'` per manifest)

```text
DEPS_COUNT(containers)=0
DEPS_COUNT(docs_chain)=0
DEPS_COUNT(challenges)=2
DEPS_COUNT(helix_qa)=8
DEPS_COUNT(helix_agent)=42
DEPS_COUNT(llms_verifier)=1
DEPS_COUNT(security)=0
DEPS_COUNT(vision_engine)=0
DEPS_COUNT(dag_orchestrator)=0
DEPS_COUNT(auth)=0
DEPS_COUNT(concurrency)=0
DEPS_COUNT(database)=0
DEPS_COUNT(observability)=0
DEPS_COUNT(cache)=0
```

### 3. Totals

```text
AUDITED_TOTAL: 47
HAS_MANIFEST: 14
MISSING: 33
```

---

*Generated read-only per §11.4.31 audit. No git staging performed. This document is a
point-in-time snapshot at the Last-modified timestamp; re-run the presence check to
refresh.*

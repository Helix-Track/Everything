# install_upstreams Upstream-Remote Audit (§11.4.36)

**Revision:** 1
**Last modified:** 2026-06-17T05:00:58Z
**Authority:** §11.4.36 (mandatory `install_upstreams` on clone/add) · §6.W (GitHub + GitLab only; GitFlic/GitVerse retired) · §2.1 (multi-upstream push is the norm) · §11.4 anti-bluff (all rows backed by real captured `git remote -v` output)
**Scope:** Own-org submodules newly added to the `helix_track` monorepo, EXCLUDING the six in-flight client dirs being renamed by the concurrent main stream (`Core`, `Web-Client`/`web_client`, `Desktop-Client`, `Android-Client`, `iOS-Client`, `Screensaver`/`screensaver`) and `constitution`.

## Summary

| Metric | Count |
|---|---|
| Submodules in scope (audited) | 49 |
| Have BOTH a GitHub remote AND a GitLab remote | 40 |
| Have GitHub only (GitLab MIRROR GAP) | 9 |
| Have GitHub only AND no `upstreams/` recipe dir | 6 |
| Have GitHub only DESPITE having an `upstreams/` recipe dir | 3 |
| `install_upstreams` on PATH | yes (`/Volumes/T7/Projects/Red_Elf/Project_Toolkit/Upstreamable/install_upstreams`) |
| §6.W violation — retired GitFlic/GitVerse remotes configured | 1 (`models`) |

`install_upstreams` was run from the root of every in-scope submodule that contained an `upstreams/` (or legacy `Upstreams/`) directory with `*.sh` recipe files. It only modifies that submodule's own `.git/config` remotes (safe; no parent-repo or `.gitmodules` mutation).

## Per-submodule table

`install_upstreams-run-result` legend:
- `ran→gitlab-added` — recipe dir present, tool ran, a `gitlab` remote is now configured.
- `ran→NO-gitlab` — recipe dir present, tool ran, but no GitLab recipe / tool aborted before reaching one ⇒ still GitHub-only.
- `not-run(no-recipes)` — no `upstreams/`+`*.sh` recipes present, so `install_upstreams` is a no-op for §11.4.36.

| path | has-github-remote | has-gitlab-remote | upstreams-dir? | install_upstreams-run-result |
|---|---|---|---|---|
| harmony_os_client | yes | **no** | none | not-run(no-recipes) |
| aurora_os_client | yes | **no** | none | not-run(no-recipes) |
| containers | yes | yes | upstreams/ | ran→gitlab-added |
| docs_chain | yes | yes | Upstreams/ | ran→gitlab-added |
| challenges | yes | yes | upstreams/ | ran→gitlab-added |
| helix_qa | yes | yes | upstreams/ | ran→gitlab-added |
| helix_agent | yes | **no** | upstreams/ | ran→NO-gitlab (recipes are GitHub-only: GitHub.sh + GitHubHelixDevelopment.sh) |
| panoptic | yes | **no** | upstreams/ | ran→NO-gitlab (only recipe is GitHub.sh) |
| doc_processor | yes | yes | upstreams/ | ran→gitlab-added |
| llm_orchestrator | yes | **no** | upstreams/ | ran→NO-gitlab (push-all.sh ran + errored before VasicDigitalGitLab.sh) |
| llm_provider | yes | yes | upstreams/ | ran→gitlab-added |
| llms_verifier | yes | yes | upstreams/ | ran→gitlab-added |
| security | yes | yes | upstreams/ | ran→gitlab-added |
| vision_engine | yes | **no** | upstreams/ | ran→NO-gitlab (push-all.sh aborted on bad remote name before GitLab recipe) |
| dag_orchestrator | yes | **no** | none | not-run(no-recipes) |
| agentic | yes | yes | upstreams/ | ran→gitlab-added |
| auth | yes | yes | upstreams/ | ran→gitlab-added |
| background_tasks | yes | yes | upstreams/ | ran→gitlab-added |
| benchmark | yes | yes | upstreams/ | ran→gitlab-added |
| concurrency | yes | yes | upstreams/ | ran→gitlab-added |
| database | yes | yes | upstreams/ | ran→gitlab-added |
| debate_orchestrator | yes | **no** | none | not-run(no-recipes) |
| embeddings | yes | yes | upstreams/ | ran→gitlab-added |
| event_bus | yes | yes | upstreams/ | ran→gitlab-added |
| formatters | yes | yes | upstreams/ | ran→gitlab-added |
| helix_memory | yes | yes | upstreams/ | ran→gitlab-added |
| helix_specifier | yes | yes | upstreams/ | ran→gitlab-added |
| llm_ops | yes | yes | upstreams/ | ran→gitlab-added |
| mcp_module | yes | yes | upstreams/ | ran→gitlab-added |
| memory | yes | yes | upstreams/ | ran→gitlab-added |
| messaging | yes | yes | upstreams/ | ran→gitlab-added |
| models | yes | yes | upstreams/ | ran→gitlab-added (**§6.W VIOLATION: also configured gitflic + gitverse**) |
| normalize | yes | **no** | none | not-run(no-recipes) |
| observability | yes | yes | upstreams/ | ran→gitlab-added |
| optimization | yes | yes | upstreams/ | ran→gitlab-added |
| planning | yes | yes | upstreams/ | ran→gitlab-added |
| plugins | yes | yes | upstreams/ | ran→gitlab-added |
| rag | yes | yes | upstreams/ | ran→gitlab-added |
| red_team | yes | **no** | none | not-run(no-recipes) |
| self_improve | yes | yes | upstreams/ | ran→gitlab-added |
| skill_registry | yes | yes | upstreams/ | ran→gitlab-added |
| storage | yes | yes | upstreams/ | ran→gitlab-added |
| streaming | yes | yes | upstreams/ | ran→gitlab-added |
| tool_schema | yes | yes | upstreams/ | ran→gitlab-added |
| vector_db | yes | yes | upstreams/ | ran→gitlab-added |
| conversation | yes | yes | upstreams/ | ran→gitlab-added |
| cache | yes | yes | upstreams/ | ran→gitlab-added |

> Note: `web_client` and `screensaver` appear in the raw evidence below only because their `.gitmodules` path tokens are lowercase (the main stream already renamed `Web-Client`→`web_client` and `Screensaver`→`screensaver`). They are part of the six EXCLUDED client dirs and are NOT in audit scope; only read-only `git remote -v` was issued against them. They are excluded from the table and from all summary counts.

## Findings

### F1 — GitLab-mirror gaps (§6.W requires GitHub + GitLab) — 9 submodules

These 9 in-scope submodules currently have a GitHub remote but **no GitLab remote**, so a §2.1 multi-upstream push would land only on GitHub:

- **No recipes at all (6)** — `harmony_os_client`, `aurora_os_client`, `dag_orchestrator`, `debate_orchestrator`, `normalize`, `red_team`. These have no `upstreams/` directory, so `install_upstreams` cannot configure any mirror. They need an `upstreams/` dir with `GitHub.sh` + `GitLab.sh` recipes authored (and the GitLab repo created) before §6.W is satisfied.
- **Recipe dir present but no GitLab recipe ran (3)** — `helix_agent` (recipes are GitHub-only: `GitHub.sh` + `GitHubHelixDevelopment.sh`), `panoptic` (only `GitHub.sh`), `llm_orchestrator` and `vision_engine` (their `upstreams/` dirs contain non-recipe action scripts — `push-all.sh`, `setup-remotes.sh`, `sync-all.sh`, `push-*.sh` — which `install_upstreams` executed; those scripts errored/aborted the run before any GitLab recipe was reached). NOTE: `llm_orchestrator` DOES ship a `VasicDigitalGitLab.sh` recipe that was never processed because `push-all.sh` (alphabetically earlier) ran first and the run ended; `vision_engine` has no `GitLab.sh`/`VasicDigitalGitLab.sh` recipe at all.

### F2 — §6.W violation: retired carriers still configured — `models`

`models` ships `GitFlic.sh` + `GitVerse.sh` recipes (alongside `GitHub.sh` + `GitLab.sh`). `install_upstreams` therefore configured `gitflic git@gitflic.ru:vasic-digital/Models.git` and `gitverse git@gitverse.ru:vasic-digital/Models.git` remotes, and added both to the `origin` multi-push fan-out. Per §6.W these carriers are RETIRED (GitHub + GitLab only). REMEDIATION: remove the `GitFlic.sh` + `GitVerse.sh` recipes from `models/upstreams/` and drop the `gitflic`/`gitverse` remotes + their `origin` pushurls.

### F3 — Non-recipe action scripts inside `upstreams/` mis-executed by `install_upstreams`

`llm_orchestrator/upstreams/` and `vision_engine/upstreams/` contain operational scripts (`push-all.sh`, `setup-remotes.sh`, `sync-all.sh`, `push-helix-github.sh`, `push-vasic-digital-gitlab.sh`, etc.) that are NOT upstream-recipe declarations. `install_upstreams` treats every `*.sh` in the dir as a recipe and ran them, causing `ERROR: No upstream repository provided` (llm_orchestrator) and `fatal: 'vasic-digital-github' does not appear to be a git repository` (vision_engine). These action scripts should be relocated out of `upstreams/` (e.g. to `scripts/`) so the recipe set is clean.

## Raw captured evidence (`git remote -v`)

The fenced blocks below are the verbatim post-`install_upstreams` `git remote -v` output for every in-scope submodule, captured 2026-06-17T05:00–05:01Z. (The leading `web_client` block is the excluded client dir, retained here only to show the raw read-only capture; it is out of scope.)

```text
### web_client
github	git@github.com:Helix-Track/Web-Client.git (fetch)
github	git@github.com:Helix-Track/Web-Client.git (push)
origin	git@github.com:Helix-Track/Web-Client.git (fetch)
origin	git@github.com:Helix-Track/Web-Client.git (push)
upstream	git@github.com:Helix-Track/Web-Client.git (fetch)
upstream	git@github.com:Helix-Track/Web-Client.git (push)

### harmony_os_client
origin	git@github.com:Helix-Track/Harmony-OS-Client.git (fetch)
origin	git@github.com:Helix-Track/Harmony-OS-Client.git (push)

### aurora_os_client
origin	git@github.com:Helix-Track/Aurora-Client.git (fetch)
origin	git@github.com:Helix-Track/Aurora-Client.git (push)

### containers
github	git@github.com:vasic-digital/Containers.git (fetch)
github	git@github.com:vasic-digital/Containers.git (push)
gitlab	git@gitlab.com:vasic-digital/containers.git (fetch)
gitlab	git@gitlab.com:vasic-digital/containers.git (push)
origin	git@github.com:vasic-digital/containers.git (fetch)
origin	git@github.com:vasic-digital/Containers.git (push)
origin	git@gitlab.com:vasic-digital/containers.git (push)
origin	git@gitlab.com:vasic-digital/Containers.git (push)
upstream	git@github.com:vasic-digital/Containers.git (fetch)
upstream	git@github.com:vasic-digital/Containers.git (push)
vasicdigitalgitlab	git@gitlab.com:vasic-digital/Containers.git (fetch)
vasicdigitalgitlab	git@gitlab.com:vasic-digital/Containers.git (push)

### docs_chain
github	git@github.com:vasic-digital/docs_chain.git (fetch)
github	git@github.com:vasic-digital/docs_chain.git (push)
gitlab	git@gitlab.com:vasic-digital/docs_chain.git (fetch)
gitlab	git@gitlab.com:vasic-digital/docs_chain.git (push)
origin	git@github.com:vasic-digital/docs_chain.git (fetch)
origin	git@github.com:vasic-digital/docs_chain.git (push)
origin	git@gitlab.com:vasic-digital/docs_chain.git (push)
upstream	git@github.com:vasic-digital/docs_chain.git (fetch)
upstream	git@github.com:vasic-digital/docs_chain.git (push)

### challenges
github	git@github.com:vasic-digital/Challenges.git (fetch)
github	git@github.com:vasic-digital/Challenges.git (push)
gitlab	git@gitlab.com:vasic-digital/challenges.git (fetch)
gitlab	git@gitlab.com:vasic-digital/challenges.git (push)
origin	git@github.com:vasic-digital/challenges.git (fetch)
origin	git@github.com:vasic-digital/Challenges.git (push)
origin	git@gitlab.com:vasic-digital/challenges.git (push)
origin	git@github.com:vasic-digital/challenges.git (push)
upstream	git@github.com:vasic-digital/Challenges.git (fetch)
upstream	git@github.com:vasic-digital/Challenges.git (push)
vasicdigitalgithub	git@github.com:vasic-digital/challenges.git (fetch)
vasicdigitalgithub	git@github.com:vasic-digital/challenges.git (push)

### helix_qa
github	git@github.com:HelixDevelopment/helixqa.git (fetch)
github	git@github.com:HelixDevelopment/helixqa.git (push)
gitlab	git@gitlab.com:vasic-digital/HelixQA.git (fetch)
gitlab	git@gitlab.com:vasic-digital/HelixQA.git (push)
origin	git@github.com:HelixDevelopment/HelixQA.git (fetch)
origin	git@github.com:HelixDevelopment/helixqa.git (push)
origin	git@gitlab.com:vasic-digital/HelixQA.git (push)
origin	git@github.com:vasic-digital/HelixQA.git (push)
upstream	git@github.com:HelixDevelopment/helixqa.git (fetch)
upstream	git@github.com:HelixDevelopment/helixqa.git (push)
vasicdigitalgithub	git@github.com:vasic-digital/HelixQA.git (fetch)
vasicdigitalgithub	git@github.com:vasic-digital/HelixQA.git (push)

### helix_agent
github	git@github.com:vasic-digital/HelixAgent.git (fetch)
github	git@github.com:vasic-digital/HelixAgent.git (push)
githubhelixdevelopment	git@github.com:HelixDevelopment/HelixAgent.git (fetch)
githubhelixdevelopment	git@github.com:HelixDevelopment/HelixAgent.git (push)
origin	git@github.com:HelixDevelopment/HelixAgent.git (fetch)
origin	git@github.com:vasic-digital/HelixAgent.git (push)
origin	git@github.com:HelixDevelopment/HelixAgent.git (push)
upstream	git@github.com:vasic-digital/HelixAgent.git (fetch)
upstream	git@github.com:vasic-digital/HelixAgent.git (push)

### panoptic
github	git@github.com:vasic-digital/Panoptic.git (fetch)
github	git@github.com:vasic-digital/Panoptic.git (push)
origin	git@github.com:vasic-digital/Panoptic.git (fetch)
origin	git@github.com:vasic-digital/Panoptic.git (push)
upstream	git@github.com:vasic-digital/Panoptic.git (fetch)
upstream	git@github.com:vasic-digital/Panoptic.git (push)

### doc_processor
github	git@github.com:HelixDevelopment/DocProcessor.git (fetch)
github	git@github.com:HelixDevelopment/DocProcessor.git (push)
gitlab	git@gitlab.com:helixdevelopment1/docprocessor.git (fetch)
gitlab	git@gitlab.com:helixdevelopment1/docprocessor.git (push)
origin	git@github.com:HelixDevelopment/DocProcessor.git (fetch)
origin	git@github.com:HelixDevelopment/DocProcessor.git (push)
origin	git@gitlab.com:helixdevelopment1/docprocessor.git (push)
origin	git@github.com:vasic-digital/DocProcessor.git (push)
origin	git@gitlab.com:vasic-digital/DocProcessor.git (push)
upstream	git@github.com:HelixDevelopment/DocProcessor.git (fetch)
upstream	git@github.com:HelixDevelopment/DocProcessor.git (push)
vasicdigitalgithub	git@github.com:vasic-digital/DocProcessor.git (fetch)
vasicdigitalgithub	git@github.com:vasic-digital/DocProcessor.git (push)
vasicdigitalgitlab	git@gitlab.com:vasic-digital/DocProcessor.git (fetch)
vasicdigitalgitlab	git@gitlab.com:vasic-digital/DocProcessor.git (push)

### llm_orchestrator
github	git@github.com:HelixDevelopment/LLMOrchestrator.git (fetch)
github	git@github.com:HelixDevelopment/LLMOrchestrator.git (push)
origin	git@github.com:HelixDevelopment/LLMOrchestrator.git (fetch)
origin	git@github.com:HelixDevelopment/LLMOrchestrator.git (push)
upstream	git@github.com:HelixDevelopment/LLMOrchestrator.git (fetch)
upstream	git@github.com:HelixDevelopment/LLMOrchestrator.git (push)

### llm_provider
github	git@github.com:HelixDevelopment/LLMProvider.git (fetch)
github	git@github.com:HelixDevelopment/LLMProvider.git (push)
gitlab	git@gitlab.com:vasic-digital/LLMProvider.git (fetch)
gitlab	git@gitlab.com:vasic-digital/LLMProvider.git (push)
origin	git@github.com:HelixDevelopment/LLMProvider.git (fetch)
origin	git@github.com:HelixDevelopment/LLMProvider.git (push)
origin	git@gitlab.com:vasic-digital/LLMProvider.git (push)
origin	git@github.com:vasic-digital/LLMProvider.git (push)
upstream	git@github.com:HelixDevelopment/LLMProvider.git (fetch)
upstream	git@github.com:HelixDevelopment/LLMProvider.git (push)
vasicdigitalgithub	git@github.com:vasic-digital/LLMProvider.git (fetch)
vasicdigitalgithub	git@github.com:vasic-digital/LLMProvider.git (push)

### llms_verifier
github	git@github.com:vasic-digital/LLMsVerifier.git (fetch)
github	git@github.com:vasic-digital/LLMsVerifier.git (push)
gitlab	git@gitlab.com:vasic-digital/LLMsVerifier.git (fetch)
gitlab	git@gitlab.com:vasic-digital/LLMsVerifier.git (push)
origin	git@github.com:vasic-digital/LLMsVerifier.git (fetch)
origin	git@github.com:vasic-digital/LLMsVerifier.git (push)
origin	git@gitlab.com:vasic-digital/LLMsVerifier.git (push)
upstream	git@github.com:vasic-digital/LLMsVerifier.git (fetch)
upstream	git@github.com:vasic-digital/LLMsVerifier.git (push)

### security
github	git@github.com:vasic-digital/Security.git (fetch)
github	git@github.com:vasic-digital/Security.git (push)
gitlab	git@gitlab.com:vasic-digital/Security.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Security.git (push)
origin	git@github.com:vasic-digital/security.git (fetch)
origin	git@github.com:vasic-digital/Security.git (push)
origin	git@gitlab.com:vasic-digital/Security.git (push)
upstream	git@github.com:vasic-digital/Security.git (fetch)
upstream	git@github.com:vasic-digital/Security.git (push)

### vision_engine
github	git@github.com:HelixDevelopment/VisionEngine.git (fetch)
github	git@github.com:HelixDevelopment/VisionEngine.git (push)
origin	git@github.com:HelixDevelopment/VisionEngine.git (fetch)
origin	git@github.com:HelixDevelopment/VisionEngine.git (push)
upstream	git@github.com:HelixDevelopment/VisionEngine.git (fetch)
upstream	git@github.com:HelixDevelopment/VisionEngine.git (push)

### dag_orchestrator
origin	git@github.com:HelixDevelopment/DagOrchestrator.git (fetch)
origin	git@github.com:HelixDevelopment/DagOrchestrator.git (push)

### agentic
github	git@github.com:vasic-digital/Agentic.git (fetch)
github	git@github.com:vasic-digital/Agentic.git (push)
gitlab	git@gitlab.com:vasic-digital/agentic.git (fetch)
gitlab	git@gitlab.com:vasic-digital/agentic.git (push)
origin	git@github.com:vasic-digital/Agentic.git (fetch)
origin	git@github.com:vasic-digital/Agentic.git (push)
origin	git@gitlab.com:vasic-digital/agentic.git (push)
upstream	git@github.com:vasic-digital/Agentic.git (fetch)
upstream	git@github.com:vasic-digital/Agentic.git (push)

### auth
github	git@github.com:vasic-digital/Auth.git (fetch)
github	git@github.com:vasic-digital/Auth.git (push)
gitlab	git@gitlab.com:vasic-digital/Auth.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Auth.git (push)
origin	git@github.com:vasic-digital/Auth.git (fetch)
origin	git@github.com:vasic-digital/Auth.git (push)
origin	git@gitlab.com:vasic-digital/Auth.git (push)
upstream	git@github.com:vasic-digital/Auth.git (fetch)
upstream	git@github.com:vasic-digital/Auth.git (push)

### background_tasks
github	git@github.com:vasic-digital/BackgroundTasks.git (fetch)
github	git@github.com:vasic-digital/BackgroundTasks.git (push)
gitlab	git@gitlab.com:vasic-digital/BackgroundTasks.git (fetch)
gitlab	git@gitlab.com:vasic-digital/BackgroundTasks.git (push)
origin	git@github.com:vasic-digital/BackgroundTasks.git (fetch)
origin	git@github.com:vasic-digital/BackgroundTasks.git (push)
origin	git@gitlab.com:vasic-digital/BackgroundTasks.git (push)
upstream	git@github.com:vasic-digital/BackgroundTasks.git (fetch)
upstream	git@github.com:vasic-digital/BackgroundTasks.git (push)

### benchmark
github	git@github.com:vasic-digital/Benchmark.git (fetch)
github	git@github.com:vasic-digital/Benchmark.git (push)
gitlab	git@gitlab.com:vasic-digital/benchmark.git (fetch)
gitlab	git@gitlab.com:vasic-digital/benchmark.git (push)
origin	git@github.com:vasic-digital/Benchmark.git (fetch)
origin	git@github.com:vasic-digital/Benchmark.git (push)
origin	git@gitlab.com:vasic-digital/benchmark.git (push)
upstream	git@github.com:vasic-digital/Benchmark.git (fetch)
upstream	git@github.com:vasic-digital/Benchmark.git (push)

### concurrency
github	git@github.com:vasic-digital/Concurrency.git (fetch)
github	git@github.com:vasic-digital/Concurrency.git (push)
gitlab	git@gitlab.com:vasic-digital/Concurrency.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Concurrency.git (push)
origin	git@github.com:vasic-digital/Concurrency.git (fetch)
origin	git@github.com:vasic-digital/Concurrency.git (push)
origin	git@gitlab.com:vasic-digital/Concurrency.git (push)
upstream	git@github.com:vasic-digital/Concurrency.git (fetch)
upstream	git@github.com:vasic-digital/Concurrency.git (push)

### database
github	git@github.com:vasic-digital/Database.git (fetch)
github	git@github.com:vasic-digital/Database.git (push)
gitlab	git@gitlab.com:vasic-digital/Database.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Database.git (push)
origin	git@github.com:vasic-digital/Database.git (fetch)
origin	git@github.com:vasic-digital/Database.git (push)
origin	git@gitlab.com:vasic-digital/Database.git (push)
upstream	git@github.com:vasic-digital/Database.git (fetch)
upstream	git@github.com:vasic-digital/Database.git (push)

### debate_orchestrator
origin	git@github.com:HelixDevelopment/DebateOrchestrator.git (fetch)
origin	git@github.com:HelixDevelopment/DebateOrchestrator.git (push)

### embeddings
github	git@github.com:vasic-digital/Embeddings.git (fetch)
github	git@github.com:vasic-digital/Embeddings.git (push)
gitlab	git@gitlab.com:vasic-digital/Embeddings.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Embeddings.git (push)
origin	git@github.com:vasic-digital/Embeddings.git (fetch)
origin	git@github.com:vasic-digital/Embeddings.git (push)
origin	git@gitlab.com:vasic-digital/Embeddings.git (push)
upstream	git@github.com:vasic-digital/Embeddings.git (fetch)
upstream	git@github.com:vasic-digital/Embeddings.git (push)

### event_bus
github	git@github.com:vasic-digital/EventBus.git (fetch)
github	git@github.com:vasic-digital/EventBus.git (push)
gitlab	git@gitlab.com:vasic-digital/EventBus.git (fetch)
gitlab	git@gitlab.com:vasic-digital/EventBus.git (push)
origin	git@github.com:vasic-digital/EventBus.git (fetch)
origin	git@github.com:vasic-digital/EventBus.git (push)
origin	git@gitlab.com:vasic-digital/EventBus.git (push)
upstream	git@github.com:vasic-digital/EventBus.git (fetch)
upstream	git@github.com:vasic-digital/EventBus.git (push)

### formatters
github	git@github.com:vasic-digital/Formatters.git (fetch)
github	git@github.com:vasic-digital/Formatters.git (push)
gitlab	git@gitlab.com:vasic-digital/Formatters.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Formatters.git (push)
origin	git@github.com:vasic-digital/Formatters.git (fetch)
origin	git@github.com:vasic-digital/Formatters.git (push)
origin	git@gitlab.com:vasic-digital/Formatters.git (push)
upstream	git@github.com:vasic-digital/Formatters.git (fetch)
upstream	git@github.com:vasic-digital/Formatters.git (push)

### helix_memory
github	git@github.com:HelixDevelopment/HelixMemory.git (fetch)
github	git@github.com:HelixDevelopment/HelixMemory.git (push)
gitlab	git@gitlab.com:helixdevelopment1/HelixMemory.git (fetch)
gitlab	git@gitlab.com:helixdevelopment1/HelixMemory.git (push)
origin	git@github.com:HelixDevelopment/HelixMemory.git (fetch)
origin	git@github.com:HelixDevelopment/HelixMemory.git (push)
origin	git@gitlab.com:helixdevelopment1/HelixMemory.git (push)
upstream	git@github.com:HelixDevelopment/HelixMemory.git (fetch)
upstream	git@github.com:HelixDevelopment/HelixMemory.git (push)

### helix_specifier
github	git@github.com:HelixDevelopment/HelixSpecifier.git (fetch)
github	git@github.com:HelixDevelopment/HelixSpecifier.git (push)
gitlab	git@gitlab.com:helixdevelopment1/HelixSpecifier.git (fetch)
gitlab	git@gitlab.com:helixdevelopment1/HelixSpecifier.git (push)
origin	git@github.com:HelixDevelopment/HelixSpecifier.git (fetch)
origin	git@github.com:HelixDevelopment/HelixSpecifier.git (push)
origin	git@gitlab.com:helixdevelopment1/HelixSpecifier.git (push)
upstream	git@github.com:HelixDevelopment/HelixSpecifier.git (fetch)
upstream	git@github.com:HelixDevelopment/HelixSpecifier.git (push)

### llm_ops
github	git@github.com:vasic-digital/LLMOps.git (fetch)
github	git@github.com:vasic-digital/LLMOps.git (push)
gitlab	git@gitlab.com:vasic-digital/llmops.git (fetch)
gitlab	git@gitlab.com:vasic-digital/llmops.git (push)
origin	git@github.com:vasic-digital/LLMOps.git (fetch)
origin	git@github.com:vasic-digital/LLMOps.git (push)
origin	git@gitlab.com:vasic-digital/llmops.git (push)
upstream	git@github.com:vasic-digital/LLMOps.git (fetch)
upstream	git@github.com:vasic-digital/LLMOps.git (push)

### mcp_module
github	git@github.com:vasic-digital/MCP_Module.git (fetch)
github	git@github.com:vasic-digital/MCP_Module.git (push)
gitlab	git@gitlab.com:vasic-digital/MCP_Module.git (fetch)
gitlab	git@gitlab.com:vasic-digital/MCP_Module.git (push)
origin	git@github.com:vasic-digital/MCP_Module.git (fetch)
origin	git@github.com:vasic-digital/MCP_Module.git (push)
origin	git@gitlab.com:vasic-digital/MCP_Module.git (push)
upstream	git@github.com:vasic-digital/MCP_Module.git (fetch)
upstream	git@github.com:vasic-digital/MCP_Module.git (push)

### memory
github	git@github.com:vasic-digital/Memory.git (fetch)
github	git@github.com:vasic-digital/Memory.git (push)
gitlab	git@gitlab.com:vasic-digital/memory.git (fetch)
gitlab	git@gitlab.com:vasic-digital/memory.git (push)
origin	git@github.com:vasic-digital/Memory.git (fetch)
origin	git@github.com:vasic-digital/Memory.git (push)
origin	git@gitlab.com:vasic-digital/memory.git (push)
upstream	git@github.com:vasic-digital/Memory.git (fetch)
upstream	git@github.com:vasic-digital/Memory.git (push)

### messaging
github	git@github.com:vasic-digital/Messaging.git (fetch)
github	git@github.com:vasic-digital/Messaging.git (push)
gitlab	git@gitlab.com:vasic-digital/Messaging.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Messaging.git (push)
origin	git@github.com:vasic-digital/Messaging.git (fetch)
origin	git@github.com:vasic-digital/Messaging.git (push)
origin	git@gitlab.com:vasic-digital/Messaging.git (push)
upstream	git@github.com:vasic-digital/Messaging.git (fetch)
upstream	git@github.com:vasic-digital/Messaging.git (push)

### models
gitflic	git@gitflic.ru:vasic-digital/Models.git (fetch)
gitflic	git@gitflic.ru:vasic-digital/Models.git (push)
github	git@github.com:vasic-digital/Models.git (fetch)
github	git@github.com:vasic-digital/Models.git (push)
gitlab	git@gitlab.com:vasic-digital/Models.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Models.git (push)
gitverse	git@gitverse.ru:vasic-digital/Models.git (fetch)
gitverse	git@gitverse.ru:vasic-digital/Models.git (push)
origin	git@github.com:vasic-digital/Models.git (fetch)
origin	git@gitflic.ru:vasic-digital/Models.git (push)
origin	git@github.com:vasic-digital/Models.git (push)
origin	git@gitlab.com:vasic-digital/Models.git (push)
origin	git@gitverse.ru:vasic-digital/Models.git (push)
upstream	git@gitflic.ru:vasic-digital/Models.git (fetch)
upstream	git@gitflic.ru:vasic-digital/Models.git (push)

### normalize
origin	git@github.com:vasic-digital/Normalize.git (fetch)
origin	git@github.com:vasic-digital/Normalize.git (push)

### observability
github	git@github.com:vasic-digital/Observability.git (fetch)
github	git@github.com:vasic-digital/Observability.git (push)
gitlab	git@gitlab.com:vasic-digital/Observability.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Observability.git (push)
origin	git@github.com:vasic-digital/Observability.git (fetch)
origin	git@github.com:vasic-digital/Observability.git (push)
origin	git@gitlab.com:vasic-digital/Observability.git (push)
upstream	git@github.com:vasic-digital/Observability.git (fetch)
upstream	git@github.com:vasic-digital/Observability.git (push)

### optimization
github	git@github.com:vasic-digital/Optimization.git (fetch)
github	git@github.com:vasic-digital/Optimization.git (push)
gitlab	git@gitlab.com:vasic-digital/Optimization.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Optimization.git (push)
origin	git@github.com:vasic-digital/Optimization.git (fetch)
origin	git@github.com:vasic-digital/Optimization.git (push)
origin	git@gitlab.com:vasic-digital/Optimization.git (push)
upstream	git@github.com:vasic-digital/Optimization.git (fetch)
upstream	git@github.com:vasic-digital/Optimization.git (push)

### planning
github	git@github.com:vasic-digital/Planning.git (fetch)
github	git@github.com:vasic-digital/Planning.git (push)
gitlab	git@gitlab.com:vasic-digital/planning.git (fetch)
gitlab	git@gitlab.com:vasic-digital/planning.git (push)
origin	git@github.com:vasic-digital/Planning.git (fetch)
origin	git@github.com:vasic-digital/Planning.git (push)
origin	git@gitlab.com:vasic-digital/planning.git (push)
upstream	git@github.com:vasic-digital/Planning.git (fetch)
upstream	git@github.com:vasic-digital/Planning.git (push)

### plugins
github	git@github.com:vasic-digital/Plugins.git (fetch)
github	git@github.com:vasic-digital/Plugins.git (push)
gitlab	git@gitlab.com:vasic-digital/plugins.git (fetch)
gitlab	git@gitlab.com:vasic-digital/plugins.git (push)
origin	git@github.com:vasic-digital/Plugins.git (fetch)
origin	git@github.com:vasic-digital/Plugins.git (push)
origin	git@gitlab.com:vasic-digital/plugins.git (push)
upstream	git@github.com:vasic-digital/Plugins.git (fetch)
upstream	git@github.com:vasic-digital/Plugins.git (push)

### rag
github	git@github.com:vasic-digital/RAG.git (fetch)
github	git@github.com:vasic-digital/RAG.git (push)
gitlab	git@gitlab.com:vasic-digital/RAG.git (fetch)
gitlab	git@gitlab.com:vasic-digital/RAG.git (push)
origin	git@github.com:vasic-digital/RAG.git (fetch)
origin	git@github.com:vasic-digital/RAG.git (push)
origin	git@gitlab.com:vasic-digital/RAG.git (push)
upstream	git@github.com:vasic-digital/RAG.git (fetch)
upstream	git@github.com:vasic-digital/RAG.git (push)

### red_team
origin	git@github.com:vasic-digital/RedTeam.git (fetch)
origin	git@github.com:vasic-digital/RedTeam.git (push)

### self_improve
github	git@github.com:vasic-digital/SelfImprove.git (fetch)
github	git@github.com:vasic-digital/SelfImprove.git (push)
gitlab	git@gitlab.com:vasic-digital/selfimprove.git (fetch)
gitlab	git@gitlab.com:vasic-digital/selfimprove.git (push)
origin	git@github.com:vasic-digital/SelfImprove.git (fetch)
origin	git@github.com:vasic-digital/SelfImprove.git (push)
origin	git@gitlab.com:vasic-digital/selfimprove.git (push)
upstream	git@github.com:vasic-digital/SelfImprove.git (fetch)
upstream	git@github.com:vasic-digital/SelfImprove.git (push)

### skill_registry
github	git@github.com:vasic-digital/SkillRegistry.git (fetch)
github	git@github.com:vasic-digital/SkillRegistry.git (push)
gitlab	git@gitlab.com:vasic-digital/SkillRegistry.git (fetch)
gitlab	git@gitlab.com:vasic-digital/SkillRegistry.git (push)
origin	git@github.com:vasic-digital/SkillRegistry.git (fetch)
origin	git@github.com:vasic-digital/SkillRegistry.git (push)
origin	git@gitlab.com:vasic-digital/SkillRegistry.git (push)
upstream	git@github.com:vasic-digital/SkillRegistry.git (fetch)
upstream	git@github.com:vasic-digital/SkillRegistry.git (push)

### storage
github	git@github.com:vasic-digital/Storage.git (fetch)
github	git@github.com:vasic-digital/Storage.git (push)
gitlab	git@gitlab.com:vasic-digital/Storage.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Storage.git (push)
origin	git@github.com:vasic-digital/Storage.git (fetch)
origin	git@github.com:vasic-digital/Storage.git (push)
origin	git@gitlab.com:vasic-digital/Storage.git (push)
upstream	git@github.com:vasic-digital/Storage.git (fetch)
upstream	git@github.com:vasic-digital/Storage.git (push)

### streaming
github	git@github.com:vasic-digital/Streaming.git (fetch)
github	git@github.com:vasic-digital/Streaming.git (push)
gitlab	git@gitlab.com:vasic-digital/Streaming.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Streaming.git (push)
origin	git@github.com:vasic-digital/Streaming.git (fetch)
origin	git@github.com:vasic-digital/Streaming.git (push)
origin	git@gitlab.com:vasic-digital/Streaming.git (push)
upstream	git@github.com:vasic-digital/Streaming.git (fetch)
upstream	git@github.com:vasic-digital/Streaming.git (push)

### tool_schema
github	git@github.com:vasic-digital/ToolSchema.git (fetch)
github	git@github.com:vasic-digital/ToolSchema.git (push)
gitlab	git@gitlab.com:vasic-digital/ToolSchema.git (fetch)
gitlab	git@gitlab.com:vasic-digital/ToolSchema.git (push)
origin	git@github.com:vasic-digital/ToolSchema.git (fetch)
origin	git@github.com:vasic-digital/ToolSchema.git (push)
origin	git@gitlab.com:vasic-digital/ToolSchema.git (push)
upstream	git@github.com:vasic-digital/ToolSchema.git (fetch)
upstream	git@github.com:vasic-digital/ToolSchema.git (push)

### vector_db
github	git@github.com:vasic-digital/VectorDB.git (fetch)
github	git@github.com:vasic-digital/VectorDB.git (push)
gitlab	git@gitlab.com:vasic-digital/VectorDB.git (fetch)
gitlab	git@gitlab.com:vasic-digital/VectorDB.git (push)
origin	git@github.com:vasic-digital/VectorDB.git (fetch)
origin	git@github.com:vasic-digital/VectorDB.git (push)
origin	git@gitlab.com:vasic-digital/VectorDB.git (push)
upstream	git@github.com:vasic-digital/VectorDB.git (fetch)
upstream	git@github.com:vasic-digital/VectorDB.git (push)

### conversation
github	git@github.com:vasic-digital/conversation.git (fetch)
github	git@github.com:vasic-digital/conversation.git (push)
gitlab	git@gitlab.com:vasic-digital/conversation.git (fetch)
gitlab	git@gitlab.com:vasic-digital/conversation.git (push)
origin	git@github.com:vasic-digital/conversation.git (fetch)
origin	git@github.com:vasic-digital/conversation.git (push)
origin	git@gitlab.com:vasic-digital/conversation.git (push)
upstream	git@github.com:vasic-digital/conversation.git (fetch)
upstream	git@github.com:vasic-digital/conversation.git (push)

### cache
github	git@github.com:vasic-digital/Cache.git (fetch)
github	git@github.com:vasic-digital/Cache.git (push)
gitlab	git@gitlab.com:vasic-digital/Cache.git (fetch)
gitlab	git@gitlab.com:vasic-digital/Cache.git (push)
origin	git@github.com:vasic-digital/Cache.git (fetch)
origin	git@github.com:vasic-digital/Cache.git (push)
origin	git@gitlab.com:vasic-digital/Cache.git (push)
upstream	git@github.com:vasic-digital/Cache.git (fetch)
upstream	git@github.com:vasic-digital/Cache.git (push)
```

# AI Infrastructure — Model Routing Architecture

**Status:** July 2026
**Scope:** Devices, models, and decision rules for when to use what

---

## Devices and Roles

| Device | Role |
|---|---|
| Raspberry Pi 5 | Orchestrator — LiteLLM proxy, routing logic, scheduler for agents |
| ThinkPad T14 (Linux) | Development, agent orchestration, local models (Granite/Ministral), git, RAG index |
| ThinkPad T14 (Windows) | **Office/admin runtime layer** — Claude for Excel/PowerPoint/Outlook, MU/admin systems. Not a duplicate of the Linux T14. |
| Mac M5 (32GB) | Sensitive documents, research, vision/OCR, heavier local inference (Mistral Small 24B) |
| e-INFRA AIaaS | Default volume tier for coding, refactoring, summarization, agents |
| Claude / GPT / Gemini (paid, one tier up) | High-stakes design, architecture decisions, security/crypto review, final audit |

---

## Core Principle

Tiers are **not** a strict sequential fallback ("always try local first"). The entry point for a task is decided by a classifier, based on three questions:

1. **Data sensitivity** — where is this allowed to go at all?
2. **Task type/volume** — is this routine bulk work or a high-stakes decision?
3. **Stakes** — does a wrong answer here cost hours or weeks?

---

## 1. Data Sensitivity Classification

| Sensitivity tier | Allowed destinations |
|---|---|
| Public / already published (code, docs, seminar material) | e-INFRA and paid clouds, no restriction |
| Internal, unpublished results (draft paper, unreleased analysis) | e-INFRA via direct API (not WebUI); paid clouds with caution |
| Truly sensitive (undisclosed crypto attacks pre-responsible-disclosure, personal data, anything under embargo) | **Local only — Mac/T14. No fallback, no exception.** |

The third tier must be a **hard rule in the router config**, not a matter of discipline — e.g. an environment flag on the client that makes it physically impossible to route out, rather than a guideline to remember.

Note: e-INFRA's own policy states the WebUI layer does not meet the standard for sensitive/classified data; direct API access bypasses that layer but the infrastructure is still shared and outside your control. Tier 3 data should not go to e-INFRA at all, regardless of access method.

---

## 2. Task Routing (Non-Sequential)

Entry point is decided directly by task type — not by trying a lower tier first and escalating on failure:

- **Routine bulk work** (coding, refactoring, summarization, agent tasks) → **e-INFRA by default**, regardless of whether a local model could technically handle it
- **Fast, low-latency queries** (shell commands, autocomplete, quick lookups) → **local models** (Granite 3B / Ministral 8B), chosen for latency, not hierarchy
- **Architecture / design decisions, cryptographic correctness, security-critical work** → **paid model directly**, no lower tier first
- **Office/admin tasks** → **Windows T14** runtime (Claude for Excel/PowerPoint/Outlook)

---

## 3. High-Stakes Work: Separating Design from Verification

For cryptography and security-critical work, a single strong model's output is not sufficient — a second opinion that just re-solves the same problem shares the same blind spots (both are LLMs facing the same prompt).

**Required format:**

1. **Model A** produces the design/proof/implementation.
2. **Model B** receives **only the result + the requirements specification** — not Model A's reasoning process — and is explicitly tasked to **attack/refute**, not confirm.
3. Wherever possible, add an **independent test**: numerical verification, a formal check, or an existing test vector. An LLM-vs-LLM audit without a concrete test is a weak audit.

This applies specifically to: HNP/LLL-based attacks, ROCA-related work, ECDSA nonce recovery, and any result intended for publication or disclosure.

---

## 4. Avoiding Redundant Use of Paid Models

Paid tiers (Claude/GPT/Gemini, one tier above base) are constrained by **quota, not cost per call**. Rules:

- Use a second paid model **only for a specific audit question** ("verify this claim / find the flaw in this proof"), never by re-sending the full original prompt to get a second full solution.
- Do not consult two or three paid models on the same open-ended question in parallel — that burns quota without adding independent signal.
- Reserve paid-model calls for: architecture decisions, crypto/security review, final code review before merge, cross-checking ambiguous results, and multimodal input handling.

### Role split among paid models

| Model | Primary role |
|---|---|
| Claude | Implementation, Claude Code (repo changes), primary design partner |
| GPT | Final review, multimodal input, second opinion when uncertain about Claude's output |
| Gemini | Large-context tasks (full repo/long documents at once), independent audit |

---

## 5. Final Routing Diagram

```
Input classifier (not a fallback chain):
├─ Sensitivity = Tier 3 → LOCAL ONLY (Mac/T14). STOP. No cloud, no exception.
├─ Routine/bulk (coding, refactor, summarization, agents) → e-INFRA (default)
├─ High-stakes design/architecture/cryptography → Paid model (Claude primary)
│    └─ Verification: independent audit (different paid model / concrete test)
│       on the finished output — not a re-solve from scratch
└─ Office/admin tasks → Windows T14 (Claude for Excel/PowerPoint/Outlook)
```

---

## Open Items for Implementation

- Router config needs a hard-coded sensitivity flag (Tier 3) that cannot be silently bypassed by task routing logic.
- `chat_template_kwargs` thinking flags differ per e-INFRA model (e.g. `deepseek-v3.2` defaults to off, `glm-4.7` defaults to on) — the Capability Registry should store this per-model, not assume a uniform parameter.
- Audit prompts for Model B should be templated separately from design prompts, to enforce "result + spec only, no process" isolation.

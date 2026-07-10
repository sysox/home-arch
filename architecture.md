# Personal Computing Architecture

---

## Architecture Vision

A personal distributed computing environment where heterogeneous devices cooperate as a single system. The infrastructure minimizes AI costs, maximizes reuse of existing hardware, reduces manual work, and provides seamless access to computation, data, and applications regardless of which physical device is in use.

---

## Goals

1. Minimize paid AI usage — prefer free local, institutional, and open models.
2. Use existing hardware effectively — no unnecessary purchases.
3. Minimize electricity consumption and environmental impact.
4. Make files easy to locate and access across all devices.
5. Support easy cross-platform work across macOS, Linux, Windows, and iPhone.
6. Protect privacy and sensitive data.
7. Keep maintenance simple.
8. Recover easily from device failure.
9. Avoid unnecessary infrastructure and hardware.
10. Support gradual extension without redesigning the whole system.
11. Minimize transmitted context — retrieve, filter, and compress before sending data to any AI model.

---

## Constraints and Non-Goals

**Assumptions:**
- Single-user system — no multi-tenant access control needed
- Core devices are trusted within the Tailscale network
- Tailscale is the private network boundary
- Laptops may frequently be offline — the system must tolerate this gracefully
- Pi is the only mandatory always-on node
- No high-availability requirement — brief Pi downtime is acceptable
- Internet and cloud services may be temporarily unavailable
- Each workstation must remain usable independently if Pi fails

**Non-goals:**
- Building a general-purpose distributed operating system
- Replacing professional versioned backup infrastructure
- Automatic conflict resolution for all file types
- Running large models on Raspberry Pi
- Keeping every file on every device at all times
- Enterprise multi-user orchestration or access management

---

## Failure Philosophy

Pi is the coordination hub but must never be a single point of failure for actual work. Every core development capability must remain available when Pi is offline.

| Capability | Pi offline | Pi online |
|---|---|---|
| SSH between devices | ✓ Tailscale routes independently | ✓ |
| VS Code Remote SSH | ✓ | ✓ |
| Development on any machine | ✓ | ✓ |
| Git — local and GitHub push/pull | ✓ | ✓ |
| Syncthing between ThinkPads | ✓ peer-to-peer continues | ✓ |
| Active work rsync to ThinkPad | Conditional — only if a ThinkPad is already awake | ✓ |
| File access on ThinkPads | ✓ | ✓ |
| Wake-on-LAN | ✗ manual only | ✓ |
| Job scheduling and routing | ✗ | ✓ |
| File catalog and iPhone apps | ✗ | ✓ |
| Nightly sync orchestration | ✗ Syncthing continues, verification paused | ✓ |

When Pi fails: core work never stops, automation and iPhone services pause. The system degrades gracefully rather than failing completely.

---

## 1. Core Devices — Overview

| Device | RAM | Storage | Role | Local AI | Cloud AI |
|---|---|---|---|---|---|
| MacBook Air M5 | 32 GB | 512 GB SSD | Primary workstation | 30B+ models | Claude, GPT, Gemini |
| Linux ThinkPad T14 Gen 1 | 16 GB | 1 TB NVMe | Linux workstation + compute node | 7–13B headless | Claude if needed |
| Windows ThinkPad T14 Gen 1 | 16 GB | 1 TB NVMe | Windows/WSL workstation + compute node | 7–13B headless | Claude if needed |
| Raspberry Pi 5 | 8 GB | 32 GB microSD | Always-on hub + app backend | None required | — |
| iPhone | — | — | Display terminal for Pi services | — | Claude, GPT, Gemini apps |

---

## 2. MacBook Air M5

**Role:** Primary workstation and control interface.

**Runs:**
- VS Code with Remote SSH (develops on Mac, executes on Linux ThinkPad)
- AI-assisted development (Claude, GPT, Gemini, or local model depending on task)
- Local AI models via Ollama + MLX (30B+ models, benefits from Neural Engine)
- Browser, communication, writing, research

**Data stored:**
- Active working set — projects currently being worked on, frequently used documents
- Inactive projects move to ThinkPads; may return when active work resumes
- Local AI models (selective — 512 GB fills quickly)

**AI:** strongest local inference in the setup — 30B+ models via Ollama/MLX. Cloud models for tasks exceeding local quality.

---

## 3. Linux ThinkPad T14 Gen 1

**Specs:** AMD Ryzen 7 PRO 4750U, 8c/16t, 16 GB RAM, 1 TB NVMe SSD

**Role:** Main Linux workstation and compute node. Used directly or woken by Pi.

**Runs:**
- OpenSSH server — VS Code Remote SSH target for Mac and Windows ThinkPad
- Python, C/C++ toolchain, compilers
- Python virtual environments and systemd services
- Docker or Podman when needed for reproducibility or conflicting dependencies
- Local AI via Ollama (7–13B, CPU-only, headless batch)
- Syncthing — mirrors data with Windows ThinkPad
- Job agent — receives tasks from Pi, reports completion

**RAM constraint:** a 13B model consumes ~9–10 GB, leaving ~6 GB for OS and builds. Heavy compilation and AI batch jobs must not run simultaneously — the scheduler queues one behind the other.

**Data stored:**
- Syncthing mirror of Windows ThinkPad — device-failure redundancy only, not versioned backup
- Linux repositories, build environments, experiment data, long-term project store

---

## 4. Windows ThinkPad T14 Gen 1

**Specs:** AMD Ryzen 7 PRO 4750U, 8c/16t, 16 GB RAM, 1 TB NVMe SSD

**Role:** Windows workstation and secondary compute. Also serves as Linux dev machine via WSL or Remote SSH to Linux ThinkPad.

**Runs:** Windows-native applications, Microsoft Office, Visual Studio, Syncthing.

**Linux development — two modes:**
```
Primary:   VS Code Remote SSH → Linux ThinkPad
Fallback:  WSL locally (when Linux ThinkPad is off or unreachable)
```

**Data stored:**
- Syncthing mirror of Linux ThinkPad — device-failure redundancy only, not versioned backup
- Office documents, Windows-specific projects, WSL environments

---

## 5. Raspberry Pi 5

**Specs:** 8 GB RAM, 32 GB microSD (no external SSD)

**Role:** Always-on personal hub and app backend. Never powers off.

**Coordination services:**
- Wake-on-LAN for both laptops
- Job scheduling and routing to devices
- Device registry — tracks capabilities and online state
- SSH and Tailscale entry point
- Sync orchestration — nightly sync window and on-demand transfers
- File catalog — lightweight index of all files across both laptops

**Task routing — deterministic rules first** (see Design Principles — *Rule before AI*):

```
student or protected institutional data → institutionally approved service or local processing
privacy-sensitive data            → local processing only
Windows-native task               → Windows ThinkPad
Linux build or Docker task        → Linux ThinkPad
large-memory task                 → Mac, Metacentrum, or lab machine
device unavailable                → queue or select another capable device
cost limit exceeded               → stop or request approval
```

AI may advise for ambiguous natural-language inputs only. Privacy, security, spending, and deletion decisions must never depend solely on a model.

**File catalog (lightweight):**
```json
{
  "name": "paper.pdf",
  "path": "research/cryptography/",
  "size": "2.4 MB",
  "modified": "2026-07-09",
  "device": "linux-laptop"
}
```
~20 MB for 100,000 files. Built by periodic scan — derived, always reconstructable. Future: add content hash, tags, and richer metadata when simple name/path search is insufficient.

**Always-on backends:** time management, English learning, calendar, status dashboard, notification push to iPhone.

**Storage:**
- microSD: OS, config, services, file catalog, calendar, job metadata, logs, optional bare Git repos
- No user datasets, document archives, or model weights
- Logs RAM-buffered, flushed periodically — no per-event writes to microSD

**Deployment model:** lightweight native services (Python venv + systemd) by default. Containers only for third-party services that genuinely require them.

**Deployment reproducibility:**
Pi must be rebuildable without manual steps. Three categories:

*Stored in Git:* service definitions, setup scripts, schemas, routing rules, deployment config.

*Backed up to ThinkPad periodically:* calendar, task data, application user data. Not committed to Git — too mutable, may contain personal data.

*Reconstructed automatically:* file catalog, job queue, logs, transient state.

Rebuild = restore config from Git + restore user data from most recent ThinkPad backup.

**Local AI:** not required. Deterministic rules work without any model. A tiny model (1–3B) may be added if resources permit and a specific use case justifies it.

---

## 6. iPhone

**Role:** Display terminal for Pi-hosted services. No permanent file storage.

**Apps:**
- Claude, GPT, Gemini — standalone cloud chat
- Time management, English learning, calendar — fetch from Pi
- File catalog browser — browse by name/path; on-demand file delivery via SFTP app or excluded from initial implementation
- Status and notifications from Pi

---

## 7. Extended Resources

### anxur (Faculty Server)
Medium-scale computation. SSH access. Specs TBD.

### Metacentrum (HPC Cluster)

MetaCentrum is the elastic large-scale compute backend for both scientific research workloads and large AI workloads.

**Scientific compute:** massive parallel experiments, parameter sweeps, simulations, cryptographic research, long-running CPU/GPU jobs spanning many machines.

**Large AI workloads:** large-model inference, parallel inference, model evaluation, fine-tuning or training where resources and policy allow.

National grid of hundreds of machines and thousands of cores. GPU nodes available. Accessed via SSH + PBS/Slurm.

### Lab Server
Research implementation and student-facing services. Uptime expectations due to student usage.

### Lab Working Group Machines
128 GB machines — potential large-model inference. Nothing installed yet.

### Occasional Devices
Parents' laptop and tablet are occasionally managed devices, not part of the infrastructure.

---

## 8. Network — Tailscale

All core devices run Tailscale (WireGuard-based overlay). Each device gets a permanent virtual IP that never changes regardless of location.

**Devices:** MacBook, Linux ThinkPad, Windows ThinkPad, Raspberry Pi, iPhone.

**Why:** devices span different networks (school, home, mobile), university firewalls block direct connections, enterprise Wi-Fi isolates devices, Mac IP changes constantly.

All inter-device communication uses Tailscale virtual IPs — VS Code Remote SSH, Syncthing, Pi APIs, file transfers, health checks. No port forwarding or firewall rules required.

```
Mac (anywhere)
    │
    ├──► Pi (always-on)
    ├──► Linux ThinkPad
    └──► Windows ThinkPad
         (same IP regardless of location)
```

---

## 9. AI Distribution

| Tier | Device | Models | When to use |
|---|---|---|---|
| Large-scale compute + AI | Metacentrum | Large models + HPC | Massive parallel experiments, simulations, large-model inference, training |
| Heavy local | MacBook Air M5 | 30B+ via Ollama/MLX | Privacy, offline, fast iteration, no token cost |
| Medium local | Linux ThinkPad | 7–13B via Ollama | Headless batch, overnight jobs |
| Medium local | Windows ThinkPad | 7–13B via Ollama | Headless batch, Windows-side tasks |
| Cloud | Claude, GPT, Gemini | Frontier models | Highest quality — select per task, data policy, and cost |
| Optional tiny local | Raspberry Pi | 1–3B if resources permit | Advisory classification only |
| Future | Lab working group machines (128 GB) | TBD | Alternative when Metacentrum unavailable |

### Cloud AI subscriptions

| Service | Subscription | Best used for |
|---|---|---|
| Claude | Paid (own) | Highest quality output, coding, architecture — use selectively |
| GPT | Paid tier 2 | Coding, general tasks, second opinion — use selectively |
| Gemini | Edu — school pays | School work; student data per university policy and service agreement |
| Local models | Ollama/MLX on Mac | Privacy-sensitive, offline, fast iteration, zero cost |

**Default escalation path:**
```
deterministic tool or rule
        ↓
local model where sufficient
        ↓
one selected cloud model where quality requires it
        ↓
additional reviewer when justified
```

**Multi-model review** (standalone experiment, not core infrastructure): Writer → Reviewer → Final revision. Run manually or via simple script. Automated orchestration through Pi is a future addition if the workflow proves valuable.

---

## 10. Storage and Data Flow

**Terminology:**
- **Mirror / replica:** current synchronized copy — does not protect against deletion, corruption, or ransomware
- **Backup:** recoverable historical copy — not currently implemented, planned future addition
- **Cache:** disposable and rebuildable without data loss
- **Authoritative source:** canonical data from which derived state is rebuilt

**File lifecycle:**
```
Active working set
  MacBook (512 GB)
        ↓ move when no longer active
Persistent replicated store
  Linux ThinkPad (1 TB) ◄── Syncthing ──► Windows ThinkPad (1 TB)
        device-failure redundancy — not versioned backup
```

**Mirror limitation:** Syncthing protects against device failure only — deletion or corruption replicates to both laptops. Future versioned backup can be added later.

**Raspberry Pi:** lightweight operational data only — catalog, calendar, configs, job metadata, logs, optional bare Git repos. No user files, no model weights.

**Code:** versioned in Git, pushed to GitHub. Pi bare Git repos are optional — add only if offline access or Pi-side automation is needed.

---

## 11. Data Management

### What gets created where

| Type | Created on | Example |
|---|---|---|
| Code | MacBook (written), Linux ThinkPad (built) | Python scripts, C binaries |
| Documents | MacBook | Notes, research, design docs |
| Office files | Windows ThinkPad | PPT, Word, Excel |
| Build artifacts | Linux ThinkPad | Compiled binaries, test results |
| Experiment results | Linux ThinkPad / anxur / Metacentrum | Logs, model outputs, datasets |
| Job metadata | Raspberry Pi | Task queue, job history |
| Calendar / tasks | Raspberry Pi | Schedules, reminders |
| Config files | MacBook → Git → all devices | Infrastructure config |
| AI model files | MacBook (primary), ThinkPads (secondary) | Ollama model weights |

### Mirror strategy

| Data | Primary | Mirror | Note |
|---|---|---|---|
| Code | Git (GitHub) | Pi bare repo (optional) | Pi mirror only if offline access needed |
| Active files | MacBook | ThinkPads via periodic rsync | Every 5–15 min while working |
| Linux/Windows data | Linux ThinkPad ↔ Windows ThinkPad | Syncthing | Device-failure redundancy only |
| Pi data | microSD | ThinkPad periodic backup | Config in Git, user data backed up |
| AI models | MacBook / ThinkPads | Re-downloadable | Low priority |

### Sync — nightly window

```
Pi wakes both laptops
        ↓
Syncthing syncs directly between laptops (peer-to-peer via Tailscale)
        ↓
Pi queries Syncthing API: wait for idle + in-sync on both
        ↓
Pi checks file count on both sides — simple sanity check
        ↓
counts match → Pi pulls updated file catalog, sleeps both laptops
counts differ → Pi flags mismatch, keeps laptops on for investigation
```

Pi is not a Syncthing relay. Sync is peer-to-peer. Pi orchestrates timing and verifies results.

Full hierarchical hash verification is a future optional enhancement.

### Sync — on-demand transfer

```
User requests file (Mac, Windows, or iPhone via Pi catalog)
        ↓
Pi checks catalog → knows which device has it
        ↓
Pi wakes source laptop, returns Tailscale address to requesting device
        ↓
Desktop clients: pull directly from source laptop
iPhone: SFTP-capable app, or file delivery excluded from initial implementation
        ↓
source laptop sleeps
```

Pi does not proxy bytes for desktop clients.

### Sync conflict handling

Files normally have one active device at a time. When simultaneous edits happen: Syncthing preserves both versions as conflict copies, conflict shown in Pi dashboard, resolution is manual.

*Requires implementation validation: the single-owner assumption must be confirmed in practice.*

### Active Work Protection

Periodic rsync (every 5–15 minutes while working) copies changed files from the active device to one reachable ThinkPad. Syncthing replicates to the second ThinkPad on the next sync window.

- No sleep interception required
- `sync_status: dirty` records when no ThinkPad was reachable during the last rsync attempt; survives reboot
- On reconnection, rsync runs immediately
- Excluded: caches, model weights, build outputs, reproducible data

Mirror and rsync protect against device failure only — not against deletion, corruption, or ransomware.

### File catalog

Pi maintains a lightweight file catalog rebuilt by periodic scan after each Syncthing sync:

```json
{
  "name": "paper.pdf",
  "path": "research/cryptography/",
  "size": "2.4 MB",
  "modified": "2026-07-09",
  "device": "linux-laptop"
}
```

The catalog is derived and always reconstructable. Content hash, tags, canonical metadata records, SQLite search index, and real-time filesystem agents are future additions — add when name/path search is insufficient.

### Rules
- Secrets never in Git — managed separately
- MacBook holds the active working set — inactive projects move to ThinkPads
- Code repositories via Git only, not Syncthing

---

## 12. Development Workflow

### Linux development — from any machine

| Where you are | Primary | Fallback |
|---|---|---|
| At home | Linux ThinkPad directly | — |
| Away with Mac | VS Code Remote SSH → Linux ThinkPad | Mac locally |
| Away with Windows ThinkPad | VS Code Remote SSH → Linux ThinkPad | WSL locally |

VS Code Remote SSH is the common pattern — files and terminal live on Linux ThinkPad regardless of which machine you sit at.

### Execution routing

```
Write code (Mac, Windows, or Linux)
        ↓ VS Code Remote SSH or direct
Execute on Linux ThinkPad
        ↓ commit
Git → GitHub
        ↓ deploy
Pi / anxur / Metacentrum / Lab server
```

| Task | Runs on |
|---|---|
| Interactive coding, quick scripts | Mac or Linux via Remote SSH |
| Linux work, C code, Docker, AI batch | Linux ThinkPad |
| Windows-native (Office, VS) | Windows ThinkPad |
| Linux work when only Windows available | WSL or Remote SSH to Linux |
| Medium compute, overnight jobs | Linux ThinkPad or anxur |
| Massive parallel / long runs | Metacentrum |
| Research + student services | Lab server |

### Compute stages by duration

| Stage | Device | Duration |
|---|---|---|
| 1 | MacBook — interactive, unit tests, AI assistance | Seconds to minutes |
| 2 | ThinkPads — builds, Docker, overnight batch | Minutes to hours |
| 3 | anxur — parallel compute, data-heavy tasks | Hours to days |
| 4 | Metacentrum — massive parallel, simulations | Days to weeks |

---

## 13. Wake and Power Management

Laptops normally sleep. Pi wakes them via Wake-on-LAN when needed.

**WoL is Layer 2 (physical LAN), not Tailscale (Layer 3).** Pi sends the magic packet to the laptop's MAC address on the local subnet broadcast address. Tailscale is used only after the device is awake. Pi and the laptop must be on the same physical network segment — if on different subnets, WoL is unavailable and the device must stay on.

**Standard method: Sleep + WoL**
- Wake time: 2–5 seconds; state (LLM servers, indexes, cache) remains in memory
- Power: ~1 W per laptop
- Linux ThinkPad: WoL confirmed supported, currently disabled — requires OS network configuration
- Caution: current sleep mode is S2idle, not S3 — reliability must be tested; S3 may be configurable in BIOS
- Validate first: run 100 WoL attempts; accept only if fully reliable

**If WoL proves unreliable:** keep ThinkPads on while at school (electricity cost is zero). Evaluate fallbacks (smart plug + AC restore, hibernation) only if needed.

**Power requirements (all wake methods):**
- Fixed DHCP lease and known MAC address per device
- OpenSSH running on startup/resume
- "Power on after AC restore" enabled in BIOS — automatic reboot after electrical outage
- Startup agent reports readiness to Pi

**Power budget:** Pi ~5 W + each ThinkPad (sleep) ~1 W = ~7 W total. All hosted at school — electricity cost zero.

**After job completion:** return to sleep if wired. If on Wi-Fi, remain awake — WoL requires same-LAN as Pi and is unavailable over Wi-Fi at a different location.

---

## 14. Capability Registry

Each device registers with Pi at startup. The scheduler asks "which device satisfies the requirements?" rather than naming specific devices.

**Device record (v1):**
```yaml
linux-laptop:
  os: linux
  online: true
  wake_method: wol          # wol | always_on | smart_plug
  tailscale_ip: "100.64.0.3"
  mac: "aa:bb:cc:dd:ee:ff"
  lan_broadcast: "192.168.1.255"
  capabilities:
    - compilation
    - docker
    - local-ai
  sync_status: clean        # clean | dirty | unknown
```

`sync_status: dirty` is set when active-work rsync failed on the last attempt. Pi uses this to prioritize sync and notify before dispatching new jobs.

**Scheduler matching:**
```
Job: compilation + online
        ↓
linux-laptop: matches → dispatch
windows-laptop: offline → wake if no online match
mac: matches → dispatch if linux unavailable
```

**Parallel dispatch:** a query returning N matches dispatches N jobs simultaneously — AI parallelization, compute parallelization, and redundant execution all use the same mechanism.

**Future fields** (add when the scheduler actually needs them): `ram_gb`, `load`, `gpu`, `gpu_vram_gb`, `storage_free_gb`, `cost_class`, `data_policy`, `wake_capabilities` per sleep state, `wake_status.wol_currently_available`.

**Extensibility:** adding a new device requires only registering its capabilities. No scheduler changes needed.

---

## 15. Service Catalog

```
Resources          CPU, RAM, GPU, storage, network
     ↓
Services           scheduler, file catalog, sync, git, notification, LLM
     ↓
Applications       time management, BTC, English learning, AI assistant
```

| Service | Runs on | Clients | Notes |
|---|---|---|---|
| Scheduler | Raspberry Pi | All devices | Job routing, WoL, capability matching |
| File Catalog | Raspberry Pi | All devices | Lightweight scan-based index |
| Notification | Raspberry Pi | iPhone | Push alerts and status |
| Git Mirror | Raspberry Pi | All devices | Optional — only if offline access or Pi-side automation needed |
| Time Management | Raspberry Pi | iPhone, Mac | Always-on backend |
| English Learning | Raspberry Pi | iPhone, Mac | Always-on backend |
| Remote Execution | Linux ThinkPad | Mac, Windows ThinkPad | SSH target for VS Code Remote and job dispatch |
| Local AI — heavy | MacBook Air M5 | Local, Pi requests | 30B+ via Ollama/MLX |
| Local AI — batch | ThinkPads | Pi dispatch | 7–13B via Ollama |
| Cloud AI | Claude / GPT / Gemini | Mac, Pi coordinator | Frontier models |

Adding a new device or service means registering capabilities and adding a row. No other component changes.

---

## 16. Observability

The system exposes queryable state — answers to questions you will ask while developing, debugging, or deciding what to run next.

**Core signals (v1):**

| Signal | Source | Exposed via |
|---|---|---|
| Devices online / offline | Device registry | Pi dashboard |
| Last sync timestamp | Syncthing API | Pi dashboard |
| Sync conflicts | Syncthing conflict log | Pi dashboard, iPhone notification |
| Failed jobs | Scheduler log | Pi dashboard, iPhone notification |
| Storage free per device | Device registry | Pi dashboard |

**Future signals** (add when needed): AI cost and token usage per model, job queue depth, wake failures, device uptime, metadata consistency, energy estimates.

All signals queryable on demand — not only on anomaly.

---

## 17. Security

Proportional to a personal infrastructure — practical hardening without enterprise complexity.

**Trust boundaries:**
- Tailscale network is the security perimeter — core devices mutually trusted within it
- Pi APIs, SSH, and Syncthing accessible only within Tailscale
- External services receive only what is explicitly sent
- No service exposed to the public internet directly

**Data classification:**

| Class | Meaning | May be processed by |
|---|---|---|
| `local-only` | Credentials, private keys, undisclosed vulnerabilities | Local only — never sent externally |
| `institutional-restricted` | Student data subject to university policy | Institutionally approved services or local |
| `cloud-eligible` | Research code, papers, general work — intent is publication | Any trusted cloud service |

Research is `cloud-eligible` by default. Exceptions treated as `local-only`: embargoed work, patent-sensitive material, contractual restrictions, confidential review material, undisclosed vulnerabilities until patched or published.

**Encryption:** full-disk encryption on ThinkPads and MacBook.

**SSH:** key-based authentication, password SSH disabled, separate key per client device.

**Network:** Tailscale ACLs, per-device firewall, Pi APIs within Tailscale only.

**Secrets:**
- Never in Git
- Stored in protected environment files or lightweight secret manager
- Recovery: password manager or encrypted recovery file stored separately from the machines it unlocks; plaintext `.env` must not be the only durable copy

**Lost device:** revoke Tailscale, rotate SSH keys and API credentials; data recoverable from remaining ThinkPad.

---

## 18. Applications

| App | Backend | Frontend | Notes |
|---|---|---|---|
| Time management | Raspberry Pi | iPhone, Mac | Always accessible via Pi |
| English learning | Raspberry Pi | iPhone, Mac | Pi controls content and schedule |
| File management | Pi catalog + ThinkPads on demand | Mac, iPhone | Name/path search; richer metadata is a future addition |
| BTC trading | Pi (always-on logic) + Linux ThinkPad (analysis) | Mac, iPhone | Pi runs continuously, analysis offloaded |
| Multi-model review | Standalone script | Mac | Writer → Reviewer → revision; manual for now; Pi orchestration is a future addition |

---

## 19. System Diagram

```
                              Cloud LLMs
                        GPT / Claude / Gemini
                                 ▲
                                 │
                    ┌────────────┴──────────────────────────┐
                    │        Tailscale Overlay Network        │
                    │   (all devices, static virtual IPs)     │
                    └────────────┬──────────────────────────┘
                                 │
         ┌───────────────────────┼───────────────┐
         │                       │               │
┌────────┴────────┐    ┌─────────┴───────┐    ┌──┴───────┐
│ MacBook Air M5  │    │ Raspberry Pi 5  │    │  iPhone  │
│ Primary control │◄──►│ Always-on hub   │◄──►│ Pi apps  │
└────────┬────────┘    └─────────┬───────┘    └──────────┘
         │ VS Code               │ Wake (WoL if wired)
         │ Remote SSH            │ Coordinate / Catalog
         │                ┌──────┴──────────┐
         │                │                 │
         └───────────────►│ Linux ThinkPad  │◄── VS Code Remote SSH ──┐
                          │ Workstation +   │                          │
                          │ Compute node    │               ┌──────────┴──────┐
                          └───────┬─────────┘               │ Windows ThinkPad│
                                  │ Syncthing               │ Workstation +   │
                                  │ (via Tailscale)          │ WSL fallback    │
                                  └─────────────────────────┘

Extended:
  anxur ── medium compute (hours–days)
  Metacentrum ── HPC + large AI (days–weeks)
  Lab server ── research + student services
```

---

## 20. Design Principles

**Single source of truth.**
One authoritative record per piece of data. When sources diverge, the authoritative one wins.

**Rule before AI.**
Deterministic rules decide first. AI may advise when input is ambiguous. Privacy, security, spending, and deletion decisions never depend solely on a model.

**Simple before complex.**
Periodic scan before real-time agents. Periodic rsync before sleep interception. JSON files before SQLite. Add complexity only when the simpler thing demonstrably fails.

**Coordinator, not bulk storage.**
Pi stores lightweight operational state — config, catalog, calendar, logs, optional bare Git repos. Not user files, datasets, or model weights. User data stays safe on ThinkPads when Pi fails.

**Coordinator, not compute.**
Pi handles scheduling and lightweight services. Computation goes to ThinkPads, Mac, or Metacentrum.

**Optional optimization.**
SQLite when JSON scanning is too slow. Real-time agents when periodic scan is too slow. Extended capability fields when the scheduler actually needs them. Start without; add when the need is proven.

**Local first.**
Free local models before paid cloud. Sensitive data stays on the machine. Direct peer-to-peer sync before any relay.

**Rebuildable state.**
Anything derived can be deleted and reconstructed. Pi catalog, SQLite indexes, build artifacts — none are authoritative. Authoritative state lives in durable synced files or Git.

**Direct device-to-device transfer.**
Data flows between devices directly. Pi coordinates — wakes the source and hands off the address. Pi does not proxy bytes.

**No mandatory always-on services except Pi.**
Laptops sleep when idle. Everything else woken on demand.

**Minimize transmitted context.**
Retrieve → filter → compress → send. AI cost and latency scale with context size, not just model calls.

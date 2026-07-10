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
- Core devices are trusted — no zero-trust enforcement within the Tailscale network
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
- Building Kubernetes-style container orchestration
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
| Active work rsync to ThinkPad | Conditional — only if a ThinkPad is already awake; without Pi, sleeping ThinkPads cannot be woken | ✓ |
| File access on ThinkPads | ✓ | ✓ |
| Wake-on-LAN | ✗ manual only | ✓ |
| Job scheduling and routing | ✗ | ✓ |
| File catalog and iPhone apps | ✗ | ✓ |
| Nightly sync orchestration | ✗ Syncthing continues, verification paused | ✓ |

When Pi fails: core work never stops, automation and iPhone services pause. The system degrades gracefully rather than failing completely.

---

## 1. Core Devices — Overview

| Device | RAM | Storage | Role | Local AI | Cloud AI | Frontend | Creates | Backed up by |
|---|---|---|---|---|---|---|---|---|
| MacBook Air M5 | 32 GB | 512 GB SSD | Primary workstation | 30B+ models | Claude, GPT, Gemini | VS Code, Claude Code, browser | Code, docs, notes, configs | ThinkPads via rsync (active work) |
| Linux ThinkPad T14 Gen 1 | 16 GB | 1 TB NVMe | Linux workstation + compute node | 7–13B headless | Claude if needed | VS Code, terminal; VS Code Remote SSH target | Build artifacts, experiment results, logs | Windows ThinkPad (Syncthing mirror — device-failure redundancy) |
| Windows ThinkPad T14 Gen 1 | 16 GB | 1 TB NVMe | Windows/WSL workstation + compute node | 7–13B headless | Claude if needed | Windows desktop, Office, VS Code Remote SSH to Linux | Office docs, Windows outputs, WSL artifacts | Linux ThinkPad (Syncthing mirror — device-failure redundancy) |
| Raspberry Pi 5 | 8 GB | 32 GB microSD | Always-on hub + app backend | None required; optional tiny model | — | Web dashboard, SSH entry point | Job metadata, logs, calendar, file catalog | Laptops (lightweight data only) |
| iPhone | — | — | Display terminal for Pi services | — | Claude, GPT, Gemini apps (standalone) | Time mgmt, EN learning, calendar, notifications | — | — |

---

## 2. Extended Resources — Overview

| Device | Role | AI | Frontend |
|---|---|---|---|
| anxur (faculty server) | Medium-scale computation | TBD | SSH, terminal |
| Metacentrum (HPC grid) | Elastic large-scale compute: massive parallel scientific workloads and large AI model execution | Large models + GPU nodes | SSH, job scheduler (PBS/Slurm) |
| Lab working group machines | 128 GB machines — potential large model inference | Nothing installed yet — future option | SSH |
| Lab server | Research implementation + student-facing services | TBD | Student web interface, admin |
| Parents' laptop | Occasional managed device | — | Standard desktop |
| Parents' tablet | Occasional managed device | — | Apps, browser |

---

## 3. MacBook Air M5

**Role:** Primary workstation and control interface. The main device for interactive work.

**Runs:**
- VS Code with Remote SSH (develops on Mac, executes on Linux ThinkPad)
- AI-assisted development (Claude, GPT, Gemini, or local model depending on task)
- Local AI models via Ollama + MLX (30B+ models, benefits from Neural Engine)
- Browser, communication, writing, research
- Control interfaces for Pi and both laptops

**Data stored:**
- Active working set — projects currently being worked on, frequently used documents, selected local copies
- Inactive projects move to the ThinkPads, which provide the larger persistent replicated store; projects may return to MacBook when active work resumes
- Local AI models (selective — 512 GB fills quickly)

**Development workflow:**
- Write code on Mac
- Execute via VS Code Remote SSH on Linux ThinkPad
- Use Mac locally only for quick scripts or when Linux laptop is off

**AI:**
- Primary AI workhorse — strongest local inference in the setup
- 30B+ models locally via Ollama/MLX
- Claude, GPT, Gemini via cloud for tasks exceeding local quality

---

## 4. Linux ThinkPad T14 Gen 1

**Specs:** AMD Ryzen 7 PRO 4750U, 8c/16t, 16 GB RAM, 1 TB NVMe SSD

**Role:** Main Linux workstation and compute node. Used directly when at home, woken by Pi when needed remotely.

**Runs:**
- OpenSSH server (accepts VS Code Remote SSH from Mac and Windows ThinkPad)
- Native development tools — Python, C/C++ toolchain, compilers
- Python virtual environments and systemd services for lightweight components
- Docker or Podman when useful for reproducibility, third-party services, or conflicting dependencies — not a permanent mandatory layer
- Local AI via Ollama (7–13B models, CPU-only, headless batch tasks)
- Build and test tools
- Job agent (receives tasks from Pi, reports completion)
- Syncthing (mirrors data with Windows ThinkPad)
- Monitoring agent (reports status to Pi)
- File metadata JSON records (authoritative, synced via Syncthing) + optional local SQLite search index (derived, disposable)

**RAM constraint:** 16 GB is restrictive. Running a 14B model consumes ~9–10 GB, leaving ~6 GB for OS, Docker, and builds. Heavy compilation and AI batch jobs must not run simultaneously — schedule one or the other. The Pi scheduler enforces this: before dispatching a local AI job to a ThinkPad, it checks `load` and available RAM headroom from the capability registry. If a build is already running, the AI job is queued, not dispatched.

**Data stored:**
- Syncthing mirror of Windows ThinkPad — device-failure redundancy only, not versioned backup
- Linux repositories and build environments
- Experiment data and results
- Archived models
- Authoritative JSON metadata records (synced to Windows ThinkPad via Syncthing)

**Operating model:**
```
Pi sends Wake-on-LAN magic packet
        ↓
laptop wakes from sleep (2–5s) or boots (~30s)
        ↓
reports ready to Pi
        ↓
Pi submits job
        ↓
laptop executes, stores result
        ↓
Pi collects result
        ↓
laptop returns to sleep (or shuts down if idle)
```

---

## 5. Windows ThinkPad T14 Gen 1

**Specs:** AMD Ryzen 7 PRO 4750U, 8c/16t, 16 GB RAM, 1 TB NVMe SSD (same hardware as Linux ThinkPad)

**Role:** Windows workstation and secondary compute. Used directly or woken by Pi. Also serves as Linux development machine via WSL or VS Code Remote SSH to Linux ThinkPad.

**Windows runs:**
- Windows-native applications
- Microsoft Office (PPT, Word, Excel)
- Visual Studio
- Windows software testing
- Syncthing (mirrors data with Linux ThinkPad)

**Linux development on Windows ThinkPad — two modes:**
```
Primary:   VS Code Remote SSH → Linux ThinkPad
           (same pattern as Mac — files and terminal on Linux)

Fallback:  WSL locally
           (when Linux ThinkPad is off or unreachable)
```

**WSL runs:**
- Linux command-line development
- Builds and tests
- Docker workloads
- Linux-compatible AI tools
- Cross-platform validation

**Data stored:**
- Syncthing mirror of Linux ThinkPad — device-failure redundancy only, not versioned backup
- Office documents and Windows-specific projects
- WSL repositories and Linux environments

**Filesystem separation:**
```
Windows filesystem
├── Windows-native applications
├── Office documents
└── Windows-specific projects

WSL filesystem
├── Linux repositories
├── build environments
└── Linux tools
```

**Note:** Linux repositories should be stored inside WSL filesystem rather than under `/mnt/c` for performance. Mirroring of WSL data handled separately from Windows Syncthing instance.

---

## 6. Raspberry Pi 5

**Specs:** 8 GB RAM, 32 GB microSD (no external SSD)

**Role:** Always-on personal hub and app backend. Never powers off.

**Coordination services:**
- Wake-on-LAN for both laptops
- Job scheduling and routing to devices
- Device registry (tracks which devices are online)
- SSH and Tailscale entry point to the whole infrastructure
- Sync orchestration — triggers nightly sync window and on-demand transfers
- Merkle hash registry — stores directory hashes from both laptops, verifies sync

**Task routing — deterministic rules first** (see Design Principles — *Rule before AI*):

Deterministic routing rules (examples):
```
student or protected institutional data → institutionally approved service or local processing
privacy-sensitive data            → local processing only
Windows-native task               → Windows ThinkPad
Linux build or Docker task        → Linux ThinkPad
large-memory task                 → Mac, Metacentrum, or lab machine
device unavailable                → queue or select another capable device
cost limit exceeded               → stop or request approval
unsynchronized data               → do not sleep or shut down
```

AI advisory (for ambiguous natural-language requests only):
- classifying a task (coding, document, research, admin, computation)
- extracting requirements from a natural-language description
- suggesting a workflow
- identifying relevant files or metadata
- estimating whether cloud AI is needed
- deciding whether another review pass is useful

**Critical constraint:** privacy, security, spending, data deletion, shutdown, and access control decisions must never depend solely on a model — the rule engine validates or overrides.

**File catalog (lightweight):**
Pi maintains a small catalog of all files across both laptops:
```json
{
  "name": "paper.pdf",
  "path": "research/cryptography/",
  "size": "2.4 MB",
  "hash": "sha256:abc123",
  "location": "linux-laptop",
  "modified": "2026-07-09"
}
```
- Total catalog size: ~20 MB for 100,000 files — safe on microSD
- Any device fetches catalog from Pi to browse available files
- On-demand file requests: Pi wakes source laptop and coordinates direct transfer to requesting device — Pi does not proxy bytes
- iPhone uses catalog for file browsing — no files stored on iPhone

**Always-on application backends:**
- Time management app (iPhone connects here)
- English learning app (iPhone connects here)
- Calendar and task data
- Status dashboard

**Automation:**
- Cron jobs and schedulers
- Device monitoring and health checks
- Nightly sync window: wakes both laptops, waits for Syncthing idle, verifies Merkle hashes, sleeps both
- On-demand transfer: wakes source laptop, coordinates transfer — desktop clients connect directly, mobile clients use a temporary endpoint on the source device
- Notification push to iPhone

**Storage strategy:**
- microSD only: OS, config, small services, file catalog, calendar, job metadata, logs, small bare Git repositories
- Not bulk storage: no user datasets, document archives, large project files, or model weights — Pi must never become a NAS or the only authoritative location of important user data
- **Write wear protection:** logs handled via a write-efficient strategy — RAM-buffered, flushed periodically, not written per-event. Monitoring agents write at low frequency (e.g. every 60s), not on every state change. This eliminates the main cause of microSD wear without requiring an external SSD.

**Deployment model (Pi services):**
Lightweight native services (Python venv + systemd) by default. Containers only for third-party services that genuinely require them.

**Deployment reproducibility (architectural requirement):**
Pi is the coordination hub — microSD failure is its most likely failure mode. Pi must be fully rebuildable without manual steps. This requires separating two categories:

*Reproducible configuration — stored in Git:*
service definitions, setup scripts, schemas, static policies, routing rules, deployment configuration.

*Recoverable runtime state — periodically exported to a ThinkPad, not committed to Git:*
calendar and task data, job queue, scheduler state, file catalog, application state, usage logs.

Git restores configuration. The ThinkPad export restores runtime state. Neither substitutes for the other. Runtime state must never be committed to Git — it is mutable, may contain personal data, and changes too frequently. Rebuild restores configuration from Git first, then runtime state from the most recent ThinkPad export.

**Local AI on Pi:**

No local AI model required by default. The Pi works correctly with deterministic rules alone. Optional AI assistance may be provided by:
- a tiny local model (1–3B) when resources permit
- a model running on the Mac or a ThinkPad, called remotely
- a cloud model when policy permits

The architecture must function correctly even when no model is running on the Pi.

**Unsuitable workloads:**
- Large model inference
- Heavy compilation
- Large-scale document processing
- File storage beyond lightweight catalog and operational data

---

## 7. iPhone

**Role:** Display terminal for Pi-hosted services. No permanent file storage — apps fetch and display only what is needed in the moment.

**Apps:**
- Claude app, GPT app, Gemini app — standalone cloud chat, independent of infrastructure
- Time management frontend — fetches today's tasks from Pi, not stored locally
- English learning frontend — fetches current lesson from Pi, not stored locally
- Calendar frontend — fetches current data from Pi, not stored locally
- File catalog browser — fetches file list from Pi; if a file is requested it is shown temporarily and not kept
- Status and notifications from Pi

---

## 8. Extended Resources

### anxur (Faculty Server)
- Medium-scale computation when Mac and ThinkPads are insufficient
- Available via SSH
- Specs TBD

### Metacentrum (HPC Cluster)

MetaCentrum is the elastic large-scale compute backend for both scientific research workloads and large AI workloads.

**Scientific and research compute:**
- Massively parallel experiments, parameter sweeps, simulations
- Cryptographic research and data-heavy workloads
- Long-running CPU and GPU jobs spanning many machines or cores

**Large AI workloads:**
- Large-model inference and parallel inference
- Model evaluation, possible fine-tuning or training where resources and policy allow
- AI workloads that exceed MacBook and ThinkPad capacity

Accessed via job submission (SSH + PBS/Slurm scheduler). National grid of hundreds of machines and thousands of cores; GPU nodes available.

### Lab Server
- Research implementation and experiments
- Student-facing services (course homework, teaching tools)
- Has uptime expectations due to student usage
- Admin interface + student web interface

### Parents' Laptop and Tablet
- Occasionally managed devices
- Not part of the compute infrastructure

---

## 9. Network Architecture — Tailscale

All core devices run Tailscale (WireGuard-based overlay network). Each device gets a permanent virtual IP (`100.x.x.x`) that never changes regardless of physical location or network.

**Devices on Tailscale:**
- MacBook Air M5
- Linux ThinkPad
- Windows ThinkPad
- Raspberry Pi 5
- iPhone

**Why Tailscale:**
- Devices are across different networks (school, home, mobile)
- University firewalls block direct connections
- Enterprise Wi-Fi isolates devices from each other
- Mac IP changes constantly

**All inter-device communication uses Tailscale virtual IPs:**
- VS Code Remote SSH
- Syncthing peer-to-peer sync
- Pi APIs (file catalog, job routing, app backends)
- File transfers
- Device health checks

No port forwarding, no firewall rules, no IT involvement required.

```
Mac (anywhere)
    │ Tailscale 100.64.0.1
    │
    ├──► Pi 100.64.0.2 (always-on)
    ├──► Linux ThinkPad 100.64.0.3
    └──► Windows ThinkPad 100.64.0.4
         (reachable at same IP regardless of location)
```

---

## 10. AI Distribution

| Tier | Device | Models | When to use |
|---|---|---|---|
| Highest quality | Cloud — Claude, GPT, Gemini | Frontier models | Best output quality — all three are equally valid choices |
| Large-scale compute + AI | Metacentrum | Large models + HPC + parallel scientific compute | Massive parallel experiments, simulations, large-model inference, training, model evaluation |
| Heavy local | MacBook Air M5 | 30B+ via Ollama/MLX | Privacy, offline, no token cost, fast iteration |
| Medium local | Linux ThinkPad | 7–13B via Ollama | Headless batch, overnight jobs |
| Medium local | Windows ThinkPad | 7–13B via Ollama | Headless batch, Windows-side tasks |
| Optional tiny local | Raspberry Pi | 1–3B if resources permit | Advisory classification only — not required; deterministic rules handle routing by default |
| Future | Lab working group machines (128 GB) | TBD — nothing installed yet | Alternative to Metacentrum if availability is poor |

**Routing principle:** local models and Metacentrum for coding and batch work (cost, privacy, speed). Cloud (Claude, GPT, Gemini) for highest quality output. Gemini edu for anything involving student data.

### Cloud AI subscriptions

| Service | Subscription | Best used for |
|---|---|---|
| Claude | Paid (own) | Highest quality output, coding, architecture, reasoning — use selectively |
| GPT | Paid tier 2 | Coding, general tasks, second opinion — use selectively |
| Gemini | Edu — school pays | School work and Google Workspace. Primary use: student data (grades, personal info) that requires institutional data handling per university policy and service agreement |
| Local models | Ollama/MLX on Mac | Privacy-sensitive work, offline, fast iteration, zero cost |

**Default escalation path:**
```
deterministic tool or rule
        ↓
local model where sufficient
        ↓
one selected cloud model where quality requires it
        ↓
additional reviewer model only when justified
        ↓
three-model consensus — exceptional tasks only
```

**Task routing:**

| Task type | AI approach | Cost |
|---|---|---|
| Simple decisions, routing, classification | Deterministic rules or Pi tiny local | Free |
| Small / atomic coding tasks | Small local models (Mac or ThinkPad) | Free |
| Coding — multiple projects parallel | Local Mac M5 + Metacentrum | Free |
| Document tasks — structure, polish, summarize | Metacentrum large models or Mac M5 local | Free |
| School / student data | Gemini edu (per university policy and service agreement) | School pays |
| Privacy sensitive | Local only — nothing leaves the machine | Free |
| Quality-critical — one model sufficient | Single cloud model: Claude, GPT, or Gemini | Paid (one) |
| Exceptional quality-critical tasks | 3-LLM consensus loop — bounded by hard iteration and spending limits | Paid (multiple) |

**3-LLM consensus loop (concept — implementation details TBD):**
```
Task submitted
        ↓
Claude → GPT → Gemini iterate, each reviewing previous output
        ↓
loop continues until convergence
        ↓ (hard maximum iterations + spending limit enforced)
final output returned
```
Optional and exceptional — used only when single-model quality is insufficient and the task justifies the cost. Pi orchestrates API calls.

A fixed pipeline (Writer → Reviewer → Reviewer → Synthesizer) is an acceptable simpler alternative — bounded by design, predictable call count, easier to implement. Both satisfy the architectural requirements as long as spending and iteration limits are enforced.

Implementation details to be decided: pipeline vs iterative choice, convergence criteria, reviewer roles, model ordering, disagreement handling. **Required constraints:** hard maximum iteration count and spending limit on every run.

---

## 11. Storage and Data Flow

**Terminology:**
- **Mirror / replica:** current synchronized copy — does not protect against deletion, corruption, or ransomware
- **Backup:** recoverable historical or versioned copy — not currently implemented, planned future addition
- **Archive:** long-term retained data
- **Cache:** disposable and rebuildable — can be deleted without data loss
- **Authoritative source:** canonical representation from which all derived state is rebuilt

**File lifecycle:**
```
Active working set
  MacBook (512 GB)
        ↓ move when no longer active
Persistent replicated store
  Linux ThinkPad (1 TB) ◄── Syncthing ──► Windows ThinkPad (1 TB)
        device-failure redundancy — not versioned backup
```

**External drives:** not part of permanent infrastructure. Used only for data transport or emergency recovery when a laptop is damaged.

**Mirror limitation:** Syncthing replication protects against device failure but not against accidental deletion, corruption, or ransomware — a bad change replicates to both laptops. Future versioned or offline backup can be added later.

**Raspberry Pi:** lightweight operational data only — calendar, configs, job metadata, file catalog, logs, small bare Git repositories. No user files, no datasets, no model weights, no external SSD.

**File metadata:** canonical JSON records live in `metadata/records/`, synced via Syncthing to both ThinkPads. Each device may build a local SQLite search index from these records — disposable, never synced. Pi holds a lightweight file catalog only (name, path, size, hash, location).

**Code:** versioned in Git, mirrored through Pi. Syncthing handles documents and data, not repositories.

---

## 12. Data Management

### What gets created where

| Type | Created on | Example |
|---|---|---|
| Code | MacBook (written), Linux ThinkPad (built) | Python scripts, C binaries |
| Documents | MacBook | Notes, research, design docs |
| Office files | Windows ThinkPad | PPT, Word, Excel |
| Build artifacts | Linux ThinkPad | Compiled binaries, test results |
| Experiment results | Linux ThinkPad / anxur / Metacentrum | Logs, model outputs, datasets |
| Job metadata | Raspberry Pi | Task queue, job history, status |
| Calendar / tasks | Raspberry Pi | Schedules, reminders |
| Config files | MacBook → Git → all devices | Infrastructure config repo |
| Logs | All devices | System and application logs |
| AI model files | MacBook (primary), ThinkPads (secondary) | Ollama model weights |

### Backup strategy

| Data | Primary location | Backup | Archive |
|---|---|---|---|
| Code | Git (Pi mirror) | GitHub / remote | — |
| Active files | MacBook | Moves to ThinkPads when no longer active | — |
| Linux/Windows data | Linux ThinkPad ↔ Windows ThinkPad | Syncthing mirror — device-failure redundancy only (not protection against deletion/corruption) | External drive (emergency transport only) |
| Pi persistent data | Pi microSD | Lightweight only — offload large data to laptops | — |
| Office documents | Windows ThinkPad | Linux ThinkPad (Syncthing) | — |
| Config repo | Git (Pi mirror) | GitHub | — |
| AI models | MacBook / ThinkPads | Re-downloadable — low priority | — |

### Data flow

```
MacBook (active work)
        │ rsync on sleep/shutdown → active work protected
        │ inactive projects → move to ThinkPads
        ▼
Linux ThinkPad ◄── Syncthing ──► Windows ThinkPad
  (replicated working copy — device-failure redundancy)
  Note: not a versioned backup — deletion/corruption replicates to both

External drive: transport or emergency only

Raspberry Pi (job metadata, calendar, configs — lightweight only)

All code → Git → Pi mirror → GitHub (offsite)
```

### Sync modes

**Mode 1 — Nightly scheduled sync:**
```
Pi wakes both laptops (e.g. 3am)
        ↓
Syncthing syncs directly between laptops (peer-to-peer via Tailscale)
        ↓
Pi queries Syncthing API on both: wait for idle + 100% completion
        ↓
Pi computes Merkle hash verification (only after Syncthing idle)
        ↓
hashes match → Pi pulls updated file catalog from both laptops (pull, not push)
        ↓
Pi updates its catalog, sleeps both laptops
hashes differ → Pi flags mismatch, keeps laptops on for investigation
```

**Mode 2 — On-demand transfer:**
```
User requests file/folder (from Mac, Windows, or iPhone via Pi catalog)
        ↓
Pi checks catalog → knows which laptop has it
        ↓
Pi wakes source laptop, returns its Tailscale address to requesting device
        ↓
Desktop clients (Mac, Windows): pull file directly from source laptop via SSH/SFTP/rsync
Mobile clients (iPhone): source laptop exposes a temporary authenticated HTTPS endpoint;
  iPhone fetches via HTTPS — Pi may proxy small files as a controlled exception
        ↓
source laptop sleeps (Pi notified on completion)
```

**Transfer principle:** desktop clients transfer directly — Pi does not proxy bytes. Mobile clients use a temporary authenticated endpoint on the source device; Pi may act as a controlled proxy only when a direct mobile connection to the source is impractical. Pi is never a Syncthing relay or persistent storage node.

**Important:** Sync between laptops happens peer-to-peer directly via Tailscale. Pi only orchestrates timing and verifies results.

### Sync conflict handling

Simultaneous editing of the same file on both laptops should be uncommon — files normally have one active owner at a time, and the workflow is designed around one primary device per task. *Requires implementation validation: the single-owner assumption must be confirmed to hold in practice.*

When it happens:

- Syncthing preserves both versions as conflict copies — no conflicting version is automatically deleted
- The conflict is flagged in the Pi file catalog and status dashboard
- Resolution is manual by default
- Safe merge may be automated for specific file types (e.g. append-only logs, structured formats with non-overlapping fields) — implemented only when justified

### Sync verification — hierarchical hashing

Directories are verified using hierarchical hashes (Merkle tree):

```
root_hash
├── hash(documents/)
│   ├── hash(file1.pdf)
│   └── hash(file2.pdf)
├── hash(research/)
│   └── hash(paper.pdf)
└── hash(projects-data/)
```

Pi stores only hashes — not files. Verification:

```
Pi asks Linux:   hash(research/) = abc123
Pi asks Windows: hash(research/) = abc123  →  in sync ✓

Pi asks Linux:   hash(documents/) = xyz789
Pi asks Windows: hash(documents/) = aaa111  →  out of sync → drill down
```

**Race condition prevention:** Merkle hash calculation only triggers after Syncthing API reports `idle` and `100% completion` on both laptops. Never computed during active transfer.

*Requires implementation validation: idle detection reliability and performance on large directory trees must be confirmed in practice.*

### Metadata architecture

No embeddings — plain text and tag search only.

```
Shared/
├── data/                    # actual files — synced via Syncthing
└── metadata/
    └── records/             # canonical JSON files — authoritative source of truth
        └── ab/
            └── abcdef12.json

Per device (not synced — derived from records, disposable):
  metadata/indexes/local.sqlite   # optional local search cache, rebuilt on demand
```

**Authoritative source:** JSON metadata records in `metadata/records/`. These are synchronized via Syncthing and are the only canonical store.

**Write ownership:** Each metadata record has one active owner device — the device where the file was created or last explicitly managed. Other devices may read records and build local indexes but must not modify records they do not own. Ownership transfers when a file is explicitly moved or reassigned. This prevents conflicting updates to the authoritative store when both devices are offline simultaneously and resolves the multi-writer problem without requiring distributed coordination.

**SQLite is derived data:** generated from JSON records as a disposable local search index. It can be deleted and rebuilt at any time without data loss. It must never be synchronized between devices.

**When to introduce SQLite:** a first implementation may use only JSON files. SQLite should be added only when scanning JSON records becomes inefficient. Its purpose is fast filtering, tag search, path search, hash lookup, and optionally FTS5 full-text search.

Each metadata record:
```json
{
  "content_hash": "sha256:...",
  "name": "paper.pdf",
  "logical_path": "research/cryptography/paper.pdf",
  "locations": [
    "linux:/shared/research/cryptography/paper.pdf",
    "windows:/Shared/research/cryptography/paper.pdf"
  ],
  "tags": ["cryptography", "research"],
  "summary": "...",
  "metadata_version": 4
}
```

Metadata agents use filesystem event monitoring to watch for file changes and update JSON records.

**Metadata agent correctness — idempotent processing:** Agents must not attempt to distinguish Syncthing-generated events from user-generated events at the filesystem level. Once Syncthing completes a file operation, the resulting event is indistinguishable from a local edit. Instead, agents must be designed so that processing any event is safe regardless of origin:

- Metadata updates are idempotent — processing the same file twice produces the same record, not a duplicate
- Record identity is determined by content hash and logical path — not by the event that triggered processing
- Temporary Syncthing work files (identified by naming convention) are excluded from processing; final replicated files are indexed normally
- Agents debounce and batch events to reduce unnecessary reprocessing
- The result: Syncthing replication and local edits are handled identically and safely

### Active Work Protection

The system attempts to protect unfinished work by copying it to a ThinkPad before controlled sleep or shutdown. This applies to cooperative shutdown paths only — lid close, crash, battery depletion, OS update, and forced shutdown may bypass the sync step. For these cases, the persistent `sync_status: dirty` flag records that protection has not completed and survives device reboot. Periodic incremental sync (not only on shutdown) reduces the exposure window.

**Mechanism roles:**
```
rsync      → copies current active work (including uncommitted) before sleep/shutdown
Syncthing  → replicates protected shared location to second ThinkPad on schedule
Git        → versions source code and configuration
```

Git commits are encouraged but not required. Uncommitted code, draft documents, notes, and other active files are covered by rsync.

**Shutdown / sleep workflow:**
```
User or power manager requests sleep/shutdown
        ↓
active-work sync starts
        ↓
rsync copies changed files to designated protected location on one reachable ThinkPad
        ↓
at least one protected copy verified to exist
        ↓
sleep/shutdown allowed
        ↓
Syncthing replicates to second ThinkPad (immediately or at next sync window)
```

Not all devices need to be online before a device may sleep — only one ThinkPad needs to be reachable for the protection requirement to be satisfied.

**Failure behaviour:**
- rsync attempt has a hard timeout (e.g. 30 seconds) — if no ThinkPad is reachable within that time, the attempt fails gracefully; sleep is never blocked indefinitely
- *Requires implementation validation: rsync timeout behavior and macOS sleep assertion reliability must be tested before relying on this mechanism*
- If rsync fails or times out → notify user
- Interactive shutdown → ask whether to continue without sync
- Automated shutdown → postpone if unsynchronized changes exist and a ThinkPad is reachable; proceed after timeout if unreachable
- Excluded from rsync: temporary files, caches, model weights, build outputs, package environments, other reproducible data

**Important:** rsync and Syncthing mirroring protect primarily against device failure. They do not protect against accidental deletion, silent corruption, or ransomware — a change replicates to both devices. Future versioned or offline backup can be added later.

### Rules
- Secrets never in Git — managed separately (e.g. environment files, vault)
- MacBook holds the active working set — 512 GB is a workspace, not a persistent archive; inactive projects move to ThinkPads and return when active work resumes
- Code repositories are not synced via Syncthing — Git only
- Same content hash = same content object — one metadata record with multiple location entries; logically distinct files with identical content are rare but may require separate records identified by logical path
- Merkle hashes computed only after Syncthing reports idle — never during transfer
- Pi stores lightweight operational data only — not user files, not full metadata DB; Git repos on Pi are bare mirrors, not user data stores
- JSON metadata records are authoritative — SQLite is a disposable derived index only

---

## 13. Development Workflow

### Linux development — available from any machine

| Where you are | Primary Linux dev | Fallback |
|---|---|---|
| At home | Linux ThinkPad directly | — |
| Away with Mac | VS Code Remote SSH → Linux ThinkPad | Mac locally (limited) |
| Away with Windows ThinkPad | VS Code Remote SSH → Linux ThinkPad | WSL locally |

VS Code Remote SSH is the common pattern — files and terminal live on Linux ThinkPad regardless of which machine you sit at.

### Execution routing

```
Write code (Mac, Windows, or directly on Linux)
        ↓ VS Code Remote SSH or direct
Execute on Linux ThinkPad
        ↓ commit
Git (mirrored on Pi)
        ↓ deploy
Pi / anxur / Metacentrum / Lab server
```

| Task | Runs on |
|---|---|
| Interactive coding, quick scripts | Mac locally or Linux via Remote SSH |
| Linux work, C code, Docker, AI batch | Linux ThinkPad |
| Windows-native (Office, VS, drivers) | Windows ThinkPad |
| Linux work when only Windows available | Windows ThinkPad via WSL or Remote SSH to Linux |
| Medium compute, overnight jobs | Linux ThinkPad or anxur |
| Massive parallel / long runs | Metacentrum |
| Research + student services | Lab server |

### Compute stages by duration

| Stage | Device | Duration |
|---|---|---|
| 1 | MacBook M5 — interactive, unit tests, AI assistance | Seconds to minutes |
| 2 | ThinkPads — medium tests, Docker, overnight batch | Minutes to hours |
| 3 | anxur — scientific parallel compute, data-heavy tasks | Hours to days |
| 4 | Metacentrum — massive parallel, long simulations | Days to weeks |

---

## 14. Wake and Power Management

Laptops are normally in **sleep** (preferred) or fully powered off. Pi wakes them via Wake-on-LAN when a task requires them.

**WoL operates at Layer 2 (physical LAN), not over Tailscale (Layer 3).** Pi sends the magic packet directly to the laptop's MAC address on the local subnet broadcast address. Tailscale is used only after the device is awake. WoL therefore requires Pi and the target laptop to be on the same physical network segment. When they are on different subnets, WoL is unavailable — the device must use Profile B (always-on) or be woken by other means.

**WoL availability is a runtime property, not a static capability.** Before attempting WoL, the scheduler checks `wake_status.wol_currently_available` from the capability registry. A device may support WoL from sleep but not from hibernation or shutdown. Network changes, VLAN assignments, filtered broadcasts, or loss of standby power can make WoL unavailable even for a device that previously supported it.

**Wake mechanism — priority order:**

**1. Sleep + Wake-on-LAN** (preferred)
- Wake time: 2–5 seconds
- Apps, LLM servers, indexes, cache remain in memory — ready immediately
- Power: ~1 W per laptop (~2 €/year per device)
- Test first: run 100 WoL attempts, accept only if fully reliable
- **Linux ThinkPad status:** WoL confirmed supported, currently disabled — requires OS network configuration
- **Caution:** current sleep mode is S2idle (Modern Standby), not S3 — WoL reliability must be tested before relying on it; S3 sleep may be configurable in BIOS

**2. Hibernation + WoL** (if supported)
- RAM saved to SSD, power ~0 W
- Resume where left off
- Requires swap ≥ RAM size and verified WoL from S4 — neither confirmed on current hardware

**3. Full shutdown + WoL from S5**
- Power: 0 W, no extra hardware
- Boot time: 20–40 seconds
- BIOS must support WoL from S5 — not guaranteed

**4. Smart plug + BIOS "Power on after AC restore"** (fallback)
```
Raspberry Pi
      │ API command
      ▼
Smart Plug
      │ AC power restored
      ▼
BIOS: Power on after AC restore
      ▼
ThinkPad boots
```
- Adds hardware, less elegant, requires power cycle
- Use only if WoL options fail

**5. GPIO → power button simulation** (last resort)
- Most reliable mechanically
- Requires opening laptop and running cables to Pi GPIO
- Only if nothing else works

**Recommended approach:** test Sleep + WoL first, fall through the list only if reliability is insufficient.

### Dynamic power profiles

Pi detects each laptop's connection type and applies the appropriate power policy:

**Profile A — Wired (Ethernet connected):**
- Sleep enabled (~1 W)
- WoL active — Pi wakes via magic packet (2–5s)
- Full speed Syncthing sync

**Profile B — Wireless (Wi-Fi only):**
- Always-on mandate (screen off, no sleep)
- WoL disabled — Pi sends jobs directly via Tailscale
- Syncthing and SSH tunnelled through Tailscale

**Failure handling:**
- Ethernet outage → laptop falls back to Wi-Fi → Pi detects via Tailscale → switches to Profile B automatically
- Wi-Fi outage → laptop unreachable → Pi marks device offline → jobs queue until restored
- Electrical outage → everything reboots on power restore ("Power on after AC restore" in BIOS) → Pi re-registers all devices via Tailscale

**For AI architecture — sleep is advantageous:**
A laptop in sleep is not just a compute node — it can keep a local LLM server, indexes, cache, and open builds in memory. When Pi wakes it, it is ready in seconds rather than needing a full reload. The cost difference (~1 W per laptop) is negligible.

**Power budget (sleep 24/7):**
- Raspberry Pi: ~5 W
- Linux ThinkPad (sleep): ~1 W
- Windows ThinkPad (sleep): ~1 W
- Total: ~7 W
- **Note:** all three devices hosted at school — electricity cost is zero.

**Common requirements (all methods):**
- Fixed DHCP lease and known MAC address
- OpenSSH running on startup/resume
- Startup agent that reports readiness to Pi
- **"Power on after AC restore" enabled in BIOS** on Pi, Linux ThinkPad, and Windows ThinkPad — ensures automatic reboot after electrical outage without manual intervention

**After job completion:**
- If wired (Profile A): return to sleep (~1 W) — preferred, keeps LLM servers and state in memory
- If wireless (Profile B): remain awake (always-on mandate)
- Full shutdown only if explicitly requested or no jobs expected for an extended period
- Never shut down while: a user session is active, a job is running, or unsynchronized changes exist

---

## 15. Capability Registry

Each device advertises its capabilities to Pi at startup and on state change. The Pi scheduler never asks "which device?" — it asks "which device satisfies the requirements?"

**Device capability record:**
```yaml
linux-laptop:
  tailscale_ip: "100.64.0.3"
  mac: "aa:bb:cc:dd:ee:ff"      # WoL target — Layer 2
  lan_broadcast: "192.168.1.255" # subnet broadcast for WoL packet
  os: linux
  wake_method: wol
  capabilities:
    ram_gb: 16
    gpu: false
    gpu_vram_gb: 0
    docker: true
    compilation: true
    local_ai: true          # Ollama 7–13B
    office: false
    storage_free_gb: 900
    holds_metadata: true
    cost_class: local-free  # local-free | institutional | paid-api
    data_policy: cloud-eligible  # local-only | institutional-restricted | cloud-eligible
    internet_access: false
    availability: on-demand # interactive | on-demand | batch
  wake_capabilities:
    sleep: verified         # WoL from sleep — tested and confirmed
    hibernate: unverified   # WoL from S4 — not confirmed on current hardware
    shutdown: unsupported   # WoL from S5 — not confirmed on current hardware
  status:
    online: true
    load: 0.3               # normalized 0.0–1.0
    power_profile: A        # A=wired/sleep, B=wifi/always-on
    battery_pct: null       # null = plugged in
    sync_status: clean      # clean | dirty | unknown
    wake_status:
      same_lan_as_pi: true
      wol_currently_available: true  # runtime: is WoL usable right now?
```

**Scheduler matching:**
```
Job requirements: os=linux + compilation + ram_gb >= 8 + online
        ↓
Pi queries registry
        ↓
linux-laptop: online, matches all → dispatch
windows-laptop: offline → wake if no online match exists
mac: os mismatch → skip
```

**Parallel dispatch — same registry, different query:**
```
Job: run experiment with 3 independent parameter sets
        ↓
Pi queries registry: os=linux OR local_ai + online
        ↓
linux-laptop: matches
windows-laptop: matches (WSL)
mac: matches
        ↓
all three dispatched simultaneously, results collected
```

This generalizes: AI parallelization (same prompt to multiple models), compute parallelization (independent workloads across devices), and redundant execution (same job on two devices, first result wins) all use the same matching mechanism. The scheduler asks for N matches instead of one.

**Dirty state tracking:** a device sets `sync_status: dirty` when active-work rsync failed on its last sleep — Pi has no other way to know unsynced work exists. On reconnection, the device reports this status to Pi. Pi uses it to prioritize sync and notify the user before dispatching new jobs to that device.

**Why this matters:** new devices register their capabilities. The scheduler needs no changes. The same matching logic that routes jobs today will route to a Mac mini, a GPU workstation, or a lab machine without modification.

**Capability categories:**
- **Hardware:** `ram_gb`, `gpu`, `gpu_vram_gb`, `storage_free_gb`
- **Software:** `docker`, `compilation`, `local_ai`, `office`, `holds_metadata`
- **Policy:** `cost_class`, `data_policy` (`local-only` | `institutional-restricted` | `cloud-eligible`), `internet_access`, `availability`
- **Wake capabilities (static):** `wake_capabilities.sleep`, `.hibernate`, `.shutdown` — `verified` | `unverified` | `unsupported`; `mac`, `lan_broadcast`
- **Status (dynamic):** `online`, `load`, `power_profile`, `battery_pct`, `sync_status`; `wake_status.same_lan_as_pi`, `wake_status.wol_currently_available`

The device registry in Section 14 is a subset of this — wake configuration lives there. Full capability records live here and are the authoritative input to the scheduler.

---

## 16. Service Catalog

The architecture is organized in three layers:

```
Resources          CPU, RAM, GPU, storage, network
     ↓
Services           scheduler, metadata, LLM, file catalog, search, git, notification
     ↓
Applications       time management, BTC, English learning, research, AI assistant
```

Services are the software components that run on top of hardware resources and are consumed by other devices or applications. Thinking in services — not devices — makes the system behave like a distributed operating system.

| Service | Runs on | Clients | Notes |
|---|---|---|---|
| Scheduler | Raspberry Pi | All devices | Job routing, WoL, capability matching |
| File Catalog | Raspberry Pi | All devices | Lightweight name/path/hash/location index |
| Notification | Raspberry Pi | iPhone | Push alerts and status |
| Git Mirror | Raspberry Pi | All devices | Central bare repo, synced to GitHub offsite |
| Time Management | Raspberry Pi | iPhone, Mac | Always-on backend |
| English Learning | Raspberry Pi | iPhone, Mac | Always-on backend |
| Metadata Store | ThinkPads (synced) | All devices | Authoritative JSON records via Syncthing |
| Search | ThinkPads | Mac, iPhone | SQLite index built from metadata records |
| Remote Execution | Linux ThinkPad | Mac, Windows ThinkPad | SSH target for VS Code Remote and job dispatch |
| Local AI — heavy | MacBook Air M5 | Local, Pi requests | 30B+ models via Ollama/MLX |
| Local AI — batch | ThinkPads | Pi dispatch | 7–13B models via Ollama |
| Cloud AI | Claude / GPT / Gemini | Mac, Pi coordinator | Frontier models, 3-LLM consensus loop |

Adding a new device or service means registering its capabilities and adding a row here. No other component needs to change.

---

## 17. Observability

The system exposes queryable state — not just alerts, but answers to questions you will ask while developing, debugging, or deciding what to run next.

| Signal | Source | Exposed via |
|---|---|---|
| Devices online / offline | Capability registry | Pi dashboard, Mac |
| Device uptime | Capability registry | Pi dashboard |
| Last sync timestamp | Syncthing API | Pi dashboard |
| Sync consistency | Merkle hash registry | Pi dashboard |
| Sync conflicts | Syncthing conflict log | Pi dashboard, iPhone notification |
| AI cost today | API call log | Pi dashboard |
| AI cost this month | API call log (aggregated) | Pi dashboard |
| LLM usage per model and provider | Per-model call log | Pi dashboard |
| Estimated tokens / context sent | API call log | Pi dashboard |
| Job queue depth | Scheduler | Pi dashboard |
| Failed jobs | Scheduler log | Pi dashboard, iPhone notification |
| Wake failures | WoL log | Pi dashboard |
| Storage free per device | Capability registry | Pi dashboard |
| Metadata consistency | Hash comparison | Pi dashboard |
| Energy estimate (optional) | Device state + power profile | Pi dashboard |

The Pi status dashboard is the primary observability interface. iPhone receives push notifications for critical signals: failed jobs, sync mismatch, wake failure, low storage. All signals are queryable on demand — not just surfaced on anomaly. Energy values are estimates derived from device state and expected power draw; no specialized hardware is required.

**Goal coverage check:** every goal has at least one observability signal — AI cost signals cover goal 1, device uptime covers goal 8, sync consistency covers goal 4, storage signals cover goal 9.

---

## 18. Security

Proportional to a personal infrastructure — practical hardening without enterprise complexity.

**Trust boundaries:**
- Tailscale network is the security perimeter — all core devices are mutually trusted within it
- Pi APIs, SSH endpoints, and Syncthing are accessible only within the Tailscale network
- External services (cloud AI, GitHub) are reached from inside the perimeter; they receive only what is explicitly sent
- No service is exposed to the public internet directly

**Data classification:**

| Class | Meaning | May be processed by |
|---|---|---|
| `local-only` | Credentials, private keys, undisclosed vulnerabilities (until patched or published) | Local models and tools only — never sent to any external service |
| `institutional-restricted` | Student data (grades, personal info) subject to university policy | Institutionally approved services (currently Gemini edu per service agreement) or local processing |
| `cloud-eligible` | Research code, papers, experiments, general work — research is public by default | Any trusted cloud service: Claude, GPT, Gemini, GitHub |

Research data and code are `cloud-eligible` by default — the intent is to publish. The exception is an undisclosed vulnerability or weakness: this is `local-only` from discovery until the fix is released or responsible disclosure is complete.

This classification maps directly to the `data_policy` field in the capability registry and to the Pi scheduler routing rules.

**Encryption:**
- Full-disk encryption on both ThinkPads and MacBook
- Encrypted at rest — protects against physical theft

**SSH:**
- Key-based authentication on all devices
- Password-based SSH disabled where practical
- Separate SSH key per client device

**Network:**
- Tailscale ACLs define which devices can reach which services
- Firewall on each device allows only necessary services
- Pi APIs accessible only within Tailscale network

**Secrets:**
- Never stored in Git
- API credentials (Claude, GPT, Gemini, Tailscale) stored in protected environment files or a lightweight secret manager
- Least-privilege service accounts for Pi services
- **Recovery:** critical credentials must have a durable recovery copy — password manager, or encrypted recovery file stored separately from the machines it unlocks. Plaintext `.env` files must not be the only durable copy of a credential. Institutional secrets stored in institutional systems (university IT, not personal hardware only).

**Data protection:**
- Student and protected institutional data handled only through institutionally approved services (currently Gemini edu, per university policy and service agreement) or local processing
- Sensitive data never sent to Claude/GPT without explicit decision
- Logs must not contain sensitive data (student names, grades, API keys)
- Log retention policy: rotate and delete old logs

**Updates:**
- Automatic security updates enabled on Pi (unattended-upgrades or equivalent)
- Regular manual updates on ThinkPads and Mac

**Lost device recovery:**
- Full-disk encryption limits exposure from physical loss
- Tailscale device revoked immediately on loss
- SSH keys rotated
- API credentials rotated
- Data recoverable from remaining ThinkPad (Syncthing mirror)

---

## 19. Applications

| App | Backend | Frontend | Notes |
|---|---|---|---|
| Time management | Raspberry Pi | iPhone, Mac | Always accessible via Pi |
| English learning | Raspberry Pi | iPhone, Mac | Pi decides what to do and when; UI later |
| File management | Shared JSON metadata records + optional local index + Pi lightweight catalog | Mac, iPhone | Content-hash metadata, plain text/tag search, on-demand file transfer |
| BTC trading | Pi (always-on logic) + Linux ThinkPad (analysis) | Mac, iPhone | Pi runs continuously, heavy analysis offloaded |
| 3-LLM consensus loop | Raspberry Pi (coordinator) | Mac | Pi calls Claude + GPT + Gemini iteratively until all satisfied; used for quality-critical tasks |

---

## 20. System Diagram

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
  Metacentrum ── HPC, massive parallel (days–weeks)
  Lab server ── research + student services
```

---

## 21. Design Principles

These principles underlie every decision in this document. When implementing months later and a design question arises, the answer should follow directly from one of these.

**Single source of truth.**
One authoritative record per piece of data. JSON metadata records are canonical — SQLite indexes are derived. The Pi file catalog is derived. When sources diverge, the authoritative one wins.

**Rule before AI.**
Deterministic rules decide first. AI may classify or advise when input is ambiguous. Decisions involving privacy, security, spending, or data deletion never depend solely on a model.

**Simple before complex.**
Python venv and systemd before Docker. JSON files before SQLite. A working plain implementation before an optimized one. Add complexity only when the simpler thing demonstrably fails.

**Coordinator, not bulk storage.**
Pi orchestrates — it wakes devices, routes jobs, tracks catalog entries, verifies sync. It stores lightweight operational state (config, scheduler state, job metadata, calendar, file catalog, logs, small bare Git repositories) but not user datasets, document archives, large project files, or model weights. When Pi fails, user data remains safe on the ThinkPads.

**Coordinator, not compute.**
Pi handles scheduling and lightweight services. Computation goes to ThinkPads, Mac, or Metacentrum. Pi must never become a bottleneck for work that another device handles better.

**Optional optimization.**
SQLite is added when JSON scanning is too slow. Docker when a service genuinely needs it. Local AI on Pi only if resources permit. Start without the optimization; add it when the cost is proven.

**Local first.**
Free local models before paid cloud. Local execution before remote. Sensitive data never leaves the machine. Direct peer-to-peer sync before any relay.

**Rebuildable state.**
Anything derived can be deleted and reconstructed. SQLite indexes, file catalogs, build artifacts — none are authoritative. Authoritative state lives in durable synced files or Git. Nothing important exists only in one place and in one form.

**Direct device-to-device transfer.**
Data flows between devices directly. Pi coordinates — it wakes the source and hands off the address. It never proxies bytes. This keeps Pi lightweight and keeps transfer speed independent of Pi's capacity.

**No mandatory always-on services except Pi.**
Laptops sleep when idle. Mac goes wherever the user goes. Only Pi stays on permanently. Everything else is woken on demand, used, and returned to sleep.

**Minimize transmitted context.**
Before sending anything to an AI model: retrieve only what is relevant, filter noise, compress where possible. The goal is not just fewer tokens — it is a retrieve → filter → compress → send pipeline. AI cost and latency scale with context size, not just model calls.

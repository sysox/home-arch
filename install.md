# Install — softvér podľa zariadenia

**Stav:** júl 2026

---

## Mac M5 (32 GB)

| Typ | Možnosti |
| --- | --- |
| Sieť | Tailscale |
| AI stack | Ollama, Open WebUI, Mistral Small 3.2 24B, Ministral 3 8B, MLX (voliteľne) |
| Coding fallback model | Qwen3-Coder 30B (voliteľné) |
| Audio prepis | Whisper / MLX Whisper |
| IDE | VS Code + Remote SSH, Continue (⚠️ exportovať dáta pred 15.7.2026) |
| Markdown | VS Code (Markdown All in One + Preview Enhanced) alebo Obsidian |
| PKM/poznámky | Obsidian / Logseq / Zettlr |
| Task manager | Taskwarrior / Todoist |
| Reference manager | Zotero / JabRef |
| Password manager | KeePassXC |
| YubiKey nástroje | ykman (YubiKey Manager), yubikey-agent (SSH cez YubiKey) |
| PDF anotácia | Zotero (vstavané) / Xournal++ |
| Diagramy/slajdy | LaTeX/TikZ, Beamer/Keynote |
| Git | git, GitHub klient |
| Dotfiles | chezmoi / GNU stow |
| System monitor | btop |

---

## Linux ThinkPad T14

| Typ | Možnosti |
| --- | --- |
| Sieť | Tailscale |
| AI stack | Ollama, Ministral 3 8B, Granite 4.1 3B, EmbeddingGemma, faster-whisper |
| Web automatizácia | Playwright, Browser Use (voliteľné) |
| Dev toolchain | Python, C/C++ toolchain, Docker/Podman |
| Remote target | OpenSSH server |
| Git hosting | Gitea (na tomto stroji alebo Pi) |
| Sync | Syncthing (s Windows ThinkPad) |
| Job agent | vlastný Python worker service |
| Remote desktop klient | Remmina |
| Markdown | VS Code (Markdown All in One + Preview Enhanced), glow / mdcat (CLI) |
| Terminal multiplexer | tmux |
| Diff/merge | Meld / difftastic |
| Sieťové/TLS nástroje | nmap, testssl.sh |
| Linter/analyzátor | cppcheck, clang-tidy, ruff |
| Secrets pre dev | sops + age |
| Backup | restic / Borg Backup |
| YubiKey nástroje | ykman, yubikey-agent, pam-u2f (login/sudo) |
| Dotfiles | chezmoi / GNU stow |
| System monitor | btop |

---

## Windows ThinkPad T14

| Typ | Možnosti |
| --- | --- |
| Sieť | Tailscale |
| AI stack | Ollama natívne, Ministral 3 8B, Granite 4.1 3B (voliteľné) |
| Office | MS Office |
| Automatizácia | Windows UI Automation / Power Automate |
| Linux fallback | WSL2 |
| Sync | Syncthing (s Linux ThinkPad) |
| Markdown | VS Code (Markdown All in One + Preview Enhanced) |
| YubiKey nástroje | YubiKey Manager (Windows verzia) |
| Password manager | KeePassXC |

---

## Raspberry Pi 5 (8 GB)

| Typ | Možnosti |
| --- | --- |
| Sieť | Tailscale |
| Scheduler | Python + systemd |
| Job queue / device registry | vlastný Python service |
| Wake-on-LAN | WoL utilita |
| Monitoring/notifikácie | vlastný monitoring + notification service |
| Git mirror (voliteľné) | Gitea (bare repo) |
| Dashboard | jednoduchý web dashboard |
| Sieťová hygiena (voliteľné) | Pi-hole / AdGuard Home |
| Backup cieľ | restic repozitár (na USB SSD) |

---

## iPhone

| Typ | Možnosti |
| --- | --- |
| Cloud AI | Claude, GPT, Gemini appky |
| Pi klient appky | time management, English learning, file catalog browser |
| File transfer | SFTP-capable app (voliteľné) |
| YubiKey | YubiKey pre iPhone (NFC/Lightning, ak podporované appkou) |
| Password manager | KeePassXC klient (KeePassium a pod.) |

---

## Poznámka — YubiKey

YubiKey je hardvér (2× YubiKey, kat. 16 — Používané), nie per-stroj softvér. Klientske nástroje (ykman, yubikey-agent, pam-u2f) treba nainštalovať na každom stroji, kde sa má použiť na auth/SSH/sudo — pozri Mac a Linux ThinkPad vyššie.

## Otvorené medzery (zatiaľ bez rozhodnutia)

- PKM nástroj — Obsidian / Logseq / Zettlr (nerozhodnuté)
- Task manager — Taskwarrior / Todoist (nerozhodnuté)
- Reference manager — Zotero / JabRef (nerozhodnuté)
- Versioned backup — restic / Borg Backup (nerozhodnuté)

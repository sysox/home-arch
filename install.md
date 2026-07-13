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

Rozhodnuté: **Gitea beží na Raspberry Pi + USB SSD** (always-on), nie na ThinkPade. ThinkPad má iba Git klientov. **Docker Engine + Compose** namiesto neurčitého Docker/Podman. **restic** ako jednotný backup nástroj pre všetky zariadenia (nie Borg). **UFW** s explicitným pravidlom cez `tailscale0`, nie všeobecné "povoliť SSH".

| Typ | Odporúčané nástroje | Priorita / poznámka |
| --- | --- | --- |
| Sieť | Tailscale | Esenciálne |
| Firewall | UFW — default deny incoming; služby povoľovať cez `tailscale0` | Esenciálne; nepovoľovať SSH verejne |
| Remote target | OpenSSH server | Esenciálne; VS Code Remote SSH a automatizácia |
| AI stack | Ollama ako systemd služba, Ministral 3 8B, Granite 4.1 3B, EmbeddingGemma, faster-whisper | Esenciálne |
| Audio a multimédiá | ffmpeg | Esenciálne pre Whisper a konverzie audia/videa |
| AI runtime fallback | llama.cpp CLI | Nice-to-have na benchmarky a priame testovanie GGUF |
| AI runtime budúci | vLLM cez Docker | Neprioritné; iba pri konkrétnej potrebe vysokého throughputu |
| Web automatizácia | Playwright + Chromium/WebKit/Firefox (`playwright install --with-deps`) | Esenciálne; headless je default |
| Adaptívna web automatizácia | Browser Use | Nice-to-have; pridávať až po zvládnutí Playwrightu |
| Virtuálna obrazovka | Xvfb | Nice-to-have; iba pre headed browser/GUI skripty bez aktívnej relácie |
| Python stack | Python 3, uv, projektové virtuálne prostredia | Esenciálne — uv namiesto ručného venv+pip |
| Python kvalita | ruff, pytest, mypy/pyright, pre-commit | Esenciálne pre projekty |
| Python notebooky | JupyterLab | Nice-to-have pre experimenty a výskum |
| C/C++ toolchain | build-essential, CMake, Ninja, pkg-config, GCC, Clang | Esenciálne |
| Debugging | gdb, valgrind, strace, ltrace | Esenciálne |
| Profilovanie a benchmarky | perf, hyperfine, time | Esenciálne pre výskumné implementácie |
| Shell kvalita | shellcheck, shfmt | Nice-to-have, užitočné pre infra skripty |
| Kontajnery | Docker Engine + Compose plugin | Esenciálne; nie súčasne s Podman bez dôvodu |
| Git klient | git, git-lfs | Esenciálne |
| GitHub CLI | gh | Esenciálne pre issues, PR, releases, automatizáciu |
| Gitea CLI | tea | Nice-to-have (klient k Gitea na Pi) |
| Git hosting | — (Gitea beží na Raspberry Pi, viď sekcia Pi) | ThinkPad je iba klient/worker |
| Git remotes | lokálna Gitea (na Pi) + GitHub | Esenciálne; Gitea súkromne, GitHub verejne/spolupráca |
| Sync | Syncthing (s Windows ThinkPad) | Esenciálne pre dokumenty/dáta, nie pre aktívne Git checkouty |
| Prenos a recovery snapshoty | rsync | Esenciálne; architektúra ho už používa |
| Backup | restic + systemd timer | Esenciálne; versioned a šifrovaný backup |
| Off-site/cloud copy | rclone | Nice-to-have ako ďalší backup target |
| Job agent | vlastná Python systemd služba | Esenciálne |
| Job state/fronta | SQLite | Esenciálne; netreba zatiaľ Redis/RabbitMQ |
| Plánovanie úloh | systemd timers; cron len pre jednoduché kompatibilné úlohy | Esenciálne |
| Logovanie služby | journald + logrotate | Esenciálne |
| Health endpoint | jednoduché HTTP/JSON health checky | Esenciálne pre Pi dispatcher |
| Remote desktop klient | Remmina | Nice-to-have na pripájanie k iným počítačom |
| Remote desktop server | GNOME Remote Desktop alebo xrdp | Voliteľné; iba ak sa chceš pripájať na plochu tohto ThinkPadu |
| Terminálový multiplexer | tmux | Esenciálne pre vzdialené a dlhotrvajúce úlohy |
| Odolné vzdialené spojenie | mosh | Nice-to-have pri nestabilnej sieti |
| Markdown | VS Code + Markdown All in One + Markdown Preview Enhanced | Esenciálne |
| Markdown CLI | glow alebo mdcat | Nice-to-have |
| Diff/merge | Meld + difftastic | Esenciálne/Nice-to-have |
| CLI vyhľadávanie | ripgrep, fd, fzf | Esenciálne |
| CLI pohodlie | bat, tree, jq, yq | Esenciálne |
| Disková orientácia | ncdu alebo duf | Nice-to-have |
| Sieťové nástroje | nmap, testssl.sh, OpenSSL CLI | Esenciálne |
| Sieťová diagnostika | tcpdump, tshark/Wireshark, mtr, dnsutils, netcat, socat | Esenciálne pre TLS, networking, výučbu |
| HTTP debugging | mitmproxy | Nice-to-have |
| PDF spracovanie | poppler-utils, qpdf | Esenciálne pre extrakciu a kontrolu PDF |
| Konverzia dokumentov | Pandoc | Esenciálne/Nice-to-have |
| Obrázky | ImageMagick | Nice-to-have |
| OCR | OCRmyPDF / Tesseract | Nice-to-have, až keď vznikne konkrétny OCR workflow |
| Databázové nástroje | sqlite3 CLI | Esenciálne |
| Analytická databáza | DuckDB | Nice-to-have pre experimentálne dáta a veľké CSV/Parquet |
| Linter/analyzátor | cppcheck, clang-tidy, ruff | Esenciálne |
| Secrets pre dev | sops + age | Esenciálne |
| Password manager | KeePassXC | Esenciálne |
| YubiKey nástroje | ykman, yubikey-agent, pam-u2f | Esenciálne/voliteľné; PAM meniť až po overení recovery prístupu |
| Šifrovanie disku | LUKS full-disk encryption | Esenciálne, rieši sa pri inštalácii OS |
| Automatické security aktualizácie | unattended-upgrades + needrestart | Esenciálne; bez automatického rebootu |
| Firmware | fwupd | Esenciálne pre BIOS a zariadenia podporované cez LVFS |
| Dotfiles | chezmoi | Esenciálne; GNU stow len ako jednoduchšia alternatíva |
| System monitor | btop | Esenciálne |
| Teploty a spotreba | lm-sensors, powertop | Nice-to-have |
| Disk health | nvme-cli, smartmontools | Esenciálne |
| GPU monitoring | ~~nvtop~~ | Neinštalovať — Ryzen 4750U je APU bez dedikovanej GPU |
| fail2ban | — | Zatiaľ netreba, SSH ide iba cez Tailscale, nie verejne |
| Open WebUI | — | Na Linuxe nie je nutné, môže používať centrálnu inštanciu (Mac) |

### Rýchly inštalačný ťahák (Ubuntu/Debian)

```bash
sudo apt update && sudo apt upgrade -y

# Základ, CLI komfort, monitoring
sudo apt install -y curl wget git git-lfs tmux mosh btop ufw openssh-server \
  jq yq ripgrep fd-find fzf bat tree ncdu duf \
  smartmontools nvme-cli lm-sensors powertop \
  meld cppcheck clang-tidy shellcheck shfmt \
  build-essential cmake ninja-build pkg-config gdb valgrind strace ltrace \
  linux-tools-common linux-tools-generic hyperfine \
  poppler-utils qpdf pandoc imagemagick sqlite3 ffmpeg \
  unattended-upgrades needrestart fwupd

# uv (Python projekty, nahrádza venv+pip)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Firewall — default deny, len SSH a Tailscale rozhranie
sudo ufw default deny incoming
sudo ufw allow in on tailscale0
sudo ufw enable

# Docker Engine + Compose plugin
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo apt install -y gh

# KeePassXC, sops/age, restic
sudo apt install -y keepassxc restic

# Playwright (v uv-spravovanom Python venv projektu)
uv pip install playwright
uv run playwright install --with-deps

# Automatické security updaty (bez auto-rebootu)
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

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
| Git hosting | **Gitea (rozhodnuté) — server tu, na USB SSD, s SQLite backendom** |
| Dashboard | jednoduchý web dashboard |
| Sieťová hygiena (voliteľné) | Pi-hole / AdGuard Home |
| Backup cieľ | restic repozitár (na USB SSD) — Gitea dáta + repozitáre a konfiguráciu treba zálohovať cez restic, Gitea sama osebe nie je backup |

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

## Rozhodnuté (uzavreté od predchádzajúcej verzie)

- **Backup: restic** (nie Borg) — jednotný nástroj pre Linux, Mac, Windows aj Pi repository; história snapshotov, šifrovanie, kontrola repozitára, obnova.
- **Kontajnery na Linux ThinkPade: Docker Engine + Compose plugin** (nie Podman) — potrebné pre reprodukovateľné viacslužbové stacky.
- **Gitea: server na Raspberry Pi + USB SSD**, nie na ThinkPade — Pi je always-on, ThinkPad sa vypína. ThinkPad má iba Git klientov (git, git-lfs, gh, tea).
- **vLLM** odstránené z reálneho install plánu na Linux ThinkPad — na 16GB CPU-only stroji neprináša výhodu oproti Ollama/llama.cpp; ostáva len ako budúci experiment.
- **Xvfb** iba voliteľné — Playwright funguje headless štandardne, netreba ho pre bežný scraping workflow.
- **nvtop** odstránené — Ryzen 4750U je APU bez dedikovanej GPU, nemá čo zobrazovať.
- **fail2ban** zatiaľ netreba — SSH ide iba cez Tailscale, nie je verejne dostupné.
- **Open WebUI na Linux ThinkPade** nie je nutné — môže používať centrálnu inštanciu na Macu.

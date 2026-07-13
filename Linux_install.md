# Linux ThinkPad T14 — zoznam na inštaláciu

**Stav:** júl 2026

---

## Princípy balíčkovania a adresárovej štruktúry

### Priorita zdroja balíka

```
1. apt          → systémové balíky, security-critical (ufw, openssh, docker)
2. jazykový nástroj (uv/npm/cargo) → dev knižnice, per-projekt izolácia
3. natívny installer výrobcu (curl | sh) → Ollama, Tailscale, Claude Code
4. AppImage/binary release → jednorazové nástroje bez balíka v repozitári
```

**Snap/Flatpak zámerne vynechané** — Snap má mount overhead a pomalší štart (opačný smer než chceš na CPU-only 16GB worker stroji), Flatpak je GUI-orientovaný (sandboxing cez Portals API), tento stroj je headless/CLI-first.

### Adresárová štruktúra (FHS + XDG)

```
/usr/            → systémové balíky (apt) — nikdy sem ručne nič nepridávaj
/usr/local/      → manuálne nainštalovaný softvér pre všetkých používateľov (make install cieľ)
/opt/            → veľké samostatné aplikácie s vlastnou štruktúrou (napr. SageMath mimo apt)
~/.local/bin/    → per-user binárky (claude-code, uv tool install sem cielia automaticky)
~/.local/share/  → per-user aplikačné dáta
~/.config/       → per-user konfigurácia (XDG_CONFIG_HOME), spravované cez chezmoi/stow
~/.cache/        → cache, bezpečne mazateľné
```

**Pravidlo:** `~/.local/bin` musí byť v `PATH`. Každý `uv` projekt má vlastný `.venv` v projektovom adresári, nikdy globálny site-packages.

**Nikdy:** `sudo pip install` alebo `sudo npm install -g` — zapisuje do systémových ciest spravovaných apt, spôsobuje root-owned súbory v user-space adresároch a permission chaos pri každej ďalšej aktualizácii (presne dôvod, prečo Claude Code dokumentácia varuje pred `sudo npm install -g`).

---


## Fáza 1 — systém a sieť

```
tailscale
openssh-server
ufw
git
git-lfs
gh
syncthing
rsync
restic
docker (Engine + Compose plugin)
tmux
mosh
btop
earlyoom
keepassxc
sops
age
fwupd
unattended-upgrades
needrestart
curl
wget
jq
yq
```

IDE: **VS Code** (alebo VSCodium) + rozšírenia Remote SSH, Python, C/C++, Markdown All in One, Markdown Preview Enhanced, Docker

Archívy a certifikáty: `zip`, `unzip`, `zstd`, `xz-utils`, `ca-certificates`, `gnupg`

## Fáza 2 — vývoj (jazyky, debugging, kvalita)

```
python3
python3-dev
uv
ruff
pytest
pytest-cov
pytest-benchmark
hypothesis
mypy (alebo pyright)
pre-commit
build-essential
gcc
clang
cmake
ninja-build
pkg-config
gdb
valgrind
strace
ltrace
perf (linux-tools-generic)
hyperfine
cppcheck
clang-tidy
shellcheck
shfmt
libssl-dev
libffi-dev
libgmp-dev
libmpfr-dev
libmpc-dev
libfplll-dev
```

Poznámka: `libfplll-dev`/`libgmp-dev`/`libmpfr-dev`/`libmpc-dev` sú potrebné najmä pri kompilácii fpylll alebo gmpy2 zo zdrojov. Ak `uv` nájde kompatibilný binárny wheel, nemusia byť potrebné, no ponechávajú sa ako súčasť výskumného/vývojového prostredia.

## Fáza 3 — lokálna AI

```
ollama (systemd služba)
ministral 3 8b (model)
granite 4.1 3b (model)
embeddinggemma (model)
faster-whisper
ffmpeg
```

Voliteľné (poistka, zvyčajne netreba — PyPI wheel ctranslate2 býva self-contained): `libopenblas-dev`

Voliteľné: llama.cpp CLI, reranker (neskôr podľa potreby)

Ollama konfigurácia pre 16GB CPU-only stroj (systemd override pre `ollama.service`):
```
OLLAMA_MAX_LOADED_MODELS=1  # default je 3 pre CPU — bez tohto Ollama drží v RAM až 3 modely naraz
OLLAMA_NUM_PARALLEL=1       # jedna inference požiadavka naraz (rieši paralelizmus v rámci JEDNÉHO modelu, nie počet modelov)
OLLAMA_KEEP_ALIVE=5m        # po nečinnosti model uvoľniť
```

## Fáza 4 — dokumenty a RAG

```
docling
pymupdf
poppler-utils
qpdf
pandoc
sqlite3
sqlite-vec
```

## Fáza 5 — automatizácia a worker

```
playwright (+ chromium cez playwright install --with-deps)
fastapi
uvicorn
httpx
pydantic
litellm      # unifikované API pre worker: jedno rozhranie pre Ollama/Claude/GPT/Gemini, netreba separátnu integráciu na providera
```

Voliteľné: browser-use, xvfb, mitmproxy

## Fáza 6 — AI coding CLI

```
nodejs (LTS) + npm      # kvôli repomix, gemini-cli a ďalším JS nástrojom, nie kvôli claude-code
claude-code
  # preferované: oficiálny Anthropic APT stable repozitár (aktualizácie cez bežné apt update/upgrade)
  # alternatíva: natívny installer curl -fsSL https://claude.ai/install.sh | bash
  # npm inštaláciu (@anthropic-ai/claude-code) už nepoužívať pre nové nasadenie — deprecated cesta
repomix
llm (Simon Willison CLI)
ast-grep
difftastic
```

Voliteľné: codex (@openai/codex) + **bubblewrap** (nutná závislosť pre Codex sandbox na Linuxe), files-to-prompt, gemini-cli, openai CLI/SDK, aider, aichat/mods

## Fáza 7 — matematicko-kryptografický výskum (nové, doplnené)

```
sagemath    # VYNECHANÉ 2026-07-13 — nie je apt balík na Ubuntu 26.04 (dropnuté upstream, iba
            # osirotené sagemath-database-* zostali). Zatiaľ bez náhrady; revidovať cez
            # PPA alebo conda-forge/micromamba, ak bude sage skutočne potrebný.
fplll-tools # skutočný apt balík (nie "fplll")
fpylll
gmpy2
pycryptodome
z3          # solver a CLI
```

Python bindings (v konkrétnom uv projekte, nie globálne): `z3-solver`

Voliteľné: sympy, pari-gp, ntl, flint

## Fáza 8 — testovanie náhodnosti (nové, doplnené)

```
dieharder
```

Voliteľné: nist-sts, testu01, practrand (často nutná manuálna kompilácia)

## Fáza 9 — bezpečnostné skenovanie (nové, doplnené)

```
pip-audit
gitleaks
bandit
hadolint
```

Voliteľné: trivy, semgrep, afl++ (fuzzing pre C/kryptografické implementácie)

## Fáza 10 — YubiKey a smartcard

```
ykman
yubikey-agent
libpam-u2f
pcscd
pcsc-tools
scdaemon
opensc
```

Voliteľné: `yubikey-personalization` — iba pre legacy alebo špecifické Yubico OTP/challenge-response použitie (ykman pokrýva FIDO2/PIV/OpenPGP/OATH ako primárny nástroj)

## Fáza 11 — sieťové a kryptografické nástroje

```
openssl
nmap
testssl.sh
tcpdump
tshark (alebo wireshark)
mtr
dnsutils
netcat
socat
iproute2
ethtool
iperf3
traceroute
whois
```

Voliteľné: hping3, arp-scan

Poznámka: `testssl.sh` nie je vo všetkých distribúciách bežný apt balík — inštalovať z oficiálneho upstream repozitára (git clone) alebo ako kontajner, nie predpokladať `apt install testssl.sh`.

## Fáza 12 — CLI pohodlie

```
ripgrep
fd-find
fzf
bat
tree
ncdu (alebo duf)
meld
glow (alebo mdcat)
```

Voliteľné (doplnené): lazygit (alebo gitui), direnv, watchexec (alebo entr)

## Fáza 13 — monitoring hardvéru

```
nvme-cli
smartmontools
lm-sensors
powertop
```

---

## Voliteľné / doplniť neskôr (po otestovaní základu)

Stav k 2026-07-13: časť nainštalovaná (Fáza 15 v skripte), zvyšok zostáva odložený.

```
# NAINŠTALOVANÉ (Fáza 15):
jupyterlab       # cez uv tool install, nie apt/system Python
ocrmypdf
tesseract        # apt balík sa volá tesseract-ocr
rclone
lazygit          # presunuté do Fázy 12
direnv           # presunuté do Fázy 12
watchexec / entr # entr nainštalovaný ako náhrada (watchexec nie je apt balík)
trivy            # nie je apt balík, oficiálny install.sh do ~/.local/bin
afl++
tea (Gitea CLI klient)  # POZOR: apt balík "tea" je iný program (Qt textový editor,
                        # name collision) — skutočný Gitea CLI je binary release
                        # z gitea.com, inštaluje sa do ~/.local/bin
libntl-dev
libflint-dev
libsodium-dev

# ZÁMERNE ODLOŽENÉ (rozhodnutie 2026-07-13, nie chyba):
systemd-zram-generator  # balík auto-aktivuje 4GB zram swap hneď pri apt install
                        # (vlastný default config), čo obchádza pravidlo "testovať
                        # pred zapnutím" — inštalovať ručne až pri skutočnej potrebe
sympy                   # knižnica, nie CLI — pridať cez 'uv add sympy' per-projekt,
                        # nedáva zmysel globálny install pod per-projektovou .venv architektúrou
pari-gp                 # nainštalovaný (Fáza 15) — CAS náhrada za chýbajúci sagemath
sagemath                # VYNECHANÉ — pozri poznámku pri Fáze 7, nie je apt balík na tomto Ubuntu

# ZATIAĽ NEINŠTALOVANÉ (nízka priorita / čaká na konkrétnu potrebu):
browser-use
aider
files-to-prompt
gemini-cli
openai (CLI/SDK)
llama.cpp
imagemagick
libreoffice (headless)
duckdb
qdrant           # kontradikcia s vlastným rozhodnutím pre sqlite-vec (Fáza 4) — pozri "Zámerne neinštalovať"
promptfoo
langfuse
semgrep
codex + bubblewrap
huggingface_hub / hf CLI
transformers
safetensors
sentence-transformers
tox / nox
```

## Zámerne neinštalovať

```
vLLM (CPU-only stroj)
Kubernetes
Redis / RabbitMQ / Kafka
Milvus / Weaviate / Elasticsearch
qdrant (rovnaký dôvod — Fáza 4 zámerne zvolila ľahký embedded sqlite-vec namiesto samostatnej vector DB služby)
fail2ban (SSH iba cez Tailscale)
Gitea (beží na Pi, nie tu)
Open WebUI (centrálne na Macu)
nvtop (žiadna dedikovaná GPU)
```

## Prevádzkové veci (nie balíky, ale nutná konfigurácia)

```
LUKS full-disk encryption
Ollama iba cez localhost/Tailscale, nikdy verejný port
UFW default deny incoming
restic — retention policy (koľko snapshotov držať, nielen že beží)
restic — pravidelný test obnovy, nie iba úspešný snapshot
Syncthing — adresáre a ignore pravidlá
limity paralelizmu AI workeru (koľko jobov naraz pri 16GB RAM)
ZRAM (systemd-zram-generator) — otestovať pri reálnej záťaži (Ollama + Playwright + VS Code súčasne), nie automaticky zapnúť na 100 % RAM bez merania
```

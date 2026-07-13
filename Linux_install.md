# Linux ThinkPad T14 — zoznam na inštaláciu

**Stav:** júl 2026

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

Poznámka: `libfplll-dev`/`libgmp-dev`/`libmpfr-dev`/`libmpc-dev` sú nutné pre kompiláciu fpylll a gmpy2 vo Fáze 7 — bez nich pip/uv install zlyhá.

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

Ollama konfigurácia pre 16GB CPU-only stroj:
```
OLLAMA_NUM_PARALLEL=1      # nikdy viac naraz — CPU context switching zabíja výkon
OLLAMA_KEEP_ALIVE=5m       # model neostáva zbytočne v RAM, uvoľní miesto pre whisper/SageMath
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
```

Voliteľné: browser-use, xvfb, mitmproxy

## Fáza 6 — AI coding CLI

```
nodejs (LTS) + npm      # kvôli repomix, gemini-cli a ďalším JS nástrojom, nie kvôli claude-code
claude-code              # natívny installer (curl https://claude.ai/install.sh), npm je legacy/deprecated
repomix
llm (Simon Willison CLI)
ast-grep
difftastic
```

Voliteľné: codex (@openai/codex) + **bubblewrap** (nutná závislosť pre Codex sandbox na Linuxe), files-to-prompt, gemini-cli, openai CLI/SDK, aider, aichat/mods

## Fáza 7 — matematicko-kryptografický výskum (nové, doplnené)

```
sagemath
fplll
fpylll
gmpy2
pycryptodome
z3
```

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
yubikey-personalization
```

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

```
browser-use
aider
files-to-prompt
gemini-cli
openai (CLI/SDK)
llama.cpp
jupyterlab
ocrmypdf
tesseract
imagemagick
libreoffice (headless)
duckdb
qdrant
promptfoo
langfuse
rclone
lazygit / gitui
direnv
watchexec / entr
trivy
semgrep
afl++
codex + bubblewrap
tea (Gitea CLI klient)
huggingface_hub / hf CLI
transformers
safetensors
sentence-transformers
tox / nox
systemd-zram-generator
libntl-dev
libflint-dev
libsodium-dev
```

## Zámerne neinštalovať

```
vLLM (CPU-only stroj)
Kubernetes
Redis / RabbitMQ / Kafka
Milvus / Weaviate / Elasticsearch
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

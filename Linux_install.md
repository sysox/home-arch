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

## Fáza 2 — vývoj (jazyky, debugging, kvalita)

```
python3
uv
ruff
pytest
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
```

## Fáza 3 — lokálna AI

```
ollama (systemd služba)
ministral 3 8b (model)
granite 4.1 3b (model)
embeddinggemma (model)
faster-whisper
ffmpeg
```

Voliteľné: llama.cpp CLI, reranker (neskôr podľa potreby)

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
nodejs (LTS) + npm
claude-code (@anthropic-ai/claude-code)
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
```

Voliteľné: pari-gp, ntl

## Fáza 8 — testovanie náhodnosti (nové, doplnené)

```
dieharder
```

Voliteľné: nist-sts, testu01, practrand (často nutná manuálna kompilácia)

## Fáza 9 — bezpečnostné skenovanie (nové, doplnené)

```
pip-audit
```

Voliteľné: trivy, semgrep

## Fáza 10 — YubiKey a smartcard

```
ykman
yubikey-agent
pam-u2f
pcscd
scdaemon
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
```

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
codex + bubblewrap
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

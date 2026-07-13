# Inštalačný stav — Linux ThinkPad T14

Stav k: 2026-07-13
Zariadenie: Ubuntu 26.04 LTS, AMD Ryzen 7 PRO 4750U, 16 GB RAM, 1 TB NVMe

---

## Čo je hotové

### Fázy 1–13 (pôvodný zoznam) — všetko nainštalované a overené

| Fáza | Obsah | Stav |
|---|---|---|
| 1 | systém a sieť (git, docker, tailscale, ufw, sops, restic...) | ✅ UFW aktívne, Tailscale pripojený |
| 2 | vývoj (python3, build-essential, gdb, valgrind, uv...) | ✅ |
| 3 | lokálna AI (Ollama + limity, ffmpeg) | ✅ služba beží, limity nastavené |
| 4 | dokumenty a RAG (poppler, qpdf, pandoc, sqlite3) | ✅ |
| 5 | automatizácia/worker (log-only, per-projekt cez uv) | ✅ |
| 6 | AI coding CLI (node, claude-code, repomix, llm, ast-grep, difftastic) | ✅ |
| 7 | matematicko-kryptografický výskum (fplll, z3) | ✅ (sagemath vynechané — pozri nižšie) |
| 8 | testovanie náhodnosti (dieharder) | ✅ |
| 9 | bezpečnostné skenovanie (gitleaks, hadolint) | ✅ |
| 10 | YubiKey a smartcard (yubikey-manager, pcscd...) | ✅ balíky; PAM/U2F konfigurácia čaká |
| 11 | sieťové a kryptografické nástroje (nmap, testssl...) | ✅ |
| 12 | CLI pohodlie (ripgrep, fd, bat, glow, lazygit, direnv, entr) | ✅ + symlinky fd/bat |
| 13 | monitoring hardvéru (nvme-cli, smartd) | ✅ |

### Fáza 14 (nové) — VS Code

VS Code 1.128.0 + rozšírenia: Remote SSH, Python, C/C++, Markdown All in One,
Markdown Preview Enhanced, Docker.

### Fáza 15 (nové) — voliteľné doplnky

jupyterlab (cez uv), ocrmypdf, tesseract-ocr, libsodium-dev, libntl-dev,
libflint-dev, pari-gp, afl++, rclone, trivy, tea (Gitea CLI, opravené —
pozri nižšie), sops + age kľúč.

### Ollama modely stiahnuté

`ministral-3:8b` (6.0 GB), `granite4.1:3b` (2.1 GB), `embeddinggemma:latest` (621 MB).

### Backup (mimo skriptu, manuálne)

Lokálny restic repozitár `~/backups/restic-thinkpad`, jeden snapshot
(2138 súborov, 870 MB). Heslo uložené v KeePassXC. **Offsite kópia na Macu
čaká, kým zariadenie dorazí** — do vtedy je toto jediná (lokálna) kópia navyše
k Syncthing zrkadleniu.

### Secrets (mimo skriptu, manuálne)

sops + age nastavené (`~/.config/sops/`), šablóny `.sops.yaml`/`.envrc` pre
per-projekt API kľúče. Age privátny kľúč zálohovaný v KeePassXC.

---

## Chyby nájdené a opravené počas inštalácie

Toto boli reálne chyby v pôvodnom skripte/zozname, nie hypotetické — každá
bola overená priamo na tomto stroji pred opravou.

| Problém | Oprava |
|---|---|
| `docker-compose-plugin` neexistuje ako apt balík | správny názov: `docker-compose-v2` |
| `sops` nie je apt balík na Ubuntu 26.04 | .deb release z GitHubu (getsops/sops) |
| `ykman` nie je apt balík (iba binárka) | správny apt balík: `yubikey-manager` |
| `fplll` (CLI) sa neinštaloval, iba `libfplll-dev` (headers) | pridaný `fplll-tools` |
| `hadolint` nie je apt balík (Haskell, nebalený) | binary release z GitHubu do `~/.local/bin` |
| `smartmontools` systemd unit neexistuje | správny unit: `smartd` |
| `testssl.sh` apt balík existuje, ale binárka sa volá `testssl` (bez .sh) | opravená detekcia; zbytočný git clone odstránený |
| `dnsutils` je virtuálny/tranzitívny balík (rieši sa na `bind9-dnsutils`) | nie chyba, len poznámka — dig/nslookup fungujú |
| `npm install -g` bez nastaveného prefixu by zlyhal alebo vyžadoval sudo | `npm config set prefix ~/.local` pred prvým globálnym install |
| `fd-find`/`bat` inštalujú binárky ako `fdfind`/`batcat` (name clash) | symlinky `fd`/`bat` do `~/.local/bin` |
| `sagemath` nie je apt balík na Ubuntu 26.04 (dropnuté upstream) | vynechané, čiastočná náhrada: pari-gp/sympy/flint |
| GitHub API vracia JSON niekedy pretty-printed, niekedy minifikovaný na jeden riadok — `grep '"tag_name"' \| cut -d'"' -f4` sa nespoľahlivo rozbil na hadolint | nahradené `jq -r '.tag_name'` (spoľahlivé, jq je nainštalovaný od Fázy 1) |
| VS Code apt kľúč URL zmenené z `.gpg` na `.asc` (staré URL vracia 404) | opravené na `microsoft.asc` |
| apt balík `tea` je úplne iný program (Qt textový editor), nie Gitea CLI — name collision | skutočný Gitea `tea` binary release z gitea.com do `~/.local/bin` (má prednosť v PATH); nesprávny apt balík odinštalovaný |
| `systemd-zram-generator` sa auto-aktivuje (vlastný default config) hneď pri `apt install`, obchádza vlastné pravidlo "testovať pred zapnutím" | balík odinštalovaný, zámerne vynechaný zo skriptu — pozri Fáza 15 |

---

## Čo zostáva otvorené

| Položka | Stav | Poznámka |
|---|---|---|
| **PAM/U2F (YubiKey login/sudo)** | čaká | YubiKey príde zajtra; vyžaduje otvorenú rescue sudo reláciu pred zmenou |
| **LUKS full-disk encryption** | nevyriešené | disk momentálne NIE je šifrovaný (overené: čistý ext4, žiadny dm-crypt). Retrofit na bežiaci systém nie je bezpečný cez skript — vyžaduje plánovanie/reinštaláciu |
| **restic — offsite kópia (Mac)** | čaká na hardvér | Mac zatiaľ nedorazil; lokálny repo je zatiaľ jediná záloha navyše |
| **restic — automatizácia (systemd timer)** | odložené | zámerne, nie urgentné — zálohuje sa zatiaľ manuálne |
| **restic — retention policy (forget/prune)** | nerozhodnuté | CLAUDE.md aj tak vyžaduje explicitné potvrdenie pred každým forget/prune |
| **Dokumentačná nezrovnalosť: Pi storage** | nevyriešené | `architecture.md` píše "32 GB microSD, no external SSD", `install.md` predpokladá "USB SSD" pre Gitea/restic — treba zosúladiť |
| **Voliteľné nízka priorita** | neinštalované zámerne | browser-use, aider, gemini-cli, openai CLI, llama.cpp, imagemagick, libreoffice, duckdb, promptfoo, langfuse, semgrep, codex+bubblewrap, huggingface stack, tox/nox — pridať keď vznikne konkrétna potreba |
| **qdrant** | zámerne nie | rozpor s vlastným rozhodnutím pre sqlite-vec (Fáza 4); teraz aj v "Zámerne neinštalovať" |

---

## Zmeny v repozitári tohto sedenia

- `AGENTS.md` → premenované na `CLAUDE.md`, opravená referencia na neexistujúci
  súbor (`linux-thinkpad-install-zoznam.md` → `Linux_install.md`)
- `install-thinkpad.sh` — všetky opravy vyššie + nové `phase14` (VS Code),
  `phase15` (voliteľné doplnky), `main()` rozšírený o phase14/15
- `Linux_install.md` — aktualizovaná Fáza 7 (sagemath poznámka), sekcia
  "Voliteľné" rozdelená na nainštalované/odložené/zámerne nie, `qdrant`
  pridaný do "Zámerne neinštalovať"

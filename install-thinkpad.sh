#!/usr/bin/env bash
# Linux ThinkPad T14 — fázovaný inštalačný skript
# Použitie: ./install-thinkpad.sh phase1   (spúšťaj fázu po fáze, nie naraz)
#           ./install-thinkpad.sh all      (spustí všetky fázy postupne, so zastaveniami)
set -euo pipefail

LOG_FILE="$HOME/install-thinkpad.log"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

confirm() {
    local prompt="$1"
    read -r -p "⚠️  $prompt [y/N]: " ans
    [[ "$ans" =~ ^[Yy]$ ]] || { log "PRESKOČENÉ (bez potvrdenia): $prompt"; return 1; }
    return 0
}

apt_install() {
    log "apt install: $*"
    sudo apt update -qq
    for pkg in "$@"; do
        if apt-cache show "$pkg" &>/dev/null; then
            sudo apt install -y "$pkg" || log "ZLYHALO: $pkg — over presný názov balíka manuálne"
        else
            log "BALÍK NEEXISTUJE v repozitári: $pkg — over apt search alebo alternatívny zdroj"
        fi
    done
}

# ---------------------------------------------------------------------------
phase1() {
    log "=== Fáza 1 — systém a sieť ==="
    apt_install git git-lfs gh syncthing rsync docker.io docker-compose-v2 \
        tmux mosh btop earlyoom keepassxc age fwupd \
        unattended-upgrades needrestart curl wget jq yq \
        zip unzip zstd xz-utils ca-certificates gnupg openssh-server

    # sops — nie je apt balík na tomto Ubuntu, oficiálny .deb release z GitHubu
    if ! command -v sops &>/dev/null; then
        log "sops nie je apt balík — sťahujem oficiálny .deb release z getsops/sops."
        SOPS_TAG=$(curl -fsSL https://api.github.com/repos/getsops/sops/releases/latest | jq -r '.tag_name')
        SOPS_VER="${SOPS_TAG#v}"
        SOPS_DEB="sops_${SOPS_VER}_amd64.deb"
        curl -fsSL -o "/tmp/${SOPS_DEB}" "https://github.com/getsops/sops/releases/download/${SOPS_TAG}/${SOPS_DEB}"
        sudo apt install -y "/tmp/${SOPS_DEB}"
        rm -f "/tmp/${SOPS_DEB}"
        log "sops ${SOPS_TAG} nainštalovaný cez .deb."
    fi

    # Tailscale — vlastný repozitár
    curl -fsSL https://tailscale.com/install.sh | sh
    log "Tailscale nainštalovaný. Spusti 'sudo tailscale up' manuálne a autentifikuj sa."

    # restic
    apt_install restic

    log "restic nainštalovaný. Repozitár a retention policy nastav manuálne (restic init), skript to nerobí automaticky."

    # UFW — inštalácia áno, aktivácia vyžaduje potvrdenie
    apt_install ufw
    if confirm "Aktivovať UFW (default deny incoming, povoliť len tailscale0)? Over že Tailscale beží, inak môžeš stratiť SSH prístup."; then
        sudo ufw default deny incoming
        sudo ufw allow in on tailscale0
        sudo ufw --force enable
        log "UFW aktivované."
    fi

    log "Fáza 1 hotová. VS Code/VSCodium nainštaluj manuálne (grafický installer alebo repozitár podľa preferencie)."
}

phase2() {
    log "=== Fáza 2 — vývoj ==="
    apt_install python3 python3-dev build-essential gcc clang cmake ninja-build \
        pkg-config gdb valgrind strace ltrace linux-tools-generic hyperfine \
        cppcheck clang-tidy shellcheck shfmt \
        libssl-dev libffi-dev libgmp-dev libmpfr-dev libmpc-dev libfplll-dev

    # uv — vlastný installer, nie apt
    curl -LsSf https://astral.sh/uv/install.sh | sh
    log "uv nainštalovaný. Python nástroje inštaluj cez 'uv tool install' (ruff, mypy/pyright, pre-commit)."
    log "Príklad: uv tool install ruff && uv tool install pre-commit"

    log "Fáza 2 hotová. Projektové závislosti (pytest, pytest-cov, hypothesis, fastapi...) pridávaj cez 'uv add' v konkrétnom projekte, nie globálne."
}

phase3() {
    log "=== Fáza 3 — lokálna AI ==="
    curl -fsSL https://ollama.com/install.sh | sh

    # Systemd override pre pamäťové limity — kritické pre 16GB CPU-only stroj
    sudo mkdir -p /etc/systemd/system/ollama.service.d
    cat <<'EOF' | sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null
[Service]
Environment="OLLAMA_MAX_LOADED_MODELS=1"
Environment="OLLAMA_NUM_PARALLEL=1"
Environment="OLLAMA_KEEP_ALIVE=5m"
EOF
    sudo systemctl daemon-reload
    sudo systemctl enable --now ollama
    log "Ollama nainštalovaná s limitmi (MAX_LOADED_MODELS=1, KEEP_ALIVE=5m)."

    log "Stiahni modely manuálne: ollama pull <ministral-model>, ollama pull <granite-model>, ollama pull <embeddinggemma>"
    log "faster-whisper a ffmpeg: apt install ffmpeg, faster-whisper cez uv v konkrétnom projekte."
    apt_install ffmpeg
}

phase4() {
    log "=== Fáza 4 — dokumenty a RAG ==="
    apt_install poppler-utils qpdf pandoc sqlite3
    log "docling, pymupdf, sqlite-vec inštaluj cez 'uv add' v RAG projekte (nie globálne)."
}

phase5() {
    log "=== Fáza 5 — automatizácia a worker ==="
    log "playwright, fastapi, uvicorn, httpx, pydantic, litellm — cez 'uv add' vo worker projekte."
    log "Po 'uv add playwright': spusti 'uv run playwright install --with-deps' pre Chromium."
}

phase6() {
    log "=== Fáza 6 — AI coding CLI ==="

    # Node.js LTS — kvôli repomix/gemini-cli, NIE kvôli claude-code
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    apt_install nodejs

    # npm global prefix -> ~/.local (XDG, per-user), inak 'npm install -g' bez sudo zlyhá
    # (a so sudo by porušilo pravidlo "nikdy sudo npm install -g" z Linux_install.md)
    mkdir -p "$HOME/.local"
    npm config set prefix "$HOME/.local"

    # Claude Code — preferovaný APT repozitár
    sudo install -d -m 0755 /etc/apt/keyrings
    sudo curl -fsSL https://downloads.claude.ai/keys/claude-code.asc -o /etc/apt/keyrings/claude-code.asc
    echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/stable stable main" \
        | sudo tee /etc/apt/sources.list.d/claude-code.list
    apt_install claude-code
    log "Ak APT repozitár zlyhá, alternatíva: curl -fsSL https://claude.ai/install.sh | bash"

    npm install -g repomix

    # llm CLI — cez uv tool install (nie apt, nie npm)
    uv tool install llm
    log "llm CLI nainštalovaný cez uv tool install."

    # ast-grep — nie je apt balík na tomto systéme, ale existuje ako npm balík @ast-grep/cli
    npm install -g @ast-grep/cli
    log "ast-grep (sg) nainštalovaný cez npm."

    # difftastic — nie je apt ani npm balík, oficiálny binary release z GitHubu
    if ! command -v difft &>/dev/null; then
        DIFFT_TAG=$(curl -fsSL https://api.github.com/repos/Wilfred/difftastic/releases/latest | jq -r '.tag_name')
        curl -fsSL -o /tmp/difft.tar.gz \
            "https://github.com/Wilfred/difftastic/releases/download/${DIFFT_TAG}/difft-x86_64-unknown-linux-gnu.tar.gz"
        mkdir -p "$HOME/.local/bin"
        tar -xzf /tmp/difft.tar.gz -C "$HOME/.local/bin" difft
        chmod +x "$HOME/.local/bin/difft"
        rm -f /tmp/difft.tar.gz
        log "difftastic ${DIFFT_TAG} nainštalovaný do ~/.local/bin."
    fi
}

phase7() {
    log "=== Fáza 7 — matematicko-kryptografický výskum ==="
    log "sagemath VYNECHANÉ — nie je apt balík na tomto Ubuntu (dropnuté upstream, iba osirotené sagemath-database-* zostali). Rozhodnutie: zatiaľ preskočiť, revidovať neskôr (PPA alebo conda-forge/micromamba, ak bude treba)."
    apt_install libfplll-dev fplll-tools
    log "fpylll, gmpy2, pycryptodome, z3-solver — cez 'uv add' v research projekte (headers z Fázy 2 už sú nainštalované)."
    apt_install z3
}

phase8() {
    log "=== Fáza 8 — testovanie náhodnosti ==="
    apt_install dieharder
}

phase9() {
    log "=== Fáza 9 — bezpečnostné skenovanie ==="
    log "pip-audit, bandit — cez 'uv tool install'."
    apt_install gitleaks

    # hadolint — nie je apt balík (Haskell, zvyčajne nebalený), oficiálny static binary z GitHub release
    if ! command -v hadolint &>/dev/null; then
        log "hadolint nie je apt balík — sťahujem oficiálny binary release z hadolint/hadolint."
        HADOLINT_TAG=$(curl -fsSL https://api.github.com/repos/hadolint/hadolint/releases/latest | jq -r '.tag_name')
        mkdir -p "$HOME/.local/bin"
        curl -fsSL -o "$HOME/.local/bin/hadolint" \
            "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_TAG}/hadolint-linux-x86_64"
        chmod +x "$HOME/.local/bin/hadolint"
        log "hadolint ${HADOLINT_TAG} nainštalovaný do ~/.local/bin."
    fi
}

phase10() {
    log "=== Fáza 10 — YubiKey a smartcard ==="
    apt_install yubikey-manager yubikey-agent libpam-u2f pcscd pcsc-tools scdaemon opensc
    sudo systemctl enable --now pcscd
    log "Fáza 10 hotová. PAM/U2F login/sudo konfiguráciu VYKONAJ MANUÁLNE — skript to zámerne nerobí automaticky. Pred zmenou nechaj otvorenú sudo reláciu."
}

phase11() {
    log "=== Fáza 11 — sieťové a kryptografické nástroje ==="
    apt_install nmap tcpdump tshark mtr dnsutils netcat-openbsd socat \
        iproute2 ethtool iperf3 traceroute whois

    # POZOR: apt balík "testssl.sh" nainštaluje binárku ako /usr/bin/testssl (bez .sh)
    if ! command -v testssl &>/dev/null; then
        apt_install testssl.sh
    fi
    if ! command -v testssl &>/dev/null; then
        log "testssl.sh apt balík nedostupný — klonujem z oficiálneho repozitára."
        git clone --depth 1 https://github.com/drwetter/testssl.sh.git "$HOME/testssl.sh"
        log "testssl.sh stiahnutý do $HOME/testssl.sh — spúšťaj ako $HOME/testssl.sh/testssl.sh"
    fi
}

phase12() {
    log "=== Fáza 12 — CLI pohodlie ==="
    apt_install ripgrep fd-find fzf bat tree ncdu meld glow lazygit direnv entr

    # Ubuntu balí fd-find/bat pod inými menami binárky (kolízia názvov) — symlink do ~/.local/bin
    mkdir -p "$HOME/.local/bin"
    [[ -x /usr/bin/fdfind ]] && ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"
    [[ -x /usr/bin/batcat ]] && ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
    log "watchexec nie je apt balík na tomto systéme — entr je nainštalovaný ako náhrada (podľa zoznamu 'watchexec alebo entr')."
}

phase13() {
    log "=== Fáza 13 — monitoring hardvéru ==="
    apt_install nvme-cli smartmontools lm-sensors powertop
    sudo systemctl enable --now smartd || true
    log "Fáza 13 hotová."
}

phase14() {
    log "=== Fáza 14 — VS Code ==="
    # POZOR: kľúč je teraz .asc, nie .gpg (staré .gpg URL vracia 404)
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f /tmp/packages.microsoft.gpg
    apt_install code

    for ext in ms-vscode-remote.remote-ssh ms-python.python ms-vscode.cpptools \
        yzhang.markdown-all-in-one shd101wyy.markdown-preview-enhanced ms-azuretools.vscode-docker; do
        code --install-extension "$ext" --force
    done
    log "Fáza 14 hotová — VS Code + rozšírenia (Remote SSH, Python, C/C++, Markdown All in One, Markdown Preview Enhanced, Docker)."
}

phase15() {
    log "=== Fáza 15 — voliteľné doplnky (výskum/bezpečnosť) ==="
    apt_install ocrmypdf tesseract-ocr libsodium-dev libntl-dev libflint-dev pari-gp afl++ rclone

    # jupyterlab — cez uv tool install (nie apt/system Python)
    uv tool install jupyterlab
    log "jupyterlab nainštalovaný cez uv tool install (spúšťaj: jupyter-lab)."

    # sympy — knižnica, nie CLI nástroj; nedáva zmysel globálny install pod per-projektovou .venv architektúrou
    log "sympy VYNECHANÉ zámerne — je to knižnica, pridaj cez 'uv add sympy' v konkrétnom projekte, nie globálne."

    # trivy — nie je apt balík, oficiálny installer skript (binary release), netreba sudo
    if ! command -v trivy &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        curl -fsSL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b "$HOME/.local/bin"
        log "trivy nainštalovaný do ~/.local/bin."
    fi

    # tea (Gitea CLI) — POZOR: apt balík "tea" je INÝ program (Qt textový editor, name collision).
    # Skutočný Gitea CLI je binary release z gitea.com, nie apt.
    if ! command -v tea &>/dev/null || ! tea --version 2>&1 | grep -q golang; then
        mkdir -p "$HOME/.local/bin"
        TEA_TAG=$(curl -fsSL https://gitea.com/api/v1/repos/gitea/tea/releases/latest | jq -r '.tag_name')
        TEA_VER="${TEA_TAG#v}"
        curl -fsSL -o "$HOME/.local/bin/tea" \
            "https://gitea.com/gitea/tea/releases/download/${TEA_TAG}/tea-${TEA_VER}-linux-amd64"
        chmod +x "$HOME/.local/bin/tea"
        log "tea (Gitea CLI) ${TEA_TAG} nainštalovaný do ~/.local/bin (~/.local/bin má prednosť pred /usr/bin v PATH)."
    fi

    # sops + age kľúč pre šifrovanie API kľúčov/secrets (idempotentné — negeneruje nový kľúč ak už existuje)
    mkdir -p "$HOME/.config/sops/age"
    chmod 700 "$HOME/.config/sops/age"
    if [[ ! -f "$HOME/.config/sops/age/keys.txt" ]]; then
        age-keygen -o "$HOME/.config/sops/age/keys.txt"
        chmod 600 "$HOME/.config/sops/age/keys.txt"
        log "Nový age kľúč vygenerovaný. ZÁLOHUJ ho ihneď (KeePassXC alebo fyzická kópia) — strata = trvalá strata všetkých sops secrets zašifrovaných týmto kľúčom."
    fi

    # systemd-zram-generator ZÁMERNE VYNECHANÉ:
    # balík má vlastný default config a AUTOMATICKY aktivuje 4GB zram swap hneď pri inštalácii,
    # bez ohľadu na to, či si to niekto vyžiadal. To je v rozpore s vlastnou poznámkou v Linux_install.md
    # ("otestovať pri reálnej záťaži, nie automaticky zapnúť bez merania"). Inštaluj manuálne až po
    # rozhodnutí, a over /usr/lib/systemd/zram-generator.conf pred inštaláciou.
    log "systemd-zram-generator VYNECHANÉ zámerne — auto-aktivuje zram swap hneď pri apt install, čo obchádza vlastné pravidlo 'testovať pred zapnutím'. Inštaluj ručne, až keď bude treba."

    log "Fáza 15 hotová."
}

# ---------------------------------------------------------------------------
main() {
    local target="${1:-}"
    case "$target" in
        phase1|phase2|phase3|phase4|phase5|phase6|phase7|phase8|phase9|phase10|phase11|phase12|phase13|phase14|phase15)
            "$target"
            ;;
        all)
            for p in phase1 phase2 phase3 phase4 phase5 phase6 phase7 phase8 phase9 phase10 phase11 phase12 phase13 phase14 phase15; do
                log ">>> Spúšťam $p"
                "$p"
                log ">>> $p dokončená. Skontroluj výstup pred pokračovaním."
            done
            ;;
        *)
            echo "Použitie: $0 {phase1..phase15|all}"
            exit 1
            ;;
    esac
}

main "$@"

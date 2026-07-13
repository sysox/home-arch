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
    apt_install git git-lfs gh syncthing rsync docker.io docker-compose-plugin \
        tmux mosh btop earlyoom keepassxc sops age fwupd \
        unattended-upgrades needrestart curl wget jq yq \
        zip unzip zstd xz-utils ca-certificates gnupg openssh-server

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

    # Claude Code — preferovaný APT repozitár
    sudo install -d -m 0755 /etc/apt/keyrings
    sudo curl -fsSL https://downloads.claude.ai/keys/claude-code.asc -o /etc/apt/keyrings/claude-code.asc
    echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/stable stable main" \
        | sudo tee /etc/apt/sources.list.d/claude-code.list
    apt_install claude-code
    log "Ak APT repozitár zlyhá, alternatíva: curl -fsSL https://claude.ai/install.sh | bash"

    npm install -g repomix
    log "llm CLI: uv tool install llm"
    log "ast-grep a difftastic: over dostupnosť v distribučnom repozitári alebo cargo/binary release."
}

phase7() {
    log "=== Fáza 7 — matematicko-kryptografický výskum ==="
    apt_install sagemath libfplll-dev
    log "fplll, fpylll, gmpy2, pycryptodome, z3-solver — cez 'uv add' v research projekte (headers z Fázy 2 už sú nainštalované)."
    apt_install z3
}

phase8() {
    log "=== Fáza 8 — testovanie náhodnosti ==="
    apt_install dieharder
}

phase9() {
    log "=== Fáza 9 — bezpečnostné skenovanie ==="
    log "pip-audit, bandit — cez 'uv tool install'."
    apt_install gitleaks hadolint
}

phase10() {
    log "=== Fáza 10 — YubiKey a smartcard ==="
    apt_install ykman yubikey-agent libpam-u2f pcscd pcsc-tools scdaemon opensc
    sudo systemctl enable --now pcscd
    log "Fáza 10 hotová. PAM/U2F login/sudo konfiguráciu VYKONAJ MANUÁLNE — skript to zámerne nerobí automaticky. Pred zmenou nechaj otvorenú sudo reláciu."
}

phase11() {
    log "=== Fáza 11 — sieťové a kryptografické nástroje ==="
    apt_install nmap tcpdump tshark mtr dnsutils netcat-openbsd socat \
        iproute2 ethtool iperf3 traceroute whois

    if ! command -v testssl.sh &>/dev/null; then
        log "testssl.sh nie je apt balík — klonujem z oficiálneho repozitára."
        git clone --depth 1 https://github.com/drwetter/testssl.sh.git "$HOME/testssl.sh"
        log "testssl.sh stiahnutý do $HOME/testssl.sh — spúšťaj ako $HOME/testssl.sh/testssl.sh"
    fi
}

phase12() {
    log "=== Fáza 12 — CLI pohodlie ==="
    apt_install ripgrep fd-find fzf bat tree ncdu meld
    log "glow/mdcat, lazygit/gitui, direnv, watchexec — over dostupnosť v repozitári alebo cez binary release."
}

phase13() {
    log "=== Fáza 13 — monitoring hardvéru ==="
    apt_install nvme-cli smartmontools lm-sensors powertop
    sudo systemctl enable --now smartmontools || true
    log "Fáza 13 hotová."
}

# ---------------------------------------------------------------------------
main() {
    local target="${1:-}"
    case "$target" in
        phase1|phase2|phase3|phase4|phase5|phase6|phase7|phase8|phase9|phase10|phase11|phase12|phase13)
            "$target"
            ;;
        all)
            for p in phase1 phase2 phase3 phase4 phase5 phase6 phase7 phase8 phase9 phase10 phase11 phase12 phase13; do
                log ">>> Spúšťam $p"
                "$p"
                log ">>> $p dokončená. Skontroluj výstup pred pokračovaním."
            done
            ;;
        *)
            echo "Použitie: $0 {phase1..phase13|all}"
            exit 1
            ;;
    esac
}

main "$@"

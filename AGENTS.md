# AGENTS.md — inštrukcie pre AI agenta vykonávajúceho inštaláciu

Tento súbor číta claude-code / Codex CLI automaticky pri otvorení tohto adresára. Platí pre vykonanie `install-thinkpad.sh` na Linux ThinkPad T14.

## Kontext

Cieľové zariadenie: Ubuntu Linux, AMD Ryzen 7 PRO 4750U, 16 GB RAM, 1 TB NVMe. Referenčný zoznam softvéru: `linux-thinkpad-install-zoznam.md`. Skript: `install-thinkpad.sh`.

## Prevádzkový režim (povinné)

- Bež v móde **`on-request`/`workspace-write`** (ekvivalent Codex `--full-auto` alebo claude-code default permissions). **NIKDY nepoužívaj `--yolo` / `--dangerously-bypass-approvals-and-sandbox` / `--dangerously-skip-permissions`** na tomto stroji — obsahuje reálne dáta, SSH kľúče a produkčnú konfiguráciu, nie je to izolovaný kontajner.
- Spúšťaj skript fázu po fáze (`./install-thinkpad.sh phase1`, `phase2`, ...), nie naraz cez jedno volanie. Po každej fáze skontroluj exit kód a výstup pred pokračovaním na ďalšiu.

## Kroky vyžadujúce explicitné potvrdenie od človeka — NIKDY nepokračuj automaticky

Tieto operácie skript sám zastaví a vypíše prompt. Ak sa objaví prompt, **nepotvrdzuj ho sám** — zastav a čakaj na človeka:

1. **UFW aktivácia** (`ufw enable`) — môže zablokovať existujúce SSH spojenie, ak pravidlá nie sú správne.
2. **LUKS full-disk encryption** — nedá sa bezpečne retrofitovať skriptom na bežiaci systém; ak nie je nastavené, iba nahlás človeku, nerob nič.
3. **PAM/U2F zmeny** (`pam-u2f` konfigurácia login/sudo) — pred zmenou musí zostať otvorená existujúca root/sudo relácia ako záchranná sieť. Skontroluj, že taká relácia existuje, inak PAM zmenu odmietni vykonať.
4. **Docker group add** (`usermod -aG docker $USER`) — vyžaduje odhlásenie/prihlásenie, uprac používateľa, nerestartuj reláciu sám.
5. **Akékoľvek `restic forget`/`restic prune`** alebo iné mazanie snapshotov — vždy ukáž, čo bude zmazané, a čakaj na potvrdenie.
6. **Zmena YubiKey slotov alebo OTP konfigurácie** — nevratné, vždy potvrdiť.

## Čo smieš robiť bez pýtania

- `apt install` pre balíky zo zoznamu (okrem vyššie uvedených výnimiek), `pip`/`uv add`/`uv tool install`, `ollama pull`, vytváranie systemd unit súborov (bez `enable --now` na rizikové služby ako UFW), git operácie v rámci lokálneho repa, čítanie logov a diagnostika.

## Pri zlyhaní balíka

- Ak `apt install X` zlyhá s "unable to locate package", over presný názov balíka pre danú distribúciu/verziu Ubuntu (napr. `apt search`), neskús naslepo alternatívny názov bez overenia.
- `testssl.sh` nie je štandardný apt balík na všetkých distribúciách — ak zlyhá, nainštaluj cez `git clone` z oficiálneho repozitára, neponáhľaj sa s neoverenými zdrojmi.
- Ak `pip`/`uv install` niečoho z Fázy 7 (fpylll, gmpy2) zlyhá kompiláciou, over že sú nainštalované dev headers z Fázy 2 (`libgmp-dev`, `libmpfr-dev`, `libmpc-dev`, `libfplll-dev`) pred ďalšími pokusmi.

## Po dokončení každej fázy

Napíš krátky súhrn: čo sa nainštalovalo, čo zlyhalo, čo čaká na potvrdenie človeka. Neprechádzaj mlčky cez chyby.

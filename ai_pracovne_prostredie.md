# AI pracovné prostredie

**Stav:** júl 2026

---

## 1. Prehľad zariadení

| Zariadenie | Hlavná úloha |
|---|---|
| **Mac** | náročné lokálne AI úlohy, písanie, analýza, vision |
| **Linux ThinkPad** | menšie modely, RAG, skripty, batch |
| **Windows ThinkPad** | Office, Windows automatizácia, menšie AI úlohy |
| **Raspberry Pi** | jednoduché služby, monitoring, prípadne scheduler |
| **MetaCentrum** | veľké modely a veľké výpočty |
| **Cloud** | najťažšie úlohy a finálny review, iba pre necitlivé dáta |

---

## 2. Čo nainštalovať

**Mac**
- Tailscale
- Ollama
- Open WebUI
- Mistral Small 3.2 24B
- Ministral 8B ako rýchlejší fallback
- Whisper alebo MLX Whisper
- prípadne Qwen Coder

**Linux ThinkPad**
- Tailscale
- Ollama
- Ministral 8B
- Granite 3B
- EmbeddingGemma
- faster-whisper
- Playwright
- Python

**Windows ThinkPad**
- Tailscale
- Ollama
- Ministral 8B
- Windows UI Automation alebo Power Automate
- prípadne WSL2

**Raspberry Pi**
- Tailscale
- Python
- systemd služby
- jednoduchý monitoring zariadení
- notifikácie

Na Pi nedávať veľké modely.

**Poznámka k IDE klientovi:** ak používaš Continue, vedz, že ho akvirovalo Cursor a projekt je zmrazený (repozitár read-only) — cloudové dáta v Continue hube sa navyše mažú po 15.7.2026. Ak tam niečo máš, exportuj to. Na nový vývoj zvážiť inú voľbu.

---

## 3. Na čo ktorý model používať

| Model | Použitie |
|---|---|
| **Mistral Small 24B** | dlhšie texty, analýza, sumarizácia, porovnávanie dokumentov |
| **Ministral 8B** | bežné otázky, kratšie texty, malé skripty, batch |
| **Granite 3B** | JSON, extrakcia údajov, klasifikácia |
| **EmbeddingGemma** | vyhľadávanie v dokumentoch a RAG |
| **Whisper** | prepis audia |
| **Qwen Coder** | programovanie |
| **Cloud (GPT/Claude/Gemini)** | náročný review, zložité reasoning úlohy, aktuálne informácie |

---

## 4. Ako vyberať model

```text
Krátka jednoduchá úloha            → ThinkPad, Ministral 8B
Dlhší text alebo zložitejšia analýza → Mac, Mistral Small 24B
Extrakcia do JSON                   → Granite 3B
Vyhľadávanie v dokumentoch           → EmbeddingGemma + Mistral
Audio                                → Whisper
Veľký programátorský projekt         → MetaCentrum alebo cloud
Citlivé dáta                         → iba lokálne modely
```

---

## 5. Ako s tým pracovať

**Bežný chat** — Open WebUI, vybrať model podľa úlohy.

**Programovanie** — IDE klient pripojený na Ollama alebo cloudový nástroj. Malé úlohy lokálne, veľké repo úlohy MetaCentrum alebo cloud.

**Dokumenty**
- Nahrať dokument.
- Krátky dokument → priamo Mistral Small.
- Veľké množstvo dokumentov → RAG.
- Aktuálne fakty → vždy doplniť webové vyhľadávanie.

**Audio**
- Nahrať audio.
- Prepis cez Whisper.
- Sumarizácia cez Ministral alebo Mistral Small.

**Automatizácia**
- Najprv klasický Python alebo Playwright skript.
- AI použiť iba tam, kde sa obsah mení alebo je nejednoznačný.
- Mazanie, odoslanie a publikovanie vždy manuálne potvrdiť.

---

## 6. Pravidlá pre cloud

- Heslá, kľúče a študentské údaje neposielať do cloudu.
- Verejné texty a vlastné drafty môžu ísť do cloudu.
- Cloud použiť až vtedy, keď lokálny model nestačí.
- Aktuálne informácie overovať cez web, nie iba z pamäte modelu.

---

## 7. Odporúčaný postup nasadenia

1. Nainštalovať Ollama na Mac a ThinkPady.
2. Stiahnuť jeden model na Mac a jeden na ThinkPady.
3. Pripojiť ich do Open WebUI.
4. Otestovať typické úlohy: text, programovanie, extrakcia, audio, dokumenty.
5. Až potom pridať RAG, automatizáciu alebo scheduler.

---

## Referenčné zdroje

- [Mistral Small 3.2 v Ollame](https://ollama.com/library/mistral-small3.2)
- [Ministral 3 v Ollame](https://ollama.com/library/ministral-3)
- [Granite 4.1 v Ollame](https://ollama.com/library/granite4.1)
- [EmbeddingGemma v Ollame](https://ollama.com/library/embeddinggemma)
- [Ollama API](https://docs.ollama.com/api/introduction)
- [Open WebUI](https://docs.openwebui.com/)
- [Playwright](https://playwright.dev/docs/intro)
- [Tailscale](https://tailscale.com/docs/how-to/quickstart)

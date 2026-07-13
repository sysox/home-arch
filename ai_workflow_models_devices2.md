# AI pracovné prostredie: úlohy, modely, zariadenia a spôsob používania

**Stav:** júl 2026

## 1. Hardvér a jeho rola

| Zariadenie | Parametre | Hlavná rola |
|---|---|---|
| **MacBook Air M5** | 32 GB unified memory, 512 GB SSD | hlavný lokálny AI server, písanie, analýza, vision, lokálny coding fallback |
| **Linux ThinkPad T14** | Ryzen 7 PRO 4750U, 16 GB RAM, 1 TB NVMe | Linux vývoj, automatizácia, RAG, extrakcia, prvý paralelný worker |
| **Windows ThinkPad T14** | Ryzen 7 PRO 4750U, 16 GB RAM, 1 TB NVMe | Office, Windows automatizácia, WSL, druhý paralelný worker |
| **Raspberry Pi 5** | 8 GB RAM | always-on scheduler, routing, Wake-on-LAN, monitoring |
| **MetaCentrum** | serverové CPU/GPU | veľké coding modely, veľký kontext, rozsiahle dávky |
| **Cloud** | GPT, Claude, Gemini | najvyššia kvalita a finálna kontrola |

Základné rozdelenie:

```text
Mac = silný lokálny model
ThinkPady = identickí paralelní workeri
Pi = koordinátor
MetaCentrum = veľké kódovanie
Cloud = posledná úroveň
```

---

# 2. Čo chcem robiť a čo na to použiť

| Činnosť | Model alebo nástroj | Kde beží | Ako sa používa |
|---|---|---|---|
| **Repo-level programovanie** | veľký LLM dostupný na MetaCentre | MetaCentrum | VS Code/Continue, CLI agent alebo API |
| **Lokálne programovanie** | Mistral Small 3.2 24B; voliteľne Qwen3-Coder 30B | Mac | Continue, terminálový agent alebo Ollama API |
| **Malé skripty a vysvetlenie kódu** | Ministral 3 8B | ľubovoľný ThinkPad | lokálny chat alebo Continue |
| **E-maily** | Mistral Small 3.2 24B | Mac | Open WebUI: poznámky → návrh → manuálne odoslanie |
| **E-maily bez Macu** | Ministral 3 8B | aktuálny ThinkPad | lokálna Ollama |
| **Výučbové materiály** | Mistral Small 3.2 24B | Mac | osnova, návrh, revízia, Markdown/LaTeX |
| **Články a odborné texty** | Mistral Small 3.2 24B | Mac | Writer → reviewer → finálny text |
| **Sumarizácia dokumentov** | Mistral Small alebo Ministral 8B | Mac/ThinkPady | interaktívne alebo dávkovým skriptom |
| **Extrakcia do JSON** | Granite 4.1 3B | oba ThinkPady | Python API + JSON Schema/Pydantic |
| **Klasifikácia dokumentov** | Granite 4.1 3B | oba ThinkPady | dávkové spracovanie fronty |
| **Extrakcia znalostí** | parser + EmbeddingGemma + Granite/Mistral | Linux + Mac | dokument → segmenty → retrieval → štruktúrovaný výstup |
| **Semantické vyhľadávanie/RAG** | EmbeddingGemma + lokálny index | Linux ThinkPad | lokálna služba pre všetky zariadenia |
| **Porovnanie dokumentov** | Mistral Small 3.2 | Mac | relevantné časti alebo diff → analýza |
| **Hromadné spracovanie** | Ministral 8B/Granite 3B | oba ThinkPady paralelne | dispatcher prideľuje ďalšiu položku voľnému workeru |
| **Stabilné webové formuláre** | Playwright | Linux ThinkPad | deterministický skript bez LLM |
| **Meniaci sa alebo neznámy web** | Browser Use + Mistral | browser na ThinkPade, model na Macu | agent navrhne kroky, rizikové kroky sa potvrdia |
| **Office/Windows aplikácie** | Windows UI Automation + lokálny model | Windows ThinkPad | skript vykoná, model pripraví údaje alebo rozhodnutie |
| **Prepis audia** | Whisper | Mac alebo Linux | audio → text → Mistral pripraví zhrnutie |
| **Screenshoty a diagramy** | Mistral Small/Ministral 8B | Mac primárne | multimodálny vstup |
| **Triedenie súborov** | Granite alebo Ministral | Linux | model navrhne kategóriu; skript vykoná po kontrole |
| **Writer–Reviewer** | Mac writer, ThinkPady revieweri | všetky tri stroje | nezávislé odpovede → finálna syntéza |
| **Routing úloh** | deterministické pravidlá | Raspberry Pi | podľa typu, citlivosti, dostupnosti a výkonu |

---

# 3. Modely

## Primárne modely

| Model | Približná veľkosť | Kde | Rola |
|---|---:|---|---|
| **Mistral Small 3.2 24B** | 15 GB | Mac | hlavný model na text, e-maily, materiály, vision a tools |
| **Ministral 3 8B** | 6 GB | oba ThinkPady; voliteľne Mac | spoločný univerzálny worker |
| **Granite 4.1 3B** | približne 2 GB | oba ThinkPady | JSON, extrakcia, klasifikácia a tool selection |
| **EmbeddingGemma** | 622 MB | Linux ThinkPad | embeddings, retrieval a RAG |
| **Whisper** | podľa variantu | Mac/Linux | audio → text |

## Voliteľné modely

| Model | Kde | Prečo ho skúsiť |
|---|---|---|
| **Qwen 3.6 27B** | Mac | A/B test proti Mistral Small pre reasoning a všeobecné úlohy |
| **Qwen3-Coder 30B** | Mac | lokálny coding fallback |
| **Phi-4 Mini** | ThinkPady | rýchla logika, matematika a function calling |
| **Gemma** | Mac | alternatívna multimodalita |
| **Llama/DeepSeek** | MetaCentrum | väčšie serverové úlohy |

Slovenčina a čeština nie sú hlavné výberové kritérium. Priorita je:

1. anglický technický text,
2. presné inštrukcie,
3. structured output,
4. tool calling,
5. automatizácia,
6. pomer kvalita/výkon.

---

# 4. Čo nainštalovať na Mac

| Komponent | Úloha |
|---|---|
| **Tailscale** | bezpečné spojenie so zariadeniami |
| **Ollama** | jednotné lokálne modelové API |
| **Open WebUI** | hlavné rozhranie pre e-maily, články a dokumenty |
| **Mistral Small 3.2 24B** | hlavný lokálny model |
| **Ministral 3 8B** | rýchly model zhodný s ThinkPadmi |
| **Continue** | VS Code → lokálne/MetaCentrum modely |
| **MLX voliteľne** | benchmark Apple-native inference |
| **Whisper voliteľne** | rýchle prepisy |
| **Qwen3-Coder voliteľne** | silný lokálny coding agent |

Pravidlá:

- iba jeden veľký model načítaný naraz,
- bežný kontext 8K–16K,
- obrovský kontext presunúť na MetaCentrum,
- Ollama sprístupniť iba cez Tailscale,
- Mac zostáva on-demand worker, nie povinný always-on server.

---

# 5. Čo nainštalovať na Linux ThinkPad

| Komponent | Úloha |
|---|---|
| **Tailscale** | súkromná sieť |
| **Ollama** | lokálny AI server |
| **Ministral 3 8B** | hlavný univerzálny worker |
| **Granite 4.1 3B** | structured JSON a extrakcia |
| **EmbeddingGemma** | semantické vyhľadávanie |
| **Playwright** | stabilná webová automatizácia |
| **Browser Use voliteľne** | adaptívna browser automatizácia |
| **Whisper** | prepis audia |
| **Python worker service** | prijímanie úloh od dispatchera |
| **SQLite/vector index** | lokálna znalostná báza |
| **VS Code/Continue** | Linux vývoj a malé AI úlohy |

Pravidlá:

- ťažký build a modelová inference nie súčasne,
- jeden väčší model naraz,
- dávky idú cez frontu,
- výsledky validovať pred vykonaním akcie.

---

# 6. Čo nainštalovať na Windows ThinkPad

| Komponent | Úloha |
|---|---|
| **Tailscale** | súkromná sieť |
| **Ollama natívne pre Windows** | lokálny model server |
| **Ministral 3 8B** | rovnaký worker ako na Linuxe |
| **Granite 4.1 3B voliteľne** | paralelná extrakcia |
| **Windows UI Automation** | Office a desktopové workflow |
| **WSL2** | Linux vývojový fallback |
| **Syncthing** | dátová replika podľa hlavnej architektúry |

Pravidlá:

- Ollamu nespúšťať primárne vo WSL,
- WSL má mať obmedzenú RAM,
- Linux a Windows majú používať rovnaký názov modelu a rovnakú schému requestov,
- Windows worker rieši druhú časť dávky alebo Windows-only úlohu.

---

# 7. Čo nainštalovať na Raspberry Pi

| Komponent | Úloha |
|---|---|
| **Tailscale** | spojenie zariadení |
| **Python + systemd** | scheduler a služby |
| **Device registry** | online stav a schopnosti |
| **Job queue** | fronta úloh |
| **Wake-on-LAN** | budenie ThinkPadov |
| **Health checks** | dostupnosť modelov a workerov |
| **Notification service** | chyby a dokončené úlohy |
| **Jednoduchý dashboard** | stav systému |

Pi nebude:

- prevádzkovať veľký LLM,
- ukladať modelové váhy,
- prenášať všetky veľké súbory ako proxy,
- používať LLM ako jediný mechanizmus pre bezpečnostné alebo deštruktívne rozhodnutia.

---

# 8. Ako s tým pracovať

## E-mail alebo článok

```text
Open WebUI
    ↓
Mistral Small na Macu
    ↓
návrh
    ↓
manuálna kontrola
    ↓
použitie/odoslanie
```

## Programovanie

```text
VS Code + Continue
    ↓
malá úloha → lokálny Ministral
veľká úloha → MetaCentrum
citlivá úloha → Mac lokálne
finálny review → iný model
```

## Automatizácia

```text
Python skript
    ↓
LLM API
    ↓
JSON výstup
    ↓
validácia schémy
    ↓
Playwright/UI Automation
    ↓
kontrola výsledku
```

## Extrakcia znalostí

```text
dokument
    ↓
parser
    ↓
logické segmenty
    ↓
EmbeddingGemma
    ↓
retrieval
    ↓
Granite/Mistral
    ↓
JSON + odkaz na zdroj
```

## Hromadná úloha

```text
dispatcher vytvorí frontu
    ↓
Linux worker si vezme položku
Windows worker si vezme položku
Mac si vezme náročnejšiu položku
    ↓
po dokončení si každý vezme ďalšiu
```

---

# 9. Paralelizácia

Rovnaký **Ministral 3 8B** na oboch ThinkPadoch umožní:

- identické API requesty,
- load balancing,
- paralelné spracovanie dokumentov,
- redundanciu,
- dva nezávislé názory,
- jednoduchý retry na druhom stroji.

Správne:

```text
request A → Linux
request B → Windows
request C → Mac
```

Jeden model sa nebude deliť medzi viac počítačov. Paralelizujú sa **úlohy**, nie vrstvy jedného modelu.

---

# 10. Routing pravidlá

| Situácia | Cieľ |
|---|---|
| Dá sa vyriešiť klasickým programom | skript bez LLM |
| Krátka jednoduchá úloha | voľný ThinkPad |
| JSON alebo klasifikácia | Granite na ThinkPade |
| E-mail, článok, materiál (draft) | Mistral Small na Macu |
| Screenshot alebo vision | Mac |
| Veľké kódovanie | MetaCentrum |
| Mac nedostupný | Ministral na ThinkPade |
| Veľká dávka | oba ThinkPady + Mac |
| Kritická operácia (mazanie, platba, publikovanie) | manuálne potvrdenie |

## Cloud gate — kedy ísť na Claude/GPT/Gemini namiesto lokálneho modelu

Cloud je **fallback po zlyhaní alebo pred finálnym krokom**, nie default. Explicitné triggery (nahrádzajú vágne "nedostatočná kvalita"):

| Trigger | Príklad |
|---|---|
| **Finálny review pred odoslaním/publikovaním** | e-mail klientovi, článok pred submitom, konferenčné materiály |
| **Lokálny model preukázateľne zlyhal** | Mistral/Ministral dal nekonzistentný alebo vecne chybný výstup na overiteľnej úlohe |
| **Komplexný reasoning nad rámec lokálnej kapacity** | viacstupňový dôkaz, návrh architektúry, cross-document syntéza, kde 24B model viditeľne stráca niť |
| **Výstup smeruje k tretej strane bez možnosti opravy** | oficiálny dokument, submission, niečo čo nejde vziať späť |

Všetko ostatné (draft, extrakcia, klasifikácia, interná komunikácia, RAG, batch spracovanie) ostáva lokálne **bez ohľadu na citlivosť dát** — to nahrádza pôvodné pravidlo "citlivé dáta → lokálne zariadenie", ktoré je teraz dôsledok, nie samostatný trigger.

**Anti-pattern:** volať cloud preventívne "pre istotu". Ak lokálny výstup nebol explicitne testovaný/porovnaný a nezlyhal, zostáva lokálne.

---

# 11. Bezpečnosť

- používať Tailscale MagicDNS namiesto bežných LAN IP,
- žiadny verejný port forwarding,
- Ollama API povoliť iba cez Tailscale/firewall,
- nevkladať heslá, SSH kľúče ani tokeny do promptu,
- citlivé prompty neukladať do spoločných logov,
- mazanie, platba, publikovanie a odoslanie vyžadujú potvrdenie,
- model iba navrhuje; deterministický nástroj validuje a vykonáva,
- každý worker má zoznam povolených nástrojov a adresárov.

---

# 12. Poradie implementácie

## Fáza 1 – modely samostatne

1. Tailscale na všetky zariadenia.
2. Ollama na Mac a oba ThinkPady.
3. Ministral 3 8B na oba ThinkPady.
4. Mistral Small 3.2 na Mac.
5. Zmerať rýchlosť, RAM a kvalitu.

## Fáza 2 – spoločné používanie

1. Bezpečný remote Ollama prístup cez Tailscale.
2. Open WebUI pripojené k Macu.
3. Continue pripojené k MetaCentru a lokálnym endpointom.
4. Otestovať fallback medzi zariadeniami.

## Fáza 3 – workeri

1. Jednoduchý Python dispatcher.
2. Linux a Windows endpoint.
3. Dynamická fronta.
4. Timeout, retry a validácia.
5. Presun dispatchera na Pi.

## Fáza 4 – znalostná báza

1. Parsery.
2. EmbeddingGemma.
3. Lokálny index.
4. Retrieval.
5. Odpoveď s citáciou zdroja.

## Fáza 5 – automatizácia

1. Jeden stabilný Playwright workflow.
2. JSON výstup z modelu.
3. Validácia.
4. Potvrdenie rizikovej akcie.
5. Až potom adaptívny browser agent.

---

# 13. Čo zatiaľ neinštalovať

- veľa podobných modelov bez A/B testu,
- 70B model na Mac v extrémne nízkej kvantizácii,
- veľký lokálny coding model, pokiaľ funguje MetaCentrum,
- LLM na Raspberry Pi,
- Kubernetes alebo komplikovaný cluster,
- distribuovanú inferenciu jedného modelu medzi notebookmi,
- autonómneho agenta s právom mazať, publikovať alebo platiť,
- veľkú vektorovú databázu pred overením potreby.

---

# 14. Finálny návrh

| Zariadenie | Hlavný model/nástroj | Hlavná práca |
|---|---|---|
| **Mac M5 32 GB** | Mistral Small 3.2 24B | e-maily, články, materiály, vision, syntéza |
| **Linux ThinkPad** | Ministral 3 8B + Granite 3B | automatizácia, RAG, extrakcia, Linux worker |
| **Windows ThinkPad** | Ministral 3 8B | paralelný worker, Office, Windows automatizácia |
| **Raspberry Pi** | Python scheduler | routing, queue, Wake-on-LAN, monitoring |
| **MetaCentrum** | dostupný veľký LLM | hlavné programovanie a veľký kontext |
| **Cloud** | GPT/Claude/Gemini | najvyššia kvalita a finálna kontrola |

```text
Mistral Small na Macu = hlavný lokálny asistent
Ministral na ThinkPadoch = identickí paralelní workeri
Granite = structured extraction
EmbeddingGemma = lokálne vyhľadávanie
MetaCentrum = veľké kódovanie
Raspberry Pi = koordinácia
```

---

# 15. Referenčné zdroje

- [Mistral Small 3.2 v Ollame](https://ollama.com/library/mistral-small3.2)
- [Ministral 3 v Ollame](https://ollama.com/library/ministral-3)
- [Granite 4.1 v Ollame](https://ollama.com/library/granite4.1)
- [EmbeddingGemma v Ollame](https://ollama.com/library/embeddinggemma)
- [Qwen3-Coder v Ollame](https://ollama.com/library/qwen3-coder)
- [Ollama API](https://docs.ollama.com/api/introduction)
- [Open WebUI](https://docs.openwebui.com/)
- [Continue s Ollamou](https://docs.continue.dev/guides/ollama-guide)
- [Playwright](https://playwright.dev/docs/intro)
- [Browser Use](https://docs.browser-use.com/)
- [OpenAI Whisper](https://github.com/openai/whisper)
- [Tailscale](https://tailscale.com/docs/how-to/quickstart)

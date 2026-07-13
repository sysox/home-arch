# Kategórie činností — podklad pre mapovanie softvéru

**Stav:** katalóg činností a požadovaných schopností softvéru. Nejde o finálny zoznam produktov ani o implementačný plán — konkrétne názvy sa uvádzajú len tam, kde už boli reálne zvolené alebo slúžia ako príklad kandidáta.

**Stavové značky** (len pri konkrétnych/rozhodujúcich položkách): *Používané* / *Rozhodnuté* / *Plánované* / *Voliteľné*.

**Princíp duplicity:** viaceré kategórie zdieľajú tie isté schopnosti (kalendár, poznámky, task manager, zdieľanie súborov, komunikácia, prezentovanie, AI, synchronizácia, backup). Každá má **jednu hlavnú kategóriu**, kde je definovaná, inde sa objavuje len ako **cross-link**:
- kalendár → primárne kat. 9
- komunikácia → primárne kat. 15
- súbory a metadata → primárne kat. 17
- bezpečnosť a recovery → primárne kat. 16
- AI workflow → primárne kat. 27
- vlastné aplikácie → primárne kat. 24
- prezentovanie/vizuál → primárne kat. 5

---

## 1. Výskum (matematika, kryptografia, príp. iné oblasti)

**Štúdium**
- čítanie článkov a kníh — extrakcia myšlienok, osobné poznámky, AI poznámky
- prednášky, podcasty, kurzy a iný odborný obsah
- sledovanie nových prác, autorov, citácií a tém (Google Scholar, IACR ePrint, arXiv, DBLP, konferencie)
- → SW: PDF reader/anotátor, reference manager, RSS/alert sledovanie feedov; poznámky → kat. 6

**Hodnotenie**
- posudzovanie článkov, grantov, technických správ a projektov
- kontrola novosti, významu, správnosti, dôkazov, experimentov, kódu, dát a reprodukovateľnosti
- → SW: PDF anotátor, reference manager, prostredie na spustenie/overenie cudzieho kódu (rovnaké ako pri vývoji softvéru, kat. 2)

**Tvorba myšlienok**
- formulácia problémov, výskumných otázok a hypotéz
- hľadanie súvislostí, otvorených problémov, nových metód, konštrukcií, algoritmov a útokov
- → SW: mind-mapping nástroj; poznámky → kat. 6

**Teoretická práca**
- matematické výpočty, modelovanie
- dôkazy, protidôkazy, príklady
- bezpečnostná analýza, korektnosť, zložitosť
- → SW: LaTeX sadzba, symbolický počítačový systém (CAS); poznámky s matematickou notáciou → kat. 6

**Experimentálna práca**
- návrh experimentov, prototypy, implementácia
- reprodukcia cudzích výsledkov
- benchmarky, spracovanie a interpretácia výsledkov
- → SW: notebook prostredie (Jupyter a pod.), programovací jazyk/knižnice, nástroj na vizualizáciu dát; verzovanie → kat. 2

**Písanie**
- články, technické správy, abstrakty, related work
- dokumentácia výsledkov
- iteratívne úpravy a review vlastných draftov
- → SW: LaTeX/textový editor, reference manager; verzovanie textu → kat. 2

**Publikačný proces**
- výber venue, submission, rebuttal
- zapracovanie pripomienok, camera-ready verzia, supplementary materials
- artefakty a evidencia publikácií
- → SW: submission systém konferencie/časopisu (web), LaTeX, archív publikácií (napr. BibTeX databáza)

**Spolupráca**
- diskusie, konzultácie, spoločné riešenie problémov
- zdieľanie článkov, poznámok, kódu a výsledkov
- koordinácia spoluautorov
- → SW: zdieľaný repozitár/cloud úložisko; komunikácia → kat. 15

**Organizácia výskumu**
- evidencia zdrojov, poznámok, nápadov, experimentov, rozhodnutí
- sledovanie úloh, termínov a stavu jednotlivých výskumných smerov
- → SW: poznámky → kat. 6; úlohy a kalendár → kat. 9

**Prezentovanie výsledkov**
- interné semináre, konferenčné prezentácie, postery, demonštrácie, popularizačné vysvetlenia
- → SW: tvorba slajdov/diagramov/grafov → kat. 5

**Dátová správa**
- datasety — tvorba, uchovávanie, verzovanie
- licencovanie a zdieľanie (open data, FAIR princípy)
- prepojenie dát s publikovanými výsledkami
- → SW: dátové úložisko s verzovaním (git-lfs/DVC), dátový repozitár na zverejnenie (napr. Zenodo-typ služby)

**Konferenčná/komunitná služba**
- členstvo v program committee, organizovanie workshopov a konferencií, review pre časopisy ako inštitucionálna rola
- → SW: konferenčný review systém (EasyChair/HotCRP-typ); kalendár → kat. 9, email → kat. 15

**Akademický profil a branding**
- ORCID, Google Scholar — správa profilu, kontrola spárovania publikácií
- Scopus, IACR profil *(Voliteľné — nie sú momentálne aktívne spravované)*
- LinkedIn *(Voliteľné — zatiaľ nie pevne rozhodnutý plán)*
- osobná webstránka *(zatiaľ nie)*
- → SW: webové profily/dashboardy databáz

---

## 2. Vývoj softvéru

**Návrh**
- požiadavky, architektúra, dátové modely, API
- bezpečnostné vlastnosti
- výber technológií a rozdelenie systému na komponenty
- → SW: diagramovací nástroj, plain-text/markdown editor pre špecifikácie

**Implementácia**
- písanie kódu v C, Pythone a shelli
- prototypy, knižnice, nástroje, skripty
- integrácia existujúcich komponentov
- → SW: editor/IDE, kompilátor a interpreter (C, Python, shell), správca balíkov/závislostí

**Debugging**
- hľadanie chýb, analýza logov, reprodukcia problémov
- ladenie výkonu, pamäte, súbehu a sieťovej komunikácie
- → SW: debugger (gdb/pdb), profiler (pamäť/CPU), log viewer/analyzátor, sieťový sniffer

**Testovanie**
- unit, integračné, regresné a property-based testy
- fuzzing, testovacie vektory, negatívne testy
- overovanie kryptografických implementácií
- → SW: testovací framework (pytest a pod.), fuzzing nástroj, test-vector generátor/validátor, CI runner testov

**Hodnotenie kódu**
- code review vlastného a cudzieho kódu
- kontrola správnosti, bezpečnosti, čitateľnosti, výkonu a udržiavateľnosti
- → SW: code review nástroj (v rámci git platformy), statický analyzátor/linter

**Verzovanie a Git workflow**
- git, branche, commity, pull requesty, issues; riešenie konfliktov a koordinácia vývoja
- **Gitea** — súkromný/lokálny Git hosting *(Rozhodnuté, beh na Pi → kat. 7)*
- **GitHub** — verejný remote a platforma pre spoluprácu *(Používané)*
- možnosť viacerých Git remotes súčasne (lokálny + verejný)
- ochrana lokálnych commitov pred stratou
- oddelenie zdrojového kódu od Syncthing synchronizácie — Git rieši verzovanie kódu, Syncthing nie je náhrada
- → SW: git klient, diff/merge nástroj

**Build a nasadenie**
- správa závislostí, prostredí, buildov, balíkov, kontajnerov
- CI/CD, releasy, nasadenie na zariadenia alebo servery
- → SW: build systém (make/CMake a pod.), kontajnerizácia (Docker), CI/CD platforma

**Dokumentácia**
- README, používateľská dokumentácia, dokumentácia architektúry/kódu/API
- príklady použitia a záznam rozhodnutí
- → SW: markdown editor, generátor dokumentácie z kódu

**Údržba**
- opravy chýb, aktualizácie závislostí, refaktoring, migrácie, spätná kompatibilita, technický dlh, archivácia projektov
- → SW: dependency-tracking nástroj, issue tracker

**AI podpora vývoja**
- AI coding assistant — generovanie a review kódu
- promptové profily používané špecificky pri vývoji
- integrácia AI do vývojového workflow (napr. inline návrhy, code review asistencia)
- *(Všeobecná lokálna AI infraštruktúra a výber modelu podľa úlohy → kat. 27)*
- → SW: AI coding asistent, formatter/linter

**Platformy a typy aplikácií**
- aktuálny cieľ: **osobné aplikácie**, klient najmä **iPhone**, backend na **Raspberry Pi** alebo inom vlastnom zariadení *(Rozhodnuté smerovanie)*
- **bez potreby verejnej App Store distribúcie** v prvej fáze
- desktopové aplikácie (Linux, Windows, macOS), CLI nástroje, knižnice, serverové/backendové aplikácie
- *Voliteľné/budúce:* Android klient, verejné store vydanie (App Store/Google Play), telemetry a crash reporting, rozsiahle multi-platform CI, cross-platform frameworky (Flutter/Qt/Electron/React Native)
- → SW: pre osobné použitie stačí Xcode dev build + fyzické zariadenie; store-level nástroje len pri rozhodnutí pre verejnú distribúciu

---

## 3. Písanie a editácia textu

- akademický text (papers, dokumentácia)
- korešpondencia (email → kat. 15)
- preklad SK/CZ/EN
- štylistická/gramatická úprava
- aktívne učenie sa angličtiny — slovná zásoba, frázy, výnimky *(Plánovaná appka → kat. 24)*
- → SW: textový/LaTeX editor, prekladový nástroj, grammar/style checker

---

## 4. Výučba a vzdelávacie materiály

- príprava seminárov/prednášok
- tvorba zadaní a riešení, **tvorba personalizovaných variantov zadaní**
- **generovanie testovacích dát a kryptografických inštancií**
- hodnotenie zadaní/skúšok, **automatické hodnotenie a testovanie riešení**
- detekcia plagiátorstva / testovanie podobnosti riešení
- tvorba testovacích otázok a variantov
- **serverové výučbové utility, kryptografické a sieťové laboratóriá**
- **správa TLS/network capture zadaní**
- **evidencia pokusov, výsledkov a bodov (per študent/zadanie)**
- **AI tutor s postupnými nápovedami**
- **oneskorené sprístupnenie riešenia** (časovo podmienené)
- **kontrola, že automaticky generované zadanie má jednoznačné riešenie**
- **správa veľkých VM, PCAP a dátových súborov pre študentov**
- konzultácie so študentmi
- vedenie a oponovanie záverečných prác (bc/mgr/PhD)
- → SW: LMS/študijný informačný systém, nástroj na tvorbu materiálov, plagiarism/similarity checker (aj pre kód), testovacie/laboratórne prostredie na generovanie inštancií; kalendár na konzultácie → kat. 9

---

## 5. Prezentovanie / vizuálna komunikácia

*(Primárna kategória pre slajdy, diagramy a grafy — ostatné kategórie sem cross-linkujú.)*

- slajdy pre konferencie/výučbu
- diagramy (TikZ, SVG)
- grafy z dát/experimentov
- poster tvorba (konferencie)
- → SW: prezentačný nástroj (Beamer/PowerPoint/Keynote-typ), vektorový/diagramový editor, plotting knižnica, poster/veľkoformátový layout nástroj

---

## 6. Správa znalostí a dokumentov

*(Primárna kategória pre poznámky/PKM — ostatné kategórie sem cross-linkujú.)*

- organizácia poznámok a referencií
- knowledge base / ontológie
- vyhľadávanie vo vlastnom archíve
- správa bibliografie/citácií (BibTeX a pod.)
- **AI-IR a AI-optimalizovaná reprezentácia dokumentov**
- **extrakcia entít, tvrdení a vzťahov**
- **ontológie a knowledge representation**
- **provenance každej informácie** — odkiaľ pochádza
- **väzba medzi textovou podobou dokumentu a jeho významovou reprezentáciou**
- **porovnávanie alternatívnych reprezentácií** toho istého obsahu
- **meranie, či možno z reprezentácie rekonštruovať text, význam alebo odpoveď na otázku**
- **RAG — výber iba relevantných častí dokumentu** pri dopyte
- **archivácia a prepájanie AI konverzácií s projektmi a dokumentmi** *(detail → kat. 26)*
- → SW: PKM/poznámkový nástroj, reference manager, lokálny full-text/sémantický vyhľadávač, embedding/RAG vrstva

*(Poznámka: praktické operácie so súbormi ako také — kopírovanie, konverzia, deduplikácia — sú v kategórii 17.)*

---

## 7. Systémová a infraštruktúrna administrácia

**Základná správa**
- správa zariadení (Mac/ThinkPady/Pi)
- sieť, TLS/security testovanie
- **Tailscale** — privátna sieťová vrstva *(Rozhodnuté)*
- → SW: konfiguračný/monitoring nástroj, sieťový/TLS scanner (nmap, testssl.sh)

**Vzdialený prístup**
- SSH prístup k vlastným počítačom
- **SSH a VS Code Remote SSH** *(Používané)* — kód sa píše lokálne, beží/debuguje sa na vzdialenom stroji
- **Remmina** — klient vzdialenej plochy na Linuxe *(Rozhodnuté/kandidát)*
- prenos súborov medzi zariadeniami, vzdialené spúšťanie príkazov a aktualizácií
- **Wake-on-LAN**
- prístup k zariadeniam za NAT/firewallom (cez Tailscale)
- núdzový prístup pri nefunkčnom hlavnom zariadení
- → SW: SSH klient/agent, Tailscale, remote desktop nástroj, WoL utilita

**Vzdialená podpora rodičov**
- jednorazové pripojenie so súhlasom používateľa vs. trvalý spravovaný prístup
- zdieľanie obrazovky + klávesnica/myš, hlasová/video komunikácia počas podpory
- odosielanie súborov, reštart a opätovné pripojenie, evidencia vykonaných zásahov
- bezpečné oddelenie osobných a administrátorských účtov
- → SW: remote support nástroj, video/hlasový nástroj popri tom

**Vlastný server na Raspberry Pi**
- **Gitea** na Pi alebo inom vlastnom serveri *(Rozhodnuté/plánované → kat. 2)*
- **externý USB SSD** pre Raspberry Pi (úložná kapacita)
- → SW: Gitea, úložisko/RAID podľa potreby

**Virtuálne prostredia**
- virtuálne stroje, kontajnery
- testovacie Linux/Windows prostredia, izolované prostredia na cudzie projekty
- snapshoty a návrat k predchádzajúcemu stavu
- → SW: hypervisor/VM nástroj, Docker/kontajnerizácia

**Backup a obnoviteľnosť**
- **versioned backup pomocou štandardného backup nástroja** — nie Syncthing/rsync (tie nie sú plnohodnotný backup, chýba im história verzií/retencia)
- obnoviteľná konfigurácia zariadení pomocou skriptov a dotfiles
- **inventár nainštalovaných aplikácií a schopností jednotlivých zariadení**
- obnova pracovného prostredia po čistej inštalácii
- → SW: versioned backup nástroj, package manager, dotfiles/config-sync nástroj

**Sieťová hygiena** *(Voliteľné, budúce)*
- blokovanie reklám a telemetrie na úrovni siete (Pi-hole/AdGuard Home)
- izolácia IoT zariadení do samostatnej VLAN — všeobecná bezpečnostná prax, nie špecificky kvôli konkrétnemu zariadeniu

**Kontinuita práce naprieč zariadeniami**
- priradenie činností a projektov k vhodným zariadeniam
- otvorenie rovnakého pracovného kontextu na inom počítači, pokračovanie rozpracovanej úlohy
- synchronizácia repozitárov (Git, nie Syncthing), dokumentov, konfigurácií, clipboardu
- vzdialené spúšťanie aplikácií a výpočtov
- evidencia posledného pracovného stavu *(detail metadát → kat. 17)*
- spoločné dotfiles, editorové a terminálové nastavenia
- → SW: Syncthing (pre dáta, nie kód), dotfiles manager, Tailscale/SSH, monitoring a launcher pracovných kontextov

---

## 8. Automatizácia opakovaných úloh

- skriptovanie
- scheduling/cron úlohy
- automatizácia práce na vzdialených zariadeniach
- automatické spúšťanie úloh podľa dostupnosti počítača
- presun výpočtov medzi Mac, Linux, Windows, Pi a MetaCentrom
- automatické zálohovanie pred aktualizáciou
- automatická kontrola stavu zariadení, notifikácie pri chybe/výpadku/dokončení výpočtu
- automatická synchronizácia konfigurácií
- automatické spracovanie dokumentov, emailov a príloh
- automatické vytváranie reportov
- browser automation pre služby bez API
- *(orchestrácia viacerých AI modelov/nástrojov → kat. 27)*
- → SW: shell/scripting jazyk, cron/task scheduler, notifikačný nástroj → kat. 26, browser automation (Playwright/Browser Use)

---

## 9. Osobná organizácia, projekty a time management

*(Jadro budúceho osobného systému. Primárna kategória pre kalendár a task manager.)*

**Úlohy a projekty**
- evidencia projektov, úloh, podúloh, priorít, závislostí a stavu rozpracovanosti
- **"next action"** pre každý aktívny projekt
- rozlíšenie aktívnych, čakajúcich, pozastavených a ukončených projektov
- prepojenie úloh s dokumentmi, emailmi, kontaktmi, kalendárom a výskumnými témami
- → SW: task/project manager s podporou závislostí a stavov

**Kalendár a plánovanie času**
- udalosti, stretnutia, termíny a pripomienky
- plánovanie blokov práce (**time blocking**) pre výskum, výučbu, vývoj, administratívu a osobné aktivity
- koordinácia viacerých kalendárov a rolí
- **plán verzus skutočne využitý čas**
- ochrana sústredeného času a riešenie konfliktov
- → SW: kalendár s podporou viacerých kalendárov/rolí *(existujúci kalendár je autoritatívny systém pre udalosti a stretnutia — pozri architektonickú poznámku nižšie)*

**Riadenie pozornosti**
- výber ďalšej činnosti podľa priority, termínu, energie, dostupného času a zariadenia
- obmedzenie množstva paralelne rozpracovaných projektov
- denné, týždenné a dlhodobejšie review a retrospektíva
- **časová bilancia medzi výskumom, výučbou, administratívou a osobným životom**
- **zachytenie prerušenej práce a možnosť pokračovať na inom zariadení** *(detail → kat. 7, 17)*
- → SW: task manager s prioritizáciou, review nástroj

**Architektonická poznámka**
- **existujúci kalendár = autoritatívny systém pre udalosti a stretnutia** — vlastná appka ho integruje, nenahrádza
- **vlastná appka môže byť autoritatívna pre projekty, úlohy, priority, časové bloky a pracovné kontexty** *(→ kat. 24)*

---

## 10. Grantová a fakultná administratíva

- písanie grantových žiadostí
- výkazníctvo a reporting (priebežné/záverečné správy)
- rozpočtovanie projektu
- sledovanie termínov (call deadlines, milestones)
- komunikácia s grantovou agentúrou/rektorátom
- *(grantové zmluvy → kat. 20; kalendár termínov → kat. 9; email → kat. 15)*
- → SW: textový editor/šablóny žiadostí, tabuľkový nástroj (rozpočet)

---

## 11. Cestovanie

- plánovanie ciest (trasa, doprava, ubytovanie)
- história navštívených miest
- watchlist miest na videnie (per destinácia) *(prepojenie na appku → kat. 24)*
- konferenčné cestovanie (práca + voľný čas)
- praktická logistika (víza, poistenie, packing)
- auto: poistenie (PZP/Kasko), termíny STK/EK
- → SW: mapová/plánovacia aplikácia, travel-tracker; termíny/pripomienky → kat. 9

*(Cross-link: plánovanie hiking/bicyklových trás sa prelína s kategóriou 21 — trasa sa naplánuje na počítači/mobile a nahrá do hodiniek na navigáciu.)*

---

## 12. Životné plánovanie (všeobecne)

- osobné/rodinné plány a ciele
- časová bilancia naprieč rolami *(operatívna stránka → kat. 9; toto je skôr dlhodobý/cieľový pohľad)*
- rozhodovanie o väčších životných krokoch
- → SW: poznámkový nástroj na ciele/rozhodnutia → kat. 6, 26; kalendár → kat. 9

---

## 13. Správa majetku

- hnuteľný/nehnuteľný majetok — evidencia, poistenie, údržba
- domácnosť/vybavenie
- *(zmluvy, záruky → kat. 20; termíny revízií → kat. 9)*
- → SW: evidenčný nástroj/tabuľka

---

## 14. Financie

- bežné financie/rozpočet
- **BTC/krypto — držba, portfolio, self-custody, bezpečnosť a recovery** *(nie automatizované obchodovanie — to je mimo rozsahu)*
- fondy/investície — sledovanie výkonnosti, rebalancing
- daňová agenda
- náklady na predplatné (cloud, AI služby, servery, domény/hosting), porovnanie produktov a hardvéru
- faktúry, reklamácie, záruky (finančná stránka)
- → SW: rozpočtový/bankingový nástroj, krypto wallet + portfolio tracker (hardvérová peňaženka pre self-custody → kat. 16), investičný tracker, daňový softvér

---

## 15. Komunikácia a spolupráca

*(Primárna kategória pre komunikáciu — ostatné kategórie sem cross-linkujú.)*

- email, chat a instant messaging, videohovory, zdieľanie obrazovky
- plánovanie stretnutí *(kalendár → kat. 9)*, spoločná editácia dokumentov, zdieľanie súborov
- zápisnice a poznámky zo stretnutí, automatický prepis a sumarizácia hovorov
- oddelenie pracovnej, fakultnej a súkromnej komunikácie
- komunikácia so študentmi, kolegami, spoluautormi a rodinou
- **kontakty a vzťahy**: adresár, história dôležitej komunikácie, poznámky ku kontaktom, follow-up pripomienky, evidencia spoluprác
- → SW: emailový klient, chat, videokonferencie, zdieľané dokumenty, správca kontaktov

---

## 16. Bezpečnosť, identita a kontinuita

*(Primárna kategória pre bezpečnosť a recovery.)*

**Rozlíšenie typov tajomstiev**
- autentizačné tajomstvá (heslá, TOTP, passkeys)
- šifrovacie tajomstvá (kľúče na šifrovanie dát/diskov)
- recovery artefakty (recovery codes, shares)
- trust providers (osoby/inštitúcie, ktoré overujú/schvaľujú obnovu)
- secret providers (kde tajomstvo reálne sídli)

**Prevencia a každodenná bezpečnosť**
- **KeePassXC** alebo zodpovedajúci password manager *(Rozhodnuté/kandidát)*
- **2× YubiKey** *(Používané)*
- **passkeys/FIDO2**
- **TOTP ako fallback** (nie primárny mechanizmus)
- SSH kľúče, PGP/GPG, certifikáty
- **diskové šifrovanie na prenosných zariadeniach**
- **oddelenie bežného a administrátorského účtu**
- API tokeny a secrets, licenčné kľúče a developer účty
- audit účtov a prístupov, kontrola kompromitovaných hesiel
- **Tailscale nie je jediná bezpečnostná hranica** — citlivé služby majú mať vlastnú autentizáciu a oprávnenia

**Obnova a kontinuita**
- **recovery codes**
- **distribuovaný/social recovery systém** *(vlastný výskumný projekt — priama väzba)*
- **deterministické odvodzovanie tajomstiev**
- **oddelenie Recovery Key a Vault Key**
- incident response pri strate zariadenia alebo účtu
- krízové scenáre: strata/krádež počítača, telefónu alebo YubiKey, poškodenie disku, kompromitácia účtu, výpadok internetu/Pi/hlavného PC
- obnova po čistej inštalácii
- núdzový prístup rodiny k dôležitým dokumentom
- **testovanie obnovy** — pravidelný "dril"
- → SW: password manager, YubiKey nástroje, SSH agent, GPG, secrets manager, versioned backup → kat. 7, offline trezor

**Digitálna hygiena a audit**
- čistenie starých/nepoužívaných účtov
- sledovanie expirácie domén a SSL certifikátov
- → SW: doménový/certifikátový monitoring

---

## 17. Správa dát, súborov, metadát a formátov

*(Primárna kategória pre súbory a metadata.)*

**Vrstva 1 — automaticky odvodený inventár** *(vždy rekonštruovateľné skenovaním)*
- názov, cesta, veľkosť, čas zmeny
- zariadenie alebo úložisko, prípadne hash

**Vrstva 2 — autoritatívne používateľské metadata** *(nie odvoditeľné, musia byť explicitne uložené)*
- stabilné ID nezávislé od cesty k súboru
- projekt, téma, osoby, publikácia, predmet, experiment
- autoritatívna verzia, pracovná kópia, generovaný výstup
- klasifikácia citlivosti a prístupových práv
- životný cyklus súboru
- **provenance a závislosti** — z čoho bol súbor vytvorený a čo z neho vzniklo
- používateľské tagy a komentáre
- **evidencia, na ktorom zariadení je posledný pracovný stav**
- **prepojenie súboru s Git repozitárom, úlohou, emailom alebo AI konverzáciou**
- **detekcia presunutých a premenovaných súborov**
- **mapovanie súborov naprieč Macom, Linuxom, Windowsom a Pi**

*(SQLite alebo iný index je odvodená vyhľadávacia vrstva nad vrstvou 2, nie náhrada za ňu. Autoritatívne metadata majú byť exportovateľné do otvoreného formátu.)*

**Operácie so súbormi**
- organizácia adresárovej štruktúry, pomenovanie a verzovanie súborov
- konverzia formátov, kompresia a archivácia, deduplikácia
- kontrolné súčty a integrita dát, hromadné premenovanie
- zdieľanie veľkých súborov, šifrovaný prenos súborov
- práca s PDF, DOCX, XLSX, obrázkami a videom
- synchronizácia a riešenie konfliktov, dlhodobá archivácia
- → SW: file manager, rsync/rclone, archivačný nástroj, konvertory

**Vyhľadávanie**
- vyhľadávanie podľa názvu, textového obsahu, typu, dátumu, projektu a vlastných metadát
- fulltextové a sémantické vyhľadávanie naprieč zariadeniami a archívmi
- → SW: fulltextový indexer, sémantický vyhľadávač

**Dátový katalóg**
- spoločná evidencia dokumentov, datasetov, repozitárov, experimentov a mediálnych súborov
- stabilné identifikátory nezávislé od cesty k súboru
- export metadát do otvoreného formátu
- → SW: checksum/dedup nástroje, vlastná databáza katalógu → kat. 24

---

## 18. Médiá a multimédiá

- fotografia a organizácia fotografií
- skenovanie dokumentov, OCR
- audio nahrávky, prepis hovoreného slova, nahrávanie prednášok
- strih audia a videa
- snímanie obrazovky, tvorba screenshotov a anotácií
- správa obrázkov použitých v prezentáciách, licencia a pôvod médií
- dlhodobé uloženie osobného archívu
- → SW: správca fotografií, OCR, Whisper, audio/video editor, screenshot nástroj

---

## 19. Mobilné zariadenia

- backup a synchronizácia
- **Find My alebo ekvivalent**
- vzdialené vymazanie strateného zariadenia
- synchronizácia kontaktov, kalendára a fotografií
- MFA a bezpečnostné aplikácie
- testovanie vlastných aplikácií
- **prístup k službám na Pi** (klient)
- správa SIM/eSIM, roamingu a dát
- *(iPhone nie je autoritatívne úložisko — môže používať lokálnu cache a offline dáta; autoritatívne systémy → kat. 17, 24)*
- → SW: mobilný backup/sync, developer tools

---

## 20. Právna, zmluvná a licenčná agenda

- pracovné a grantové zmluvy, NDA
- licencie softvéru, open-source licencie, licencie datasetov
- autorské práva, licencie obrázkov a materiálov
- privacy policy a podmienky aplikácií, GDPR pri výskume a výučbe
- zmluvy k majetku — nehnuteľnosti, poistenie, záruky
- archivácia podpísaných dokumentov, elektronické podpisovanie
- sledovanie lehôt a povinností
- → SW: digitálny trezor dokumentov, elektronický podpis; termíny → kat. 9

---

## 21. Zdravie a fitness

- hmotnosť, kalorický príjem a výdaj, **chudnutie**, kalorický deficit
- spánok a regenerácia
- zdravotné termíny a dokumenty
- **bicykel, chôdza, turistika, korčule** — vzdialenosť, čas, tempo, prevýšenie
- **dlhodobé trendy**
- Garmin Connect sync, HRV, offline topo mapy, navigácia v hodinkách *(Voliteľné — uviesť len ak reálne používané/podporované konkrétnymi hodinkami)*
- → SW: nutričný/kalorický tracker, tracker aktivít (podľa reálne vlastnených hodiniek), nástroj na import trás (GPX)

---

## 22. Rodina a domácnosť

- spoločný kalendár *(→ kat. 9)*
- vzdialená IT pomoc rodičom *(→ kat. 7)*
- rodinné dokumenty
- nákupy a údržba domácnosti
- zdieľanie fotografií a súborov
- núdzové kontakty a recovery *(→ kat. 16)*
- → SW: zdieľaný kalendár, cloud fotoalbum

---

## 23. Koníčky a voľný čas

- turistika, cyklistika, cestovanie
- knihy, filmy, hudba a hry
- watchlist aktivít a miest *(→ kat. 24)*
- osobné projekty
- evidencia vybavenia
- → SW: poznámkový/watchlist nástroj

---

## 24. Osobný informačný systém a vlastné aplikácie

*(Primárna kategória pre vlastné aplikácie.)*

**Jadro osobného informačného systému** *(vlastná appka je tu autoritatívna)*
- projekty, úlohy, priority, pracovné kontexty
- time blocking
- metadata a prepojenia súborov *(→ kat. 17)*
- spoločné vyhľadávanie naprieč osobnými dátami

**Externé autoritatívne systémy** *(appka ich integruje, nenahrádza)*
- kalendár *(→ kat. 9)*
- email *(→ kat. 15)*
- Git *(→ kat. 2)*
- reálne súborové úložiská *(→ kat. 17)*
- bibliografia/reference manager *(→ kat. 1, 6)*
- password manager *(→ kat. 16)*

**Aktuálne plánované aplikácie** *(nie nutne jedna monolitická appka — môžu zdieľať dátový model/backend, mať samostatné rozhrania)*
- time management a osobný informačný systém *(jadro)*
- katalóg súborov a metadát
- učenie sa angličtiny
- watchlist a navigácia k zaujímavým miestam
- reprezentácia a vysvetľovanie dát

**Spoločné technické požiadavky**
- spoločný dátový model, import/export otvorených formátov
- offline režim a následná synchronizácia
- ochrana citlivých údajov, šifrovanie a recovery *(→ kat. 16)*
- audit zmien, návrat k staršej verzii
- AI rozhranie nad vlastnými dátami s kontrolovaným prístupom
- → SW: vlastné desktopové/mobilné aplikácie, lokálna databáza, sync vrstva, API a integračné konektory

---

## 25. Zachytávanie a spracovanie informačných vstupov

- rýchle zachytenie myšlienky z mobilu
- hlasový vstup, screenshot, PDF, webový odkaz
- AI konverzácia, email, správa od študenta alebo kolegu
- ukladanie článkov, videí, podcastov na neskoršie spracovanie
- vytvorenie úlohy, poznámky, udalosti alebo referencie zo vstupu
- jednotný alebo rozdelený inbox pre nové podnety
- automatická extrakcia termínov a osôb
- deduplikácia a prepájanie s už existujúcimi informáciami
- rozhodnutie: spracovať, naplánovať, delegovať, archivovať alebo zmazať
- pravidelné spracovanie inboxu
- → SW: capture aplikácia, web clipper, mobilný inbox, OCR/speech-to-text, emailové pravidlá

---

## 26. Rozhodovací denník, logy a drobná evidencia

- **browser a web research management** — záložky, tab groups, uložené sessions, research tabs, prepojenie webového zdroja s projektom
- **AI konverzácie a výstupy (multi-provider)**:
  - archív významných **GPT, Claude a Gemini** konverzácií
  - export konverzácií do Markdownu alebo JSON
  - prepojenie konverzácie s projektom
  - extrakcia rozhodnutí, promptov a výsledkov
  - porovnanie výstupov modelov
- **pracovný kontext** — projekt, posledný dokument, Git branch, posledný experiment, ďalší krok, zariadenie, na ktorom bola práca rozpracovaná
- **časové a systémové logy** — na ktorom projekte/zariadení sa pracovalo; nesmie byť invazívne, cieľ je rekonštrukcia práce a porovnanie plánu so skutočnosťou (nie sledovanie)
- **notifikácie** — pravidlá, čo vyruší okamžite, čo ide do denného súhrnu, čo sa potlačí
- **rozhodovací denník** — významné technické, výskumné, finančné a životné rozhodnutia vrátane dôvodov a neskoršieho vyhodnotenia
- **tlač, skenovanie a fyzické dokumenty** — scanner/printer workflow, OCR, zaradenie originálu a digitálnej kópie
- **inventár služieb a závislostí** — ktoré workflow závisí od ktorého účtu, programu, zariadenia alebo cloudovej služby
- → SW: bookmark/tab manager, archív AI konverzácií, log/monitoring nástroj, notifikačný systém, scanner app

---

## 27. AI workflow — voľba nástroja a proces

*(Primárna kategória pre AI infraštruktúru a rozhodovanie. Provider-neutrálne — žiadny poskytovateľ nie je jadrom architektúry.)*

**Dostupné nástroje**
- **GPT, Claude, Gemini** — cloudové modely
- **lokálne modely** — **Ollama + Open WebUI** ako hlavný stack *(Rozhodnuté)*, beh na Macu a ThinkPadoch; **LM Studio** len ako voliteľná alternatíva *(Voliteľné)*
- **MetaCentrum** — veľké výpočty a veľké modely
- prípadne ďalšie inštitucionálne modely
- inštitucionálne/školské pravidlá — čo je povolené pri výučbe, hodnotení, komunikácii so študentmi

**Kritériá výberu nástroja**
- citlivosť dát — lokálne spracovanie pre citlivé dáta
- kvalita požadovaného výstupu
- cena a už existujúce predplatné
- potrebný kontext (dĺžka, formát)
- modalita (text/obraz/audio)
- **deterministický nástroj pred LLM**, kde je to možné
- **jeden silný model pred zbytočným paralelným volaním viacerých modelov**

**Workflow vzory**
- Writer → Reviewer → Revision — iba pri dôležitých výstupoch
- capability registry — čo ktorý nástroj/model vie
- persistent state pre dlhé/viacetapové workflow
- Playwright a browser automation *(→ kat. 8)*
- archivácia promptov a odpovedí *(→ kat. 26)*
- kontrola faktov a zdrojov
- **manuálne potvrdenie** pri finančných, bezpečnostných, publikačných a deštruktívnych akciách

*(Claude Projects, artefakty, pamäť a MCP sú príklady schopností konkrétneho poskytovateľa, nie jadro architektúry.)*

- → SW: Ollama/Open WebUI (hlavný lokálny stack), cloud modely podľa úlohy, orchestračná vrstva, capability registry

---

## Mapa autoritatívnych systémov

| Typ dát | Predpokladaný autoritatívny systém |
|---|---|
| Udalosti a stretnutia | existujúci kalendár |
| Projekty a úlohy | vlastná time-management aplikácia |
| Zdrojový kód | Git; Gitea/GitHub ako remote |
| Súbory | reálne súborové úložiská |
| Metadata a prepojenia | vlastný osobný informačný systém |
| Poznámky | plain text/PKM |
| Bibliografia | reference manager/BibTeX |
| Heslá a secrets | password manager |
| Fotografie | zvolený fotoarchív |
| AI konverzácie | lokálny archív/export |
| Backup | versioned backup systém |

**Dôležité:** aplikácia s najväčším počtom integrácií nemusí byť autoritatívnym systémom pre všetky dáta — vlastná appka (kat. 24) je zámerne autoritatívna len pre projekty/úlohy/metadata, nie pre kalendár, email, kód, heslá či bibliografiu.

---

## Súhrn — opakujúce sa typy softvéru naprieč kategóriami

| Typ softvéru | Primárna kategória | Cross-linkované z |
|---|---|---|
| Kalendár | 9 | 1, 4, 10, 11, 12, 15, 20, 22 |
| Poznámkový/PKM nástroj | 6 | 1, 9, 12, 23 |
| Task/project manager | 9 | 1, 4, 10, 26 |
| Komunikácia (email/chat) | 15 | 1, 3, 10, 22 |
| Súbory a metadata | 17 | 7, 19, 24 |
| Bezpečnosť a recovery | 16 | 7, 14, 19, 24 |
| AI workflow a voľba nástroja | 27 | 2, 8, 26 |
| Vlastné aplikácie | 24 | 3, 9, 11, 17, 21 |
| Prezentovanie/vizuál | 5 | 1 |

---

## Súhrn — zoznam kategórií

1. Výskum (matematika, kryptografia, príp. iné oblasti)
2. Vývoj softvéru
3. Písanie a editácia textu
4. Výučba a vzdelávacie materiály
5. Prezentovanie / vizuálna komunikácia
6. Správa znalostí a dokumentov
7. Systémová a infraštruktúrna administrácia
8. Automatizácia opakovaných úloh
9. Osobná organizácia, projekty a time management
10. Grantová a fakultná administratíva
11. Cestovanie
12. Životné plánovanie (všeobecne)
13. Správa majetku
14. Financie
15. Komunikácia a spolupráca
16. Bezpečnosť, identita a kontinuita
17. Správa dát, súborov, metadát a formátov
18. Médiá a multimédiá
19. Mobilné zariadenia
20. Právna, zmluvná a licenčná agenda
21. Zdravie a fitness
22. Rodina a domácnosť
23. Koníčky a voľný čas
24. Osobný informačný systém a vlastné aplikácie
25. Zachytávanie a spracovanie informačných vstupov
26. Rozhodovací denník, logy a drobná evidencia
27. AI workflow — voľba nástroja a proces

---

## Zmeny oproti predchádzajúcej verzii

**Doplnené oblasti**
- Kategória 4: personalizované varianty zadaní, generovanie kryptografických inštancií, automatické hodnotenie, kryptografické/sieťové laboratóriá, TLS/PCAP zadania, AI tutor, oneskorené sprístupnenie riešenia, kontrola jednoznačnosti generovaného zadania.
- Kategória 6: AI-IR reprezentácia, extrakcia entít/tvrdení/vzťahov, ontológie, provenance, RAG, porovnávanie reprezentácií.
- Kategória 7: Remmina, Gitea na Pi, externý USB SSD, inventár nainštalovaných aplikácií, explicitné odlíšenie versioned backupu od Syncthing/rsync.
- Kategória 9: "next action", time blocking, plán vs. skutočnosť, časová bilancia medzi rolami, zachytenie prerušenej práce.
- Kategória 16: rozlíšenie typov tajomstiev (autentizačné/šifrovacie/recovery/trust/secret providers), Recovery Key vs. Vault Key, deterministické odvodzovanie tajomstiev, 2× YubiKey ako potvrdený stav.
- Kategória 17: dvojvrstvová štruktúra (automaticky odvodený inventár vs. autoritatívne metadata), prepojenie súboru s Git/úlohou/emailom/AI konverzáciou.
- Kategória 25: rozšírený zoznam typov vstupov (hlas, screenshot, správa od študenta/kolegu).
- Kategória 26: multi-provider archív AI konverzácií (GPT/Claude/Gemini), pracovný kontext (branch, experiment, ďalší krok).
- Kategória 27: kompletne prepísaná na provider-neutrálnu štruktúru s kritériami výberu nástroja a workflow vzormi.
- Nová sekcia "Mapa autoritatívnych systémov" na konci dokumentu.

**Opravené nepresnosti**
- Kategória 2: "Lokálna AI infraštruktúra a Prompt Ops" presunutá do kategórie 27 — v kategórii 2 ostáva len AI podpora priamo pri vývoji (coding assistant, review).
- Kategória 7: Sieťová hygiena (Pi-hole/AdGuard/VLAN) prestala byť viazaná na Garmin ako dôvod — teraz všeobecná voliteľná prax.
- Kategória 19: odstránené "MDM-like nástroje" ako nadmerné pre osobné zariadenia; iPhone explicitne označený ako neautoritatívne úložisko.
- Kategória 21: Garmin/HRV/offline mapy preznačené z faktu na podmienené ("ak reálne používané").
- Kategória 27: odstránená Claude-centrická formulácia, nahradená provider-neutrálnou.
- Naprieč dokumentom: opakujúce sa schopnosti (kalendár, poznámky, task manager, komunikácia, súbory, bezpečnosť, AI, prezentovanie) teraz majú jednu primárnu kategóriu a cross-link inde namiesto opakovaného definovania.

**Označené ako Plánované/Voliteľné**
- Voliteľné: LM Studio (alternatíva k Ollama), Pi-hole/AdGuard Home/VLAN, Scopus a aktívna správa IACR profilu, LinkedIn, HRV a offline topo mapy, App Store/Google Play distribúcia, rozsiahla telemetry, automatizované obchodovanie s BTC (nahradené dôrazom na držbu/self-custody/recovery).
- Rozhodnuté: Tailscale, Gitea (na Pi), GitHub ako verejný remote, KeePassXC (alebo ekvivalent), 2× YubiKey, Ollama+Open WebUI ako hlavný lokálny AI stack.

**Významné presuny medzi kategóriami**
- Lokálna AI infraštruktúra: kategória 2 → kategória 27.
- Cross-linkované namiesto duplicitne definované: kalendár (viacero kategórií → 9), komunikácia (viacero → 15), súbory/metadata (7, 19, 24 → 17), bezpečnosť/recovery (7, 14, 19, 24 → 16), prezentovanie (1 → 5).

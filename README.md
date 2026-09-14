# kemp.io — ukázkový backlog

Tohle není zadání a není to produkt. Je to **ukázka, jak chceme v kurzu pracovat s backlogem**:
jaká je struktura úkolů, co má obsahovat story a jak poznáme, že je hotová.

Obsah issues je schválně mělký. Váš vlastní backlog bude konkrétnější — tady jde o formu.

> Zadání pro tým je jinde. Tenhle repozitář ukazuje jen způsob práce.

---

## Dvě úrovně: epic a story

GitHub umí **sub-issues** — issue může mít pod sebou další issues. Používáme to takhle:

- **Epic** je větší celek, který dává smysl jako kus produktu. Trvá víc než jeden sprint
  a sám o sobě se nedá vzít do práce. Má štítek `typ: epic`.
- **Story** je kus práce, který jde dodat a ukázat na demu. Visí pod epicem jako sub-issue.
  Má štítek `typ: story`.

V epicu se pak sám od sebe objeví seznam podřízených story s ukazatelem, kolik je hotovo.
Nemusíte nic psát ručně — přidáte sub-issue a GitHub dopočítá zbytek.

Hlubší zanořování nedělejte. Když story potřebuje rozpad, je to nejspíš malý epic.

## Sprinty jsou milestones

GitHub Projects umí i **iterační pole**, ale sprint vědomě držíme na **milestonu**. Důvod je
praktický: milestone je vidět přímo v repozitáři, dá se podle něj filtrovat seznam issues
a nemusíte kvůli němu otevírat board. Iterace by žila jen v projektu — a měli bychom dvě
místa, která se dřív nebo později rozejdou.

| Milestone | Konec | O čem to je |
|---|---|---|
| `Sprint 1 · validace` | 19. 10. 2026 | lean canvas, byznys, nasazená prázdná šablona |
| `Sprint 2 · jádro přihlašování` | 9. 11. 2026 | jedna cesta end-to-end, nasazená |
| `Sprint 3 · první modul` | 23. 11. 2026 | první modul z kostry |
| `Sprint 4 · dotažení` | 30. 11. 2026 | jeden malý modul nebo nedodělky |
| `Po výuce · prezentace` | 15. 1. 2027 | bez PO checkpointu, příprava prezentace |

Co nemá milestone, je **neplánovaný backlog**. To je v pořádku a je tam většina věcí.

## Štítky

Čtyři skupiny, každá jinou barvou. Na issue patří **právě jeden štítek z každé skupiny**
kromě `stav`, který se používá jen když je potřeba.

| Skupina | Štítky | K čemu |
|---|---|---|
| `typ` | epic · story · bug · chore · spike | co to je za práci |
| `modul` | přihlášky · ubytování · platby · doprava · přehledy · základ | kam to v produktu patří |
| `priorita` | must · should · could | co spadne první, když dojde čas |
| `odhad` | 1 · 2 · 3 · 5 · 8 | story pointy, přiděluje tým na planningu |
| `stav` | potřebuje upřesnit · blokováno | proč to zrovna neběží |

`spike` je časově omezené zjišťování, ne dodávka. Výstupem je odpověď, ne funkce.

## Board

[kemp.io — ukázkový backlog](https://github.com/users/tomaskriz-max/projects/1) je veřejný
a všechny issues z tohohle repozitáře v něm jsou.

Sloupce držíme jednoduché: **Backlog → Připraveno → Děláme → Review → Hotovo.**

Do `Děláme` patří jen to, co má někdo rozdělané. Když tam visí pět věcí na tři lidi,
něco je špatně.

Board má dva pohledy — *Sprint board* na denní práci a *Celý backlog* jako tabulku.
V tabulce si zapněte seskupení podle `Milestone` a uvidíte sprinty pod sebou.

## Definition of Ready

Story se nebere do sprintu, dokud:

- je jasné, **komu** to pomůže a **proč**
- má akceptační kritéria, na kterých se tým shodl
- vejde se do sprintu — když ne, rozdělte ji
- nemá otevřenou otázku, která by mohla změnit zadání

## Definition of Done

- funguje to na **nasazeném prostředí**, ne na localhostu
- prošlo to code review
- PO si to může sám proklikat na datech, která si vymyslí na místě

## Jak psát story

Šablony jsou v [`.github/ISSUE_TEMPLATE`](.github/ISSUE_TEMPLATE) a nastaví se samy,
když založíte nové issue.

Dobrá story říká **situaci a co z ní má vzejít**. Neříká, jak to naprogramovat —
to je vaše rozhodnutí a bylo by škoda si ho ubrat.

# Jak si takový board nastavit

Dvě cesty ke stejnému výsledku. **Skriptem** to trvá minutu, **ručně** asi deset —
ale uvidíte, kde co je, a to se bude hodit, až budete něco měnit.

---

## Cesta A — skriptem

Potřebujete [gh CLI](https://cli.github.com) přihlášené a se scopem `project`:

```bash
gh auth login
gh auth refresh -s project
```

Pak z kořene svého repozitáře:

```bash
./scripts/setup-board.sh <owner>/<repo> "Název boardu"
```

Skript založí projekt, přejmenuje sloupce, nastaví sprinty, udělá dva pohledy,
propojí board s repozitářem a nasype do něj existující issues.

**Data sprintů si nejdřív upravte** — jsou nahoře ve skriptu v poli `SPRINTS`
jako `název|začátek|délka ve dnech`.

Zbydou dvě věci, které přes API udělat nejde — jsou to poslední dva kroky ruční cesty.

---

## Cesta B — ručně

### 1. Založit projekt

Na svém profilu (ne v repu) → záložka **Projects** → **New project** → šablona **Board** → *Create*.

Projekt patří účtu, ne repozitáři. To je správně — jeden board může sledovat víc repozitářů.

### 2. Propojit s repozitářem

V repu → záložka **Projects** → **Link a project** → vyberte ten svůj.

Od téhle chvíle jde issue přidat na board přímo z jejího postranního panelu.

### 3. Přepsat sloupce

Na boardu klikněte na **⋯** vpravo nahoře → **Settings** → v levém sloupci **Status**.

Přejmenujte a doplňte, ať jich je pět:

| Sloupec | Co v něm je |
|---|---|
| Backlog | není naplánované |
| Připraveno | splňuje Definition of Ready |
| Děláme | někdo to má rozdělané |
| Review | čeká na code review nebo na PO |
| Hotovo | nasazené a odsouhlasené |

### 4. Přidat pole Sprint

Pořád v **Settings** → dole **+ New field**.

- **Field name:** `Sprint`
- **Field type:** `Iteration`

Dole se objeví nastavení iterací. Nastavte začátek prvního sprintu a přidávejte další
tlačítkem **Add iteration**. **Délku každé iterace jde změnit zvlášť** — využijte toho,
sprinty v semestru nejsou stejně dlouhé.

> Iterace je víc než štítek s datem: GitHub ví, která zrovna běží, nabídne ji jako první
> a umí z ní postavit burn-up v Insights.

### 5. Seskupit board podle sprintu

Zpátky na board → **⋯** u názvu pohledu → **Group by** → `Sprint`.

Tohle je ten okamžik, kdy začne board dávat smysl: vidíte, co se dělá teď, a co čeká
na příští iteraci.

### 6. Zapnout automatické přidávání

**Settings** → **Workflows** → **Auto-add to project** → vyberte repozitář → *Enable*.

Bez tohohle kroku si každé nové issue musíte na board přetáhnout ručně a jednou týdně
zjistíte, že vám tam něco chybí.

---

## Co ještě stojí za zapnutí

**Šablony issues.** Zkopírujte si složku [`.github/ISSUE_TEMPLATE`](.github/ISSUE_TEMPLATE)
do svého repozitáře. Drží tvar story a ušetří to na refinementu spoustu dohadování.

**Štítky.** Výchozí anglické štítky smažte, ať v seznamu nepřekáží. Naše skupiny
(`typ`, `modul`, `priorita`, `odhad`, `stav`) jsou popsané v [README](README.md#štítky) —
přenesete je jedním průchodem:

```bash
gh label list -R tomaskriz-max/kemp-io-backlog --json name,color,description \
  | jq -r '.[] | [.name, .color, .description] | @tsv' \
  | while IFS=$'\t' read -r n c d; do
      gh label create "$n" -R <owner>/<repo> -c "$c" -d "$d" --force
    done
```

**Sub-issues.** V otevřeném issue je v pravém panelu sekce **Sub-issues** →
*Add sub-issue*. Můžete přidat existující issue nebo rovnou založit nové.
Epic si pak sám dopočítá, kolik z něj je hotovo.

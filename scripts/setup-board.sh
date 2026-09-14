#!/usr/bin/env bash
# Založí a nastaví board pro týmový repozitář — sloupce, sprinty, pohledy.
#
#   ./scripts/setup-board.sh <owner>/<repo> "<název boardu>"
#
# Potřebuje gh CLI přihlášené se scopem `project`:
#   gh auth refresh -s project
set -euo pipefail

REPO="${1:?Použití: $0 <owner>/<repo> [název boardu]}"
TITLE="${2:-$REPO — backlog}"
OWNER="${REPO%%/*}"

# Sprinty: název|začátek|délka ve dnech. Uprav podle svého semestru.
SPRINTS=(
  "Sprint 1 · validace|2026-09-21|28"
  "Sprint 2 · jádro přihlašování|2026-10-19|21"
  "Sprint 3 · první modul|2026-11-09|14"
  "Sprint 4 · dotažení|2026-11-23|7"
  "Po výuce · prezentace|2026-11-30|46"
)

say() { printf '\n\033[1m%s\033[0m\n' "$1"; }

say "1/6  Zakládám projekt"
PROJECT=$(gh project create --owner "$OWNER" --title "$TITLE" --format json)
NUM=$(jq -r .number <<<"$PROJECT")
PID=$(jq -r .id <<<"$PROJECT")
URL=$(jq -r .url <<<"$PROJECT")
echo "     $URL"

say "2/6  Přejmenovávám sloupce"
SFID=$(gh project field-list "$NUM" --owner "$OWNER" --format json \
  | jq -r '.fields[] | select(.name=="Status") | .id')
gh api graphql -f query='
mutation($f:ID!){
  updateProjectV2Field(input:{ fieldId:$f, singleSelectOptions:[
    {name:"Backlog",    color:GRAY,   description:"Není naplánované"},
    {name:"Připraveno", color:BLUE,   description:"Splňuje Definition of Ready"},
    {name:"Děláme",     color:YELLOW, description:"Někdo to má rozdělané"},
    {name:"Review",     color:ORANGE, description:"Čeká na code review nebo na PO"},
    {name:"Hotovo",     color:GREEN,  description:"Nasazené a odsouhlasené"}
  ]}){ projectV2Field{ ... on ProjectV2SingleSelectField { name } } }
}' -f f="$SFID" --silent
echo "     Backlog → Připraveno → Děláme → Review → Hotovo"

say "3/6  Zakládám pole Sprint (iterace)"
FID=$(gh api graphql -f query='
mutation($p:ID!){ createProjectV2Field(input:{projectId:$p, dataType:ITERATION, name:"Sprint"}){
  projectV2Field{ ... on ProjectV2IterationField { id } } } }' \
  -f p="$PID" --jq '.data.createProjectV2Field.projectV2Field.id')

ITERS=""
for s in "${SPRINTS[@]}"; do
  IFS='|' read -r t d n <<<"$s"
  ITERS+="{startDate:\"$d\", duration:$n, title:\"$t\"},"
done
FIRST_START="${SPRINTS[0]#*|}"; FIRST_START="${FIRST_START%%|*}"

gh api graphql -f query="
mutation(\$f:ID!){
  updateProjectV2Field(input:{ fieldId:\$f, iterationConfiguration:{
    startDate:\"$FIRST_START\", duration:7, iterations:[${ITERS%,}] }}){
    projectV2Field{ ... on ProjectV2IterationField { name } } }
}" -f f="$FID" --silent
for s in "${SPRINTS[@]}"; do echo "     ${s%%|*}"; done

say "4/6  Zakládám pohledy"
VID=$(gh api graphql -f query='query($p:ID!){ node(id:$p){ ... on ProjectV2 {
  views(first:1){ nodes{ id } } } } }' -f p="$PID" --jq '.data.node.views.nodes[0].id')
gh api graphql -f query='mutation($v:ID!){ updateProjectV2View(input:{viewId:$v,
  name:"Celý backlog"}){ projectV2View{ name } } }' -f v="$VID" --silent
gh api graphql -f query='mutation($p:ID!){ createProjectV2View(input:{projectId:$p,
  name:"Sprint board", layout:BOARD_LAYOUT}){ projectV2View{ name } } }' -f p="$PID" --silent
echo "     Celý backlog (tabulka) + Sprint board (kanban)"

say "5/6  Propojuji s repozitářem $REPO"
RID=$(gh api "repos/$REPO" --jq .node_id)
gh api graphql -f query='mutation($p:ID!,$r:ID!){ linkProjectV2ToRepository(input:{
  projectId:$p, repositoryId:$r}){ repository{ name } } }' -f p="$PID" -f r="$RID" --silent

say "6/6  Přidávám existující issues"
COUNT=0
while read -r u; do
  [ -z "$u" ] && continue
  gh project item-add "$NUM" --owner "$OWNER" --url "$u" --format json >/dev/null
  COUNT=$((COUNT+1))
done < <(gh issue list -R "$REPO" --state all --limit 200 --json url --jq '.[].url')
echo "     přidáno: $COUNT"

say "Hotovo → $URL"
cat <<'EOF'

Dvě věci dodělejte ručně, přes API to nejde:

  · Seskupení pohledu   na boardu ⋯ → Group by → Sprint
  · Automatické přidávání  Settings → Workflows → Auto-add to project,
    ať se nové issues na board dostanou samy

EOF

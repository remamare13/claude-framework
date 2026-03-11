# Frontend & Design orodja — nameščena globalno

Naslednja orodja so nameščena na user scope (`~/.claude.json` / `~/.claude/plugins/`)
in so na voljo vsem agentom za frontend, design in UI delo.

## Plugins (Claude Code marketplace)

### 1. frontend-design (Anthropic official)
- **Namestitev:** `claude plugin install frontend-design --scope user`
- **Marketplace:** `claude-plugins-official`
- **Opis:** Anthropic-ov uradni plugin za frontend design — pomaga pri HTML/CSS/JS,
  responsive design, vizualni hierarhiji, tipografiji, barvnih shemah
- **Uporaba:** Avtomatsko aktiven pri frontend nalogah

### 2. playwright (Microsoft / Anthropic official)
- **Namestitev:** `claude plugin install playwright --scope user`
- **Marketplace:** `claude-plugins-official`
- **Opis:** Browser automation za testiranje — screenshot, klik, navigacija,
  form filling, E2E testi
- **Uporaba:** Za vizualno preverjanje spletnih strani, E2E teste, screenshot validacijo

### 3. impeccable (Paul Bakaus)
- **Namestitev:** `claude plugin install impeccable --marketplace impeccable --scope user`
- **Marketplace:** `impeccable`
- **Opis:** Design review tool — analizira UI za dostopnost, konsistentnost,
  vizualno hierarhijo, UX probleme
- **Uporaba:** Po implementaciji UI za review in izboljšave

### 4. swift-lsp (Anthropic official)
- **Namestitev:** `claude plugin install swift-lsp --scope user`
- **Marketplace:** `claude-plugins-official`
- **Opis:** Swift Language Server Protocol support
- **Uporaba:** Za Swift/iOS/macOS razvoj (ni relevantno za web)

## MCP Servers (v ~/.claude.json)

### 5. Figma MCP
- **Transport:** HTTP
- **URL:** `https://mcp.figma.com/mcp`
- **Opis:** Uradni Figma MCP — bere Figma design datoteke, extracts components,
  styles, layout info. Zahteva Figma auth (browser popup ob prvi uporabi).
- **Uporaba:** Ko imaš Figma design in rabiš implementacijo — prebere design in
  pomaga pri pixel-perfect implementaciji

### 6. shadcn/ui MCP
- **Transport:** stdio
- **Command:** `npx shadcn@latest mcp`
- **Opis:** Uradni shadcn/ui MCP — dostop do shadcn komponent library,
  namestitev komponent, styling z Tailwind
- **Uporaba:** Za React projekte ki uporabljajo shadcn/ui + Tailwind CSS

## Kdaj uporabiti kaj

| Naloga | Orodje |
|--------|--------|
| HTML/CSS/JS pisanje | frontend-design |
| Design → koda (iz Figma) | Figma MCP + frontend-design |
| React + Tailwind komponente | shadcn MCP |
| UI review (dostopnost, UX) | impeccable |
| E2E testi, vizualna validacija | playwright |
| Screenshot preverjanje | playwright |

## Opombe
- Vsa orodja so na **user scope** — delujejo v vseh projektih
- Za namestitev novih pluginov: `claude plugin install <name> --scope user`
- Za MCP serverje: dodaj v `~/.claude.json` pod `mcpServers`
- Figma MCP zahteva enkratno avtorizacijo v brskalniku

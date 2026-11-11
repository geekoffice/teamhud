# Harbor Night: a theme

A **theme** is one JSON file that sets the whole look at once: accent colour, panel colours and
text, spacing, hub shape and colour. Harbor Night is deep slate panels with a warm lantern accent.
No build step, no code, no TeamHUD source needed.

```
theme-harbor-night/
  harbor-night.json   the theme
  README.md           this file
```

Written against TeamHUD **1.0.0-alpha.1**.

## Install

Either:

- **Drop the file in:** copy `harbor-night.json` to `.teamhud/themes` in your home folder
  (`~/.teamhud/themes/` on macOS and Linux, `%USERPROFILE%\.teamhud\themes\` on Windows).
  TeamHUD watches that folder, so it appears under **My themes** without a restart. The file name
  is the theme's id: use letters, numbers, dots, dashes and underscores. Files over 512 KB, or that
  aren't valid JSON with a `name`, are skipped.
- **Or import it:** Preferences → Appearance → Theme → **Import…** (in the Backup row at the
  bottom), pick the file, then **Apply now** or **Save to My themes**.

Then apply it from **My themes** on the same page. To remove it, delete it there (trash icon) or
delete the file.

## Change it

Everything lives under `bundle`. A section you leave out gets TeamHUD's default when the theme
is applied, so the previous theme's settings never leak into yours.

| Field | What it sets |
|---|---|
| `accentTuning` | `{ "paletteId": "custom", "customColor": "#rrggbb" }` builds the whole accent ramp from one colour. Or use a named palette: `blue`, `violet`, `teal`, `emerald`, `amber`, `rose`. |
| `uiDensityTuning` | `mode` (`compact` or `normal`), `baseSizePx` (the unit everything scales from; 12 to 18 is comfortable for `normal`), `fontFamily` (`inter` or `mono`). |
| `panelGlassTuning` | Panel see-through when idle and hovered (`idleOpacity` 0.1 to 1, `activeOpacity` 0.3 to 1), corner radius (`panelRadiusPx`, 0 to 48) and colours: `panelBg`, `panelBorder`, `textColor`, `textSecondary`, `linkColor`, `success`, `warning`, `danger`, `info`, `hoverTint`, `activeTint`. TeamHUD derives the in-between shades from these. |
| `hubElementTuning` | The hub buttons: `borderRadiusPercent` (0 square to 50 round), `backgroundColor`, `iconColor`, and many more. The easiest way to find the rest is to build a look in the theme editor and press **Export** on it under My themes. |
| `activeStyle` | `{ "chromeId": "circle", "backdropId": "none" }`. `backdropId` can also be `goo` or `user:<id>` for a backdrop shader you installed (see below). |

**The colours are sample values.** Each text colour was checked against the panel colour and
passes WCAG AA (4.5:1) with room to spare; the lowest is `danger` at about 6:1. If you change
`panelBg`, re-check your text colours with any contrast checker.

The easiest way to make your own: Preferences → Appearance → Theme → **New theme** opens a
sandboxed editor seeded from your current look. Nothing touches your overlay until you press
**Apply to HUD**. Export it and compare the file with this one.

## Pair it with a backdrop

A theme can turn on a backdrop shader that draws around the hubs. Install
[`backdrop-soft-halo`](../backdrop-soft-halo), then change `activeStyle` to:

```json
"activeStyle": { "chromeId": "circle", "backdropId": "user:soft-halo" }
```

The theme file and the `.wgsl` file together are a complete, shareable look. A theme that names
a backdrop you don't have still applies; TeamHUD swaps in a backdrop it does have.

## Safety

A theme is data: colours, numbers and names. TeamHUD cleans every theme it reads, whether
dropped in or imported, and drops anything it doesn't recognise. Themes can also carry custom
CSS and SVG icons (this one doesn't); those are sanitised too, with no scripts and no outside
URLs.

## Licence

MIT, see [LICENSING.md](../../LICENSING.md). This covers these files only, not the TeamHUD app.

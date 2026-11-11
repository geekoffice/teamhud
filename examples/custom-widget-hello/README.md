# Hello Community: a minimal custom widget

A **custom widget** is a folder with a `widget.json` and an HTML page. TeamHUD turns it into a
hub button on your overlay that opens a small panel. You don't need a build step, a TypeScript
toolchain or the TeamHUD source code.

This example shows a greeting (you can change it in the widget's settings), a click counter, and
the shared TeamHUD look, so it follows your theme, accent colour and density automatically.

```
custom-widget-hello/
  widget.json   manifest: name, entry page, icon, size, permissions, settings
  index.html    the panel's UI
  icon.svg      hub button icon (SVG only)
  README.md     this file (ignored by TeamHUD)
```

## Install

1. Copy this folder into `.teamhud/custom-widgets` in your home folder:
   - macOS / Linux: `~/.teamhud/custom-widgets/custom-widget-hello/`
   - Windows: `%USERPROFILE%\.teamhud\custom-widgets\custom-widget-hello\`
2. Wait a moment. TeamHUD watches that folder, so the widget appears without a restart.
3. Because the widget came from outside the app, TeamHUD shows a **permission review** before it
   first loads. This widget asks for one thing only, **Be clickable**, so its button and panel
   can take clicks. Approve it.
4. To remove it, delete the folder.

You can also turn it on or off and approve it in **Preferences → Plugin settings**, and see or
revoke what it holds under **Plugins & Widgets** in the privacy and security settings.

## Change it

Edit any file and save. The widget reloads live (changes are batched for about 1.5 seconds).

- **Text and layout:** `index.html`.
- **The greeting:** open the widget's settings (hub menu, or the gear icon on its row in
  Preferences → Plugin settings). The page reads it with `window.teamhud.settings.get()`
  (a promise resolving to `{ greeting: "…" }`) and follows edits with
  `window.teamhud.settings.onChange(cb)`. Settings types: `string`, `number` (with
  `min`/`max`/`step`), `boolean`, `select` (with `options`) and `color`.
- **Name, size, icon, first position:** `widget.json`. `defaults.position` is a fraction of the
  screen (0 to 1) and only applies until the user moves the widget.
- **Icon:** must be an `.svg`. Use `currentColor` for strokes and fills and leave out
  `width`, `height` and `stroke-width`; the hub sets those so your icon matches the others.

Opening `index.html` directly in a browser works for quick layout checks; the `var(--th-…, fallback)`
values keep it readable there. Inside TeamHUD the real tokens apply.

## Design system it uses

- **Elements** from `teamhud-widget://_shared/widget-bundle.js`: `<th-section label>`,
  `<th-kv-row label>`, `<th-btn variant="primary">`. Also available: `<th-chip variant>`,
  `<th-progress>`, `<th-widget-footer>`.
- **Tokens** (injected for you, updated live): `--th-font-ui`, `--th-text-md`, `--th-text-lg`,
  `--th-text-primary`, `--th-accent`, `--th-font-semibold`, `--th-space-3`, `--th-u` (the
  density unit everything scales from).
- **Utility classes**, if you prefer plain HTML: add
  `<link rel="stylesheet" href="teamhud-widget://_shared/widget.css">` and use `.th-section`,
  `.th-kv`, `.th-btn`, `.th-chip`, `.th-footer`, `.th-muted`.
- **Theme hooks:** add `data-th-component="button"` (or `chip`, `input`, `list-item`, …) to your
  own elements and a user's theme restyles them like the built-in widgets.

Rules of thumb: take colours, sizes and fonts from tokens, not literal values; don't draw your
own panel background or border (TeamHUD draws the panel); put clickable things inside an element
with `class="teamhud-interactive"`, or the overlay lets the click fall through to the app behind.

## Permissions: everything is off unless you ask

A widget can do only what its `widget.json` declares **and** the user approves. Nothing is
granted by default. This example declares no backend and no network, so it cannot reach the
internet, your files or other apps.

If your widget needs more, declare it in `permissions` and expect the user to be asked:

| Declare | What it allows |
|---|---|
| `"network": true` + `"networkHosts": [{ "host": "api.example.com" }]` | Requests to exactly those hosts (GET only unless you add `"methods"`). Any other host is refused. |
| `"backend": true` + `"backend": "backend/main.js"` | A sandboxed Node helper (CommonJS). `fs`, `child_process`, `net` and similar are blocked. |
| `"store": true` | Small key/value storage for the backend, on this computer only. |
| `"hubPositions": true` | Where the other hub buttons are on screen. |

Ask for the least you need. Changing the permissions in `widget.json` makes TeamHUD ask the
user again; changing only your HTML does not.

## Licence

MIT, see [LICENSING.md](../../LICENSING.md). This covers these files only, not the TeamHUD app.

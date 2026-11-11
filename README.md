# TeamHUD

**The heads-up display for your team.** Voice room, screen sharing, messages, a shared quest log, your team's links and your own AI, at the edge of your screen while you do the thing you're actually doing.

🌐 [teamhud.app](https://teamhud.app) · ⬇️ [Download for Mac, Windows and Linux](https://teamhud.app/downloads) · 💬 [Discord](https://discord.gg/AaD9evY5RG)

This repository is the community home for TeamHUD: where you **report problems**, **ask for features**, and find **examples** for building your own widgets and live wallpapers.

## Found a problem?

1. **Fastest:** in TeamHUD, open the tray menu → **Submit Feedback…**. It attaches your version, OS and logs for you.
2. Or [open an issue](../../issues/new/choose). Pick the form that fits, and fill in the computer and version fields. They're what lets us reproduce it.
3. Quick question or not sure it's a bug? Ask in [Discord](https://discord.gg/AaD9evY5RG).
4. Security problem? Please don't file it publicly. See [SECURITY.md](SECURITY.md).

## Build your own

| Example | What it shows |
|---|---|
| [`examples/custom-widget-hello`](examples/custom-widget-hello) | A custom hub widget with a setting and a click counter, built from `th-*` elements and `--th-*` theme tokens. Holds no permissions. |
| [`examples/live-wallpaper`](examples/live-wallpaper) | A cheap, slow animated desktop wallpaper (a `.wgsl` shader) with three options, themed by your accent colour. |
| [`examples/theme-harbor-night`](examples/theme-harbor-night) | A whole look in one JSON file: accent, panel and text colours, density and hub style. Drop it in or import it. |
| [`examples/backdrop-soft-halo`](examples/backdrop-soft-halo) | An overlay backdrop shader (`.wgsl`) that glows around each hub in its own colour, with three sliders. |
| [`examples/sound-pack-pebble`](examples/sound-pack-pebble) | A sound pack: a `pack.json`, six short original `.wav` cues and two synthesised tones, plus the script that made them. |
| [`examples/plugin-hello`](examples/plugin-hello) | Why plugins can't be built from outside yet, and which of the above to build instead. |

Plugins aren't open for outside authors yet; [`plugin-hello`](examples/plugin-hello) explains why.

New to this? Start with the widget example, then change one thing in it.

## Status

TeamHUD is in early access. Examples and formats can change between alpha builds; each example's README says which version it was written against.

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to help.

## Licence

The contents of this repository (examples, issue forms, docs) are [MIT](LICENSE). **TeamHUD itself is proprietary** (© GeekOffice LLC, not open source) and is licensed under the [Software License Agreement](https://teamhud.app/license.html). See [LICENSING.md](LICENSING.md) for what covers what.

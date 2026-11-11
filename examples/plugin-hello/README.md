# Plugins: not open to outside authors yet

There's no plugin code in this folder on purpose. This page explains what a TeamHUD plugin is,
why you can't build one from outside yet, and what to build instead.

Checked against TeamHUD **1.0.0-alpha.1**.

## What a plugin is

Most of TeamHUD is built from plugins: calls, chat, the quest log, sounds, themes. A plugin is
TypeScript that runs inside the app's main process with full access: it can add new app services,
talk to native code, open windows, hold sign-ins and wire itself into other plugins.

## Why you can't build one from outside

- **Plugins are compiled into the app.** TeamHUD finds its plugins when the app itself is built,
  not at runtime. There is no plugins folder you can drop one into, and no way to load one into
  an installed copy.
- **They build against private packages.** The plugin base class and the app's internal services
  aren't published, so a plugin can't even compile outside the TeamHUD source tree.
- **Full access is the point, and the risk.** A plugin can do anything the app can. Before outside
  code gets that, it needs a permission model, review and signing, the way custom widgets already
  have a permission review.

So a "hello world" plugin here would be code you can't build or run. We'd rather not pretend.

## What to build instead

Everything below installs into an ordinary copy of TeamHUD with no source code:

| You want to… | Build | Example |
|---|---|---|
| Add a button and panel to the overlay | A **custom widget**: a folder with `widget.json` and an HTML page | [`custom-widget-hello`](../custom-widget-hello) |
| Run logic outside the page, call an API, keep data | A custom widget with a **backend**: a sandboxed Node helper the user approves (`"backend": true`, plus network hosts or storage if needed) | [`custom-widget-hello`](../custom-widget-hello#permissions-everything-is-off-unless-you-ask) explains the permissions |
| Change the whole look | A **theme** | [`theme-harbor-night`](../theme-harbor-night) |
| Draw around the hubs | A **backdrop shader** | [`backdrop-soft-halo`](../backdrop-soft-halo) |
| Animate the desktop | A **live wallpaper** | [`live-wallpaper`](../live-wallpaper) |
| Change how TeamHUD sounds | A **sound pack** | [`sound-pack-pebble`](../sound-pack-pebble) |

A custom widget's backend is deliberately limited: no file system, no child processes, no raw
sockets, only the hosts you declare and the user approves. If your idea needs more than that
(native code, keeping someone's account credentials, its own window), tell us in
[Discord](https://discord.gg/mpbKeaveES) or with the feature form. Those requests are what shapes
how plugins open up.

## Licence

MIT, see [LICENSING.md](../../LICENSING.md). This covers these files only, not the TeamHUD app.

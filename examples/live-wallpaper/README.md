# Soft Tide: a live wallpaper

A **live wallpaper** in TeamHUD is one `.wgsl` file: a small WebGPU shader that draws your desktop
background, behind every window and icon. Soft Tide is three slow bands of light rolling like a
calm tide, tinted by your theme colour. One file, no build step, no TeamHUD source code needed.

## Install

Either:

- **Drop the file in:** copy `soft-tide.wgsl` to `.teamhud/wallpapers` in your home folder
  (`~/.teamhud/wallpapers/` on macOS and Linux, `%USERPROFILE%\.teamhud\wallpapers\` on Windows).
  TeamHUD watches that folder.
- **Or import it:** Preferences → Appearance → **Live Wallpaper** → **Import .wgsl**.

Then, on the Live Wallpaper page, pick **Soft Tide** from the **Yours** group, check the preview,
and press **Apply** (or **Turn on and apply** if the live wallpaper is off). The live wallpaper is
off until you turn it on. It runs on macOS, Windows and Linux GNOME (X11/XWayland); other Linux
desktops may show it as unsupported.

The file name is the wallpaper's id, so `soft-tide.wgsl` is `soft-tide`. Use letters, numbers,
dots, dashes and underscores. Files over 64 KB, or without the header below, are ignored.

## Change it

The file has two parts.

**1. The header** (a JSON block in the first comment) names the wallpaper and declares options.
Each `number` option becomes a slider in the preview panel. Stick to `number` options: the runtime passes only numbers
to the shader, so a `boolean` or `color` option may not reach it (unverified, and the docs disagree). Up to 24 options.

```wgsl
/* @teamhud-shader {
  "schemaVersion": 1,
  "id": "soft-tide",
  "name": "Soft Tide",
  "language": "wgsl",
  "animated": true,
  "options": [ { "key": "speed", "label": "Speed", "type": "number", "min": 0, "max": 100, "default": 25 } ]
} */
```

**2. `backdrop_main`**, called for every pixel. Keep its signature exactly as in the file:

| Input | What it is |
|---|---|
| `uv` | Screen position, 0 to 1, top-left origin (y grows downward). |
| `resolution` | Drawing size in device pixels. Use it to correct for aspect ratio. |
| `color` | The theme's backdrop colour (linear RGB). Tint with it so the wallpaper follows the user's look. |
| `widget_count`, `ws` | The overlay's hubs (positions, sizes, colours). Soft Tide ignores them. Leave `WS_LEN` as written; TeamHUD fills in the real length. |
| `params` | Your options, in the order declared: option 1 is `params[0].x`, 2 is `.y`, 3 is `.z`, 4 is `.w`, 5 is `params[1].x`, and so on. |
| `time` | Seconds. Only advances when the header says `"animated": true`. |

Return `vec4<f32>(rgb, 1.0)`. Try changing the band heights (`0.62`, `0.72`, `0.83`), the wave
frequencies (`3.0`, `4.2`, `5.5`) or adding a fourth band. TeamHUD watches the folder, so a
saved edit to a dropped-in file is picked up live. Inside the app, use **Edit code** under
Advanced and **Save shader**; **Apply** checks that the code compiles before it reaches your
desktop.

To start from something else, select any built-in wallpaper and press **New from selected**.

## Keep it light

A wallpaper runs for hours, so cost matters more than in a demo.

- Soft Tide does a handful of `sin`/`exp` per pixel, with no loops and no texture reads.
- Motion is slow on purpose: at the default speed, 10 to 15 fps looks the same as 60. Users set
  **Frame rate** (default 30) and **Auto optimize** on the Live Wallpaper page; TeamHUD also pauses
  the wallpaper while a fullscreen window covers it and while the computer runs on battery.
- For a still wallpaper, set `"animated": false`. `time` stops and nothing is redrawn per frame.

## Safety

A wallpaper is GPU code with no access to files, the network or other apps; the worst a broken
one can do is fail to compile or stall the GPU process. But the wallpaper **is visible when you
share your screen**, so don't draw anything private on it. Only install `.wgsl` files you have
read or got from someone you trust.

Want something that reacts to the overlay instead? Read the hubs from `ws` (each hub is four
`vec4`s: position, size, merge hints, colour). The full contract lives with the shader runtime in
the TeamHUD source; custom widgets with `"chrome": "surface"` are the other way to make ambient,
non-clickable visuals.

## Licence

MIT, see [LICENSING.md](../../LICENSING.md). This covers these files only, not the TeamHUD app.
